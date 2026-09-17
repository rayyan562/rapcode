@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'consumption view for travel'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zc_travhdr as projection on zr_travhdr
{

@UI.facet: [{ purpose: #STANDARD,
              type: #COLLECTION,
              label: 'Travel',
              id: 'jrn'},
              
              { parentId: 'jrn',
                purpose: #STANDARD,
                type: #IDENTIFICATION_REFERENCE,
                label: 'Travel Info' },
                
                { parentId: 'jrn',
                  purpose: #STANDARD,
                  type: #LINEITEM_REFERENCE,
                  targetElement: '_Item' 

 }]
 
 @UI.lineItem: [{ position: 10 }]
@UI.identification: [{ position: 10 }]
 
    key TravelId,
    @UI.lineItem: [{ position: 20 }]
@UI.identification: [{ position: 20 }]
 
    Description,
    @UI.lineItem: [{ position: 30 }]
@UI.identification: [{ position: 30 }]
 
    Status,
    LastChangedAt,
    /* Associations */
    _Item:redirected to composition child zc_booking_vw
}
