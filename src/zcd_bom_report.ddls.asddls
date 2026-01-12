@EndUserText.label: 'Hexa Biochem BOM Report'

@ObjectModel: {
query: {
       implementedBy: 'ABAP:ZCL_BOM_REPORT'
    }
}

@UI: {
    headerInfo: {
        typeName : 'Hexa Biochem BOM Report',
        title: { value : 'billofmaterial' },
        description: { value: 'material'}
    }
}

define custom entity ZCD_BOM_REPORT
{

      @UI.facet                   : [
                                 {
                                   id   :  'BOMReport',
                                   purpose    :  #STANDARD,
                                   type :  #IDENTIFICATION_REFERENCE,
                                   label:  'BOM Report',
                                   position   : 10 }
                               ]

      @UI.lineItem                : [{ position: 10, label: 'Plant' }]
      @UI.identification          : [{ position: 10, label: 'Plant' }]
      @UI.selectionField          : [{ position: 20 }]
      @Consumption.filter.mandatory:true
  key plant                       : werks_d;


      @EndUserText.label          : 'Material'
      @UI.lineItem                : [{ position: 50, label: 'Header Material' }]
      @UI.identification          : [{ position: 50, label: 'Header Material' }]
      @UI.selectionField          : [{ position: 10 }]
      //      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_ProductStdVH', element: 'Product' } } ]
      //      @Consumption.filter.mandatory: true
  key material                    : matnr;


      @EndUserText.label          : 'Alternative BOM'
      @UI.lineItem                : [{ position: 30, label: 'Alternative BOM' }]
      @UI.identification          : [{ position: 30, label: 'Alternative BOM' }]
      @UI.selectionField          : [{ position: 30 }]
  key billofmaterialvariant       : abap.char(2);

      @EndUserText.label          : 'Bill of Material'
      @UI.lineItem                : [{ position: 40, label: 'Bill of Material' }]
      @UI.identification          : [{ position: 40, label: 'Bill of Material' }]
      @UI.selectionField          : [{ position: 40 }]
  key billofmaterial              : abap.char(8);


      @UI.lineItem                : [{ position: 110, label: 'Component' }]
      @UI.identification          : [{ position: 110, label: 'Component' }]
  key billofmaterialcomponent     : abap.char(40);

      @UI.lineItem                : [{ position: 20, label: 'BOM Usage' }]
      @UI.identification          : [{ position: 20, label: 'BOM Usage' }]
      billofmaterialvariantusage  : abap.char(1);


      @UI.lineItem                : [{ position: 60, label: 'Header Product Description' }]
      @UI.identification          : [{ position: 60, label: 'Header Product Description' }]
      productdescription          : abap.char(40);


      @UI.lineItem                : [{ position: 70, label: 'Base Quantity' }]
      @UI.identification          : [{ position: 70, label: 'Base Quantity' }]
//      @Semantics.quantity.unitOfMeasure: 'bomheaderbaseunit'
      bomheaderquantityinbaseunit : abap.dec(13,3);


      @UI.lineItem                : [{ position: 80, label: 'Base Unit of Measure' }]
      @UI.identification          : [{ position: 80, label: 'Base Unit of Measure' }]
      bomheaderbaseunit           : abap.unit(3);


      @UI.lineItem                : [{ position: 90, label: 'Item Number' }]
      @UI.identification          : [{ position: 90, label: 'Item Number' }]
      billofmaterialitemnumber    : abap.char(4);


      @UI.lineItem                : [{ position: 100, label: 'Item Category' }]
      @UI.identification          : [{ position: 100, label: 'Item Category' }]
      billofmaterialitemcategory  : postp;


      @UI.lineItem                : [{ position: 120, label: 'Component Description' }]
      @UI.identification          : [{ position: 120, label: 'Component Description' }]
      componentdescription        : abap.char(40);


      @UI.lineItem                : [{ position: 130, label: 'Component Quantity' }]
      @UI.identification          : [{ position: 130, label: 'Component Quantity' }]
//      @Semantics.quantity.unitOfMeasure: 'billofmaterialitemunit'
      billofmaterialitemquantity  : abap.dec(13, 3);


      @UI.lineItem                : [{ position: 140, label: 'Component UoM' }]
      @UI.identification          : [{ position: 140, label: 'Component UoM' }]
      billofmaterialitemunit      : abap.unit(3);


      @UI.lineItem                : [{ position: 150, label: 'Component Scrap(%)' }]
      @UI.identification          : [{ position: 150, label: 'Component Scrap(%)' }]
      componentscrapinpercent     : abap.dec( 5, 2 );



      @UI.lineItem                : [{ position: 160, label: 'Operation Scrap(%)' }]
      @UI.identification          : [{ position: 160, label: 'Operation Scrap(%)' }]
      operationscrapinpercent     : abap.dec( 5, 2 );


      @UI.lineItem                : [{ position: 170, label: 'Co-Product' }]
      @UI.identification          : [{ position: 170, label: 'Co-Product' }]
      materialiscoproduct         : abap.char(1);


      @UI.lineItem                : [{ position: 180, label: 'Created By' }]
      @UI.identification          : [{ position: 180, label: 'Created By' }]
      createdbyuser               : abap.char(12);


      @UI.lineItem                : [{ position: 190, label: 'User Changed By' }]
      @UI.identification          : [{ position: 190, label: 'User Changed By' }]
      lastchangedbyuser           : abap.char(12);


      @UI.lineItem                : [{ position: 200, label: 'BOM Status' }]
      @UI.identification          : [{ position: 200, label: 'BOM Status' }]
      billofmaterialstatus        : abap.char( 10 );
}
