#!/usr/bin/env bash

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT
export FUSEKI_HOME="${PWD}/apache-jena-fuseki-3.7.0"
FBIN="./apache-jena-fuseki-3.7.0/bin"
HOST="http://localhost:3030"

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

if [ ! -f data/lov.nq ]; then
    gunzip -c data/lov.nq.gz > data/lov.nq
fi

log "Starting Fuseki server in the background"
./apache-jena-fuseki-3.7.0/fuseki-server --update --mem /ds > fuseki.log &
log "Interface running at ${HOST}"

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
	
	${FBIN}/s-query --service ${HOST}/ds/query --output=csv "$query"
}

remoteStats() {
	query="SELECT ?triples ?entities ?distinctSubjects ?distinctProperties ?distinctObjects ?distinctClasses ?distinctLiterals"
	for graph in "$@"; do query="$query FROM <$graph>"; done
	query="$query WHERE { {$HCLS1}{$HCLS2}{$HCLS3}{$HCLS4}{$HCLS5}{$HCLS6}{$HCLS7} }"
	
	${FBIN}/s-query --service ${HOST}/terminology --output=csv "$query"
}

terminologyStats() {
	HCLS1="SELECT (COUNT(*) AS ?triples) { GRAPH ?g { ?s ?p ?o }}"
	HCLS2="SELECT (COUNT(DISTINCT ?s) AS ?entities) { GRAPH ?g { ?s a [] }}"
	HCLS3="SELECT (COUNT(DISTINCT ?s) AS ?distinctSubjects) { GRAPH ?g { ?s ?p ?o }}"
	HCLS4="SELECT (COUNT(DISTINCT ?p) AS ?distinctProperties) { GRAPH ?g { ?s ?p ?o }}"
	HCLS5='SELECT (COUNT(DISTINCT ?o) AS ?distinctObjects) { GRAPH ?g { ?s ?p ?o  FILTER(!isLiteral(?o)) }}'
	HCLS6="SELECT (COUNT(DISTINCT ?o) AS ?distinctClasses) { GRAPH ?g { ?s a ?o }}"
	HCLS7="SELECT (COUNT(DISTINCT ?o) AS ?distinctLiterals){ GRAPH ?g { ?s ?p ?o FILTER(isLiteral(?o)) }}"
	
	query="SELECT ?triples ?entities ?distinctSubjects ?distinctProperties ?distinctObjects ?distinctClasses ?distinctLiterals 
	  { {$HCLS1}{$HCLS2}{$HCLS3}{$HCLS4}{$HCLS5}{$HCLS6}{$HCLS7} }"
	  
	${FBIN}/s-query --service ${HOST}/terminology --output=csv "$query"
}



sleep 8s

log "Creating LOV terminology server (local copy of the Linked Open Vocabularies project)"
curl -d "dbName=terminology&dbType=mem" -X POST "http://localhost:3030/$/datasets"
log "Loading LOV data into terminology store"
curl -X POST -H "Content-Type: application/n-quads" -T data/lov.nq -# ${HOST}/terminology > /dev/null
rlog "`terminologyStats`"

log "Loading datasets into Fuseki store"
${FBIN}/s-put ${HOST}/ds/data http://example.org/contacts_a data/contacts_a.ttl
log "Loaded FOAF encoded data into named graph http://example.org/contacts_a"

${FBIN}/s-put ${HOST}/ds/data http://example.org/contacts_b data/contacts_b.ttl 
log "Loaded Schema.org encoded data into named graph http://example.org/contacts_b"

${FBIN}/s-put ${HOST}/ds/data http://schema.org/ data/schema.ttl 
log "Loaded Schema.org vocabulary into named graph http://schema.org/"
rlog "`localStats "http://schema.org/"`"

${FBIN}/s-put ${HOST}/ds/data http://xmlns.com/foaf/0.1/ data/foaf.ttl 
log "Loaded FOAF vocabulary into named graph http://xmlns.com/foaf/0.1/"
rlog "`localStats "http://xmlns.com/foaf/0.1/"`"





log "Extracting schemata from graph..."
#time ${FBIN}/s-query --service ${HOST}/ds/query --query queries/schema.sparql > schema.ttl

log "Locally instantiated schema..."
time ${FBIN}/s-query --service ${HOST}/ds/query --query queries/schema1_optimized.sparql > locallyInstantiated.ttl
${FBIN}/s-put ${HOST}/ds/data http://example.org/locallyInstantiated locallyInstantiated.ttl
rlog "`localStats "http://example.org/locallyInstantiated"`"

#time ${FBIN}/s-query --service ${HOST}/ds/query --query queries/schema2_optimized.sparql > s2.ttl

log "Locally inferred schema..."
time ${FBIN}/s-query --service ${HOST}/ds/query --query queries/schema3_optimized.sparql > locallyInferred.ttl
${FBIN}/s-put ${HOST}/ds/data http://example.org/locallyInferred locallyInferred.ttl
rlog "`localStats "http://example.org/locallyInferred"`"

log "Schema inferred using LOV..."
time ${FBIN}/s-update --service ${HOST}/ds?update --update queries/multistep.sparql
${FBIN}/s-query --service ${HOST}/ds/query 'CONSTRUCT {?s ?p ?o} FROM <http://example.org/LOVInferred> {?s ?p ?o}' > LOVInferred.ttl
rlog "`localStats "http://example.org/LOVInferred"`"


#graph="http://example.org/schema"
#log "...done. Loading into \"public\" schema endpoint $graph"
#${FBIN}/s-put ${HOST}/ds/data $graph schema.ttl
##log "Schema endpoint available as named graph $graph"
#log "`localStats "$graph"`"

#time ${FBIN}/s-query --service ${HOST}/ds --query queries/multistep.sparql

rlog "\nCombined stats:\n"
rlog "`localStats "http://schema.org/"`"
rlog "`localStats "http://xmlns.com/foaf/0.1/"`"
rlog "`localStats "http://schema.org/" "http://xmlns.com/foaf/0.1/"`"
rlog "`terminologyStats`"
rlog "`localStats "http://example.org/locallyInstantiated"`"
rlog "`localStats "http://example.org/locallyInferred"`"
rlog "`localStats "http://example.org/LOVInferred"`"

log "Count the number of vocabularies that contain triples from the LOVInferred schema"
${FBIN}/s-query --service ${HOST}/ds/query --output=csv 'SELECT (count(DISTINCT ?g) as ?vocabCount)
FROM <http://example.org/LOVInferred> { 
  ?s ?p ?o .
  SERVICE <http://localhost:3030/terminology/query> {
    GRAPH ?g {?s ?p ?o}
  }
}'

wait