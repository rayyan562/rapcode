CLASS lhc_R_TRAVTB000 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR r_travtb000 RESULT result.

    METHODS create FOR MODIFY
       entities FOR CREATE r_travtb000.

    METHODS update FOR MODIFY
       entities FOR UPDATE r_travtb000.

    METHODS delete FOR MODIFY
       keys FOR DELETE r_travtb000.

    METHODS read FOR READ
       keys FOR READ r_travtb000 RESULT result.

    METHODS lock FOR LOCK
       keys FOR LOCK r_travtb000.

ENDCLASS.

CLASS lhc_R_TRAVTB000 IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.

  zbp_r_travtb000=>lt_insert = CORRESPONDING #( entities MAPPING FROM ENTITY ).



  ENDMETHOD.

  METHOD update.

  select * from ztravtb FOR ALL ENTRIES IN @entities
  WHERE travel_id = @entities-TravelID
  into TABLE @data(lt_travel).

  check lt_travel is NOT INITIAL.
GET TIME STAMP FIELD DATA(lv_timestamp).


  LOOP AT entities INTO DATA(wa_entity).

  data(ls_travel) = VALUE #( lt_travel[ travel_id = wa_entity-TravelID ] OPTIONAL ).

  ls_travel-begin_date = cond #(  when wa_entity-%control-BeginDate eq if_abap_behv=>mk-on
                                   then wa_entity-BeginDate else ls_travel-begin_date ).


  ls_travel-end_date = cond #(  when wa_entity-%control-EndDate eq if_abap_behv=>mk-on
                                   then wa_entity-EndDate else ls_travel-end_date ).


  ls_travel-status = cond #(  when wa_entity-%control-Status eq if_abap_behv=>mk-on
                                   then wa_entity-Status else ls_travel-status ).


  ls_travel-description = cond #(  when wa_entity-%control-Description eq if_abap_behv=>mk-on
                                   then wa_entity-Description else ls_travel-description ).


  ls_travel-currency_code = cond #(  when wa_entity-%control-CurrencyCode eq if_abap_behv=>mk-on
                                   then wa_entity-CurrencyCode else ls_travel-currency_code ).


  ls_travel-booking_fee = cond #(  when wa_entity-%control-BookingFee eq if_abap_behv=>mk-on
                                   then wa_entity-BookingFee else ls_travel-begin_date ).


  ls_travel-total_price = cond #(  when wa_entity-%control-TotalPrice eq if_abap_behv=>mk-on
                                   then wa_entity-TotalPrice else ls_travel-total_price ).
 "Update ETag / last change information
  ls_travel-local_last_changed_at = lv_timestamp.
  ls_travel-last_changed_at       = lv_timestamp.
  ls_travel-local_last_changed_by = sy-uname.

  APPEND ls_travel to zbp_r_travtb000=>lt_update.
  clear ls_travel.
  ENDLOOP.






  ENDMETHOD.

  METHOD delete.


  zbp_r_travtb000=>lt_delete = CORRESPONDING #( keys MAPPING travel_id = TravelID ).






  ENDMETHOD.

  METHOD read.

  select from ztravtb
  FIELDS *
  FOR ALL ENTRIES IN @keys
  WHERE travel_id = @keys-TravelID
  into TABLE @data(lt_travel).

  if sy-subrc eq 0.

  result = CORRESPONDING #( lt_travel MAPPING TravelID = travel_id
                                              TotalPrice = total_price
                                              BookingFee = booking_fee
                                              CurrencyCode = currency_code
                                              BeginDate = begin_date
                                              EndDate = end_date
                                               LocalCreatedBy     = local_created_by
      LocalCreatedAt     = local_created_at
      LocalLastChangedBy = local_last_changed_by
      LocalLastChangedAt = local_last_changed_at
      LastChangedAt      = last_changed_at ).

  ENDIF.


  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZR_TRAVTB000 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZR_TRAVTB000 IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.

*  if zbp_r_travtb000=>lt_insert is NOT INITIAL.
*
*  READ TABLE zbp_r_travtb000=>lt_insert ASSIGNING FIELD-SYMBOL(<fs_insert>) INDEX 1.
*  if <fs_insert> is ASSIGNED.
*
*  if <fs_insert>-status = 'H'.
*
*  APPEND VALUE #( travelid = <fs_insert>-travel_id ) to failed-r_travtb000.
*APPEND VALUE #( travelid = <fs_insert>-travel_id
*                 %msg = new_message_with_text(
*                          severity = if_abap_behv_message=>severity-error
*                          text     = |travel status should not be { <fs_insert>-status }|
*                        ) ) to reported-r_travtb000.
*
*
*
*
*  ENDIF.
*
*  ENDIF.
*
*
*
*
*  ENDIF.
*
*
*
*
*
*

  ENDMETHOD.

  METHOD save.

  if zbp_r_travtb000=>lt_insert is NOT INITIAL.

  insert ztravtb FROM TABLE  @( VALUE #( for wa in zbp_r_travtb000=>lt_insert ( CORRESPONDING #( wa ) ) ) ).

  elseif zbp_r_travtb000=>lt_update is NOT INITIAL.
    modify ztravtb FROM TABLE  @( VALUE #( for wa in zbp_r_travtb000=>lt_update ( CORRESPONDING #( wa ) ) ) ).


    elseif zbp_r_travtb000=>lt_delete is NOT INITIAL.

  delete ztravtb FROM TABLE  @( VALUE #( for wa in zbp_r_travtb000=>lt_delete ( CORRESPONDING #( wa ) ) ) ).

  ENDIF.




  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
