CLASS zcl_ce_travel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ce_travel IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
  DATA : lv_orderby TYPE string,
         lt_filters TYPE if_rap_query_filter=>tt_name_range_pairs,
         lt_travel_id TYPE RANGE OF /dmo/travel_id.

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


LOOP AT lt_sort INTO DATA(wa_sort).

if wa_sort-descending = abap_true.

lv_orderby = |'{ lv_orderby } { wa_sort-element_name } DESCENDING' |.
else.
lv_orderby = |'{ lv_orderby } { wa_sort-element_name } ASCENDING' |.


ENDIF.


ENDLOOP.

IF lv_orderby IS INITIAL.

LV_ORDERBY = 'TRAVEL_ID'.
ENDIF.
"filtering
data(lo_filter) = io_request->get_filter(  ).
try.
lt_filters = lo_filter->get_as_ranges(  ).

data(ls_filter) = VALUE #( lt_filters[ name = 'TRAVEL_ID' ] OPTIONAL ).

IF sy-subrc eq 0.

LOOP AT ls_filter-range INTO DATA(ls_range).

APPEND VALUE #( sign = ls_range-sign
                option = ls_range-option
                low = conv /dmo/travel_id( |{ ls_range-low ALPHA = in }| )
                high = conv /dmo/travel_id( |{ ls_range-high ALPHA = in }| )

                ) to lt_travel_id.



ENDLOOP.


ENDIF.



CATCH CX_RAP_QUERY_FILTER_NO_RANGE.

ENDTRY.

SELECT FROM /dmo/travel
FIELDS travel_id, status, description
WHERE (  travel_id in @lt_travel_id )
ORDER BY (lv_orderby)
into TABLE @data(lt_travel) UP TO @lv_top ROWS OFFSET @lv_skip.


if io_request->is_total_numb_of_rec_requested(  ).

io_response->set_data( lt_travel ).
io_response->set_total_number_of_records( lines( lt_travel ) ).


ENDIF.




  ENDIF.



  ENDMETHOD.
ENDCLASS.
