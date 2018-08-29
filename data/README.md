# Experiment Data
`contacts_a.ttl` and `contacts_b.ttl` are two sets of 2500 personal data records each, converted from corresponding raw datasets using the [SPARQL-Generate extension](https://ci.mines-stetienne.fr/sparql-generate/) with the conversion script `raw2RDF.sh`.
The data is encoded using the [FOAF](http://xmlns.com/foaf/spec/), [Schema.org](https://schema.org/docs/schemas.html) and [WGS84](https://www.w3.org/2003/01/geo/#vocabulary) vocabularies.

## Additional Licensing Information
File: `foaf.ttl`
License: (CC BY 1.0) Dan Brickley, Libby Miller (c.f. http://xmlns.com/foaf/spec/20140114.html)
Source: http://xmlns.com/foaf/spec/20140114.rdf (accessed 2018-04-18, converted to Turtle via https://rdf-translator.appspot.com/)

File: `schema.ttl`
License: (CC BY-SA 3.0) Schema.org Sponsors (c.f. https://schema.org/docs/terms.html)
Source: https://schema.org/version/3.3/schema.ttl (accessed 2018-04-17)

File: `lov.nq`
License: (CC BY 4.0) Linked Open Vocabularies Contributors (c.f. https://lov.linkeddata.es/dataset/lov/about)
Source: https://lov.linkeddata.es/lov.nq.gz (accessed 2018-08-13)

File: `sparql-generate-jena.jar`
License: Apache Software License, Version 2.0 (c.f. https://ci.mines-stetienne.fr/sparql-generate/license.html)
Source: https://ci.mines-stetienne.fr/sparql-generate/language-cli.html (accessed 2018-07-23)
