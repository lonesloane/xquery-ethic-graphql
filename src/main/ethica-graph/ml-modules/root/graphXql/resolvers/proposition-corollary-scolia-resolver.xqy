xquery version "1.0-ml";

module namespace gxqlr = "http://graph.x.ql/resolvers";
import module namespace gxqlr = "http://graph.x.ql/resolvers"
    at "/graphXql/resolvers/ethic-item-resolver.xqy";

import schema namespace gxql ="http://graph.x.ql"
    at "/graphxql/entities/graphXql-types.xsd";

declare default element namespace "http://graph.x.ql";
declare namespace eth="http://ethica.graph.ql";

declare function gxqlr:proposition-corollary-scolia-entity-resolver($var-map as map:map) as element(*, gxql:PropositionCorollaryScolia)?
{
    let $uri :=
        if (map:contains($var-map, 'uri'))
        then
            map:get($var-map, 'uri')
        else if (map:contains($var-map, 'partNumber')
            and map:contains($var-map, 'propositionCorollaryNumber')
            and map:contains($var-map, 'propositionNumber')
            and map:contains($var-map, 'itemNumber'))
        then
            let $uri :=
                cts:uris('', (), cts:and-query((
                  cts:element-value-query(xs:QName('eth:type'), 'Proposition-Corollary-Scolia'),
                  cts:element-value-query(xs:QName('eth:part-number'), map:get($var-map, 'partNumber')),
                  cts:element-value-query(xs:QName('eth:proposition-corollary-number'), map:get($var-map, 'propositionCorollaryNumber')),
                  cts:element-value-query(xs:QName('eth:proposition-number'), map:get($var-map, 'propositionNumber')),
                  cts:element-value-query(xs:QName('eth:item-number'), map:get($var-map, 'itemNumber'))
                )))
            return if ($uri) then $uri else ('null')
        else fn:error((), 'ENTITY RESOLVER EXCEPTION', ("500", "Internal server error", "No identifier received in variables: ", $var-map))

    return
        element gxql:propositionCorollaryScolia
        {
            element gxql:uri {$uri}
        }

};

declare function gxqlr:proposition-corollary-scolia-field-resolver($field-name as xs:string) as xdmp:function
{
         if ($field-name eq 'name') then xdmp:function(xs:QName('gxqlr:item-name-resolver'))
    else if ($field-name eq 'uri') then xdmp:function(xs:QName('gxqlr:item-uri-resolver'))
    else if ($field-name eq 'text') then xdmp:function(xs:QName('gxqlr:item-text-resolver'))
    else if ($field-name eq 'partNumber') then xdmp:function(xs:QName('gxqlr:item-partNumber-resolver'))
    else if ($field-name eq 'itemNumber') then xdmp:function(xs:QName('gxqlr:item-itemNumber-resolver'))
    else if ($field-name eq 'references') then xdmp:function(xs:QName('gxqlr:item-references-resolver'))
    else if ($field-name eq 'propositionNumber') then xdmp:function(xs:QName('gxqlr:pcs-proposition-number-resolver'))
    else if ($field-name eq 'propositionCorollaryNumber') then xdmp:function(xs:QName('gxqlr:pcs-proposition-corollary-number-resolver'))
    else
        fn:error((), 'FIELD RESOLVER EXCEPTION', ("500", "Internal server error", "unsupported field: "||$field-name))
};

declare function gxqlr:pcs-proposition-number-resolver($item as element(*, gxql:PropositionCorollaryScolia), $var-map as map:map)
{
    fn:doc($item/uri/fn:string())//eth:coordinates/eth:proposition-number/string()
};

declare function gxqlr:pcs-proposition-corollary-number-resolver($item as element(*, gxql:PropositionCorollaryScolia), $var-map as map:map)
{
    fn:doc($item/uri/fn:string())//eth:coordinates/eth:proposition-corollary-number/string()
};