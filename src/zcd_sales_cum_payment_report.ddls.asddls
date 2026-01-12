@EndUserText.label: 'Sales Cum Payment Report'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZSALES_CUM_PAYMENT'
    }
}

@UI: {
  headerInfo: {
    typeName: 'Sales Cum Payment Report',
    typeNamePlural: 'Sales Cum Payment Report',
    title: { value: 'soldtoparty' },
    description: { value: 'soldtoparty' }
  }
}

define custom entity ZCD_SALES_CUM_PAYMENT_REPORT
{
      @UI.facet                   : [
                           {
                             id   :  'Sales_cum_payment',
                             purpose    :  #STANDARD,
                             type :  #IDENTIFICATION_REFERENCE,
                             label:  'Sales Cum Payment Report',
                             position   : 10 }
                         ]

      @UI.lineItem                : [{ position:10, label: 'Party Code' }]
      @UI.identification          : [{ position:10, label: 'Party Code' }]
      @UI.selectionField          : [{ position: 10 }]
      @EndUserText.label          : 'Party Code'
  key soldtoparty                 : abap.char( 15 );
  
   @UI.lineItem                : [{ position:130, label:'Doc No' }]
      @UI.identification          : [{ position: 130, label:'Doc No'}]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Doc No'
 key  accountingdocument1         : abap.char( 15 );
  


      @UI.lineItem                : [{ position: 60, label: 'Doc No' }]
      @UI.identification          : [{ position: 60, label: 'Doc No'  }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Doc No'
 key  accountingdocument          : abap.numc( 10 );


      @UI.lineItem                : [{ position: 20, label: 'Party' }]
      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 20, label: 'Party'  }]
      @EndUserText.label          : 'Party'
      customername                : abap.char(40);


      @UI.lineItem                : [{ position: 30, label: 'Account'  }]
      @UI.identification          : [{ position: 30, label: 'Account' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Account'
      glaccount                   : abap.char( 15 );


      @UI.lineItem                : [{ position: 40, label:'Sales Org' }]
      @UI.identification          : [{ position: 40, label: 'Sales Org' }]
      @EndUserText.label          : 'Sales Org'
      profitcenter                : abap.char( 10 );


      @UI.lineItem                : [{ position: 50, label: 'RV ClearingDocument' }]
      @UI.identification          : [{ position: 50, label: 'RV ClearingDocument' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'RV ClearingDocument'
      clearingaccountingdocument  : abap.numc( 10 );


      @UI.lineItem                : [{ position: 70, label: 'Doc Date' }]
      @UI.identification          : [{ position:70, label: 'Doc Date' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Doc Date'
      postingdate                 : abap.dats;


      @UI.lineItem                : [{ position: 80, label: 'Bill Date' }]
      @UI.identification          : [{ position:80, label:'Bill Date ' }]
//      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Bill Date'
      billingdocumentdate         : abap.dats;

      @UI.lineItem                : [{ position: 90, label: 'Bill No' }]
      @UI.identification          : [{ position: 90, label:'Bill No' }]
      @UI.selectionField          : [{ position: 20 }]
      @EndUserText.label          : 'Bill No'
      billingdocument             : abap.char( 15 );


      @UI.lineItem                : [{ position: 100, label: 'NET AMT' }]
      @UI.identification          : [{ position: 100, label: 'NET AMT' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'NET AMT'
      netamt                      : abap.dec( 10, 2 );

      @UI.lineItem                : [{ position: 110, label: 'Paid AMT' }]
      @UI.identification          : [{ position: 110, label: 'Paid AMT'}]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Paid AMT'
      amountintransactioncurrency : abap.dec( 10, 2 );

      @UI.lineItem                : [{ position: 120, label: 'Type' }]
      @UI.identification          : [{ position: 120, label: 'Type' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Type'
      accountingdocumenttype      : abap.char( 10 );


     

      @UI.lineItem                : [{ position:140, label:'CHQ No' }]
      @UI.identification          : [{ position: 140, label:'CHQ No' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'CHQ No'
      documentreferenceid         : abap.char( 50 );


      @UI.lineItem                : [{ position:150, label:'CHQ Date' }]
      @UI.identification          : [{ position:150, label: 'CHQ Date' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'CHQ Date'
      postingdate1                : abap.dats;

      @UI.lineItem                : [{ position:160, label:'Doc Date' }]
      @UI.identification          : [{ position:160, label:'Doc Date'}]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Doc Date'
      documentdate                : abap.dats;


      @UI.lineItem                : [{ position:170, label:'Balance' }]
      @UI.identification          : [{ position: 170, label:'Balance'}]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Balance'
      balnace                       : abap.dec( 10, 2 );


      @UI.hidden                  : true
      @Semantics.unitOfMeasure    : true
      unitofmeasure               : meins;


      @UI.hidden                  : true
      @Semantics.currencyCode     : true
      purordamountcrcy            : abap.cuky(5);



}
