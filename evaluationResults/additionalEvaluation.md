# Additional Evaluation Steps

### Verification that all subjects of the autorative vocabularies are also included in the "directly instantiated" extraction by checking that the following query returns an empty result for all datasets
```
SELECT DISTINCT ?s
{
  GRAPH <http://example.org/NAME> {?s ?p ?o}
  FILTER NOT EXISTS {
  	GRAPH <http://example.org/NAME_locallyInstantiated> {?s ?x ?y}
  }
} ORDER BY ?s
```


### Check which subjects are included in the "directly instantiated" schema that are not in the authorative vocabulary via query
```
SELECT DISTINCT ?s
{
  GRAPH <http://example.org/NAME_locallyInstantiated> {?s ?p ?o}
  FILTER NOT EXISTS {
  	GRAPH <http://example.org/NAME> {?s ?x ?y}
  }
} ORDER BY ?s
```

##### GenDR:
\#	 | IRI
-------: | -------------------------------------
1	 | <http://bio2rdf.org/bio2rdf_vocabulary:identifier>
2	 | <http://bio2rdf.org/bio2rdf_vocabulary:namespace>
3	 | <http://bio2rdf.org/bio2rdf_vocabulary:uri>
4	 | <http://bio2rdf.org/bio2rdf_vocabulary:x-identifiers.org>
5	 | <http://bio2rdf.org/ncbigene_vocabulary:Resource>
6	 | <http://bio2rdf.org/pubmed_vocabulary:Resource>
7	 | <http://bio2rdf.org/taxonomy_vocabulary:Resource>
8	 | <http://bio2rdf.org/wormbase_vocabulary:Resource>
9	 | <http://purl.org/dc/terms/identifier>
10	 | <http://purl.org/dc/terms/title>
11	 | <http://rdfs.org/ns/void#inDataset>
12	 | <http://www.w3.org/1999/02/22-rdf-syntax-ns#type>
13	 | <http://www.w3.org/2000/01/rdf-schema#Resource>
14	 | <http://www.w3.org/2000/01/rdf-schema#label>
15	 | <http://www.w3.org/2002/07/owl#Class>
16	 | <http://www.w3.org/2002/07/owl#DatatypeProperty>
17	 | <http://www.w3.org/2002/07/owl#ObjectProperty>

##### Orphanet:
\#	 | IRI
-------: | -------------------------------------
1	 | <http://bio2rdf.org/bio2rdf_vocabulary:identifier>
2	 | <http://bio2rdf.org/bio2rdf_vocabulary:namespace>
3	 | <http://bio2rdf.org/bio2rdf_vocabulary:uri>
4	 | <http://bio2rdf.org/bio2rdf_vocabulary:x-identifiers.org>
5	 | <http://bio2rdf.org/ensembl_vocabulary:Resource>
6	 | <http://bio2rdf.org/genatlas_vocabulary:Resource>
7	 | <http://bio2rdf.org/hgnc_vocabulary:Resource>
8	 | <http://bio2rdf.org/icd10_vocabulary:Resource>
9	 | <http://bio2rdf.org/iuphar_vocabulary:Resource>
10	 | <http://bio2rdf.org/meddra_vocabulary:Resource>
11	 | <http://bio2rdf.org/mesh_vocabulary:Resource>
12	 | <http://bio2rdf.org/obi_vocabulary:Resource>
13	 | <http://bio2rdf.org/omim_vocabulary:Resource>
14	 | <http://bio2rdf.org/reactome_vocabulary:Resource>
15	 | <http://bio2rdf.org/snomedct_vocabulary:Resource>
16	 | <http://bio2rdf.org/umls_vocabulary:Resource>
17	 | <http://bio2rdf.org/uniprot_vocabulary:Resource>
18	 | <http://purl.org/dc/terms/identifier>
19	 | <http://purl.org/dc/terms/title>
20	 | <http://rdfs.org/ns/void#inDataset>
21	 | <http://www.w3.org/1999/02/22-rdf-syntax-ns#type>
22	 | <http://www.w3.org/2000/01/rdf-schema#Resource>
23	 | <http://www.w3.org/2000/01/rdf-schema#label>
24	 | <http://www.w3.org/2000/01/rdf-schema#subClassOf>
25	 | <http://www.w3.org/2002/07/owl#Class>
26	 | <http://www.w3.org/2002/07/owl#DatatypeProperty>
27	 | <http://www.w3.org/2002/07/owl#ObjectProperty>

