CLASS LHC_ZR_TRAVTB DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR R_TRAVTB
        RESULT result,
      UpdateStatus FOR MODIFY
            keys FOR ACTION R_TRAVTB~UpdateStatus RESULT RESULT,
      ShowTotal FOR MODIFY
            keys FOR ACTION R_TRAVTB~ShowTotal,
      CopyTravel FOR MODIFY
            keys FOR ACTION R_TRAVTB~CopyTravel,
      CreateRecord FOR MODIFY
            keys FOR ACTION R_TRAVTB~CreateRecord,
      validate_status FOR VALIDATE ON SAVE
            keys FOR R_TRAVTB~validate_status,
      precheck_update FOR PRECHECK
            entities FOR UPDATE R_TRAVTB,
      gettravelplace FOR DETERMINE ON modify
            keys FOR R_TRAVTB~gettravelplace,
      is_modify_allowed RETURNING VALUE(modify_allowed) TYPE abap_bool,
      get_instance_authorizations FOR INSTANCE AUTHORIZATION
            keys REQUEST requested_authorizations FOR R_TRAVTB RESULT result,
      get_instance_features FOR INSTANCE FEATURES
            keys REQUEST requested_features FOR R_TRAVTB RESULT result.

          METHODS Clear FOR MODIFY
            keys FOR ACTION R_TRAVTB~Clear RESULT result.
ENDCLASS.

CLASS LHC_ZR_TRAVTB IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.

*  if requested_authorizations-%update = if_abap_behv=>mk-on or
*    requested_authorizations-%action-Edit = if_abap_behv=>mk-on.
*
*    if is_modify_allowed(  ) = abap_false.
*
*    result-%update = if_abap_behv=>auth-unauthorized.
*        result-%action-Edit = if_abap_behv=>auth-unauthorized.
*
*  else.
*
*    result-%update = if_abap_behv=>auth-allowed.
*        result-%action-Edit = if_abap_behv=>auth-allowed.
*
*  endif.
*  endif.
  ENDMETHOD.

  METHOD is_modify_allowed.
  modify_allowed = abap_false.
  ENDMETHOD.
  METHOD UpdateStatus.

*  MODIFY ENTITIES OF zR_TRAVTB IN LOCAL MODE ENTITY R_TRAVTB
*  UPDATE FIELDS ( Status )
*  WITH VALUE #(  for key in keys
*              ( %key-TravelID = key-TravelID
*                   Status = 'P' ) ).


READ ENTITIES OF zr_travtb IN LOCAL MODE ENTITY r_travtb
ALL FIELDS WITH CORRESPONDING #( keys )
RESULT data(lt_result).


LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<fs_result>).


if <fs_result>-TotalPrice le 100.

APPEND VALUE #( %tky = <fs_result>-%tky ) to failed-r_travtb.
APPEND VALUE #( %tky = <fs_result>-%tky
                 %msg = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = 'total price should not be lessthan 100'
                        ) ) to reported-r_travtb.




else.

<fs_result>-Status = 'M'.
endif.
ENDLOOP.


  MODIFY ENTITIES OF zR_TRAVTB IN LOCAL MODE ENTITY R_TRAVTB
  UPDATE FIELDS ( Status ) WITH CORRESPONDING #( lt_result ).



result = VALUE #( for ls_result in lt_result
                   (  %tky = ls_result-%tky
                      %param = ls_result ) ).




  ENDMETHOD.

  METHOD ShowTotal.
  READ ENTITIES OF zr_travtb IN LOCAL MODE ENTITY r_travtb
ALL FIELDS WITH CORRESPONDING #( keys )
RESULT data(lt_travel).


data(lv_total_price) = REDUCE decfloat34(  INIT sum = 0 for ls_travel in lt_travel NEXT
                                                sum = sum + ls_travel-TotalPrice ).
"hardcoding message - new_message_with_text
"get message from message class - new_message

   APPEND VALUE #( %tky = keys[ 1 ]-%tky
                   %msg = new_message(
                            id       = 'ZMSG_EXTRACTION'
                            number   = '000'
                            severity =  if_abap_behv_message=>severity-information
                            v1       =  lv_total_price
*                            v2       =
*                            v3       =
*                            v4       =

                          )  ) to reported-r_travtb.
              ENDMETHOD.

  METHOD CopyTravel.
data: lt_copy TYPE TABLE FOR CREATE zr_travtb.
  READ ENTITIES OF zr_travtb IN LOCAL MODE ENTITY r_travtb
