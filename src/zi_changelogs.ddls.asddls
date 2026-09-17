@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'change logs view'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_changelogs as select from zchangelog_dbt
{

@UI.lineItem: [{ position: 10 }]
    key change_id as ChangeId,
    @UI.lineItem: [{ position: 20 }]
    
    travel_id as TravelId,
    @UI.lineItem: [{ position: 30 }]
    
    changing_operation as ChangingOperation,
    @UI.lineItem: [{ position: 40 }]
    
    changed_field_name as ChangedFieldName,
    @UI.lineItem: [{ position: 50 }]
    old_value as OldValue,
        @UI.lineItem: [{ position: 60 }]
    
    changed_value as ChangedValue,
    @UI.lineItem: [{ position: 70 }]
    
    created_at as CreatedAt
}
