#!/usr/bin/env bash

distrib="http://download.bio2rdf.org/files/release/3"

echo "Downloading Schemata"
for name in {gendr,orphanet,homologene}; do
	curl -# $distrib/$name/$name.schema.owl -O
done

echo "Downloading Orphanet"
for file in {d2s,disease,epi,genes,signs}; do
	curl -# $distrib/orphanet/orphanet-$file.nq.gz -O
done

echo "Downloading GenDR"
curl -# $distrib/gendr/gendr_gene_manipulations.nq.gz -O
curl -# $distrib/gendr/gendr_gene_expression.nq.gz -O

echo "Downloading Homologene"
curl -# $distrib/homologene/homologene.nq.gz -O

gunzip *.nq.gz
