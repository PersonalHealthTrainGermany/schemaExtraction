#!/usr/bin/env bash

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT
export FUSEKI_HOME="${PWD}/apache-jena-fuseki-3.7.0"
FBIN="./apache-jena-fuseki-3.7.0/bin"

HOST="http://admin:password@localhost:3030"  # Terminology
VHOST="http://admin:password@localhost:3031" # Datastore

# Color codes via https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux#5947802
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

log() {
  # echo in color
  echo -e "${GREEN}${1}${NC}"
}

rlog() {
  # echo in color
  echo -e "${RED}${1}${NC}"
}

HCLS1="SELECT (COUNT(*) AS ?triples) { ?s ?p ?o }"
HCLS2="SELECT (COUNT(DISTINCT ?s) AS ?entities) { ?s a [] }"
HCLS3="SELECT (COUNT(DISTINCT ?s) AS ?distinctSubjects) { ?s ?p ?o }"
HCLS4="SELECT (COUNT(DISTINCT ?p) AS ?distinctProperties) { ?s ?p ?o }"
HCLS5='SELECT (COUNT(DISTINCT ?o) AS ?distinctObjects) { ?s ?p ?o  FILTER(!isLiteral(?o)) }'
HCLS6="SELECT (COUNT(DISTINCT ?o) AS ?distinctClasses) { ?s a ?o }"
HCLS7="SELECT (COUNT(DISTINCT ?o) AS ?distinctLiterals){ ?s ?p ?o FILTER(isLiteral(?o)) }"

localStats() {
	query="SELECT ?triples ?entities ?distinctSubjects ?distinctProperties ?distinctObjects ?distinctClasses ?distinctLiterals"
	for graph in "$@"; do query="$query FROM <$graph>"; done
	query="$query WHERE { {$HCLS1}{$HCLS2}{$HCLS3}{$HCLS4}{$HCLS5}{$HCLS6}{$HCLS7} }"
	
	${FBIN}/s-query --service ${VHOST}/dataset/query --output=csv "$query"
}

log "Starting Terminology server in the background"

if [ ! -f data/lov.nq ]; then
    gunzip -c data/lov.nq.gz > data/lov.nq
fi

sudo docker rm -f terminology
sudo docker run --rm --name terminology \
   -p 3030:3030 \
   -e ADMIN_PASSWORD=password \
   -e JVM_ARGS=-Xmx2g \
   -d stain/jena-fuseki:3.10.0 /jena-fuseki/fuseki-server --update --mem  /terminology 

log " * waiting for Terminology Service to become available"
until $(curl --output /dev/null --silent --head --fail $HOST); do
    printf '.'
    sleep 1
done
echo ""

log " * Loading LOV data into terminology store"
curl -X POST -H "Content-Type: application/n-quads" -T data/lov.nq -# ${HOST}/terminology > /dev/null
log " * loading additional dataset schemata"
for name in {gendr,orphanet,homologene}; do
  ${FBIN}/s-put ${HOST}/terminology/data http://example.org/$name additionalExperiments/data/$name.schema.owl
done

log " * launching datastore via docker"
# documentation: https://hub.docker.com/r/tenforce/virtuoso
sudo docker rm -f triplestore
sudo docker run --rm --name triplestore \
  --link terminology \
  -p 3031:3030 \
  -e ADMIN_PASSWORD=password \
  -e JVM_ARGS=-Xmx48g \
  -d stain/jena-fuseki:3.10.0 /jena-fuseki/fuseki-server --mem --update /dataset

log " * waiting for datastore to become available"
until $(curl --output /dev/null --silent --head --fail $VHOST); do
  printf '.'
  sleep 1
done
echo ""

