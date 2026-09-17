@EndUserText.label: 'abstract entity for travel status'
define abstract entity zabs_trav_status
{

@Consumption.valueHelpDefinition: [{ entity:{ element: 'Status', name: 'ZR_TRAVTB'} }]
  status : /dmo/travel_status;
    
}
