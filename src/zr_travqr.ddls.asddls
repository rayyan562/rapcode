@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZTRAVQR'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_TRAVQR
  as select from ztravqr as R_TRAVQR
{
  key travel_id as TravelID,
  description as Description,
  status as Status,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.imageUrl: true
  qrcode as Qrcode,
  mimetype as MimeType,
  filename as FIleName
}