log " * Loading datasets into store"
for f in additionalExperiments/data/*.nq; do
  curl -X POST -H "Content-Type: application/n-quads" -T ${f} -# ${VHOST}/dataset > /dev/null
done

for name in {gendr,orphanet,homologene}; do
  echo ""
  rlog "processing dataset: $name"

  export SCHEMA="http://example.org/$name"
  export FROM="FROM <$SCHEMA>"
  export GRAPH="http://bio2rdf.org/${name}_resource:bio2rdf.dataset.${name}.R3"

  log "$name Dataset Stats:"
  rlog "`localStats "$GRAPH"`"
  
  log "$name vocabulary in named graph $schema:"
  ${FBIN}/s-put ${VHOST}/dataset/data http://example.org/$name additionalExperiments/data/$name.schema.owl
  rlog "`localStats "http://example.org/${name}"`"

 
  log " * Extracting schemata from graph $GRAPH"

  rlog "Locally instantiated schema..."
  ${FBIN}/s-delete ${VHOST}/dataset http://example.org/${name}_locallyInstantiated
  time ${FBIN}/s-query --service ${VHOST}/dataset/query @<(envsubst < additionalExperiments/queries/1.sparql) > additionalExperiments/${name}_locallyInstantiated.ttl
  ${FBIN}/s-put ${VHOST}/dataset/data http://example.org/${name}_locallyInstantiated additionalExperiments/${name}_locallyInstantiated.ttl
  rlog "`localStats "http://example.org/${name}_locallyInstantiated"`"

  rlog "Locally inferred schema..."
  ${FBIN}/s-delete ${VHOST}/dataset http://example.org/${name}_locallyInferred
  time ${FBIN}/s-query --service ${VHOST}/dataset/query @<(envsubst < additionalExperiments/queries/2.sparql) > additionalExperiments/${name}_locallyInferred.ttl
  ${FBIN}/s-put ${VHOST}/dataset/data http://example.org/${name}_locallyInferred additionalExperiments/${name}_locallyInferred.ttl
  rlog "`localStats "http://example.org/${name}_locallyInferred"`"

  rlog "Schema inferred using LOV..."
  ${FBIN}/s-delete ${VHOST}/dataset http://example.org/${name}_LOVInferred
  time ${FBIN}/s-update --service ${VHOST}/dataset?update @<(envsubst < additionalExperiments/queries/3.sparql)
  ${FBIN}/s-query --service ${VHOST}/dataset/query 'CONSTRUCT {?s ?p ?o} FROM <http://example.org/LOVInferred> {?s ?p ?o}' > additionalExperiments/${name}_LOVInferred.ttl
  ${FBIN}/s-put ${VHOST}/dataset/data http://example.org/${name}_LOVInferred additionalExperiments/${name}_LOVInferred.ttl
  rlog "`localStats "http://example.org/${name}_LOVInferred"`"


  log " * Verifying, that: locallyInstantiated ⊆ locallyInferred"
  tmp=$($FBIN/s-query --service ${VHOST}/dataset/query --output=tsv \
    "SELECT * { 
      GRAPH <http://example.org/${name}_locallyInstantiated> {?s ?p ?o} 
      MINUS {
        GRAPH <http://example.org/${name}_locallyInferred> {?s ?p ?o}
      }
    }" | wc -l)
  if [ "$(echo $tmp)" -gt "1" ]; then 
    rlog "! ! ! W A R N I N G ! ! !      locallyInstantiated ⊈ locallyInferred     ! ! ! W A R N I N G ! ! !"

    $FBIN/s-query --service ${VHOST}/dataset/query --output=tsv \
    "SELECT * { 
      GRAPH <http://example.org/${name}_locallyInstantiated> {?s ?p ?o} 
      MINUS {
        GRAPH <http://example.org/${name}_locallyInferred> {?s ?p ?o}
      }
    }"
  else 
    log "   (🗸) validated successfully"
  fi

log " * Verifying, that: locallyInferred ⊆ LOVInferred"
  tmp=$($FBIN/s-query --service ${VHOST}/dataset/query --output=tsv \
    "SELECT * { 
      GRAPH <http://example.org/${name}_locallyInferred> {?s ?p ?o} 
      MINUS {
        GRAPH <http://example.org/${name}_LOVInferred> {?s ?p ?o}
      }
    }" | wc -l)
  if [ "$(echo $tmp)" -gt "1" ]; then 
    rlog "! ! ! W A R N I N G ! ! !      locallyInferred ⊈ LOVInferred      ! ! ! W A R N I N G ! ! !"

    $FBIN/s-query --service ${VHOST}/dataset/query --output=tsv \
    "SELECT * { 
      GRAPH <http://example.org/${name}_locallyInferred> {?s ?p ?o} 
      MINUS {
        GRAPH <http://example.org/${name}_LOVInferred> {?s ?p ?o}
      }
    }"
  else 
    log "   (🗸) validated successfully"
  fi

done
read -n 1 -s -r -p "Press any key to to remove the terminology and triple store or press Ctrl+C to terminate without cleanup"
sudo docker rm -f triplestore terminology

wait
