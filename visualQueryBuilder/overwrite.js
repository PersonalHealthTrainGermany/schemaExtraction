'use strict';

angular.module('VSB.config')
    .config(function (globalConfig) {
        globalConfig.name = 'SCHEMA_CONFIG';
        globalConfig.prefixes = _.merge(globalConfig.prefixes, {
            'units': 'http://dbpedia.org/units/',
            'yago': 'http://dbpedia.org/class/yago/',
            'schema': 'http://schema.org/',
            'foaf': 'http://xmlns.com/foaf/0.1/'
        });
        globalConfig.defaultGraphURIs = ['http://example.org/locallyInferred','http://example.org/contacts_a','http://example.org/contacts_b'];
        globalConfig.baseURL = 'http://localhost:3030/ds/sparql';
        globalConfig.resultURL = globalConfig.baseURL;
        globalConfig.endPointQueries = Object.assign(globalConfig.endPointQueries, {
				    getDirectProperties: '<%uri%> (rdfs:subClassOf )* ?class .' +
				        '{?uri rdfs:domain ?class} UNION {?uri schema:domainIncludes ?class} .' +
				        'OPTIONAL { {?uri rdfs:range ?range} UNION {?uri schema:rangeIncludes ?range} }  .' +
				        'OPTIONAL { ?uri rdf:type ?type }  .' +
				        'OPTIONAL { ?uri rdfs:label ?label . BIND(LANG(?label) AS ?label_loc) } .' +
				        'OPTIONAL { ?uri rdfs:comment ?comment . BIND(LANG(?comment) AS ?comment_loc) } .' +
				        'FILTER ( !isBlank(?class) && !isBlank(?uri) && !isBlank(?range) ) ',
				    getInverseProperties: '<%uri%> (rdfs:subClassOf)* ?class .' +
				        '{?uri rdfs:range ?class} UNION {?uri schema:rangeIncludes ?class} .' +
				        'OPTIONAL { {?uri rdfs:domain ?range} UNION {?uri schema:domainIncludes ?range}}  .' +
				        'OPTIONAL { ?uri rdf:type ?type }  .' +
				        'OPTIONAL { ?uri rdfs:label ?label . BIND(LANG(?label) AS ?label_loc) } .' +
				        'OPTIONAL { ?uri rdfs:comment ?comment . BIND(LANG(?comment) AS ?comment_loc) } .' +
				        'FILTER ( !isBlank(?class) && !isBlank(?uri) && !isBlank(?range) ) ',
				    getSuperAndEqClasses: '<%uri%> (rdfs:subClassOf|(owl:equivalentClass|^owl:equivalentClass))* ?uri ' +
				        'FILTER ( !isBlank(?uri) )',
				    getSubAndEqClasses: '<%uri%> (^rdfs:subClassOf|(owl:equivalentClass|^owl:equivalentClass))* ?uri ' +
				        'FILTER ( !isBlank(?uri) )',
				    getAvailableClasses: '{?uri a rdfs:Class .} UNION {?uri a owl:Class .} .' +
				        'FILTER ( !isBlank(?uri) )' +
				        'OPTIONAL { ?uri rdfs:label ?label . BIND(LANG(?label) AS ?label_loc) } .' +
				        'OPTIONAL { ?uri rdfs:comment ?comment . BIND(LANG(?comment) AS ?comment_loc)} ',
				    getPossibleRelation: '<%uri1%> (rdfs:subClassOf|(owl:equivalentClass|^owl:equivalentClass))* ?class1 .' +
                '<%uri2%> (rdfs:subClassOf|(owl:equivalentClass|^owl:equivalentClass))* ?class2 .' +
                '{ ' +
                '?uri (rdfs:domain|schema:domainIncludes) ?class1 . ' +
                '?uri (rdfs:range|schema:rangeIncludes) ?class2  .' +
                '} UNION { ' +
                '?uri (rdfs:domain|schema:domainIncludes) ?class2 . ' +
                '?uri (rdfs:range|schema:rangeIncludes) ?class1  .' +
                '}'
				});
    })

    /*
     * Everything below is just for the dbpedia demo on leipert.github.io/vsb
     *
     *
     */

    .run(function ($localForage, TranslatorToVSBL, MessageService, languageStorage) {

        languageStorage.mergeLanguages({
            de: {
                EXAMPLE_MESSAGE: 'Visual Query Builder (leipert.github.io/vsb)'
            },
            en: {
                EXAMPLE_MESSAGE: 'Visual Query Builder (leipert.github.io/vsb)'
            }
        });

        MessageService.addMessage('<span translate="EXAMPLE_MESSAGE"></span>');

        $localForage.getItem('current').then(function (data) {
            if (data === null || data === undefined) {
                loadExample()
            }
        }, loadExample);

        function loadExample() {
            TranslatorToVSBL.translateJSONToVSBL(getExample());
        }

        function getExample() {
            return {
                "CONFIG": "SCHEMA_CONFIG",
                "START": {
                    "type": "LIST_ALL",
                    "linkTo": "person"
                },
                "SUBJECTS": [
									{
										"uri": "http://schema.org/Person",
										"pos": {
											"x": 390,
											"y": 190
										},
										"view": true,
										"alias": "Person",
										"properties": [
											{
												"uri": "http://schema.org/givenName",
												"type": "STANDARD_PROPERTY",
												"filterExists": true,
												"hasFilter": false,
												"compareRaw": {},
												"linkTo": null,
												"view": true,
												"optional": false,
												"arithmetic": null,
												"compare": null,
												"alias": "givenName"
											},
											{
												"uri": "http://schema.org/familyName",
												"type": "STANDARD_PROPERTY",
												"filterExists": true,
												"hasFilter": false,
												"compareRaw": {},
												"linkTo": null,
												"view": true,
												"optional": false,
												"arithmetic": null,
												"compare": null,
												"alias": "familyName"
											}
										]
									}
								]
            };
        }
    }
);