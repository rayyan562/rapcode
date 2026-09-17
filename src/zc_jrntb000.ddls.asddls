@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZJRNTB000'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_JRNTB000
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_JRNTB000
  association [1..1] to ZR_JRNTB000 as _BaseEntity on $projection.TRAVELID = _BaseEntity.TRAVELID
{
  key TravelID,
  Description,
  Status,
  @Semantics: {
    User.Createdby: true
  }
  LocalCreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  LocalCreatedAt,
  @Semantics: {
    User.Localinstancelastchangedby: true
  }
  LocalLastChangedBy,
  @Semantics: {
    Systemdatetime.Localinstancelastchangedat: true
  }
  LocalLastChangedAt,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  LastChangedAt,
  _BaseEntity
}
