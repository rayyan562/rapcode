@EndUserText.label: 'call external api into rap'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_CALL_API'
define custom entity zce_prod_api
{


@UI.lineItem: [{ position: 10, label: 'Product Id' }]  
  key product_id : abap.int4;
  @UI.lineItem: [{ position: 20, label: 'Product Name' }]  
  
  product_name : abap.char( 100 );
 @UI.lineItem: [{ position: 30, label: 'Supplier Id' }]  
 
  supplier_id : abap.int4;
  @UI.lineItem: [{ position: 40, label: 'Category Id' }]  
  
  category_id : abap.int4;
  @UI.lineItem: [{ position: 50, label: 'Quantity Per Unit' }]  
  
  quantity_per_unit : abap.char(100);
  @UI.lineItem: [{ position: 60, label: 'Unit Price' }]  
  
  unit_price : abap.dec( 16, 0 );
  @UI.lineItem: [{ position: 70, label: 'Units In Stock' }]  
  
  units_in_stock : abap.int2;
    @UI.lineItem: [{ position: 80, label: 'Units On Order' }]  
  
  units_on_order : abap.int2;
  
  
}
