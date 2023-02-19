xquery version "1.0-ml";

module namespace gxqlr = "http://graph.x.ql/resolvers";

import module namespace gxqlr = "http://graph.x.ql/resolvers"
    at
    "/graphXql/resolvers/ethic-item-resolver.xqy",
    "/graphXql/resolvers/affection-definition-resolver.xqy",
    "/graphXql/resolvers/affection-definition-explanation-resolver.xqy",
    "/graphXql/resolvers/appendix-resolver.xqy",
    "/graphXql/resolvers/appendix-chapter-resolver.xqy",
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

import schema namespace gxql = "http://graph.x.ql" 
    at "/graphxql/entities/graphXql-types.xsd";

declare function gxqlr:get-entity-resolver($entity-name as xs:string) as xdmp:function
{
    if      ($entity-name eq 'affectionDefinition') then xdmp:function(xs:QName('gxqlr:affection-definition-entity-resolver'))
    else if ($entity-name eq 'affectionDefinitions') then xdmp:function(xs:QName('gxqlr:affection-definition-list-resolver'))
    else if ($entity-name eq 'affectionDefinitionExplanation') then xdmp:function(xs:QName('gxqlr:affection-definition-explanation-entity-resolver'))
    else if ($entity-name eq 'appendix') then xdmp:function(xs:QName('gxqlr:appendix-entity-resolver'))
    else if ($entity-name eq 'appendixChapter') then xdmp:function(xs:QName('gxqlr:appendix-chapter-entity-resolver'))
    else if ($entity-name eq 'axioms') then xdmp:function(xs:QName('gxqlr:axiom-list-resolver'))
    else if ($entity-name eq 'axiom') then xdmp:function(xs:QName('gxqlr:axiom-entity-resolver'))
    else if ($entity-name eq 'generalDefinition') then xdmp:function(xs:QName('gxqlr:general-definition-entity-resolver'))
    else if ($entity-name eq 'generalDefinitionExplanation') then xdmp:function(xs:QName('gxqlr:general-definition-explanation-entity-resolver'))
    else if ($entity-name eq 'definition') then xdmp:function(xs:QName('gxqlr:definition-entity-resolver'))
    else if ($entity-name eq 'definitions') then xdmp:function(xs:QName('gxqlr:definition-list-resolver'))
    else if ($entity-name eq 'definitionExplanation') then xdmp:function(xs:QName('gxqlr:definition-explanation-entity-resolver'))
    else if ($entity-name eq 'postulate') then xdmp:function(xs:QName('gxqlr:postulate-entity-resolver'))
    else if ($entity-name eq 'postulates') then xdmp:function(xs:QName('gxqlr:postulate-list-resolver'))
    else if ($entity-name eq 'preface') then xdmp:function(xs:QName('gxqlr:preface-entity-resolver'))
    else if ($entity-name eq 'prefaces') then xdmp:function(xs:QName('gxqlr:preface-list-resolver'))
    else if ($entity-name eq 'proposition') then xdmp:function(xs:QName('gxqlr:proposition-entity-resolver'))
    else if ($entity-name eq 'propositions') then xdmp:function(xs:QName('gxqlr:proposition-list-resolver'))
    else if ($entity-name eq 'propositionAxiom') then xdmp:function(xs:QName('gxqlr:proposition-axiom-entity-resolver'))
    else if ($entity-name eq 'propositionCorollary') then xdmp:function(xs:QName('gxqlr:proposition-corollary-entity-resolver'))
    else if ($entity-name eq 'propositionCorollaryDemonstration') then xdmp:function(xs:QName('gxqlr:proposition-corollary-demonstration-entity-resolver'))
    else if ($entity-name eq 'propositionCorollaryScolia') then xdmp:function(xs:QName('gxqlr:proposition-corollary-scolia-entity-resolver'))
    else if ($entity-name eq 'propositionDemonstration') then xdmp:function(xs:QName('gxqlr:proposition-demonstration-entity-resolver'))
    else if ($entity-name eq 'propositionLemme') then xdmp:function(xs:QName('gxqlr:proposition-lemme-entity-resolver'))
    else if ($entity-name eq 'propositionLemmeAxiom') then xdmp:function(xs:QName('gxqlr:proposition-lemme-axiom-entity-resolver'))
    else if ($entity-name eq 'propositionLemmeCorollary') then xdmp:function(xs:QName('gxqlr:proposition-lemme-corollary-entity-resolver'))
    else if ($entity-name eq 'propositionLemmeDefinition') then xdmp:function(xs:QName('gxqlr:proposition-lemme-definition-entity-resolver'))
    else if ($entity-name eq 'propositionLemmeDemonstration') then xdmp:function(xs:QName('gxqlr:proposition-lemme-demonstration-entity-resolver'))
    else if ($entity-name eq 'propositionLemmeScolia') then xdmp:function(xs:QName('gxqlr:proposition-lemme-scolia-entity-resolver'))
    else if ($entity-name eq 'propositionPostulate') then xdmp:function(xs:QName('gxqlr:proposition-postulate-entity-resolver'))
    else if ($entity-name eq 'propositionScolia') then xdmp:function(xs:QName('gxqlr:proposition-scolia-entity-resolver'))
    else if ($entity-name eq 'ethicItem') then xdmp:function(xs:QName('gxqlr:ethic-item-entity-resolver'))
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
            case $o as element(*, gxql:AffectionDefinition) return gxqlr:affection-definition-field-resolver($field-name)
            case $o as element(*, gxql:AffectionDefinitionExplanation) return gxqlr:affection-definition-explanation-field-resolver($field-name)
            case $o as element(*, gxql:Appendix) return gxqlr:appendix-field-resolver($field-name)
            case $o as element(*, gxql:AppendixChapter) return gxqlr:appendix-chapter-field-resolver($field-name)
            case $o as element(*, gxql:Axiom) return gxqlr:axiom-field-resolver($field-name)
            case $o as element(*, gxql:Definition) return gxqlr:definition-field-resolver($field-name)
            case $o as element(*, gxql:DefinitionExplanation) return gxqlr:definition-explanation-field-resolver($field-name)
            case $o as element(*, gxql:GeneralDefinition) return gxqlr:general-definition-field-resolver($field-name)
            case $o as element(*, gxql:GeneralDefinitionExplanation) return gxqlr:general-definition-explanation-field-resolver($field-name)
            case $o as element(*, gxql:Postulate) return gxqlr:postulate-field-resolver($field-name)
            case $o as element(*, gxql:Preface) return gxqlr:preface-field-resolver($field-name)
            case $o as element(*, gxql:Proposition) return gxqlr:proposition-field-resolver($field-name)
            case $o as element(*, gxql:PropositionAxiom) return gxqlr:proposition-axiom-field-resolver($field-name)
            case $o as element(*, gxql:PropositionCorollary) return gxqlr:proposition-corollary-field-resolver($field-name)
            case $o as element(*, gxql:PropositionCorollaryDemonstration) return gxqlr:proposition-corollary-demonstration-field-resolver($field-name)
            case $o as element(*, gxql:PropositionCorollaryScolia) return gxqlr:proposition-corollary-scolia-field-resolver($field-name)
            case $o as element(*, gxql:PropositionDemonstration) return gxqlr:proposition-demonstration-field-resolver($field-name)
            case $o as element(*, gxql:PropositionLemme) return gxqlr:proposition-lemme-field-resolver($field-name)
            case $o as element(*, gxql:PropositionLemmeAxiom) return gxqlr:proposition-lemme-axiom-field-resolver($field-name)
            case $o as element(*, gxql:PropositionLemmeCorollary) return gxqlr:proposition-lemme-corollary-field-resolver($field-name)
            case $o as element(*, gxql:PropositionLemmeDefinition) return gxqlr:proposition-lemme-definition-field-resolver($field-name)
            case $o as element(*, gxql:PropositionLemmeDemonstration) return gxqlr:proposition-lemme-demonstration-field-resolver($field-name)
            case $o as element(*, gxql:PropositionLemmeScolia) return gxqlr:proposition-lemme-scolia-field-resolver($field-name)
            case $o as element(*, gxql:PropositionPostulate) return gxqlr:proposition-postulate-field-resolver($field-name)
            case $o as element(*, gxql:PropositionScolia) return gxqlr:proposition-scolia-field-resolver($field-name)
            case $o as element(*, gxql:EthicItem) return gxqlr:ethic-item-field-resolver($field-name)
            default return fn:error((), 'RESOLVER EXCEPTION', ("500", "Internal server error", "unexpected entity type: ", xdmp:describe($entity, (), ())))
};

