Starting Fuseki server in the background
Interface running at http://localhost:3030
Creating LOV terminology server (local copy of the Linked Open Vocabularies project)
Loading LOV data into terminology store
triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
833834,129827,171168,1209,145498,1469,180680

Loading datasets into Fuseki store

Loaded FOAF encoded data into named graph http://example.org/contacts_a
Loaded Schema.org encoded data into named graph http://example.org/contacts_b

Loaded Schema.org vocabulary into named graph http://schema.org/
triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
8427,1617,1619,15,476,31,3193
Loaded FOAF vocabulary into named graph http://xmlns.com/foaf/0.1/
triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
631,84,86,15,38,9,154

Extracting schemata from graph...

Locally instantiated schema...
real	0m2,093s
triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
47,23,23,3,5,2,0

Locally inferred schema...
real	0m7,535s
triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
576,95,95,13,71,9,118

Schema inferred using LOV...
real	0m5,910s
triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
2345,208,208,87,379,16,850

Combined stats:

triples,entities,distinctSubjects,distinctProperties,distinctObjects,distinctClasses,distinctLiterals
8427,1617,1619,15,476,31,3193
631,84,86,15,38,9,154
9058,1701,1705,23,508,38,3335
833834,129827,171168,1209,145498,1469,180680
47,23,23,3,5,2,0
576,95,95,13,71,9,118
2345,208,208,87,379,16,850

Count the number of vocabularies that contain triples from the LOVInferred schema: 265


### SUMMARY
What		 | triples	 | entities	 | distinctSubjects	 | distinctProperties	 | distinctObjects	 | distinctClasses	 | distinctLiterals
---------------: | --------------| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- 
Schema.org vocab | 8427		 | 1617		 | 1619		 | 15		 | 476		 | 31		 | 3193
FoaF voab	 | 631		 | 84		 | 86		 | 15		 | 38		 | 9		 | 154
Schema.org+FoaF	 | 9058		 | 1701		 | 1705		 | 23		 | 508		 | 38		 | 3335
dataset		 | 833834	 | 129827	 | 171168	 | 1209		 | 145498	 | 1469		 | 180680
directly inst.	 | 47		 | 23		 | 23		 | 3		 | 5		 | 2		 | 0
locally inferred | 576		 | 95		 | 95		 | 13		 | 71		 | 9		 | 118
LOV inferred	 | 2345		 | 208		 | 208		 | 87		 | 379		 | 16		 | 850
