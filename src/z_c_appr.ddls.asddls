@EndUserText.label: 'Leave Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED

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


         @UI: {
                 lineItem:       [ { position: 10, importance: #HIGH, label: 'Leave ID' } ],
                 identification: [ { position: 10, label: 'Leave ID [1,...,99999999]' } ] }
         @Search.defaultSearchElement: true
         @EndUserText: { label: 'LeaveID',quickInfo: 'Leave Request ID' }
         @UI.selectionField: [ { position: 10 } ]
  key    leaveid         as LeaveID,

         @UI: {
                  lineItem:       [ { position: 20, importance: #HIGH, label: 'Accept Leave',criticality: 'StatusCriticality' },
                                    { type: #FOR_ACTION, dataAction: 'acceptLeave', label: 'Accept Leave' },
                                    { type: #FOR_ACTION, dataAction: 'holdLeave', label: 'Hold' },
                                    { type: #FOR_ACTION, dataAction: 'rejectLeave', label: 'Reject Leave' } ],
                  identification: [ { position: 20, label: 'Approval Status' } ]  }
         @UI.hidden: #(CreateAction)
  //                         identification: [ { position: 20, label: 'Status [O(Open)|A(Approved)|X(Canceled)|H(HOLD)]' } ]  }
         @Consumption.valueHelpDefinition: [{entity: {name: 'Z_I_APPR_STAT_VH', element: 'Approval_status' }}]
         @Search.defaultSearchElement: true
         @EndUserText: { label: 'Approval Status',quickInfo: 'Approval Status' }
         @UI.selectionField: [ { position: 20 } ]
         approved        as ApprovalStatus,

         @UI.hidden: true
         StatusCriticality,

         @UI:  {
                lineItem:       [ { position: 30, importance: #HIGH, label: 'Approval Reason' } ],
                identification: [ { position: 30, label: 'Approval Reason' } ] }
         @EndUserText: { label: 'Approval Reason',quickInfo: 'Approval Reason' }
         appr_reas       as ApprovalReason,


         @UI: {
                   lineItem:       [ { position: 40, importance: #HIGH, label: 'Requested Date' } ],
                   identification: [ { position: 40, label: 'Requested Date' } ] }
         @EndUserText: { label: 'Requested Date',quickInfo: 'Requested Date' }
         req_date        as ReqDate,

         @UI: {
                   lineItem:       [ { position: 50, importance: #HIGH, label: 'Leave Requested By' } ],
                   identification: [ { position: 50, label: 'Leave Requested By' } ] }
         @EndUserText: { label: 'Leave Requested By',quickInfo: 'Leave Requested By' }
         leave_req_by    as ReqBy,

         @UI: {
                   lineItem:       [ { position: 60, importance: #HIGH, label: 'Leave Approved By' } ],
                   identification: [ { position: 60, label: 'Leave Approved By' } ] }
         @EndUserText: { label: 'Leave Approved By',quickInfo: 'Leave Approved By' }
         approved_by     as ApprBy,

         @UI: {
                   lineItem:       [ { position: 70, importance: #HIGH, label: 'Leave Approved On' } ],
                   identification: [ { position: 70, label: 'Leave Approved On' } ] }
         @EndUserText: { label: 'Leave Approved On',quickInfo: 'Leave Approved On' }
         approved_on     as ApprOn,

         @UI: {
                   lineItem:       [ { position: 80, importance: #HIGH, label: 'Leave Expired' } ],
                   identification: [ { position: 80, label: 'Leave Expired' } ] }
         @EndUserText: { label: 'Leave Expired',quickInfo: 'Leave Expired' }
         leave_exp       as LeaveExp,

         @UI.hidden: true
         last_changed_at as LastChangedAt,

         @UI.hidden: true
         local_last_changed_at

}
