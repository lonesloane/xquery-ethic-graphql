xquery version "1.0-ml";

module namespace gxqlr = "http://graph.x.ql/resolvers";
import module namespace gxqlr = "http://graph.x.ql/resolvers"
    at "/graphXql/resolvers/ethic-item-resolver.xqy",
       "/graphXql/resolvers/proposition-lemme-axiom-resolver.xqy",
       "/graphXql/resolvers/proposition-lemme-demonstration-resolver.xqy",
       "/graphXql/resolvers/proposition-lemme-definition-resolver.xqy",
       "/graphXql/resolvers/proposition-lemme-corollary-resolver.xqy",
       "/graphXql/resolvers/proposition-lemme-scolia-resolver.xqy";

import schema namespace gxql ="http://graph.x.ql"
    at "/graphxql/entities/graphXql-types.xsd";

declare default element namespace "http://graph.x.ql";
declare namespace eth="http://ethica.graph.ql";

declare function gxqlr:proposition-lemme-entity-resolver($var-map as map:map) as element(*, gxql:PropositionLemme)?
{
    let $uri :=
        if (map:contains($var-map, 'uri'))
        then
            map:get($var-map, 'uri')
        else if (map:contains($var-map, 'partNumber') and map:contains($var-map, 'propositionNumber') and map:contains($var-map, 'itemNumber'))
        then
            cts:uris('', (), cts:and-query((
              cts:element-value-query(xs:QName('eth:type'), 'Proposition-Lemme'),
              cts:element-value-query(xs:QName('eth:part-number'), map:get($var-map, 'partNumber')),
              cts:element-value-query(xs:QName('eth:proposition-number'), map:get($var-map, 'propositionNumber')),
              cts:element-value-query(xs:QName('eth:item-number'), map:get($var-map, 'itemNumber'))
            )))
        else fn:error((), 'ENTITY RESOLVER EXCEPTION', ("500", "Internal server error", "No identifier received in variables: ", $var-map))

    return
        element gxql:propositionLemme
        {
            element gxql:uri {$uri}
        }
};

declare function gxqlr:proposition-lemme-field-resolver($field-name as xs:string) as xdmp:function
{
    if ($field-name eq $gxqlr:ETHIC-ITEM-FIELDS) then
        gxqlr:ethic-item-field-resolver($field-name)
    else if ($field-name eq 'propositionNumber') then
        xdmp:function(xs:QName('gxqlr:proposition-lemme-propositionNumber-resolver'))
    else if ($field-name eq 'descendants') then
        xdmp:function(xs:QName('gxqlr:item-descendants-resolver'))
    else
        fn:error((), 'FIELD RESOLVER EXCEPTION', ("500", "Internal server error", "unsupported field: "||$field-name))
};

declare function gxqlr:proposition-lemme-propositionNumber-resolver($item as element(*, gxql:PropositionLemme), $var-map as map:map)
{
    fn:doc($item/uri/fn:string())/eth:proposition-lemme/eth:coordinates/eth:proposition-number/string()
};
