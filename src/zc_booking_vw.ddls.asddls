@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'consumption view for booking'
@Metadata.ignorePropagatedAnnotations: true
define view entity zc_booking_vw as projection on zi_booking_vw
{

@UI.facet: [{ type: #IDENTIFICATION_REFERENCE, label: 'Booking Info' }]
@UI.lineItem: [{ position: 10 }]
@UI.identification: [{ position: 10 }]
    key TravelId,
    @UI.lineItem: [{ position: 20 }]
@UI.identification: [{ position: 20 }]
    
    key BookingId,
    @UI.lineItem: [{ position: 30 }]
@UI.identification: [{ position: 30 }]
    
    BeginDate,
    @UI.lineItem: [{ position: 40 }]
@UI.identification: [{ position: 40 }]
    
    EndDate,
    /* Associations */
    _header: redirected to parent zc_travhdr
}
