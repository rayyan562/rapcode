CLASS zcl_sercm_call_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_sercm_call_api IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

   DATA(top)     = io_request->get_paging( )->get_page_size( ).
    DATA(skip)    = io_request->get_paging( )->get_offset( ).
    DATA(requested_fields)  = io_request->get_requested_elements( ).
    DATA(sort_order)    = io_request->get_sort_elements( ).
    data(filter) = io_request->get_filter( ).



DATA:
  ls_business_data TYPE zsercm_product=>tys_alphabetical_list_of_produ,

  lt_business_data TYPE table of zsercm_product=>tys_alphabetical_list_of_produ,
  lo_http_client   TYPE REF TO if_web_http_client,
  lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
  lo_request       TYPE REF TO /iwbep/if_cp_request_create,
  lo_response      TYPE REF TO /iwbep/if_cp_response_create,
  lo_read_list_request TYPE REF TO /iwbep/if_cp_request_read_list,
  lo_entity_list_resource TYPE REF TO /iwbep/if_cp_resource_list,
  lo_read_list_response TYPE REF TO /iwbep/if_cp_response_read_lst.



TRY.
DATA(lo_destination) = cl_http_destination_provider=>create_by_url( 'https://services.odata.org' ).
lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v4_remote_proxy(
  EXPORTING
     is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                         proxy_model_id      = 'ZSERCM_PRODUCT'
                                         proxy_model_version = '0001' )
    io_http_client             = lo_http_client
    iv_relative_service_root   = '/V4/Northwind/Northwind.svc' ).

ASSERT lo_http_client IS BOUND.

lo_entity_list_resource = lo_client_proxy->create_resource_for_entity_set( 'PRODUCTS' ).
lo_read_list_request = lo_entity_list_resource->create_request_for_read(  ).
lo_read_list_response = lo_read_list_request->execute(  ).
lo_read_list_response->get_business_data( IMPORTING et_business_data = lt_business_data ).


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

io_response->set_data( lt_business_data ).
io_response->set_total_number_of_records( lines( lt_business_data ) ).

ENDIF.

  ENDMETHOD.
ENDCLASS.
