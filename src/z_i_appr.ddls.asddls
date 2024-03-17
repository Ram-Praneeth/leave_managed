@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Approval View'
define root view entity Z_I_APPR
  as select from zdevl_appr
{
  key leaveid,
      approved,
      appr_reas,
      req_date,
      leave_req_by,
      approved_by,
      approved_on,
      leave_exp,

      /*-- Admin data --*/
      @Semantics.user.createdBy: true
      created_by,
      @Semantics.systemDateTime.createdAt: true
      created_at,
      @Semantics.user.lastChangedBy: true
      last_changed_by,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at

}
