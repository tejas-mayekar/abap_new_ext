@EndUserText.label: 'Supplier Aging Report.'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_SUPPLIER_AGING_REPORT'
    }
}

@UI: {
  headerInfo: {
    typeName: 'Supplier Aging Report',
    typeNamePlural: 'Supplier Aging Report',
    title: { value: 'Supplier' },
    description: { value: 'supplier' }
  }
}

define custom entity ZCD_SUPPLIER_AGING_REPORT

{
      @UI.facet                   : [
                           {
                             id   :  'supp_and_cust_aging_report',
                             purpose    :  #STANDARD,
                             type :  #IDENTIFICATION_REFERENCE,
                             label:  'Supplier Aging Report',
                             position   : 10 }
                         ]

      @UI.lineItem                : [{ position:40, label: 'Supplier' }]
      @UI.identification          : [{ position:40, label: 'Supplier' }]
      @UI.selectionField          : [{ position: 20 }]
      @EndUserText.label          : 'Supplier'
  key supplier                    : abap.char( 50 );

      @UI.lineItem                : [{ position:50, label: 'Supplier Name' }]
      @UI.identification          : [{ position: 50, label: 'Supplier Name' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Supplier Name'
  key suppliername                : abap.char( 50 );


      @UI.lineItem                : [{ position:160, label:'Company Code Currency' }]
      @UI.identification          : [{ position:160, label:'Company Code Currency' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Company Code Currency'
      @Semantics.currencyCode     : true
  key companycodecurrency         : abap.cuky( 5 );

      @UI.selectionField          : [{ position:10 }]
      @Consumption.filter.mandatory:true
      @Consumption.filter.selectionType: #SINGLE
      @EndUserText.label          : 'Key_Date'
      @UI.lineItem                : [{ hidden: true }]
      @UI.identification          : [{ hidden: true }]
      date1                       : abap.dats;


      @UI.lineItem                : [{ position:170, label:'Amount In Company Code Currency' }]
      @UI.identification          : [{ position:170, label:'Amount In Company Code Currency' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Amount In Company Code Currency'
      amountincompanycodecurrency : abap.curr( 23, 2 );


      @UI.lineItem                : [{ position:210, label:'Total' }]
      @UI.identification          : [{ position:210, label:'Total' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Total'
      total                       : abap.dec( 16, 2);

      @UI.lineItem                : [{ position:220, label:'No Due' }]
      @UI.identification          : [{ position:220, label:'No Due' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'No Due'
      futureamount                : abap.dec( 16, 2);


      @UI.lineItem                : [{ position:230, label:'Overdue Amount' }]
      @UI.identification          : [{ position:230, label:'Overdue Amount' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Overdue Amount'
      overdueamount               : abap.dec( 16, 2);


      @UI.lineItem                : [{ position:240, label:'O/s 0-30 Days' }]
      @UI.identification          : [{ position:240, label:'O/s 0-30 Days' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'O/s 0-30 Days'
      amt1stdueperiod             : abap.dec( 16, 2);


      @UI.lineItem                : [{ position:250, label:'O/s 31-60 Days' }]
      @UI.identification          : [{ position:250, label:'O/s 31-60 Days' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'O/s 31-60 Days'
      amt2stdueperiod             : abap.dec( 16, 2);


      @UI.lineItem                : [{ position:260, label:'O/s 61-90 Days' }]
      @UI.identification          : [{ position:260, label:'O/s 61-90 Days' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'O/s 61-90 Days'
      amt3stdueperiod             : abap.dec( 16, 2);


      @UI.lineItem                : [{ position:270, label:'O/s 91-120 Days' }]
      @UI.identification          : [{ position:270, label:'O/s 91-120 Days' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'O/s 91-120 Days'
      amt4stdueperiod             : abap.dec( 16, 2);


      @UI.lineItem                : [{ position:280, label:'O/s 121-150 Days' }]
      @UI.identification          : [{ position:280, label:'O/s 121-150 Days' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'O/s 121-150 Days'
      amt5stdueperiod             : abap.dec( 16, 2);



      @UI.lineItem                : [{ position:290, label:'O/s 151-180 Days' }]
      @UI.identification          : [{ position:290, label:'O/s 151-180 Days' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'O/s 151-180 Days'
      amT6stdueperiod             : abap.dec( 16, 2);

      @UI.lineItem                : [{ position:300, label:'O/s 181-365 Days' }]
      @UI.identification          : [{ position:300, label:'O/s 181-365 Days' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'O/s 181-365 Days'
      amt7stdueperiod             : abap.dec( 16, 2);

      @UI.lineItem                : [{ position:310, label:'O/s >365'}]
      @UI.identification          : [{ position:310, label:'O/s >365'}]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'O/s >365'
      amt8stdueperiod             : abap.dec( 16, 2);


      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'FutrAmt 1st Due Period 0-30 Days'
      futramt1thdueperd           : abap.dec( 16, 2);


      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'FutrAmt 2nd Due Perd days 31-60 Days'
      futramt2thdueperd           : abap.dec( 16, 2);



      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'FutrAmt 3rd Due Period 61-90 Days'
      futramt3thdueperd           : abap.dec( 16, 2);


      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'FutrAmt 4th Due Period 91-120 Days'
      futramt4thdueperd           : abap.dec( 16, 2);


      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'FutrAmt 5th Due Period 121-150 Days'
      futramt5thdueperd           : abap.dec( 16, 2);


      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'FutrAmt 6th Due Period 151-180 Days'
      futramt6thdueperd           : abap.dec( 16, 2);

      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'FutrAmt Last Due Period 181-365 Days'
      futramt7thdueperd           : abap.dec( 16, 2);



      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'FutrAmt Last Due Period >365'
      futramt8thdueperd           : abap.dec( 16, 2);

}
