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
                  lineItem:       [ { position: 20, importance: #HIGH, label: 'Accept Leave' },
                                    { type: #FOR_ACTION, dataAction: 'acceptLeave', label: 'Accept Leave' },
                                    { type: #FOR_ACTION, dataAction: 'holdLeave', label: 'Hold' },
                                    { type: #FOR_ACTION, dataAction: 'rejectLeave', label: 'Reject Leave' } ],
                  identification: [ { position: 20, label: 'Approval Status' } ]  }
         //                identification: [ { position: 20, label: 'Status [O(Open)|A(Approved)|X(Canceled)|H(HOLD)]' } ]  }
         @Consumption.valueHelpDefinition: [{entity: {name: 'Z_I_APPR_STAT_VH', element: 'Approval_status' }}]
         @Search.defaultSearchElement: true
         @EndUserText: { label: 'Approval Status',quickInfo: 'Approval Status' }
         @UI.selectionField: [ { position: 20 } ]
         approved        as ApprovalStatus,


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

         @UI.hidden: true
         last_changed_at as LastChangedAt

}