ALL FIELDS WITH CORRESPONDING #( keys )
RESULT data(lt_travel_copy).

select max( travel_id ) from ztravtb into @data(lv_travel_copyid).
if sy-subrc eq 0.

lv_travel_copyid = lv_travel_copyid + 1.

ENDIF.

LOOP AT lt_travel_copy ASSIGNING FIELD-SYMBOL(<fs_travel_copy>).


APPEND VALUE #( %cid = keys[ key entity %key = <fs_travel_copy>-%key ]-%cid
                %is_draft = keys[ key entity %key = <fs_travel_copy>-%key ]-%is_draft
                %data = VALUE #( travelid = lv_travel_copyid
                                 status   = <fs_travel_copy>-Status
                                 description = <fs_travel_copy>-Description
                                 CurrencyCode = <fs_travel_copy>-CurrencyCode
                                 bookingfee = <fs_travel_copy>-BookingFee
                                 totalprice = <fs_travel_copy>-TotalPrice
                                 begindate = cl_abap_context_info=>get_system_date(  )
                                 enddate   = <fs_travel_copy>-EndDate
                                  ) ) to lt_copy.



ENDLOOP.

  MODIFY ENTITIES OF zR_TRAVTB IN LOCAL MODE ENTITY R_TRAVTB
CREATE FIELDS ( TravelID Status Description CurrencyCode BookingFee TotalPrice BeginDate EndDate )
with lt_copy MAPPED data(lt_mapped).


mapped-r_travtb = lt_mapped-r_travtb.


  ENDMETHOD.

  METHOD CreateRecord.

select max( travel_id ) from ztravtb into @data(lv_travel_copyid).
if sy-subrc eq 0.

lv_travel_copyid = lv_travel_copyid + 1.

ENDIF.


    MODIFY ENTITIES OF zR_TRAVTB IN LOCAL MODE ENTITY R_TRAVTB
     CREATE FROM VALUE #( for ls_keys in keys (
                          %cid = ls_keys-%cid
                          TravelID = lv_travel_copyid
                                 Status   = 'C'
                                 Description = 'Chennai'
                                 CurrencyCode = 'INR'
                                 BookingFee = 220
                                 TotalPrice = 260
                                 BeginDate = cl_abap_context_info=>get_system_date(  )
                                 EndDate   = cl_abap_context_info=>get_system_date(  ) + 10
                                 %control = VALUE #(  TravelID = if_abap_behv=>mk-on
                                                      Status = if_abap_behv=>mk-on
                                                      Description = if_abap_behv=>mk-on
                                                      CurrencyCode = if_abap_behv=>mk-on
                                                      TotalPrice = if_abap_behv=>mk-on
                                                      BookingFee = if_abap_behv=>mk-on
                                                      BeginDate = if_abap_behv=>mk-on
                                                      EndDate = if_abap_behv=>mk-on ) ) ).



  ENDMETHOD.

  METHOD validate_status.

  READ ENTITIES OF zr_travtb IN LOCAL MODE ENTITY r_travtb
ALL FIELDS WITH CORRESPONDING #( keys )
RESULT data(lt_status_validate).


loop AT lt_status_validate INTO DATA(wa_status_validate).


if wa_status_validate-Status eq 'N'.

APPEND VALUE #( %tky = wa_status_validate-%tky ) to failed-r_travtb.
APPEND VALUE #( %tky = wa_status_validate-%tky
                 %msg = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Travel Status { wa_status_validate-Status } Not Allowed|
                        ) ) to reported-r_travtb.

else.

APPEND VALUE #( %tky = wa_status_validate-%tky
                 %msg = new_message_with_text(
                          severity = if_abap_behv_message=>severity-success
                          text     = |Travel Validation Success|
                        ) ) to reported-r_travtb.




ENDIF.




ENDLOOP.





  ENDMETHOD.

  METHOD precheck_update.

