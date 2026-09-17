@EndUserText.label: 'custom entity for travel info'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_CE_TRAVEL'
define custom entity zce_travel
{

@UI.facet: [{ type: #IDENTIFICATION_REFERENCE, label: 'Travel Info' }]
@UI.lineItem: [{ position: 10 }]
@UI.identification: [{ position: 10 }]
@UI.selectionField: [{ position: 10 }]
  key travel_id : /dmo/travel_id;
  @UI.lineItem: [{ position: 20 }]
@UI.identification: [{ position: 20 }]
@UI.selectionField: [{ position: 20 }]
  
  Status : /dmo/travel_status;
  @UI.lineItem: [{ position: 30 }]
@UI.identification: [{ position: 30 }]
@UI.selectionField: [{ position: 30 }]
  
  Description : /dmo/description;
  
}
