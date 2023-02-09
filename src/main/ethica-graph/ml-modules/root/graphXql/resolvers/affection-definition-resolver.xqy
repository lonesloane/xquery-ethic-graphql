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
            let $partNumber := map:get($var-map, 'partNumber') => xs:string()
            let $itemNumber := map:get($var-map, 'itemNumber') => xs:string()
            return
            cts:uris('', (), cts:and-query((
              cts:element-value-query(xs:QName('eth:type'), 'Affection-Definition'),
              cts:element-value-query(xs:QName('eth:part-number'), $partNumber),
              cts:element-value-query(xs:QName('eth:item-number'), $itemNumber)
            )))
        else fn:error((), 'ENTITY RESOLVER EXCEPTION', ("500", "Internal server error", "No identifier received in variables: ", $var-map))

    return
        element gxql:affectionDefinition
        {
            element gxql:uri {$uri}
        }

};

declare function gxqlr:affection-definition-list-resolver($var-map as map:map) as element(*, gxql:AffectionDefinition)*
{
    let $partNumber := map:get($var-map, 'partNumber') => xs:string()
    let $uris :=
        cts:uris('', (), cts:and-query((
              cts:element-value-query(xs:QName('eth:type'), 'Affection-Definition'),
              (if (map:contains($var-map, 'partNumber'))
              then cts:element-value-query(xs:QName('eth:part-number'), $partNumber)
              else ())
        )))

    for $uri in $uris
    order by xs:int(fn:doc($uri)/eth:affection-definition/eth:coordinates/eth:ordinal) ascending
    return
        element gxql:affectionDefinition
        {
            element gxql:uri {$uri}
        }
};

declare function gxqlr:affection-definition-field-resolver($field-name as xs:string) as xdmp:function
{
    if ($field-name eq $gxqlr:ETHIC-ITEM-FIELDS) then
        gxqlr:ethic-item-field-resolver($field-name)
    else
        fn:error((), 'AFFECTION DEFINITION FIELD RESOLVER EXCEPTION', ("500", "Internal server error", "unsupported field: "||$field-name))
};
