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
        "/graphXql/resolvers/preface-resolver.xqy",
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

declare variable $gxqlr:ETHIC-ITEM-FIELDS :=
    (
        'name',
        'type',
        'uri',
        'text',
        'partNumber',
        'itemNumber',
        'descendants',
        'references',
        'previous',
        'next'
    );

declare function gxqlr:ethic-item-entity-resolver($var-map as map:map) as element(*, gxql:EthicItem)?
{
    let $uri :=
        if (map:contains($var-map, 'uri'))
        then map:get($var-map, 'uri')
        else fn:error((), 'ENTITY RESOLVER EXCEPTION', ("500", "Internal server error", "No uri received in variables: ", $var-map))

    return
        element gxql:item
        {
            element gxql:uri {$uri}
        }
};

declare function gxqlr:ethic-item-field-resolver($field-name as xs:string) as xdmp:function
{
    if ($field-name = $gxqlr:ETHIC-ITEM-FIELDS) then xdmp:function(xs:QName('gxqlr:item-'||$field-name||'-resolver'))
    else
        fn:error((), 'ETHIC ITEM FIELD RESOLVER EXCEPTION', ("500", "Internal server error", "unsupported field: "||$field-name))
};

declare function gxqlr:item-name-resolver($item as element(*, gxql:EthicItem), $var-map as map:map)
{
    fn:doc($item/uri/fn:string())//eth:name/string()
};

declare function gxqlr:item-type-resolver($item as element(*, gxql:EthicItem), $var-map as map:map)
{
    fn:doc($item/uri/fn:string())//eth:type/string()
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
    return gxqlr:linked-entities-resolver($reference-maps, 'reference')
};

declare function gxqlr:item-descendants-resolver($item as element(*, gxql:EthicItem), $var-map as map:map)
{
    let $descendant-maps := gxqlr:find-descendants($item/uri/fn:string())
    return gxqlr:linked-entities-resolver($descendant-maps, 'descendant')
};

declare function gxqlr:item-previous-resolver($item as element(*, gxql:EthicItem), $var-map as map:map) as element(*, gxql:EthicItem)?
{
    let $uri := $item/uri/fn:string()
    let $current-ordinal := cts:search(fn:doc()//eth:coordinates/eth:ordinal, cts:document-query($uri)) => xs:int()
    let $current-type := cts:search(fn:doc()//eth:type, cts:document-query($uri)) => xs:string()

    let $previous-item-name := cts:search(fn:doc(), cts:and-query((
                                cts:element-value-query(xs:QName('eth:type'), $current-type)
                                ,cts:element-range-query(xs:QName('eth:ordinal'), '<', $current-ordinal)))
                                ,cts:index-order(cts:element-reference(xs:QName('eth:ordinal')), 'descending')
                                )[1]//eth:name/string()
    let $previous-item-uri := 'http://ethica.graph.ql/'||$previous-item-name
    let $var-map := map:map() => map:with('uri', $previous-item-uri)

    return
        if ($previous-item-uri) then gxqlr:ethic-item-entity-resolver($var-map)
        else ()
};

declare function gxqlr:item-next-resolver($item as element(*, gxql:EthicItem), $var-map as map:map) as element(*, gxql:EthicItem)?
{
    let $uri := $item/uri/fn:string()
    let $current-ordinal := cts:search(fn:doc()//eth:coordinates/eth:ordinal, cts:document-query($uri)) => xs:int()
    let $current-type := cts:search(fn:doc()//eth:type, cts:document-query($uri)) => xs:string()

    let $next-item-name := cts:search(fn:doc(), cts:and-query((
                                cts:element-value-query(xs:QName('eth:type'), $current-type)
                                ,cts:element-range-query(xs:QName('eth:ordinal'), '>', $current-ordinal)))
                                ,cts:index-order(cts:element-reference(xs:QName('eth:ordinal')), 'ascending')
                                )[1]//eth:name/string()
    let $next-item-uri := 'http://ethica.graph.ql/'||$next-item-name
    let $var-map := map:map() => map:with('uri', $next-item-uri)

    return
        if ($next-item-uri) then gxqlr:ethic-item-entity-resolver($var-map)
        else ()
};

declare function gxqlr:linked-entities-resolver($linked-entities as map:map*, $link-type as xs:string){
    for $linked-entity in $linked-entities
        let $linked-entity-uri := map:get($linked-entity, $link-type)
        let $linked-entity-type := map:get($linked-entity, 'type')
        let $var-map := map:map() => map:with('uri', $linked-entity-uri)
        return
            switch ($linked-entity-type)
            case 'http://ethica.graph.ql/Model#Affection-Definition' return gxqlr:affection-definition-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Affection-Definition-Explanation' return gxqlr:affection-definition-explanation-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Affections-General-Definition' return gxqlr:general-definition-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Affections-General-Definition-Explanation' return gxqlr:general-definition-explanation-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Appendix' return gxqlr:appendix-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Axiom' return gxqlr:axiom-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Definition' return gxqlr:definition-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Definition-Explanation' return gxqlr:definition-explanation-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Postulate' return gxqlr:postulate-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Preface' return gxqlr:preface-entity-resolver($var-map)
            case 'http://ethica.graph.ql/Model#Proposition' return gxqlr:proposition-entity-resolver($var-map)
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
            case 'http://ethica.graph.ql/Model#Proposition-Postulate' return gxqlr:proposition-postulate-entity-resolver($var-map)
            default return fn:error((), 'RESOLVER EXCEPTION', ("500", "Internal server error", "unsupported linked type: "||$linked-entity-type))
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

