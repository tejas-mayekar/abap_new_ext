@EndUserText.label: 'Hexa Biochem Stock Aging'

@ObjectModel: {
query: {
       implementedBy: 'ABAP:ZCL_STOCK_AGING'
    }
}

@UI: {
    headerInfo: {
        typeName : 'Hexa Biochem Stock Aging',
        title: { value : 'productname' },
        description: { value: 'product'}
    }
}

define custom entity ZCD_FS_STOCK_AGING
{
      @UI.facet       : [
                           {
                             id   :  'Stock_Aging',
                             purpose    :  #STANDARD,
                             type :  #IDENTIFICATION_REFERENCE,
                             label:  'Sales Stock Aging',
                             position   : 10 }
                         ]


      @EndUserText.label: 'Material No.'
      @UI.lineItem    : [{ position: 10, label: 'Item No' }]
      @UI.identification: [{ position: 10, label: 'Item No' }]
      @UI.selectionField: [{ position: 11 }]
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_ProductStdVH', element: 'Product' } } ]
      //      @Consumption.filter.mandatory: true
  key product         : matnr;

      @UI.lineItem    : [{ position: 20, label: 'Item Name' }]
      @UI.identification: [{ position: 20, label: 'Item Name' }]
  key productname     : abap.string;

      @EndUserText.label: 'Plant'
      @UI.selectionField: [{ position: 12 }]
      @UI.lineItem    : [{ position: 25, label: 'Plant'}]
      @UI.identification: [{ position: 25, label: 'Plant'}]
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_PlantStdVH', element: 'Plant' } } ]
      //      @Consumption.filter.mandatory: true
  key plant           : werks_d;

      @EndUserText.label: 'Storage Location'
      @UI.selectionField: [{ position: 13 }]
      @UI.lineItem    : [{ position: 170, label: 'Storage Location'}]
      @UI.identification: [{ position: 170, label: 'Storage Location', hidden: true }]
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_StorageLocationStdVH', element: 'StorageLocation' } } ]
      storagelocation : abap.char( 15 );

      @EndUserText.label: 'Material Type'
      @UI.selectionField: [{ position: 14 }]
      @UI.lineItem    : [{ position: 180, label: 'Material Type'}]
      @UI.identification: [{ position: 180, label: 'Material Type', hidden: true }]
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_ProductType', element: 'ProductType' } } ]
      materialtype    : abap.char( 15 );

      @EndUserText.label: 'Selection Date'
      @UI.selectionField: [{ position: 15 }]
      @UI.lineItem    : [{ position: 160, label: 'Selectin Date'}]
      @UI.identification: [{ position: 160, label: 'Selection Date', hidden: true }]
      @Consumption.filter.selectionType: #SINGLE
      @Consumption.filter.mandatory: true
      selectiondate   : abap.dats;

      @UI.lineItem    : [{ position: 30, label: '<30 QTY' }]
      @UI.identification: [{ position: 30, label: '<30 QTY' }]
      lt_30           : abap.char(20);

      @UI.lineItem    : [{ position: 40, label: '<30 Current AMT' }]
      @UI.identification: [{ position: 40, label: '<30 Current AMT' }]
      lt_30_amt       : abap.dec(16,2);

      @UI.lineItem    : [{ position: 50, label: '31 to 60 QTY' }]
      @UI.identification: [{ position: 50, label: '31 to 60 QTY' }]
      bt_31_60        : abap.char(20);

      @UI.lineItem    : [{ position: 60, label: '31 to 60 Current AMT' }]
      @UI.identification: [{ position: 60, label: '31 to 60 Current AMT' }]
      bt_31_60_amt    : abap.dec(16,2);

      @UI.lineItem    : [{ position: 70, label: '61 to 90 QTY' }]
      @UI.identification: [{ position: 70, label: '61 to 90 QTY' }]
      bt_61_90        : abap.char(20);

      @UI.lineItem    : [{ position: 80, label: '61 to 90 Current AMT' }]
      @UI.identification: [{ position: 80, label: '61 to 90 Current AMT' }]
      bt_61_90_amt    : abap.dec(16,2);

      @UI.lineItem    : [{ position: 90, label: '91 to 180 QTY' }]
      @UI.identification: [{ position: 90, label: '91 to 180 QTY' }]
      bt_91_180       : abap.char(20);

      @UI.lineItem    : [{ position: 100, label: '91 to 180 Current AMT' }]
      @UI.identification: [{ position: 100, label: '91 to 180 Current AMT' }]
      bt_91_180_amt   : abap.dec(16,2);

      @UI.lineItem    : [{ position: 110, label: '181 to 365 QTY' }]
      @UI.identification: [{ position: 110, label: '181 to 365 QTY' }]
      bt_181_365      : abap.char(20);

      @UI.lineItem    : [{ position: 120, label: '181 to 365 Current AMT' }]
      @UI.identification: [{ position: 120, label: '181 to 365 Current AMT' }]
      bt_181_365_amt  : abap.dec(16,2);

      @UI.lineItem    : [{ position: 130, label: '>365 QTY' }]
      @UI.identification: [{ position: 130, label: '>365 QTY' }]
      gt_365          : abap.char(20);

      @UI.lineItem    : [{ position: 140, label: '>365 Current AMT' }]
      @UI.identification: [{ position: 140, label: '>365 Current AMT' }]
      gt_365_amt      : abap.dec(16,2);

}
