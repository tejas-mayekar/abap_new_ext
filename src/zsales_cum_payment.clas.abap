CLASS zsales_cum_payment DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.

    INTERFACES if_rap_query_provider.

    TYPES: BEGIN OF it_salesdata,

             soldtoparty                 TYPE i_billingdocumentbasic-soldtoparty,
             customername                TYPE i_customer-customername,
             glaccount                   TYPE i_operationalacctgdocitem-glaccount,
             profitcenter                TYPE i_journalentryitem-profitcenter,
             clearingaccountingdocument  TYPE i_operationalacctgdocitem-clearingaccountingdocument,
             accountingdocument          TYPE i_billingdocumentbasic-accountingdocument,
             postingdate                 TYPE i_operationalacctgdocitem-postingdate,
             billingdocumentdate         TYPE i_billingdocumentbasic-billingdocumentdate,
             billingdocument             TYPE i_billingdocumentbasic-billingdocument,
             totalnetamount              TYPE i_billingdocumentbasic-totalnetamount,
             totaltaxamount              TYPE i_billingdocumentbasic-totaltaxamount,
             fiscalyear                  TYPE i_billingdocumentbasic-fiscalyear,
             amountintransactioncurrency TYPE i_operationalacctgdocitem-amountintransactioncurrency,
             accountingdocumenttype      TYPE i_operationalacctgdocitem-accountingdocumenttype,
             documentdate                TYPE i_operationalacctgdocitem-documentdate,
             documentreferenceid         TYPE i_billingdocumentbasic-documentreferenceid,
             invoicereference            TYPE i_operationalacctgdocitem-invoicereference,
             netamt                      TYPE string,
             accountingdocument1         TYPE string,
             postingdate1                TYPE dats,
             balnace                     TYPE string,

           END OF it_salesdata.

    DATA: gt_salesdata TYPE STANDARD TABLE OF it_salesdata.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZSALES_CUM_PAYMENT IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA : it_sales_data TYPE TABLE OF it_salesdata,
           lt_salesdata  TYPE TABLE OF it_salesdata,
           wa_salesdata  TYPE it_salesdata.
    DATA : totalnetandtax  TYPE string.

    DATA: lr_customer         TYPE RANGE OF i_billingdocumentbasic-soldtoparty,
          lr_billdoc          TYPE RANGE OF i_billingdocumentbasic-billingdocument,
          lr_profitcenter     TYPE RANGE OF i_journalentryitem-ProfitCenter,
          lr_billingDocDate   TYPE RANGE OF i_billingdocumentbasic-BillingDocumentDate.

    DATA : balnace      TYPE string.


    CONSTANTS: lc_customer      TYPE string VALUE 'SOLDTOPARTY',
               lc_billingdoc    TYPE string VALUE 'BILLINGDOCUMENT',
               lc_profitcenter  TYPE string VALUE 'PROFITCENTER',
               lc_billingDocDate    TYPE string VALUE 'BILLINGDOCUMENTDATE'.

    TRY.

        DATA(lv_top) = io_request->get_paging(  )->get_page_size(  ).
        IF lv_top <= 0.
          lv_top = 1 .
        ENDIF.

        DATA(lv_skip) = io_request->get_paging(  )->get_offset(  ).

        DATA(lt_filters) = io_request->get_filter(  )->get_as_ranges(  ).
        IF lt_filters IS NOT INITIAL.
          LOOP AT lt_filters INTO DATA(lw_filters).
            CASE lw_filters-name.
              WHEN lc_customer.
                lr_customer = CORRESPONDING #( lw_filters-range ).
                LOOP AT lr_customer ASSIGNING FIELD-SYMBOL(<lfs_customer>).
                  <lfs_customer>-low = |{ <lfs_customer>-low ALPHA = IN }|.
                ENDLOOP.
              WHEN lc_billingdoc.
                lr_billdoc = CORRESPONDING #( lw_filters-range ).
              WHEN lc_profitcenter.
                   lr_profitcenter = CORRESPONDING #( lw_filters-range ).
              WHEN lc_billingDocDate.
                 lr_billingdocdate = CORRESPONDING #( lw_filters-range ).
            ENDCASE.
          ENDLOOP.
        ENDIF.



        SELECT a~soldtoparty,
               a~accountingdocument,
               a~billingdocumentdate,
               a~billingdocument,
               a~totalnetamount,
               a~totaltaxamount,
               a~fiscalyear,
               b~customername,
               c~amountintransactioncurrency,
               c~glaccount,
               c~clearingaccountingdocument,
               c~postingdate,
               c~invoicereference,
               d~profitcenter
        FROM i_billingdocumentbasic AS a
        LEFT OUTER JOIN i_customer AS b
        ON  a~soldtoparty = b~customer
        LEFT OUTER JOIN i_operationalacctgdocitem AS c
        ON a~accountingdocument = c~accountingdocument
        AND a~fiscalyear  = c~fiscalyear
        AND a~companycode  = c~companycode
        AND c~financialaccounttype = 'D'
        LEFT OUTER JOIN i_journalentryitem AS d
        ON a~accountingdocument = d~accountingdocument
        AND a~fiscalyear    = d~fiscalyear
        AND a~companycode = d~companycode
        AND d~financialaccounttype = 'D'
        WHERE soldtoparty IN @lr_customer
        AND a~billingdocument IN @lr_billdoc
        AND d~ProfitCenter IN @lr_profitcenter
        AND a~BillingDocumentDate IN @lr_billingdocdate
        INTO CORRESPONDING FIELDS OF TABLE @lt_salesdata.
        SORT lt_salesdata ASCENDING BY accountingdocument.
        DELETE ADJACENT DUPLICATES FROM lt_salesdata COMPARING accountingdocument.

        SELECT a~accountingdocument,
               a~amountintransactioncurrency,
               a~accountingdocumenttype,
               a~clearingaccountingdocument,
               a~postingdate,
               a~invoicereference,
               a~documentdate,
               c~documentreferenceid
        FROM i_operationalacctgdocitem AS a
        LEFT OUTER JOIN i_billingdocumentbasic AS b
        ON a~invoicereference = b~accountingdocument
        LEFT OUTER JOIN i_journalentry AS c
         ON a~accountingdocument = c~accountingdocument
         AND a~fiscalyear  = c~fiscalyear
         AND a~companycode  = c~companycode
        FOR ALL ENTRIES IN @lt_salesdata
        WHERE a~invoicereference EQ @lt_salesdata-accountingdocument
        AND a~fiscalyear EQ @lt_salesdata-fiscalyear
        INTO TABLE @DATA(lt_invoice).
        SORT lt_invoice ASCENDING BY accountingdocument.
        DELETE ADJACENT DUPLICATES FROM lt_invoice COMPARING accountingdocument invoicereference clearingaccountingdocument.


        SELECT a~accountingdocument,
               a~amountintransactioncurrency,
               a~accountingdocumenttype,
               a~postingdate,
               a~invoicereference,
               a~documentdate,
               a~financialaccounttype,
               c~documentreferenceid
        FROM i_operationalacctgdocitem AS a
        LEFT OUTER JOIN i_journalentry AS c
         ON a~accountingdocument = c~accountingdocument
         AND a~fiscalyear  = c~fiscalyear
         AND a~companycode  = c~companycode
        FOR ALL ENTRIES IN @lt_salesdata
        WHERE a~accountingdocument EQ @lt_salesdata-clearingaccountingdocument
        AND a~fiscalyear EQ @lt_salesdata-fiscalyear
        AND   a~accountingdocumenttype = 'DZ'
        AND   a~financialaccounttype = 'D'
        INTO TABLE @DATA(lt_clearingdata).
        SORT lt_clearingdata ASCENDING BY accountingdocument.
        DELETE ADJACENT DUPLICATES FROM lt_clearingdata COMPARING accountingdocument invoicereference.


        DATA: lv_tabix       TYPE sy-tabix,
              balance_amount TYPE i_operationalacctgdocitem-amountintransactioncurrency.

        SORT lt_invoice STABLE ASCENDING BY invoicereference.
        SORT lt_clearingdata STABLE ASCENDING BY accountingdocument.


        LOOP AT lt_salesdata ASSIGNING FIELD-SYMBOL(<ls_sales>).
          CLEAR:balance_amount,lv_tabix.

          APPEND VALUE #(
            soldtoparty                = <ls_sales>-soldtoparty
            customername               = <ls_sales>-customername
            glaccount                  = <ls_sales>-glaccount
            profitcenter               = <ls_sales>-profitcenter
            clearingaccountingdocument = <ls_sales>-clearingaccountingdocument
            accountingdocument         = <ls_sales>-accountingdocument
            postingdate                = <ls_sales>-postingdate
            billingdocumentdate        = <ls_sales>-billingdocumentdate
            billingdocument            = <ls_sales>-billingdocument
            totalnetamount             = <ls_sales>-totalnetamount
            totaltaxamount             = <ls_sales>-totaltaxamount
            fiscalyear                 = <ls_sales>-fiscalyear
