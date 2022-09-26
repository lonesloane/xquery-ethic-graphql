xquery version "1.0-ml";

module namespace gxqlr = "http://graph.x.ql/resolvers";

import module namespace gxqlr = "http://graph.x.ql/resolvers"
    at "/graphXql/resolvers/ethic-item-resolver.xqy",
        "/graphXql/resolvers/affection-definition-explanation-resolver.xqy";

import schema namespace gxql ="http://graph.x.ql"
    at "/graphxql/entities/graphXql-types.xsd";

declare default element namespace "http://graph.x.ql";
declare namespace eth="http://ethica.graph.ql";

declare function gxqlr:affection-definition-entity-resolver($var-map as map:map) as element(*, gxql:AffectionDefinition)?
{
    let $uri :=
        if (map:contains($var-map, 'uri'))
        then
            map:get($var-map, 'uri')
        else if (map:contains($var-map, 'partNumber') and map:contains($var-map, 'itemNumber'))
        then
            cts:uris('', (), cts:and-query((
              cts:element-value-query(xs:QName('eth:type'), 'Affection-Definition'),
              cts:element-value-query(xs:QName('eth:part-number'), map:get($var-map, 'partNumber')),
              cts:element-value-query(xs:QName('eth:item-number'), map:get($var-map, 'itemNumber'))
            )))
        else fn:error((), 'ENTITY RESOLVER EXCEPTION', ("500", "Internal server error", "No identifier received in variables: ", $var-map))

    return
        element gxql:affectionDefinition
        {
            element gxql:uri {$uri}
        }

};

declare function gxqlr:affection-definition-field-resolver($field-name as xs:string) as xdmp:function
{
         if ($field-name eq 'name') then xdmp:function(xs:QName('gxqlr:item-name-resolver'))
    else if ($field-name eq 'uri') then xdmp:function(xs:QName('gxqlr:item-uri-resolver'))
    else if ($field-name eq 'text') then xdmp:function(xs:QName('gxqlr:item-text-resolver'))
    else if ($field-name eq 'partNumber') then xdmp:function(xs:QName('gxqlr:item-partNumber-resolver'))
    else if ($field-name eq 'itemNumber') then xdmp:function(xs:QName('gxqlr:item-itemNumber-resolver'))
    else if ($field-name eq 'descendants') then xdmp:function(xs:QName('gxqlr:affection-definition-descendants-resolver'))
    else
        fn:error((), 'FIELD RESOLVER EXCEPTION', ("500", "Internal server error", "unsupported field: "||$field-name))
};

declare function gxqlr:affection-definition-descendants-resolver($item as element(*, gxql:AffectionDefinition), $var-map as map:map)
{
    let $descendant-maps := gxqlr:find-descendants($item/uri/fn:string())
    for $descendant-map in $descendant-maps
        let $descendant-uri := map:get($descendant-map, 'descendant')
        let $descendant-type := map:get($descendant-map, 'type')
        let $var-map := map:map() => map:with('uri', $descendant-uri)
        return
            switch ($descendant-type)
            case 'http://ethica.graph.ql/Model#Proposition-Demonstration' return gxqlr:affection-definition-explanation-entity-resolver($var-map)
            default return fn:error((), 'RESOLVER EXCEPTION', ("500", "Internal server error", "unsupported descendant-type: "||$descendant-type))
};
