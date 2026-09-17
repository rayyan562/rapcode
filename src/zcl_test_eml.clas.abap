CLASS zcl_test_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_test_eml IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*"read by association
*READ ENTITIES OF zr_travhdr ENTITY travel
*ALL FIELDS WITH VALUE #( ( TravelId = '00000001' ) )
*RESULT DATA(LT_HEADER)
*
*ENTITY booking
* ALL FIELDS WITH VALUE #( ( TravelId = '00000001' BookingId = '0020'  ) )
*RESULT DATA(LT_BOOKING).
*
*out->write( '---travel---' ).
*out->write( lt_header ).
*out->write( '---booking---' ).
*out->write( lt_booking ).



data : lt_travel TYPE TABLE FOR CREATE zr_travhdr,
       lt_booking TYPE TABLE FOR CREATE zr_travhdr\_Item,
       ls_booking LIKE LINE OF lt_booking,
       lt_target like ls_booking-%target.

lt_travel = VALUE #( ( %cid = 'HDR_1' TravelId = '00000002' Status = 'C' Description = 'Chennai'
                         %control = VALUE #( TravelId = if_abap_behv=>mk-on
                                             Status = if_abap_behv=>mk-on
                                             Description = if_abap_behv=>mk-on ) ) ).

lt_target = VALUE #( ( %cid = 'ITM_1' BookingId = '0010'
                       BeginDate = CL_abap_context_info=>get_system_date(  ) - 30
                       EndDate = cl_abap_context_info=>get_system_date(  )
                       %control = VALUE #(  BookingId = if_abap_behv=>mk-on
                                            BeginDate = if_abap_behv=>mk-on
                                            EndDate = if_abap_behv=>mk-on ) ) ).

     lt_booking = VALUE #( ( %cid_ref = 'HDR_1' %target = LT_TARGET ) ).


  MODIFY ENTITIES OF zr_travhdr ENTITY     travel
  CREATE FROM lt_travel
  CREATE by \_Item FROM lt_booking
  MAPPED data(ls_mapped)
  failed data(ls_failed).


  if ls_failed is INITIAL.
  commit ENTITIES.
  if sy-subrc eq 0.
  out->write( 'travel created with booking' )  .
  endif.
  else.
           out->write( 'travel failed created with booking' )  .

ENDIF.


  ENDMETHOD.
ENDCLASS.