*loop AT entities ASSIGNING FIELD-SYMBOL(<lfs_entity>).
*
*
*check <lfs_entity>-%control-BeginDate eq '01' or <lfs_entity>-%control-EndDate eq '01'.
*
*READ ENTITIES OF zr_travtb IN LOCAL MODE
*ENTITY r_travtb
*ALL FIELDS WITH value #( ( %key = <lfs_entity>-%key ) )
*RESULT data(lt_prechecks).
*if sy-subrc eq 0.
*ASSIGN lt_prechecks[ 1 ] to FIELD-SYMBOL(<fs_prechecks>).
*if sy-subrc eq 0.
*
*<fs_prechecks> = VALUE #(  base <fs_prechecks>
*                 BeginDate = SWITCH #(  <lfs_entity>-%control-BeginDate when '01' then <lfs_entity>-BeginDate
*                                        else <fs_prechecks>-BeginDate )
*
*                  EndDate = SWITCH #(  <lfs_entity>-%control-EndDate when '01' then <lfs_entity>-EndDate
*                                        else <fs_prechecks>-EndDate ) ).
*
*
*
*if <fs_prechecks>-BeginDate > <fs_prechecks>-EndDate.
*APPEND VALUE #( %tky = <lfs_entity>-%tky ) to failed-r_travtb.
*APPEND VALUE #( %tky = <lfs_entity>-%tky
*                 %msg = new_message_with_text(
*                          severity = if_abap_behv_message=>severity-error
*                          text     = |start date should not be greater than end date|
*                        ) ) to reported-r_travtb.
*
*
*endif.
*endif.
*endif.
*
*
*
*
*ENDLOOP.
*
*


  ENDMETHOD.

  METHOD gettravelplace.

   READ ENTITIES OF zr_travtb IN LOCAL MODE ENTITY r_travtb
ALL FIELDS WITH CORRESPONDING #( keys )
RESULT data(lt_travel_place).


check lt_travel_place is NOT INITIAL.

MODIFY ENTITIES OF zr_travtb
IN LOCAL MODE ENTITY r_travtb
UPDATE FIELDS ( Description )
WITH VALUE #( for travelplace in lt_travel_place WHERE ( Status = 'P' OR Status = 'H' )
            (  %TKY = travelplace-%tky
               Description = SWITCH #( travelplace-Status
                                          when 'P' then 'Patna'
                                          when 'H' then 'Hyderabad' ) ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.

  data : update_requested TYPE abap_boolean,
         update_accepted TYPE abap_boolean.
   READ ENTITIES OF zr_travtb IN LOCAL MODE ENTITY r_travtb
ALL FIELDS WITH CORRESPONDING #( keys )
RESULT data(lt_travel_auth).

  check lt_travel_auth is NOT INITIAL.

  update_requested = cond #(   when requested_authorizations-%update = if_abap_behv=>mk-on or
    requested_authorizations-%action-Edit = if_abap_behv=>mk-on then abap_true else abap_false ).

  LOOP AT lt_travel_auth ASSIGNING FIELD-SYMBOL(<fs_travel_auth>).
  if <fs_travel_auth>-Status = 'O'.
  if update_requested = abap_true.
  update_accepted = is_modify_allowed(  ).
  if update_accepted = abap_false.
  APPEND VALUE #( %tky = <fs_travel_auth>-%tky ) to failed-r_travtb.
APPEND VALUE #( %tky = <fs_travel_auth>-%tky
                 %msg = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |no authorization to update|
                        ) ) to reported-r_travtb.
*
  endif.
  endif.
  endif.


  ENDLOOP.





  ENDMETHOD.


  METHOD get_instance_features.

  result = VALUE #( FOR key IN keys
    ( %tky   = key-%tky
      %features-%action-Clear = COND #(
          WHEN key-%is_draft = if_abap_behv=>mk-on
          THEN if_abap_behv=>fc-o-enabled
          ELSE if_abap_behv=>fc-o-disabled )
    ) ).

ENDMETHOD.
METHOD clear.

  MODIFY ENTITIES OF zr_travtb IN LOCAL MODE
    ENTITY R_TRAVTB
    UPDATE FIELDS ( Description Status BeginDate EndDate BookingFee TotalPrice CurrencyCode )
    WITH VALUE #( FOR key IN keys
                  ( %tky        = key-%tky
                    Description = ''
                    Status      = ''
                    BeginDate   = '00000000'
                    EndDate     = '00000000'
                    BookingFee  = 0
                    TotalPrice  = 0
                    CurrencyCode = '' ) )
    FAILED failed
    REPORTED reported.

  READ ENTITIES OF zr_travtb IN LOCAL MODE
    ENTITY R_TRAVTB
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

  result = VALUE #( FOR travel IN lt_travel
                     ( %tky   = travel-%tky
                       %param = travel ) ).

ENDMETHOD.
ENDCLASS.
