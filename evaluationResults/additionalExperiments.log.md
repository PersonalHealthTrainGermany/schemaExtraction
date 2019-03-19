Starting Terminology server in the background
 * waiting for Terminology Service to become available
 * Loading LOV data into terminology store
 * loading additional dataset schemata


processing dataset: gendr

triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
192,20,20,8,6,5,116
 * Extracting schemata from graph http://bio2rdf.org/gendr_resource:bio2rdf.dataset.gendr.R3

Locally instantiated schema...
real	0m0,201s
triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
361,37,37,10,16,7,105

Locally inferred schema...
real	0m0,559s
triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
380,37,37,10,16,7,124

Schema inferred using LOV...
real	0m2,133s
triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
911,71,71,58,127,12,370

 * Verifying, that: locallyInstantiated ⊆ locallyInferred
   (🗸) validated successfully
 * Verifying, that: locallyInferred ⊆ LOVInferred
   (🗸) validated successfully


processing dataset: orphanet

triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
402,40,40,9,7,5,239
 * Extracting schemata from graph http://bio2rdf.org/orphanet_resource:bio2rdf.dataset.orphanet.R3

Locally instantiated schema...
real	0m6,074s
triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
799,67,67,12,41,7,217

Locally inferred schema...
real	0m16,760s
triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
840,68,68,12,41,7,256

Schema inferred using LOV...
real	0m8,192s
triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
1380,102,102,59,153,12,506

 * Verifying, that: locallyInstantiated ⊆ locallyInferred
   (🗸) validated successfully
 * Verifying, that: locallyInferred ⊆ LOVInferred
   (🗸) validated successfully


processing dataset: homologene

triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
62,7,7,8,6,5,38
 * Extracting schemata from graph http://bio2rdf.org/homologene_resource:bio2rdf.dataset.homologene.R3

Locally instantiated schema...
real	1m5,515s
triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
184,24,24,10,13,7,40

Locally inferred schema...
real	84m25,411s
triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
190,24,24,10,13,7,46

Schema inferred using LOV...
real	1m4,512s
triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
721,58,58,58,124,12,292

 * Verifying, that: locallyInstantiated ⊆ locallyInferred
   (🗸) validated successfully
 * Verifying, that: locallyInferred ⊆ LOVInferred
   (🗸) validated successfully


### SUMMARY
processing dataset: gendr
What		 | triples	 | entities	 | distinctSubjects	 | distinctProperties	 | distinctObjects	 | distinctClasses	 | distinctLiterals
---------------: | --------------| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- 
dataset		 | 11609	 | 1123		 | 1123		 | 24		 | 1232		 | 13		 | 5158
ref. vocabulary	 | 192		 | 20		 | 20		 | 8		 | 6		 | 5		 | 116
directly inst.	 | 361		 | 37		 | 37		 | 10		 | 16		 | 7		 | 105
locally inferred | 380		 | 37		 | 37		 | 10		 | 16		 | 7		 | 124
LOV inferred	 | 911		 | 71		 | 71		 | 58		 | 127		 | 12		 | 370

processing dataset: orphanet
What		 | triples	 	 | entities	 | distinctSubjects	 | distinctProperties	 | distinctObjects	 | distinctClasses	 | distinctLiterals
---------------: | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- 
dataset		 | 377947	 | 28871	 | 28871	 | 38		 | 42891	 | 29		 | 144773
ref. vocabulary	 | 402		 | 40		 | 40		 | 9		 | 7		 | 5		 | 239
directly inst.	 | 799		 | 67		 | 67		 | 12		 | 41		 | 7		 | 217
locally inferred | 840		 | 68		 | 68		 | 12		 | 41		 | 7		 | 256
1380		 | 102		 | 102		 | 59		 | 153		 | 12		 | 506

processing dataset: homologene
What		 | triples	 | entities	 | distinctSubjects	 | distinctProperties	 | distinctObjects	 | distinctClasses	 | distinctLiterals
---------------: | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- 
dataset		 | 7189742	 | 869981	 | 869981	 | 14		 | 1420471	 | 10		 | 2865019
ref. vocabulary	 | 62		 | 7		 | 7		 | 8		 | 6		 | 5		 | 38
directly inst.	 | 184		 | 24		 | 24		 | 10		 | 13		 | 7		 | 40
locally inferred | 190		 | 24		 | 24		 | 10		 | 13		 | 7		 | 46
1380		 | 1721		 | 58		 | 58		 | 58		 | 124		 | 12		 | 292

