@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Approval Status Value Help CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_APPR_STAT_VH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name : 'ZAPPR_STS' )
{
      @ObjectModel.text.element: ['Description']
  key cast(left( value_low, 1 ) as zappr_sts ) as Approval_status,
      text                                     as Description
}
where
      language       = $session.system_language
  and value_position is not initial
