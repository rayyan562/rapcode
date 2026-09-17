CLASS lhc_R_TRAVTB002 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR r_travtb002 RESULT result.

    METHODS create FOR MODIFY
       entities FOR CREATE r_travtb002.

    METHODS update FOR MODIFY
       entities FOR UPDATE r_travtb002.

    METHODS delete FOR MODIFY
       keys FOR DELETE r_travtb002.

    METHODS read FOR READ
       keys FOR READ r_travtb002 RESULT result.

    METHODS lock FOR LOCK
       keys FOR LOCK r_travtb002.

ENDCLASS.

CLASS lhc_R_TRAVTB002 IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZR_TRAVTB002 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZR_TRAVTB002 IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
