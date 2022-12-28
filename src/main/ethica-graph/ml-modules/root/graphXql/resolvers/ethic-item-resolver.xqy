xquery version "1.0-ml";

module namespace gxqlr = "http://graph.x.ql/resolvers";
import module namespace gxqlr = "http://graph.x.ql/resolvers"
    at  "/graphXql/resolvers/affection-definition-resolver.xqy",
        "/graphXql/resolvers/affection-definition-explanation-resolver.xqy",
        "/graphXql/resolvers/appendix-resolver.xqy",
        "/graphXql/resolvers/axiom-resolver.xqy",
        "/graphXql/resolvers/definition-resolver.xqy",
        "/graphXql/resolvers/definition-explanation-resolver.xqy",
        "/graphXql/resolvers/general-definition-resolver.xqy",
        "/graphXql/resolvers/general-definition-explanation-resolver.xqy",
        "/graphXql/resolvers/postulate-resolver.xqy",
        "/graphXql/resolvers/proposition-resolver.xqy",
        "/graphXql/resolvers/proposition-axiom-resolver.xqy",
        "/graphXql/resolvers/proposition-corollary-resolver.xqy",
        "/graphXql/resolvers/proposition-corollary-demonstration-resolver.xqy",
        "/graphXql/resolvers/proposition-corollary-scolia-resolver.xqy",
        "/graphXql/resolvers/proposition-demonstration-resolver.xqy",
        "/graphXql/resolvers/proposition-lemme-resolver.xqy",
        "/graphXql/resolvers/proposition-lemme-axiom-resolver.xqy",
        "/graphXql/resolvers/proposition-lemme-corollary-resolver.xqy",
        "/graphXql/resolvers/proposition-lemme-definition-resolver.xqy",
        "/graphXql/resolvers/proposition-lemme-demonstration-resolver.xqy",
        "/graphXql/resolvers/proposition-lemme-scolia-resolver.xqy",
        "/graphXql/resolvers/proposition-postulate-resolver.xqy",
        "/graphXql/resolvers/proposition-scolia-resolver.xqy";

import schema namespace gxql ="http://graph.x.ql"
    at "/graphxql/entities/graphXql-types.xsd";

declare default element namespace "http://graph.x.ql";
declare namespace eth="http://ethica.graph.ql";

declare function gxqlr:ethic-item-field-resolver($field-name as xs:string) as xdmp:function
{
         if ($field-name eq 'name') then xdmp:function(xs:QName('gxqlr:item-name-resolver'))
    else if ($field-name eq 'uri') then xdmp:function(xs:QName('gxqlr:item-uri-resolver'))
    else if ($field-name eq 'text') then xdmp:function(xs:QName('gxqlr:item-text-resolver'))
    else if ($field-name eq 'partNumber') then xdmp:function(xs:QName('gxqlr:item-partNumber-resolver'))
    else if ($field-name eq 'itemNumber') then xdmp:function(xs:QName('gxqlr:item-itemNumber-resolver'))
    else if ($field-name eq 'descendants') then xdmp:function(xs:QName('gxqlr:item-descendants-resolver'))
    else if ($field-name eq 'references') then xdmp:function(xs:QName('gxqlr:item-references-resolver'))
    else
        fn:error((), 'FIELD RESOLVER EXCEPTION', ("500", "Internal server error", "unsupported field: "||$field-name))
};

declare function gxqlr:item-name-resolver($item as element(*, gxql:EthicItem), $var-map as map:map)
{
    fn:doc($item/uri/fn:string())//eth:name/string()
};

declare function gxqlr:item-uri-resolver($item as element(*, gxql:EthicItem), $var-map as map:map)
{
    $item/uri/fn:string()
};

declare function gxqlr:item-text-resolver($item as element(*, gxql:EthicItem), $var-map as map:map)
{
    fn:doc($item/uri/fn:string())//eth:text/string()
};

declare function gxqlr:item-partNumber-resolver($item as element(*, gxql:EthicItem), $var-map as map:map)
{
    fn:doc($item/uri/fn:string())//eth:coordinates/eth:part-number/string()
};

declare function gxqlr:item-itemNumber-resolver($item as element(*, gxql:EthicItem), $var-map as map:map)
{
    fn:doc($item/uri/fn:string())//eth:coordinates/eth:item-number/string()
};

