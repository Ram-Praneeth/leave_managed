CLASS lsc_z_i_appr DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

*    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lsc_z_i_appr IMPLEMENTATION.

*  METHOD adjust_numbers.
*
*    DATA : gt_interval TYPE cl_numberrange_intervals=>nr_interval,
*           wa_interval LIKE LINE OF gt_interval.
*
*DATA leave_num type  zleaveid.
*
***  Initiate Interval Range
*    wa_interval-nrrangenr = '01'.
*    wa_interval-fromnumber = '0000000001'.
*    wa_interval-tonumber = '9999999999'.
*    wa_interval-procind = 'I'.
*
*    APPEND wa_interval TO gt_interval.
*
*    TRY.
*        CALL METHOD cl_numberrange_intervals=>create  "method to create interval
*          EXPORTING
*            interval  = gt_interval
*            object    = 'ZLEAVEID' "object name
*            subobject = ''
*          IMPORTING
*            error     = DATA(error)
*            error_inf = DATA(error_inf)
*            error_iv  = DATA(error_iv).
*      CATCH  cx_nr_object_not_found INTO DATA(lx_no_obj_found).
*      CATCH cx_number_ranges INTO DATA(cx_number_ranges).
*    ENDTRY.
*
*    TRY.
*        cl_numberrange_runtime=>number_get(
*        EXPORTING
*          nr_range_nr       = '01'
*          object            = 'ZLEAVEID'
*          quantity          = 00000000000000000001
*          subobject         = ''
**        toyear            = ''
*        IMPORTING
*          number            = DATA(number_range_key)
*          returncode        = DATA(number_range_return_code)
*          returned_quantity = DATA(number_range_returned_quantity)
*      ).
*      CATCH cx_number_ranges INTO DATA(lx_num_range).
*        DATA(res) = lx_num_range->get_text(  ).
*    ENDTRY.
*
**     number_range_returned_quantity = lines( mapped-leave ).
*
*    leave_num =  number_range_key - number_range_returned_quantity .
*
*    LOOP AT mapped-leave ASSIGNING FIELD-SYMBOL(<fs_leave>).
*       leave_num += 1.
*      <fs_leave>-leaveid = leave_num.
*    ENDLOOP.
*
**    SELECT MAX( leaveid ) FROM zdevl_appr INTO @DATA(number_range_key).
**    IF sy-subrc EQ 0.
**      LOOP AT mapped-leave ASSIGNING FIELD-SYMBOL(<fs_leave>).
**        <fs_leave>-leaveid = number_range_key + 1.
**      ENDLOOP.
**    ENDIF.
*
*  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


CLASS lhc_leave DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Leave RESULT result.
    METHODS acceptleave FOR MODIFY
      IMPORTING keys FOR ACTION leave~acceptleave RESULT result.

    METHODS holdleave FOR MODIFY
      IMPORTING keys FOR ACTION leave~holdleave RESULT result.

    METHODS rejectleave FOR MODIFY
      IMPORTING keys FOR ACTION leave~rejectleave RESULT result.

    METHODS calculateleavekey FOR DETERMINE ON SAVE
      IMPORTING keys FOR leave~calculateleavekey.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Leave.

ENDCLASS.

CLASS lhc_leave IMPLEMENTATION.


  METHOD get_instance_features.

  ENDMETHOD.

  METHOD acceptLeave.
  ENDMETHOD.

  METHOD holdLeave.
  ENDMETHOD.

  METHOD rejectLeave.
  ENDMETHOD.

  METHOD CalculateLeaveKey.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA:
      entity       TYPE STRUCTURE FOR CREATE z_i_appr,
      leave_id_max TYPE zleaveid.

    DATA : gt_interval TYPE cl_numberrange_intervals=>nr_interval,
           wa_interval LIKE LINE OF gt_interval.

    " Ensure leave ID is not yet set
    LOOP AT entities INTO entity WHERE leaveid IS NOT INITIAL.
      APPEND CORRESPONDING #( entity ) TO mapped-leave.
    ENDLOOP.

    DATA(entities_wo_leaveid) = entities.
    DELETE entities_wo_leaveid WHERE leaveid IS NOT INITIAL.

*     Initiate Interval Range
    wa_interval-nrrangenr = '01'.
    wa_interval-fromnumber = '0000000001'.
    wa_interval-tonumber = '9999999999'.
    wa_interval-procind = 'I'.

    APPEND wa_interval TO gt_interval.

    TRY.
        CALL METHOD cl_numberrange_intervals=>create  "method to create interval
          EXPORTING
            interval  = gt_interval
            object    = 'ZLEAVEID' "object name
            subobject = ''
          IMPORTING
            error     = DATA(error)
            error_inf = DATA(error_inf)
            error_iv  = DATA(error_iv).
      CATCH  cx_nr_object_not_found INTO DATA(lx_no_obj_found).
      CATCH cx_number_ranges INTO DATA(cx_number_ranges).
    ENDTRY.


    " Get Numbers
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr       = '01'
            object            = 'ZLEAVEID'
            quantity          = CONV #( lines( entities_wo_leaveid ) )
          IMPORTING
            number            = DATA(number_range_key)
            returncode        = DATA(number_range_return_code)
            returned_quantity = DATA(number_range_returned_quantity)
        ).
      CATCH cx_number_ranges INTO DATA(lx_number_ranges).
        LOOP AT entities_wo_leaveid INTO entity.
          APPEND VALUE #(  %cid = entity-%cid
                           %key = entity-%key
                           %msg = lx_number_ranges
                        ) TO reported-leave.
          APPEND VALUE #(  %cid = entity-%cid
                           %key = entity-%key
                        ) TO failed-leave.
        ENDLOOP.
        EXIT.
    ENDTRY.

    " At this point ALL entities get a number!
    ASSERT number_range_returned_quantity = lines( entities_wo_leaveid ).

    leave_id_max = number_range_key - number_range_returned_quantity.

    " Set leave ID
    LOOP AT entities_wo_leaveid INTO entity.
      leave_id_max += 1.
      entity-leaveid = CONV #( leave_id_max ).

      APPEND VALUE #( %cid  = entity-%cid
                      %key  = entity-%key
                    ) TO mapped-leave.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
