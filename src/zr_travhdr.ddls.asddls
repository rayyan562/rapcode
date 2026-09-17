@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'root entity for travel information'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zr_travhdr as select from ztrvhdr
composition [0..*] of zi_booking_vw as _Item
{
key travel_id as TravelId,
description as Description,
status as Status,
last_changed_at as LastChangedAt ,
_Item
}
