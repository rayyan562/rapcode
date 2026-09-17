CLASS LHC_ZR_TRAVQR DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR R_TRAVQR
        RESULT result,
      qrcode FOR DETERMINE ON SAVE
            keys FOR R_TRAVQR~qrcode.
ENDCLASS.

CLASS LHC_ZR_TRAVQR IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD qrcode.


  READ ENTITIES OF zR_TRAVQR IN LOCAL MODE
    ENTITY r_travqr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

  LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

    DATA(lv_qr_text) =
      |Travel ID: { <ls_travel>-TravelId }\n| &&
      |Status: { <ls_travel>-Status }\n| &&
      |Description: { <ls_travel>-Description }\n| .
    DATA lv_qr_xstring TYPE xstring.

*    TRY.
*
*        cl_rstx_barcode_renderer=>qr_code(
*          EXPORTING
*            i_module_size      = 10
*            i_mode             = 'A'
*            i_error_correction = 'M'
*            i_barcode_text     = lv_qr_text
*          IMPORTING
*            e_bitmap           = lv_qr_xstring ).
*
*      CATCH cx_root INTO DATA(lx_error).
*
*        APPEND VALUE #(
*          %tky = <ls_travel>-%tky
*          %msg = new_message_with_text(
*                   severity = if_abap_behv_message=>severity-error
*                   text     = lx_error->get_text( ) )
*        ) TO reported-r_travqr.
*
*        CONTINUE.
*
*    ENDTRY.

    MODIFY ENTITIES OF zR_TRAVQR IN LOCAL MODE
      ENTITY r_travqr
      UPDATE FIELDS (
        QrCode
        MimeType
        FileName
      )
      WITH VALUE #(
        (
          %tky     = <ls_travel>-%tky
          QrCode   = lv_qr_text
          MimeType = 'image/png'
          FileName = |QR_{ <ls_travel>-TravelId }.png|
        )
      ).

  ENDLOOP.

ENDMETHOD.

ENDCLASS.
