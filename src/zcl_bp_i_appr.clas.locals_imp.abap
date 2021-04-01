*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


CLASS lhc_leave DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    TYPES tt_leave TYPE TABLE FOR UPDATE z_i_appr.

*    METHODS validate_dates             FOR VALIDATE ON SAVE IMPORTING keys FOR leave~validateDates.

    METHODS set_status_completed       FOR MODIFY IMPORTING   keys FOR ACTION leave~acceptLeave  RESULT result.

    METHODS get_features               FOR FEATURES IMPORTING keys REQUEST    requested_features FOR leave  RESULT result.

    METHODS CalculateLeaveKey         FOR DETERMINE ON MODIFY IMPORTING keys FOR leave~CalculateLeaveKey.

ENDCLASS.

CLASS lhc_leave IMPLEMENTATION.

  METHOD calculateleavekey.

    READ ENTITIES OF z_i_appr IN LOCAL MODE
          ENTITY Leave
            FIELDS ( leaveid )
            WITH CORRESPONDING #( keys )
          RESULT DATA(lt_leave).

    DELETE lt_leave WHERE leaveid IS NOT INITIAL.
    CHECK lt_leave IS NOT INITIAL.

    "Get max travelID
    SELECT SINGLE FROM zdevl_appr FIELDS MAX( leaveid ) INTO @DATA(lv_max_leavlid).

    "update involved instances
    MODIFY ENTITIES OF z_i_appr IN LOCAL MODE
      ENTITY Leave
        UPDATE FIELDS ( leaveid )
        WITH VALUE #( FOR ls_travel IN lt_leave INDEX INTO i (
                           %key      = ls_travel-%key
                           leaveid  = lv_max_leavlid + i ) )
    REPORTED DATA(lt_reported).

  ENDMETHOD.



  METHOD set_status_completed.

    " Modify in local mode: BO-related updates that are not relevant for authorization checks
    MODIFY ENTITIES OF z_i_appr IN LOCAL MODE
           ENTITY leave
              UPDATE FROM VALUE #( FOR key IN keys ( uuid = key-uuid
                                                     approved = 'A' " Accepted
                                                     %control-approved = if_abap_behv=>mk-on ) )
           FAILED   failed
           REPORTED reported.

    " Read changed data for action result
    READ ENTITIES OF z_i_appr IN LOCAL MODE
         ENTITY leave
         FROM VALUE #( FOR key IN keys (  uuid = key-uuid
                                          %control = VALUE #(
                                            leaveid       = if_abap_behv=>mk-on
                                            approved     = if_abap_behv=>mk-on
                                            appr_reas        = if_abap_behv=>mk-on
                                            req_date     = if_abap_behv=>mk-on
                                            created_by      = if_abap_behv=>mk-on
                                            created_at      = if_abap_behv=>mk-on
                                            last_changed_by = if_abap_behv=>mk-on
                                            last_changed_at = if_abap_behv=>mk-on
                                          ) ) )
         RESULT DATA(lt_leave).

    result = VALUE #( FOR leave IN lt_leave ( uuid = leave-uuid
                                                %param    = leave
                                              ) ).

  ENDMETHOD.


  METHOD get_features.

    "%control-<fieldname> specifies which fields are read from the entities

    READ ENTITY z_i_appr FROM VALUE #( FOR keyval IN keys
                                                      (  %key                    = keyval-%key
                                                       "  %control-travel_id      = if_abap_behv=>mk-on
                                                         %control-approved = if_abap_behv=>mk-on
                                                        ) )
                                RESULT DATA(lt_leave_result).


    result = VALUE #( FOR ls_leave IN lt_leave_result
                       ( %key                           = ls_leave-%key
                         %features-%action-acceptLeave = COND #( WHEN ls_leave-approved = 'A'
                                                                    THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled   )
                      ) ).

  ENDMETHOD.

ENDCLASS.