##### Homologene:
\#	 | IRI
-------: | -------------------------------------
1	 | <http://bio2rdf.org/bio2rdf_vocabulary:identifier>
2	 | <http://bio2rdf.org/bio2rdf_vocabulary:namespace>
3	 | <http://bio2rdf.org/bio2rdf_vocabulary:uri>
4	 | <http://bio2rdf.org/bio2rdf_vocabulary:x-identifiers.org>
5	 | <http://bio2rdf.org/gi_vocabulary:Resource>
6	 | <http://bio2rdf.org/ncbigene_vocabulary:Resource>
7	 | <http://bio2rdf.org/refseq_vocabulary:Resource>
8	 | <http://bio2rdf.org/taxonomy_vocabulary:Resource>
9	 | <http://purl.org/dc/terms/identifier>
10	 | <http://purl.org/dc/terms/title>
11	 | <http://rdfs.org/ns/void#inDataset>
12	 | <http://www.w3.org/1999/02/22-rdf-syntax-ns#type>
13	 | <http://www.w3.org/2000/01/rdf-schema#Resource>
14	 | <http://www.w3.org/2000/01/rdf-schema#label>
15	 | <http://www.w3.org/2002/07/owl#Class>
16	 | <http://www.w3.org/2002/07/owl#DatatypeProperty>
17	 | <http://www.w3.org/2002/07/owl#ObjectProperty>


### Check which subjects are included in the "locally inferred" schema that are not in the "directly instantiated" one, via query
```
SELECT DISTINCT ?s
{
  GRAPH <http://example.org/NAME_locallyInferred> {?s ?p ?o}
  FILTER NOT EXISTS {
  	GRAPH <http://example.org/NAME_locallyInstantiated> {?s ?x ?y}
  }
} ORDER BY ?s
```

No difference for either GenDR or Homologene, however for Orphanet there is an additional subject <http://bio2rdf.org/orphanet_vocabulary:Disorder-Gene-Association>. Further investigation via query
```
SELECT DISTINCT ?s ?p
FROM <http://example.org/orphanet>
{
?s ?p <http://bio2rdf.org/orphanet_vocabulary:Disorder-Gene-Association>
} ORDER BY ?s
```
reveals that the authorative vocabulary defines an additional class that itself does not occur in the dataset but is a superclass of the 8 instantiated and (also previously) included classes: 

\#	 | ?s                                    | ?p
-------: | ------------------------------------- | -------------------------------------
1	 | <http://bio2rdf.org/orphanet:17949>	 | <http://www.w3.org/2000/01/rdf-schema#subClassOf>
2	 | <http://bio2rdf.org/orphanet:17955>	 | <http://www.w3.org/2000/01/rdf-schema#subClassOf>
3	 | <http://bio2rdf.org/orphanet:17961>	 | <http://www.w3.org/2000/01/rdf-schema#subClassOf>
4	 | <http://bio2rdf.org/orphanet:17967>	 | <http://www.w3.org/2000/01/rdf-schema#subClassOf>
5	 | <http://bio2rdf.org/orphanet:17973>	 | <http://www.w3.org/2000/01/rdf-schema#subClassOf>
6	 | <http://bio2rdf.org/orphanet:17979>	 | <http://www.w3.org/2000/01/rdf-schema#subClassOf>
7	 | <http://bio2rdf.org/orphanet:17985>	 | <http://www.w3.org/2000/01/rdf-schema#subClassOf>
8	 | <http://bio2rdf.org/orphanet:18273>	 | <http://www.w3.org/2000/01/rdf-schema#subClassOf>

As such this case serves as a nice demonstration of how the local inference resolved the subclass relationship.