declare function gxqlr:mutation-resolver($mutation-name as xs:string) as xdmp:function
{
    ()
(:
    switch ($mutation-name)
        case '*****' return xdmp:function(xs:QName('gxqlr:*****'))
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
        case $o as element(*, gxql:AffectionDefinition) return 'AffectionDefinition'
        case $o as element(*, gxql:AffectionDefinitionExplanation) return 'AffectionDefinitionExplanation'
        case $o as element(*, gxql:Appendix) return 'Appendix'
        case $o as element(*, gxql:Axiom) return 'Axiom'
        case $o as element(*, gxql:Definition) return 'Definition'
        case $o as element(*, gxql:DefinitionExplanation) return 'DefinitionExplanation'
        case $o as element(*, gxql:GeneralDefinition) return 'GeneralDefinition'
        case $o as element(*, gxql:GeneralDefinitionExplanation) return 'GeneralDefinitionExplanation'
        case $o as element(*, gxql:Postulate) return 'Postulate'
        case $o as element(*, gxql:Preface) return 'Preface'
        case $o as element(*, gxql:Proposition) return 'Proposition'
        case $o as element(*, gxql:PropositionAxiom) return 'PropositionAxiom'
        case $o as element(*, gxql:PropositionCorollary) return 'PropositionCorollary'
        case $o as element(*, gxql:PropositionCorollaryDemonstration) return 'PropositionCorollaryDemonstration'
        case $o as element(*, gxql:PropositionCorollaryScolia) return 'PropositionCorollaryScolia'
        case $o as element(*, gxql:PropositionDemonstration) return 'PropositionDemonstration'
        case $o as element(*, gxql:PropositionLemme) return 'PropositionLemme'
        case $o as element(*, gxql:PropositionLemmeAxiom) return 'PropositionLemmeAxiom'
        case $o as element(*, gxql:PropositionLemmeCorollary) return 'PropositionLemmeCorollary'
        case $o as element(*, gxql:PropositionLemmeDefinition) return 'PropositionLemmeDefinition'
        case $o as element(*, gxql:PropositionLemmeDemonstration) return 'PropositionLemmeDemonstration'
        case $o as element(*, gxql:PropositionLemmeScolia) return 'PropositionLemmeScolia'
        case $o as element(*, gxql:PropositionPostulate) return 'PropositionPostulate'
        case $o as element(*, gxql:PropositionScolia) return 'PropositionScolia'
        case $o as element(*, gxql:EthicItem) return 'EthicItem'
        default return fn:error((), 'RESOLVER EXCEPTION', ("500", "Internal server error", "unexpected entity type: ", xdmp:describe($entity, (), ())))
};