*            amountintransactioncurrency = <ls_sales>-amountintransactioncurrency
            invoicereference            = <ls_sales>-invoicereference
            accountingdocumenttype     = ''  " Not available here
            documentdate               = ''  " Not available here
            documentreferenceid        = ''  " Not available here
            netamt                     = <ls_sales>-totalnetamount + <ls_sales>-totaltaxamount
            balnace                    = <ls_sales>-amountintransactioncurrency
          ) TO it_sales_data.

          balance_amount = <ls_sales>-amountintransactioncurrency.

          READ TABLE lt_invoice TRANSPORTING NO FIELDS WITH KEY invoicereference = <ls_sales>-accountingdocument BINARY SEARCH.
          IF sy-subrc IS INITIAL.

            lv_tabix = sy-tabix.

            LOOP AT lt_invoice ASSIGNING FIELD-SYMBOL(<lfs_invoice>) FROM lv_tabix.                 " WHERE InvoiceReference = <ls_sales>-accountingdocument.


              IF <lfs_invoice>-invoicereference = <ls_sales>-accountingdocument.

                balance_amount += <lfs_invoice>-amountintransactioncurrency.
                APPEND VALUE #(
                                accountingdocument1           = <lfs_invoice>-accountingdocument
                                amountintransactioncurrency   = <lfs_invoice>-amountintransactioncurrency
                                accountingdocumenttype        = <lfs_invoice>-accountingdocumenttype
                                postingdate1                  = <lfs_invoice>-postingdate
                                documentdate                  = <lfs_invoice>-documentdate
                                documentreferenceid           = <lfs_invoice>-documentreferenceid
                                netamt                        = '' " Not applicable for invoice
                                invoicereference              = <lfs_invoice>-invoicereference
                                balnace                       = balance_amount
             ) TO it_sales_data.
              ELSE.
                EXIT.
              ENDIF.

            ENDLOOP.
          ENDIF.


          CLEAR lv_tabix.
          READ TABLE lt_clearingdata TRANSPORTING NO FIELDS WITH KEY accountingdocument = <ls_sales>-clearingaccountingdocument BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            lv_tabix = sy-tabix.

            LOOP AT lt_clearingdata ASSIGNING FIELD-SYMBOL(<ls_clear>) FROM lv_tabix. "WHERE AccountingDocument = <ls_sales>-clearingaccountingdocument.

              IF <ls_clear>-accountingdocument = <ls_sales>-clearingaccountingdocument.

                balance_amount += <ls_clear>-amountintransactioncurrency.
                APPEND VALUE #(
                accountingdocument1              = <ls_clear>-accountingdocument
                amountintransactioncurrency      = <ls_clear>-amountintransactioncurrency
                accountingdocumenttype           = <ls_clear>-accountingdocumenttype
                postingdate1                     = <ls_clear>-postingdate
                documentdate                     = <ls_clear>-documentdate
                documentreferenceid              = <ls_clear>-documentreferenceid
                invoicereference                 = <ls_clear>-invoicereference
                netamt                           = ''  " Not applicable for clearing
                balnace                          = balance_amount
              ) TO it_sales_data.
              ELSE.
                EXIT.
              ENDIF.
            ENDLOOP.

          ENDIF.
        ENDLOOP.



        IF io_request->is_total_numb_of_rec_requested(  ).
          io_response->set_total_number_of_records( lines( it_sales_data ) ).
        ENDIF.


        DATA(lv_start) = lv_skip + 1.
        DATA(lv_end) = lv_skip + lv_top.


        IF lv_end > lines( it_sales_data ).
          lv_end = lines( it_sales_data ).
        ENDIF.

        APPEND LINES OF it_sales_data FROM lv_start TO lv_end TO gt_salesdata.

        io_response->set_data( gt_salesdata ).
        CLEAR: it_sales_data.
      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).

    ENDTRY.
  ENDMETHOD.
ENDCLASS.
