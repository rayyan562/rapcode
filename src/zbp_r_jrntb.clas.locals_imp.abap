CLASS lhc_R_JRNTB DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR r_jrntb RESULT result.

ENDCLASS.

CLASS lhc_R_JRNTB IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZR_JRNTB DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZR_JRNTB IMPLEMENTATION.

  METHOD save_modified.

  DATA travel_log        TYPE STANDARD TABLE OF zchangelog_dbt.
    DATA travel_log_create TYPE STANDARD TABLE OF zchangelog_dbt.
    DATA travel_log_update TYPE STANDARD TABLE OF zchangelog_dbt.

IF create-r_jrntb IS NOT INITIAL.
travel_log = CORRESPONDING #( create-r_jrntb MAPPING travel_id = TravelID ).

LOOP AT travel_log ASSIGNING FIELD-SYMBOL(<ls_travel_log>).
<ls_travel_log>-changing_operation = 'CREATE'.
GET TIME STAMP FIELD <ls_travel_log>-created_at.
READ TABLE create-r_jrntb ASSIGNING FIELD-SYMBOL(<ls_travel>)
WITH TABLE KEY entity
COMPONENTS TravelId = <ls_travel_log>-travel_id.

IF sy-subrc IS INITIAL.

IF <ls_travel>-%control-TravelId = cl_abap_behv=>flag_changed.

<ls_travel_log>-changed_field_name = 'TravelId'.

<ls_travel_log>-changed_value = <ls_travel>-TravelId.

TRY.

<ls_travel_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ).

CATCH cx_uuid_error.

"handle exception

ENDTRY.

APPEND <ls_travel_log> TO travel_log_create.
ENDIF.

IF <ls_travel>-%control-Status = cl_abap_behv=>flag_changed.

<ls_travel_log>-changed_field_name = 'Status'.

<ls_travel_log>-changed_value = <ls_travel>-Status.

TRY.

<ls_travel_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ).

CATCH cx_uuid_error.

"handle exception

ENDTRY.
APPEND <ls_travel_log> TO travel_log_create.
ENDIF.

IF <ls_travel>-%control-Description = cl_abap_behv=>flag_changed.

<ls_travel_log>-changed_field_name = 'Description'.

<ls_travel_log>-changed_value = <ls_travel>-Description.

TRY.

<ls_travel_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ).

CATCH cx_uuid_error.

"handle exception

ENDTRY.
APPEND <ls_travel_log> TO travel_log_create.
ENDIF.

ENDIF.
ENDLOOP.
INSERT zchangelog_dbt FROM TABLE @travel_log_create.
ENDIF.





IF update-r_jrntb IS NOT INITIAL.
travel_log = CORRESPONDING #( update-r_jrntb MAPPING travel_id = TravelID ).

  "Get old values from database before update
  SELECT *
    FROM zjrntb
    FOR ALL ENTRIES IN @update-r_jrntb
    WHERE travel_id = @update-r_jrntb-travelid
    INTO TABLE @data(lt_old_data).

LOOP AT update-r_jrntb ASSIGNING FIELD-SYMBOL(<ls_log_update>).

 "Find old database record
    READ TABLE lt_old_data
      ASSIGNING FIELD-SYMBOL(<ls_old>)
      WITH KEY travel_id = <ls_log_update>-travelid.

    IF sy-subrc <> 0.
      CONTINUE.
    ENDIF.

ASSIGN travel_log[ travel_id = <ls_log_update>-travelid ] TO FIELD-SYMBOL(<ls_log_u>).
<ls_log_u>-changing_operation = 'UPDATE'.

GET TIME STAMP FIELD <ls_log_u>-created_at.
IF <ls_log_update>-%control-Status = if_abap_behv=>mk-on.
<ls_log_u>-changed_value = <ls_log_update>-Status.

TRY.
<ls_log_u>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
CATCH cx_uuid_error.
ENDTRY.

<ls_log_u>-changed_field_name = 'Status'.
"OLD VALUE
      <ls_log_u>-old_value = <ls_old>-status.
APPEND <ls_log_u> TO travel_log_update.
ENDIF.

IF <ls_log_update>-%control-description = if_abap_behv=>mk-on.
<ls_log_u>-changed_value = <ls_log_update>-description.
TRY.
<ls_log_u>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
CATCH cx_uuid_error.
ENDTRY.
<ls_log_u>-changed_field_name = 'Description'.
"OLD VALUE
      <ls_log_u>-old_value = <ls_old>-description.
APPEND <ls_log_u> TO travel_log_update.
ENDIF.
ENDLOOP.

INSERT zchangelog_dbt FROM TABLE @travel_log_update.

ENDIF.

IF delete-r_jrntb IS NOT INITIAL.
travel_log = CORRESPONDING #( delete-r_jrntb MAPPING travel_id = TravelID ).
LOOP AT travel_log ASSIGNING FIELD-SYMBOL(<ls_log_del>).
<ls_log_del>-changing_operation = 'DELETE'.
GET TIME STAMP FIELD <ls_log_del>-created_at.
TRY.
<ls_log_del>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
CATCH cx_uuid_error.

"handle exception
ENDTRY.
ENDLOOP.

INSERT zchangelog_dbt FROM TABLE @travel_log.
ENDIF.



  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
