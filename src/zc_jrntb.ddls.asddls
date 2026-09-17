@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZJRNTB'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_JRNTB
  provider contract transactional_query
  as projection on ZR_JRNTB
  association [1..1] to ZR_JRNTB as _BaseEntity on $projection.TravelID = _BaseEntity.TravelID
{
  key TravelID,
  Description,
  Status,
  @Semantics: {
    user.createdBy: true
  }
  LocalCreatedBy,
  @Semantics: {
    systemDateTime.createdAt: true
  }
  LocalCreatedAt,
  @Semantics: {
    user.localInstanceLastChangedBy: true
  }
  LocalLastChangedBy,
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  LocalLastChangedAt,
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
  LastChangedAt,
  _logs,
  _BaseEntity
}
