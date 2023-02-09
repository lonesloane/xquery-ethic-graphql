xquery version "1.0-ml";

module namespace gxqlr = "http://graph.x.ql/resolvers";
import module namespace gxqlr = "http://graph.x.ql/resolvers"
    at "/graphXql/resolvers/ethic-item-resolver.xqy";

import schema namespace gxql ="http://graph.x.ql"
    at "/graphxql/entities/graphXql-types.xsd";

declare default element namespace "http://graph.x.ql";
declare namespace eth="http://ethica.graph.ql";

declare function gxqlr:proposition-demonstration-entity-resolver($var-map as map:map) as element(*, gxql:PropositionDemonstration)?
{
    let $uri :=
        if (map:contains($var-map, 'uri'))
        then
            map:get($var-map, 'uri')
        else if (map:contains($var-map, 'partNumber') and map:contains($var-map, 'propositionNumber') and map:contains($var-map, 'itemNumber'))
        then
            let $partNumber := map:get($var-map, 'partNumber') => xs:string()
            let $itemNumber := map:get($var-map, 'itemNumber') => xs:string()
            let $propositionNumber := map:get($var-map, 'propositionNumber') => xs:string()
            return
            cts:uris('', (), cts:and-query((
              cts:element-value-query(xs:QName('eth:type'), 'Proposition-Demonstration'),
              cts:element-value-query(xs:QName('eth:part-number'), $partNumber),
              cts:element-value-query(xs:QName('eth:proposition-number'), $propositionNumber),
              cts:element-value-query(xs:QName('eth:item-number'), $itemNumber)
            )))
        else fn:error((), 'ENTITY RESOLVER EXCEPTION', ("500", "Internal server error", "No identifier received in variables: ", $var-map))

    return
        element gxql:propositionDemonstration
        {
            element gxql:uri {$uri}
        }
};

declare function gxqlr:proposition-demonstration-field-resolver($field-name as xs:string) as xdmp:function
{
    if ($field-name eq $gxqlr:ETHIC-ITEM-FIELDS) then
        gxqlr:ethic-item-field-resolver($field-name)
    else if ($field-name eq 'propositionNumber') then
        xdmp:function(xs:QName('gxqlr:proposition-demonstration-propositionNumber-resolver'))
    else
        fn:error((), 'FIELD RESOLVER EXCEPTION', ("500", "Internal server error", "unsupported field: "||$field-name))
};

declare function gxqlr:proposition-demonstration-propositionNumber-resolver($item as element(*, gxql:PropositionDemonstration), $var-map as map:map)
{
    fn:doc($item/uri/fn:string())/eth:proposition-demonstration/eth:coordinates/eth:proposition-number/string()
};
