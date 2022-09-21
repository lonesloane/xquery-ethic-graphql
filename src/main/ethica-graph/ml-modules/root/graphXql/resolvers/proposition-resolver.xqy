xquery version "1.0-ml";

module namespace gxqlr = "http://graph.x.ql/resolvers";

import schema namespace gxql ="http://graph.x.ql"
    at "/graphxql/entities/graphXql-types.xsd";

declare default element namespace "http://graph.x.ql";
declare namespace eth="http://ethica.graph.ql";

declare variable $map-fields := map:map()
    => map:with("name", "gxqlr:proposition-name-resolver")
    => map:with("uri", "gxqlr:proposition-uri-resolver")
    => map:with("text", "gxqlr:proposition-text-resolver")
    => map:with("partNumber", "gxqlr:proposition-partNumber-resolver")
    => map:with("itemNumber", "gxqlr:proposition-itemNumber-resolver");

declare function gxqlr:proposition-entity-resolver($var-map as map:map) as element(*, gxql:Proposition)?
{
    if (map:contains($var-map, 'partNumber') and map:contains($var-map, 'itemNumber'))
    then
    (
        let $proposition-uri := fn:concat('http://ethica.graph.ql/E', map:get($var-map, 'partNumber'), 'P', map:get($var-map, 'itemNumber'))
        return
            element gxql:proposition
            {
                element gxql:uri {$proposition-uri}
            }
    )
    else fn:error((), 'ENTITY RESOLVER EXCEPTION', ("500", "Internal server error", "No identifier received in variables: ", $var-map))
};

declare function gxqlr:proposition-field-resolver($field-name as xs:string) as xdmp:function
{
    if (map:contains($map-fields,$field-name))
    then
        xdmp:function(xs:QName(map:get($map-fields, $field-name)))
    else
        fn:error((), 'FIELD RESOLVER EXCEPTION', ("500", "Internal server error", "unsupported field: "||$field-name))
};

declare function gxqlr:proposition-name-resolver($proposition as element(*, gxql:Proposition), $var-map as map:map)
{
    let $proposition := fn:doc($proposition/uri/fn:string())
    return
        'E'||$proposition/eth:proposition/eth:coordinates/eth:part/string()||'P'||$proposition/eth:proposition/eth:coordinates/eth:number/string()
};

declare function gxqlr:proposition-uri-resolver($proposition as element(*, gxql:Proposition), $var-map as map:map)
{
    $proposition/uri/fn:string()
};

declare function gxqlr:proposition-text-resolver($proposition as element(*, gxql:Proposition), $var-map as map:map)
{
    fn:doc($proposition/uri/fn:string())/eth:proposition/eth:text/string()
};

declare function gxqlr:proposition-partNumber-resolver($proposition as element(*, gxql:Proposition), $var-map as map:map)
{
    fn:doc($proposition/uri/fn:string())/eth:proposition/eth:coordinates/eth:part/string()
};

declare function gxqlr:proposition-itemNumber-resolver($proposition as element(*, gxql:Proposition), $var-map as map:map)
{
    fn:doc($proposition/uri/fn:string())/eth:proposition/eth:coordinates/eth:number/string()
};

