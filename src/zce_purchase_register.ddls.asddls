@EndUserText.label: 'Purchase Register'

@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_PURCHASE_REGISTER'
    }
}

@UI: {
  headerInfo: {
    typeName: 'Purchase Register',
    typeNamePlural: 'Purchase Register',
    title: { value: 'journalentry' },
    description: { value: 'accountingdocument' }
  }
}

define custom entity ZCE_PURCHASE_REGISTER
{

      @UI.facet                   : [
                     {
                       id         :  'PurchaseRegister',
                       purpose    :  #STANDARD,
                       type       :  #IDENTIFICATION_REFERENCE,
                       label      :  'Purchase Register',
                       position   : 10 }
                   ]

      @UI.lineItem                : [{ position: 210, label: 'PO Number' }]
      @UI.identification          : [{ position: 210, label: 'PO Number' }]
  key purchaseorder               : ebeln;

      @UI.lineItem                : [{ position: 220, label: 'PO Item No' }]
      @UI.identification          : [{ position: 220, label: 'PO Item No' }]
  key purchaseorderitem           : ebelp;

      @UI.lineItem                : [{ position: 160, label: 'Material Code' }]
      @UI.identification          : [{ position: 160, label: 'Material Code' }]
  key material                    : matnr;

      @UI.lineItem                : [{ position: 510, label: 'MIGO Doc. No' }]
      @UI.identification          : [{ position: 510, label: 'MIGO Doc. No' }]
  key materialdocument            : mblnr;

      @UI.selectionField          : [{ position: 30 }]
      @UI.lineItem                : [{ position: 60, label: 'Journal Entry' }]
      @UI.identification          : [{ position: 60, label: 'Journal Entry' }]
  key journalentry                : belnr_d;

      @UI.lineItem                : [{ position: 270, label: 'RE GL Code' }]
      @UI.identification          : [{ position: 270, label: 'RE GL Code' }]
  key glaccount                   : hkont;

      @UI.lineItem                : [{ position: 640, label: 'TAX Item Group' }]
      @UI.identification          : [{ position: 640, label: 'TAX Item Group' }]
  key taxitemgroup                : sgtxt;

      @UI.lineItem                : [{ position: 70, label: 'Reversal Ref.' }]
      @UI.identification          : [{ position: 70, label: 'Reversal Ref.' }]
      reversalreference           : belnr_d;

      @UI.lineItem                : [{ position: 10, label: 'Profit Center' }]
      @UI.identification          : [{ position: 10, label: 'Profit Center' }]
      profitcenter                : prctr;

      @UI.lineItem                : [{ position: 20, label: 'Business Place' }]
      @UI.identification          : [{ position: 20, label: 'Business Place' }]
      businessplace               : bupla;

      @UI.lineItem                : [{ position: 30, label: 'Document Type' }]
      @UI.identification          : [{ position: 30, label: 'Document Type' }]
      documenttype                : blart;

      @UI.selectionField          : [{ position: 10 }]
      @UI.lineItem                : [{ position: 40, label: 'MIRO No' }]
      @UI.identification          : [{ position: 40, label: 'MIRO No' }]
      accountingdocument          : mblnr;

      @UI.selectionField          : [{ position: 20 }]
      @UI.lineItem                : [{ position: 50, label: 'Posting Date' }]
      @UI.identification          : [{ position: 50, label: 'Posting Date' }]
      @Consumption.filter.mandatory:true
      postingdate                 : budat;

      @UI.lineItem                : [{ position: 80, label: 'Ref Doc No' }]
      @UI.identification          : [{ position: 80, label: 'Ref Doc No' }]
      refdocno                    : xblnr1;

      @UI.lineItem                : [{ position: 90, label: 'Invoice Date' }]
      @UI.identification          : [{ position: 90, label: 'Invoice Date' }]
      documentdate                : bldat;

      @UI.lineItem                : [{ position: 100, label: 'Vendor' }]
      @UI.identification          : [{ position: 100, label: 'Vendor' }]
      supplier                    : lifnr;

      @UI.lineItem                : [{ position: 110, label: 'Vendor Name' }]
      @UI.identification          : [{ position: 110, label: 'Vendor Name' }]
      suppliername                : abap.char( 80 );

      @UI.lineItem                : [{ position: 120, label: 'Vendor Region' }]
      @UI.identification          : [{ position: 120, label: 'Vendor Region' }]
      supplieregion               : regio;

      @UI.lineItem                : [{ position: 130, label: 'Vendor State' }]
      @UI.identification          : [{ position: 130, label: 'Vendor State' }]
      supplierstate               : regio;

      @UI.lineItem                : [{ position: 140, label: 'GSTIN' }]
      @UI.identification          : [{ position: 140, label: 'GSTIN' }]
      suppliergstin               : abap.char( 18 );

      @UI.lineItem                : [{ position: 150, label: 'Vendor PAN No' }]
      @UI.identification          : [{ position: 150, label: 'Vendor PAN No' }]
      supplierpanno               : abap.char( 40 );

      @UI.lineItem                : [{ position: 170, label: 'Material Description' }]
      @UI.identification          : [{ position: 170, label: 'Material Description' }]
      materialdescription         : abap.char( 40 );

      @UI.lineItem                : [{ position: 180, label: 'UoM' }]
      @UI.identification          : [{ position: 180, label: 'UoM' }]
      unitofmeasure               : meins;

      @UI.lineItem                : [{ position: 190, label: 'HSN Code' }]
      @UI.identification          : [{ position: 190, label: 'HSN Code' }]
      hsncode                     : abap.char( 16 );

      @UI.lineItem                : [{ position: 200, label: 'PO Date' }]
      @UI.identification          : [{ position: 200, label: 'PO Date' }]
      purchaseorderdate           : bldat;

      @UI.lineItem                : [{ position: 230, label: 'PO Quantity' }]
      @UI.identification          : [{ position: 230, label: 'PO Quantity' }]
      @Semantics.quantity.unitOfMeasure: 'unitofmeasure'
      purchaseorderqty            : menge_d;

      @UI.lineItem                : [{ position: 240, label: 'Bill Quantity' }]
      @UI.identification          : [{ position: 240, label: 'Bill Quantity' }]
      @Semantics.quantity.unitOfMeasure: 'materialbaseunit'
      grnquantity                 : menge_d;

      @Semantics.unitOfMeasure    : true
      materialbaseunit            : meins;

      @Semantics.currencyCode     : true
      transactioncurrency         : abap.cuky( 5 );

      @UI.lineItem                : [{ position: 250, label: 'Document Currency' }]
      @UI.identification          : [{ position: 250, label: 'Document Currency' }]
      @Semantics.amount.currencyCode: 'transactioncurrency'
      amountintransactioncurrency : abap.curr( 23, 2 );


      @UI.lineItem                : [{ position: 260, label: 'Local Currency' }]
      @UI.identification          : [{ position: 260, label: 'Local Currency' }]
      amountincompanycodecurrency : abap.curr( 23, 2 );

      @UI.lineItem                : [{ position: 280, label: 'GL Description' }]
      @UI.identification          : [{ position: 280, label: 'GL Description' }]
      glaccountname               : abap.char( 20 );

      @UI.lineItem                : [{ position: 290, label: 'CGST GL Code' }]
      @UI.identification          : [{ position: 290, label: 'CGST GL Code' }]
      cgstglaccount               : hkont;

      @UI.lineItem                : [{ position: 300, label: 'SGST GL Code' }]
      @UI.identification          : [{ position: 300, label: 'SGST GL Code' }]
      sgstglaccount               : hkont;

      @UI.lineItem                : [{ position: 310, label: 'IGST GL Code' }]
      @UI.identification          : [{ position: 310, label: 'IGST GL Code' }]
      igstglaccount               : hkont;

      @UI.lineItem                : [{ position: 320, label: 'Tax Code' }]
      @UI.identification          : [{ position: 320, label: 'Tax Code' }]
      taxcode                     : mwskz;

      @UI.lineItem                : [{ position: 330, label: 'Base Amount' }]
      @UI.identification          : [{ position: 330, label: 'Base Amount' }]
      @Semantics.amount.currencyCode: 'transactioncurrency'
      baseamount                  : abap.curr( 23, 2 );

      @UI.lineItem                : [{ position: 340, label: 'Taxable Amount' }]
      @UI.identification          : [{ position: 340, label: 'Taxable Amount' }]
      @Semantics.amount.currencyCode: 'transactioncurrency'
      taxableamount               : abap.curr( 23, 2 );

      @UI.lineItem                : [{ position: 350, label: 'CGST %' }]
      @UI.identification          : [{ position: 350, label: 'CGST %' }]
      cgstrate                    : abap.curr( 23, 2 );

      @UI.lineItem                : [{ position: 360, label: 'CGST Amount' }]
      @UI.identification          : [{ position: 360, label: 'CGST Amount' }]
      cgstamount                  : abap.curr( 23, 2 );

      @UI.lineItem                : [{ position: 370, label: 'SGST %' }]
      @UI.identification          : [{ position: 370, label: 'SGST %' }]
      sgstrate                    : abap.curr( 23, 2 );

      @UI.lineItem                : [{ position: 380, label: 'SGST Amount' }]
      @UI.identification          : [{ position: 380, label: 'SGST Amount' }]
      sgstamount                  : abap.curr( 23, 2 );

      @UI.lineItem                : [{ position: 390, label: 'IGST %' }]
      @UI.identification          : [{ position: 390, label: 'IGST %' }]
      igstrate                    : abap.curr( 23, 2 );

      @UI.lineItem                : [{ position: 400, label: 'IGST Amount' }]
      @UI.identification          : [{ position: 400, label: 'IGST Amount' }]
      igstamount                  : abap.curr( 23, 2 );

      @UI.lineItem                : [{ position: 410, label: 'RCM CGST %' }]
      @UI.identification          : [{ position: 410, label: 'RCM CGST %' }]
      rcmcgstrate                 : abap.curr( 23, 2 );

      @UI.lineItem                : [{ position: 420, label: 'RCM CGST Amount' }]
      @UI.identification          : [{ position: 420, label: 'RCM CGST Amount' }]
      rcmcgstamount               : abap.curr( 23, 2 );

      @UI.lineItem                : [{ position: 430, label: 'RCM SGST %' }]
      @UI.identification          : [{ position: 430, label: 'RCM SGST %' }]
      rcmsgstrate                 : abap.curr( 23, 2 );

      @UI.lineItem                : [{ position: 440, label: 'RCM SGST Amount' }]
      @UI.identification          : [{ position: 440, label: 'RCM SGST Amount' }]
      rcmsgstamount               : abap.curr( 23, 2 );

      @UI.lineItem                : [{ position: 450, label: 'RCM IGST %' }]
      @UI.identification          : [{ position: 450, label: 'RCM IGST %' }]
      rcmigstrate                 : abap.curr( 23, 2 );

      @UI.lineItem                : [{ position: 460, label: 'RCM IGST Amount' }]
      @UI.identification          : [{ position: 460, label: 'RCM IGST Amount' }]
      rcmigstamount               : abap.curr( 23, 2 );

      @UI.lineItem                : [{ position: 470, label: 'TDS' }]
      @UI.identification          : [{ position: 470, label: 'TDS' }]
      withhldtaxamount            : abap.curr( 23, 2 );

      @UI.lineItem                : [{ position: 480, label: 'Net Invoice Amount' }]
      @UI.identification          : [{ position: 480, label: 'Net Invoice Amount' }]
      netinvoiceamount            : abap.curr( 23, 2 );

      @UI.lineItem                : [{ position: 490, label: 'Total Tax Amount' }]
      @UI.identification          : [{ position: 490, label: 'Total Tax Amount' }]
      totaltaxamount              : abap.curr( 23, 2 );

      @UI.lineItem                : [{ position: 500, label: 'TDS Tax Code' }]
      @UI.identification          : [{ position: 500, label: 'TDS Tax Code' }]
      withhldtaxcode              : abap.char( 2 );

      //      @UI.lineItem                : [{ position: 520, label: 'Text/Narration' }]
      //      @UI.identification          : [{ position: 520, label: 'Text/Narration' }]
      //      narration                   : sgtxt;

      @UI.lineItem                : [{ position: 530, label: 'Assignment' }]
      @UI.identification          : [{ position: 530, label: 'Assignment' }]
      assignment                  : dzuonr;

      @UI.lineItem                : [{ position: 540, label: 'WE Doc No' }]
      @UI.identification          : [{ position: 540, label: 'WE Doc No' }]
      wedocno                     : belnr_d;

      @UI.lineItem                : [{ position: 550, label: 'we posting date' }]
      @UI.identification          : [{ position: 550, label: 'we posting date' }]
      wepostingdt                 : budat;

      @UI.lineItem                : [{ position: 560, label: 'GRN Date document date' }]
      @UI.identification          : [{ position: 560, label: 'GRN Date document date' }]
      grndocumentdt               : budat;

      @UI.lineItem                : [{ position: 570, label: 'GRN Ref No.( delivery  note )' }]
      @UI.identification          : [{ position: 570, label: 'GRN Ref No.( delivery  note )' }]
      grnrefno                    : xblnr;

      //      @UI.lineItem                : [{ position: 580, label: 'GRN HSN Code( mm_hsn code in MIGO )' }]
      //      @UI.identification          : [{ position: 580, label: 'GRN HSN Code( mm_hsn code in MIGO )' }]
      //      grnhsncode                  : abap.char( 24 );

      @UI.lineItem                : [{ position: 590, label: 'Purchase Group' }]
      @UI.identification          : [{ position: 590, label: 'Purchase Group' }]
      purchasegrp                 : ekgrp;

      @UI.lineItem                : [{ position: 600, label: 'WE GL Code' }]
      @UI.identification          : [{ position: 600, label: 'WE GL Code' }]
      weglcode                    : hkont;

      @UI.lineItem                : [{ position: 610, label: 'WBS Elements' }]
      @UI.identification          : [{ position: 610, label: 'WBS Elements' }]
      wbselement                  : abap.char( 24 );

      @UI.lineItem                : [{ position: 630, label: 'Document Item text' }]
      @UI.identification          : [{ position: 630, label: 'Document Item text' }]
      documentitemText            : sgtxt;

      @UI.lineItem                : [{ position: 650, label: 'Investment Profile' }]
      @UI.identification          : [{ position: 650, label: 'Investment Profile' }]
      investmentprofile           : abap.char( 24 );

      @UI.lineItem                : [{ position: 660, label: 'Narration from Header Data' }]
      @UI.identification          : [{ position: 660, label: 'Narration from Header Data' }]
      narrationheaderdata         : abap.char( 24 );

      @UI.lineItem                : [{ position: 670, label: 'KR HSN Code ' }]
      @UI.identification          : [{ position: 670, label: 'KR HSN Code ' }]
      krhsncode                   : abap.char( 24 );

      @UI.lineItem                : [{ position: 680, label: 'ACU_ID' }]
      @UI.identification          : [{ position: 680, label: 'ACU_ID' }]
      @UI.selectionField          : [{ position: 40 }]
      @Consumption.filter.mandatory:true
      FiscalYear                  : abap.numc( 4 );

}
