xquery version "1.0-ml";

module namespace gxqlr = "http://graph.x.ql/resolvers";
import module namespace gxqlr = "http://graph.x.ql/resolvers"
    at "/graphXql/resolvers/proposition-resolver.xqy",
        "/graphXql/resolvers/affection-definition-resolver.xqy",
        "/graphXql/resolvers/definition-resolver.xqy",
        "/graphXql/resolvers/general-definition-resolver.xqy",
        "/graphXql/resolvers/proposition-demonstration-resolver.xqy",
        "/graphXql/resolvers/proposition-corollary-resolver.xqy",
        "/graphXql/resolvers/proposition-lemme-resolver.xqy",
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
            case 'http://ethica.graph.ql/Model#Affections-General-Definition' return gxqlr:general-definition-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Definition' return gxqlr:definition-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition' return gxqlr:proposition-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Demonstration' return gxqlr:proposition-demonstration-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Scolia' return gxqlr:proposition-scolia-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Postulate' return gxqlr:proposition-postulate-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Corollary' return gxqlr:proposition-corollary-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition-Lemme' return gxqlr:proposition-lemme-entity-resolver($var-map)
            default return fn:error((), 'RESOLVER EXCEPTION', ("500", "Internal server error", "unsupported reference-type: "||$reference-type))
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
        select ?descendant ?type
        where {
          ?descendant eth:refersTo ?item .
          ?descendant a ?type .
        }'
    return
      sem:sparql($sparql, map:map()=>map:with('item', sem:iri($item-uri)), (), ())

};

