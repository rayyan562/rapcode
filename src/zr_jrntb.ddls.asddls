@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZJRNTB'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_JRNTB
  as select from zjrntb as R_JRNTB
  association[1..*] to zi_changelogs as _logs on $projection.TravelID = _logs.TravelId
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
  _logs
}
