#!/usr/bin/env bash
java -jar sparql-generate-jena.jar -q a.sparql -o contacts_a.ttl
java -jar sparql-generate-jena.jar -q b.sparql -o contacts_b.ttl