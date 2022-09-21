xquery version "1.0-ml";

module namespace gxqlr = "http://graph.x.ql/resolvers";

import module namespace gxqlr = "http://graph.x.ql/resolvers"
    at
    "/graphXql/resolvers/proposition-resolver.xqy";

import schema namespace gxql = "http://graph.x.ql" 
    at "/graphxql/entities/graphXql-types.xsd";

declare function gxqlr:get-entity-resolver($entity-name as xs:string) as xdmp:function
{
    if ($entity-name eq 'proposition') then xdmp:function(xs:QName('gxqlr:proposition-entity-resolver'))
    else  fn:error((), 'RESOLVER EXCEPTION', ("500", "Internal server error", "unexpected entity name: ", $entity-name))
};

declare function gxqlr:get-field-resolver($entity as element(), $field-name as xs:string) as xdmp:function
{
    (
        xdmp:log('[gxqlr:get-field-resolver] $entity: '||xdmp:describe($entity, (), ()), 'debug')
        ,xdmp:log('[gxqlr:get-field-resolver] $field-name: '||$field-name, 'debug')
    ),
    if ('__typename' eq $field-name)
    then
        xdmp:function(xs:QName('gxqlr:typename-resolver'))
    else
        typeswitch ($entity)
            case $o as element(*, gxql:Proposition) return gxqlr:proposition-field-resolver($field-name)
            default return fn:error((), 'RESOLVER EXCEPTION', ("500", "Internal server error", "unexpected entity type: ", xdmp:describe($entity, (), ())))
};

declare function gxqlr:mutation-resolver($mutation-name as xs:string) as xdmp:function
{
    ()
(:
    switch ($mutation-name)
        case 'createParticipant' return xdmp:function(xs:QName('gxqlr:createParticipant'))
        case 'deleteParticipant' return xdmp:function(xs:QName('gxqlr:deleteParticipant'))
        default return fn:error((), 'RESOLVER EXCEPTION', ("500", "Internal server error", "unknown mutation name", $mutation-name))
:)
};

declare function gxqlr:typename-resolver($entity as element()) as xs:string
{
    gxqlr:typename-resolver($entity, map:map())
};

declare function gxqlr:typename-resolver($entity as element(), $var-map as map:map) as xs:string
{
    typeswitch ($entity)
        case $o as element(*, gxql:Proposition) return 'Proposition'
        default return fn:error((), 'RESOLVER EXCEPTION', ("500", "Internal server error", "unexpected entity type: ", xdmp:describe($entity, (), ())))
};

