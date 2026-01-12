@EndUserText.label: 'Customer Aging Report'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_CUSTOMER_AGING_REPORT'
    }
}

@UI: {
  headerInfo: {
    typeName: 'Customer Aging Report',
    typeNamePlural: 'Customer Aging Report',
    title: { value: 'Customer' },
    description: { value: 'customer' }
  }
}
define custom entity ZCD_CUSTOMER_AGING_REPORT

{
      @UI.facet                   : [
                             {
                               id :  'Customer_aging_report',
                               purpose    :  #STANDARD,
                               type       :  #IDENTIFICATION_REFERENCE,
                               label      :  'Customer Aging Report',
                               position   : 10 }
                           ]

      @UI.lineItem                : [{ position:40, label: 'Customer' }]
      @UI.identification          : [{ position:40, label: 'Customer' }]
      @UI.selectionField          : [{ position: 20 }]
      @EndUserText.label          : 'Customer'
  key customer                    : lifnr;

      @UI.lineItem                : [{ position:50, label: 'Customer Name' }]
      @UI.identification          : [{ position:50, label: 'Customer Name' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Customer Name'
  key customername                : abap.char( 100 );

      @UI.lineItem                : [{ position:170, label:'Amount In Company Code Currency' }]
      @UI.identification          : [{ position:170, label:'Amount In Company Code Currency' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Amount In Company Code Currency'
      amountincompanycodecurrency : abap.dec( 16, 2 );

      @UI.lineItem                : [{ position:180, label:'Company Code Currency' }]
      @UI.identification          : [{ position:180, label:'Company Code Currency' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Company Code Currency'
      companycodecurrency         : abap.char( 10 );


      @UI.lineItem                : [{ position:210, label:'Total Amount' }]
      @UI.identification          : [{ position:210, label:'Total Amount' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Total Amount'
      totalamount                 : abap.dec( 16, 2 );

      @UI.lineItem                : [{ position:220, label:'No Due' }]
      @UI.identification          : [{ position:220, label:'No Due' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'No Due'
      futureamount                : abap.dec( 16, 2 );


      @UI.lineItem                : [{ position:230, label:'Overdue Amount' }]
      @UI.identification          : [{ position:230, label:'Overdue Amount' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'Overdue Amount'
      overdueamount               : abap.dec( 16, 2 );


      @UI.lineItem                : [{ position:240, label:'O/S 0-30 Days' }]
      @UI.identification          : [{ position:240, label:'O/S 0-30 Days' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'O/S 0-30 Days'
      amt1stdueperiod             : abap.dec( 16, 2 );


      @UI.lineItem                : [{ position:250, label:'O/S 31-60 Days' }]
      @UI.identification          : [{ position:250, label:'O/S 31-60 Days' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'O/S 31-60 Days'
      amt2nddueperiod             : abap.dec( 16, 2 );


      @UI.lineItem                : [{ position:260, label:'O/S 61-90 Days' }]
      @UI.identification          : [{ position:260, label:'O/S 61-90 Days' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'O/S 61-90 Days'
      amt3rddueperiod             : abap.dec( 16, 2 );


      @UI.lineItem                : [{ position:270, label:'O/S 91-120 Days' }]
      @UI.identification          : [{ position:270, label:'O/S 91-120 Days' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'O/S 91-120 Days'
      amt4thdueperiod             : abap.dec( 16, 2 );


      @UI.lineItem                : [{ position:280, label:'O/S 121-150 Days' }]
      @UI.identification          : [{ position:280, label:'O/S 121-150 Days' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'O/S 121-150 Days'
      amt5thdueperiod             : abap.dec( 16, 2 );

      @UI.lineItem                : [{ position:290, label:'O/S 151-180 Days' }]
      @UI.identification          : [{ position:290, label:'O/S 151-180 Days' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'O/S 151-180 Days'
      amt6thdueperiod             : abap.dec( 16, 2 );

      @UI.lineItem                : [{ position:300, label:'O/S 181-365 Days' }]
      @UI.identification          : [{ position:300, label:'O/S 181-365 Days' }]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'O/S 181-365 Days'
      amt7thdueperiod             : abap.dec( 16, 2 );

      @UI.lineItem                : [{ position:310, label:'O/S >365'}]
      @UI.identification          : [{ position:310, label:'O/S >365'}]
      @Consumption.filter.hidden  : true
      @EndUserText.label          : 'O/S >365'
      amt8thdueperiod             : abap.dec( 16, 2 );


      @UI.selectionField          : [{ position:10 }]
      @Consumption.filter.mandatory:true
      @EndUserText.label          : 'Key_Date'
      @Consumption.filter.selectionType: #SINGLE
      date1                       : abap.dats;

}
