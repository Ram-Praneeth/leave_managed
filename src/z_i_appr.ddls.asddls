@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Approval View'
define root view entity Z_I_APPR
  as select from zdevl_appr
{
  key uuid,
      leaveid,
      approved,
      appr_reas,
      req_date,
      

      /*-- Admin data --*/
      @Semantics.user.createdBy: true
      created_by,
      @Semantics.systemDateTime.createdAt: true
      created_at,
      @Semantics.user.lastChangedBy: true
      last_changed_by,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at

}
