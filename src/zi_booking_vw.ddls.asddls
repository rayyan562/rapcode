@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'booking view -- child entity'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_booking_vw as select from zbooking_item
association to parent zr_travhdr as _header on $projection.TravelId = _header.TravelId
{
    key travel_id as TravelId,
    key booking_id as BookingId,
    begin_date as BeginDate,
    end_date as EndDate,
    _header
}