declare function gxqlr:item-references-resolver($item as element(*, gxql:EthicItem), $var-map as map:map)
{
    let $reference-maps := gxqlr:find-references($item/uri/fn:string())
    for $reference-map in $reference-maps
        let $reference-uri := map:get($reference-map, 'reference')
        let $reference-type := map:get($reference-map, 'type')
        let $var-map := map:map() => map:with('uri', $reference-uri)
        return
            switch ($reference-type)
            case 'http://ethica.graph.ql/Model#Affection-Definition' return gxqlr:affection-definition-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Affection-Definition-Explanation' return gxqlr:affection-definition-explanation-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Affections-General-Definition' return gxqlr:general-definition-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Appendix' return gxqlr:appendix-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Axiom' return gxqlr:axiom-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Definition' return gxqlr:definition-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Definition-Explanation' return gxqlr:definition-explanation-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Postulate' return gxqlr:postulate-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition' return gxqlr:proposition-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Corollary' return gxqlr:proposition-corollary-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Demonstration' return gxqlr:proposition-demonstration-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Lemme' return gxqlr:proposition-lemme-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Lemme-Axiom' return gxqlr:proposition-lemme-axiom-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Scolia' return gxqlr:proposition-scolia-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Postulate' return gxqlr:proposition-postulate-entity-resolver($var-map)
            default return fn:error((), 'RESOLVER EXCEPTION', ("500", "Internal server error", "unsupported reference-type: "||$reference-type))
};

declare function gxqlr:item-descendants-resolver($item as element(*, gxql:EthicItem), $var-map as map:map)
{
    let $descendant-maps := gxqlr:find-descendants($item/uri/fn:string())
    for $descendant-map in $descendant-maps
        let $descendant-uri := map:get($descendant-map, 'descendant')
        let $descendant-type := map:get($descendant-map, 'type')
        let $var-map := map:map() => map:with('uri', $descendant-uri)
        return
            switch ($descendant-type)
            case 'http://ethica.graph.ql/Model#Affection-Definition-Explanation' return gxqlr:affection-definition-explanation-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Affections-General-Definition-Explanation' return gxqlr:general-definition-explanation-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Appendix' return gxqlr:appendix-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Definition-Explanation' return gxqlr:definition-explanation-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Postulate' return gxqlr:postulate-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Axiom' return gxqlr:proposition-axiom-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Corollary' return gxqlr:proposition-corollary-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Corollary-Demonstration' return gxqlr:proposition-corollary-demonstration-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Corollary-Scolia' return gxqlr:proposition-corollary-scolia-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Demonstration' return gxqlr:proposition-demonstration-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Lemme' return gxqlr:proposition-lemme-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Lemme-Axiom' return gxqlr:proposition-lemme-axiom-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Lemme-Corollary' return gxqlr:proposition-lemme-corollary-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Lemme-Definition' return gxqlr:proposition-lemme-definition-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Lemme-Demonstration' return gxqlr:proposition-lemme-demonstration-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Lemme-Scolia' return gxqlr:proposition-lemme-scolia-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Postulate' return gxqlr:proposition-postulate-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Scolia' return gxqlr:proposition-scolia-entity-resolver($var-map)
            default return fn:error((), 'RESOLVER EXCEPTION', ("500", "Internal server error", "unsupported descendant-type: "||$descendant-type))
};

declare function gxqlr:find-references($item-uri as xs:string) as map:map*
{
    let $sparql := '
    prefix eth:<http://ethica.graph.ql/Model#>
    select ?reference ?type
    where {
      ?item eth:refersTo ?reference .
      ?reference a ?type .
    }'
    return
      sem:sparql($sparql, map:map()=>map:with('item', sem:iri($item-uri)), (), ())
};

declare function gxqlr:find-descendants($item-uri as xs:string) as map:map*
{
    let $sparql := '
        prefix eth:<http://ethica.graph.ql/Model#>
        prefix skos: <http://www.w3.org/2004/02/skos/core#>

        select ?descendant ?type
        where {
          ?descendant ?related ?item .
          eth:descendantOf skos:broader ?related .
          ?descendant a ?type .
        }'
    return
      sem:sparql($sparql, map:map()=>map:with('item', sem:iri($item-uri)), (), ())

};

