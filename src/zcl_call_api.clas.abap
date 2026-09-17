CLASS zcl_call_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_call_api IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
  "if user requested data
  if io_request->is_data_requested(  ).

"paging - top and skip

  data(lv_top) = io_request->get_paging(  )->get_page_size(  ).

  if lv_top le 0.
  lv_top = 1.
  ENDIF.

  data(lv_skip) = io_request->get_paging(  )->get_offset(  ).

"sorting
data(lt_sort) = io_request->get_sort_elements(  ).
data(lo_filter) = io_request->get_filter(  ).

DATA:
  ls_business_data TYPE  zscm_api=>tys_alphabetical_list_of_produ,

  lt_products TYPE TABLE of   zscm_api=>tys_alphabetical_list_of_produ,

  lo_http_client   TYPE REF TO if_web_http_client,
  lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
  lo_request       TYPE REF TO /iwbep/if_cp_request_create,
  lo_response      TYPE REF TO /iwbep/if_cp_response_create,
  lo_read_list_request TYPE REF TO /iwbep/if_cp_request_read_list,
  lo_entity_list_resource TYPE REF TO /iwbep/if_cp_resource_list,
  lo_read_list_response TYPE REF TO /iwbep/if_cp_response_read_lst.


TRY.
" Create http client
DATA(lo_destination) = cl_http_destination_provider=>create_by_url( 'https://services.odata.org' ).
lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
  EXPORTING
     is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                         proxy_model_id      = 'ZSCM_API'
                                         proxy_model_version = '0001' )
    io_http_client             = lo_http_client
    iv_relative_service_root   = 'V2/Northwind/Northwind.svc/' ).

ASSERT lo_http_client IS BOUND.

lo_entity_list_resource = lo_client_proxy->create_resource_for_entity_set( 'PRODUCTS' ).
lo_read_list_request = lo_entity_list_resource->create_request_for_read(  ).
lo_read_list_response = lo_read_list_request->execute(  ).
lo_read_list_response->get_business_data( IMPORTING et_business_data = lt_products ).



CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
" Handle remote Exception
" It contains details about the problems of your http(s) connection


CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
" Handle Exception

CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
" Handle Exception
RAISE SHORTDUMP lx_web_http_client_error.

ENDTRY.

if io_request->is_total_numb_of_rec_requested(  ).

io_response->set_data( lt_products ).
io_response->set_total_number_of_records( lines( lt_products ) ).

ENDIF.


  ENDIF.
  ENDMETHOD.
ENDCLASS.
