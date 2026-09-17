@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZTRAVTB001'
}
@AccessControl.authorizationCheck: #MANDATORY
@OData.applySupportedForAggregation: #FULL

define root view entity ZC_TRAVTB001
  provider contract transactional_query
  as projection on ZR_TRAVTB001
  association [1..1] to ZR_TRAVTB001 as _BaseEntity on $projection.TravelID = _BaseEntity.TravelID
{
  key TravelID,
  BeginDate,
  EndDate,
  @Semantics: {
    amount.currencyCode: 'CurrencyCode'
  }
  BookingFee,
  @Semantics: {
    amount.currencyCode: 'CurrencyCode'
  }
  @Aggregation.default: #SUM
  
  TotalPrice,
  @Consumption: {
    valueHelpDefinition: [ {
      entity.element: 'Currency', 
      entity.name: 'I_CurrencyStdVH', 
      useForValidation: true
    } ]
  }
  CurrencyCode,
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
  _BaseEntity
}
