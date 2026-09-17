CLASS lsc_zr_jrntb000 DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zr_jrntb000 IMPLEMENTATION.

  METHOD save_modified.

  data : travel_log TYPE TABLE of zchangelogs_dbt,
         travel_log_create TYPE TABLE of zchangelogs_dbt,
         travel_log_update TYPE TABLE of zchangelogs_dbt.

 if create-r_jrntb000 is NOT INITIAL.

 travel_log = CORRESPONDING #( create-r_jrntb000  MAPPING travel_id = TravelID ).

 LOOP AT travel_log ASSIGNING FIELD-SYMBOL(<fs_travel_log>).

 <fs_travel_log>-changing_operation = 'CREATE'.
 GET TIME STAMP FIELD <fs_travel_log>-created_at.
 READ TABLE create-r_jrntb000 ASSIGNING FIELD-SYMBOL(<fs_travel>)
 with TABLE KEY entity COMPONENTS TravelID = <fs_travel_log>-travel_id.

 if sy-subrc eq 0.


 if <fs_travel>-%control-TravelID = cl_abap_behv=>flag_changed.

 <fs_travel_log>-changed_field_name = 'TravelId'.
 <fs_travel_log>-changed_value = <fs_travel>-TravelID.

 try.

 <fs_travel_log>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
 CATCH CX_UUID_ERROR.
 ENDTRY.
 APPEND <fs_travel_log> to travel_log_create.

 ENDIF.

 if <fs_travel>-%control-Status = cl_abap_behv=>flag_changed.

 <fs_travel_log>-changed_field_name = 'Status'.
 <fs_travel_log>-changed_value = <fs_travel>-Status.

 try.

 <fs_travel_log>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
 CATCH CX_UUID_ERROR.
 ENDTRY.
 APPEND <fs_travel_log> to travel_log_create.

 ENDIF.


 if <fs_travel>-%control-Description = cl_abap_behv=>flag_changed.

 <fs_travel_log>-changed_field_name = 'Description'.
 <fs_travel_log>-changed_value = <fs_travel>-Description.

 try.

 <fs_travel_log>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
 CATCH CX_UUID_ERROR.
 ENDTRY.
 APPEND <fs_travel_log> to travel_log_create.

 ENDIF.
 endif.



 ENDLOOP.

 insert zchangelogs_dbt FROM TABLE @travel_log_create.


elseif update-r_jrntb000 is NOT INITIAL.

travel_log = CORRESPONDING #( update-r_jrntb000 MAPPING travel_id = TravelID  ).

LOOP AT update-r_jrntb000 ASSIGNING FIELD-SYMBOL(<fs_log_update>).

ASSIGN travel_log[ travel_id = <fs_log_update>-TravelID ] to FIELD-SYMBOL(<fs_log_u>).
<fs_log_u>-changing_operation = 'UPDATE'.
 GET TIME STAMP FIELD <fs_log_u>-created_at.


if <fs_log_update>-%control-Status = if_abap_behv=>mk-on.
<fs_log_u>-changed_field_name = 'Status'.
 <fs_log_u>-changed_value = <fs_log_update>-Status.
 try.

 <fs_log_u>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
 CATCH CX_UUID_ERROR.
 ENDTRY.
 APPEND <fs_log_u> to travel_log_update.
endif.

if <fs_log_update>-%control-Description = if_abap_behv=>mk-on.
<fs_log_u>-changed_field_name = 'Description'.
 <fs_log_u>-changed_value = <fs_log_update>-Description.
 try.

 <fs_log_u>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
 CATCH CX_UUID_ERROR.
 ENDTRY.
  APPEND <fs_log_u> to travel_log_update.

endif.





ENDLOOP.

 insert zchangelogs_dbt FROM TABLE @travel_log_update.

elseif delete-r_jrntb000 is NOT INITIAL.

travel_log = CORRESPONDING #( delete-r_jrntb000 MAPPING travel_id = TravelID  ).


loop AT travel_log ASSIGNING FIELD-SYMBOL(<fs_log_del>).

<fs_log_del>-changing_operation = 'DELETE'.
 GET TIME STAMP FIELD <fs_log_del>-created_at.
try.

 <fs_log_del>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
 CATCH CX_UUID_ERROR.
 ENDTRY.




ENDLOOP.


INSERT zchangelogs_dbt FROM TABLE @travel_log.


 ENDIF.








  ENDMETHOD.

ENDCLASS.

CLASS LHC_ZR_JRNTB000 DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR R_JRNTB000
        RESULT result.
ENDCLASS.

CLASS LHC_ZR_JRNTB000 IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
ENDCLASS.
