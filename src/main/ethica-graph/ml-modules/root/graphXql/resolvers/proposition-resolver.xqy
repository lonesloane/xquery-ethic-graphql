xquery version "1.0-ml";

module namespace gxqlr = "http://graph.x.ql/resolvers";

import module namespace gxqlr = "http://graph.x.ql/resolvers"
    at "/graphXql/resolvers/ethic-item-resolver.xqy",
       "/graphXql/resolvers/proposition-axiom-resolver.xqy",
       "/graphXql/resolvers/proposition-lemme-resolver.xqy",
       "/graphXql/resolvers/proposition-postulate-resolver.xqy",
       "/graphXql/resolvers/proposition-demonstration-resolver.xqy",
       "/graphXql/resolvers/proposition-corollary-resolver.xqy",
       "/graphXql/resolvers/proposition-scolia-resolver.xqy";

import schema namespace gxql ="http://graph.x.ql"
    at "/graphxql/entities/graphXql-types.xsd";

declare default element namespace "http://graph.x.ql";
declare namespace eth="http://ethica.graph.ql";

declare function gxqlr:proposition-entity-resolver($var-map as map:map) as element(*, gxql:Proposition)?
{
    let $uri :=
        if (map:contains($var-map, 'uri'))
        then
            map:get($var-map, 'uri')
        else if (map:contains($var-map, 'partNumber') and map:contains($var-map, 'itemNumber'))
        then
            cts:uris('', (), cts:and-query((
              cts:element-value-query(xs:QName('eth:type'), 'Proposition'),
              cts:element-value-query(xs:QName('eth:part-number'), map:get($var-map, 'partNumber')),
              cts:element-value-query(xs:QName('eth:item-number'), map:get($var-map, 'itemNumber'))
            )))
        else fn:error((), 'ENTITY RESOLVER EXCEPTION', ("500", "Internal server error", "No identifier received in variables: ", $var-map))

    return
        element gxql:proposition
        {
            element gxql:uri {$uri}
        }
};

declare function gxqlr:propositions-entity-resolver($var-map as map:map) as element(*, gxql:Proposition)*
{
    let $part-number := map:get($var-map, 'partNumber')
    let $uris :=
        cts:uris('', (), cts:and-query((
              cts:element-value-query(xs:QName('eth:type'), 'Proposition'),
              (if (map:contains($var-map, 'partNumber'))
              then cts:element-value-query(xs:QName('eth:part-number'), map:get($var-map, 'partNumber'))
              else ())
        )))

    for $uri in $uris
    order by xs:int(fn:doc($uri)/eth:proposition/eth:coordinates/eth:ordinal) ascending
    return
        element gxql:proposition
        {
            element gxql:uri {$uri}
        }

};

declare function gxqlr:proposition-field-resolver($field-name as xs:string) as xdmp:function
{
    if ($field-name eq $gxqlr:ETHIC-ITEM-FIELDS) then
        gxqlr:ethic-item-field-resolver($field-name)
    else
        fn:error((), 'FIELD RESOLVER EXCEPTION', ("500", "Internal server error", "unsupported field: "||$field-name))
};
