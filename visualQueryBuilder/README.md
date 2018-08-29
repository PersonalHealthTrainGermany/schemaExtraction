# Visual SPARQL Builder
This folder contains a copy of the [Visual SPARQL Builder](https://github.com/leipert/vsb) tool by [Lukas Eipert](https://github.com/leipert), configured using a custom overwrite.js configuration file to allow for assisted query building against a previously extracted schema. 

Using this configuration, the schema is queried from the named graph http://example.org/locallyInferred through the SPARQL endpoint http://localhost:3030/ds/sparql. Results are further included from named graphs http://example.org/contacts_a and http://example.org/contacts_b

#### Running
Serve the contents of this directory using a http server of your choice, i.e. by running `python -m SimpleHTTPServer` (python 2.x) or `python -m http.server` (python 3.x) in the current directory.

#### Note
Unfortunately the tool is no longer maintained and not all features of the query builder work properly (c.f. https://github.com/leipert/vsb/issues). 
Additionally this tool is not currently capable of building queries that resolve equivalences and generalizations automatically.