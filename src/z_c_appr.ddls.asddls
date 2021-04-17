@EndUserText.label: 'Leave Projection View'
@AccessControl.authorizationCheck: #CHECK

@UI: {
 headerInfo: { typeName: 'Leave Approval', typeNamePlural: 'Leave Approvals', title: { type: #STANDARD, value: 'LeaveID' } } }

@Search.searchable: true

define root view entity Z_C_APPR
  as projection on Z_I_APPR
{

      // uuid - Hide field in App
      @UI.facet: [ {      id:            'Leave',
                         purpose:         #STANDARD,
                         type:            #IDENTIFICATION_REFERENCE,
                         label:           'Leave',
                         position:        10 } ]

      @UI.hidden: true
  key uuid            as LeaveUUID,

      
      @UI: {
              lineItem:       [ { position: 10, importance: #HIGH, label: 'Leave ID' } ],
              identification: [ { position: 10, label: 'Leave ID [1,...,99999999]' } ] }
      @Search.defaultSearchElement: true
      leaveid         as LeaveID,

      
      @UI: {
               lineItem:       [ { position: 20, importance: #HIGH, label: 'Accept Leave' },
                                 { type: #FOR_ACTION, dataAction: 'acceptLeave', label: 'Accept Leave' },
                                 { type: #FOR_ACTION, dataAction: 'rejectLeave', label: 'Reject Leave' } ],
             identification: [ { position: 20, label: 'Status [O(Open)|A(Accepted)|X(Canceled)]' } ]  }
      approved        as ApprovalStatus,

      
      @UI:  {
            lineItem:       [ { position: 30, importance: #HIGH, label: 'Approval Reason' } ],
             identification: [ { position: 30, label: 'Approval Reason' } ] }
      appr_reas       as ApprovalReason,

      
      @UI: {
                lineItem:       [ { position: 40, importance: #HIGH, label: 'Requested Date' } ],
                identification: [ { position: 40, label: 'Requested Date' } ] }
      req_date        as ReqDate,

      @UI.hidden: true
      last_changed_at as LastChangedAt

}
