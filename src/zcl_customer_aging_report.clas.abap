CLASS zcl_customer_aging_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider.

    " Define a structure for aging details
    TYPES : BEGIN OF ty_custaging,
              customer                    TYPE i_journalentryitem-customer,
              customername                TYPE i_customer-customername,
              companycodecurrency         TYPE i_journalentryitem-companycodecurrency,
              date1                       TYPE i_journalentryitem-netduedate,
              totalamount                 TYPE p LENGTH 16 DECIMALS 2,
              futureamount                TYPE p LENGTH 16 DECIMALS 2,
              overdueamount               TYPE p LENGTH 16 DECIMALS 2,
              amt1stdueperiod             TYPE p LENGTH 16 DECIMALS 2,
              amt2nddueperiod             TYPE p LENGTH 16 DECIMALS 2,
              amt3rddueperiod             TYPE p LENGTH 16 DECIMALS 2,
              amt4thdueperiod             TYPE p LENGTH 16 DECIMALS 2,
              amt5thdueperiod             TYPE p LENGTH 16 DECIMALS 2,
              amt6thdueperiod             TYPE p LENGTH 16 DECIMALS 2,
              amt7thdueperiod             TYPE p LENGTH 16 DECIMALS 2,
              amt8thdueperiod             TYPE p LENGTH 16 DECIMALS 2,
              futramt1thdueperd           TYPE p LENGTH 16 DECIMALS 2,
              futramt2thdueperd           TYPE p LENGTH 16 DECIMALS 2,
              futramt3thdueperd           TYPE p LENGTH 16 DECIMALS 2,
              futramt4thdueperd           TYPE p LENGTH 16 DECIMALS 2,
              futramt5thdueperd           TYPE p LENGTH 16 DECIMALS 2,
              futramt6thdueperd           TYPE p LENGTH 16 DECIMALS 2,
              futramt7thdueperd           TYPE p LENGTH 16 DECIMALS 2,
              futramt8thdueperd           TYPE p LENGTH 16 DECIMALS 2,
              amountincompanycodecurrency TYPE p LENGTH 16 DECIMALS 2,
            END OF ty_custaging.

    " Table for aging details

    DATA: gt_custaging TYPE STANDARD TABLE OF ty_custaging.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CUSTOMER_AGING_REPORT IMPLEMENTATION.


  METHOD if_rap_query_provider~select.


    DATA: lt_aging_details TYPE TABLE OF ty_custaging,
          ls_aging_details TYPE ty_custaging,
          lt_aging         TYPE TABLE OF ty_custaging.

    " Local variables for storing data and filters

    DATA: lr_customer TYPE RANGE OF i_journalentryitem-customer,
          lr_date     TYPE RANGE OF i_journalentryitem-netduedate.

    DATA: lv_duepaymenttotal    TYPE i_journalentryitem-amountincompanycodecurrency,
          lv_futurepaymenttotal TYPE i_journalentryitem-amountincompanycodecurrency,
          days                  TYPE i.

    " Define constants for field names and ranges

    CONSTANTS: lc_customer            TYPE string VALUE 'CUSTOMER',
               lc_accountingdocument  TYPE string VALUE 'ACCOUNTINGDOCUMENT',
               lc_date                TYPE string VALUE 'DATE1',
               lc_transactioncurrency TYPE string VALUE 'TRANSACTIONCURRENCY',
               lc_0l                  TYPE i_journalentryitem-ledger VALUE '0L'.


    TYPES: BEGIN OF ty_doc_sum,
             accountingdocument TYPE i_journalentryitem-accountingdocument,
             fiscalyear         TYPE i_journalentryitem-fiscalyear,
             sum_amount         TYPE i_journalentryitem-amountincompanycodecurrency,
           END OF ty_doc_sum.

    DATA: lt_doc_sum TYPE STANDARD TABLE OF ty_doc_sum,
          ls_doc_sum TYPE ty_doc_sum.



    TRY.
        " Fetch filter parameters
        DATA(lv_top) = io_request->get_paging( )->get_page_size( ).
        IF lv_top <= 0.
          lv_top = 1.
        ENDIF.

        DATA(lv_skip) = io_request->get_paging( )->get_offset( ).

        " Fetch filter parameters
        DATA(lt_filters) = io_request->get_filter( )->get_as_ranges( ).
        IF lt_filters[] IS NOT INITIAL.
          LOOP AT lt_filters INTO DATA(lw_filters).
            CASE lw_filters-name.

              WHEN lc_customer.
                lr_customer = CORRESPONDING #( lw_filters-range ).
                LOOP AT lr_customer ASSIGNING FIELD-SYMBOL(<ls_customer>).
                  <ls_customer>-low = |{ <ls_customer>-low ALPHA = IN }|.
                ENDLOOP.

              WHEN lc_date.
                lr_date = CORRESPONDING #( lw_filters-range ).
                DATA(lv_date) = lr_date[ 1 ]-low.

            ENDCASE.
          ENDLOOP.
        ENDIF.

        " Query journal entry items based on filters

        SELECT a~customer,
               a~assignmentreference,
               a~companycode,
               a~companycodecurrency,
               a~fiscalyear,
               a~glaccount,
               a~accountingdocument,
               a~ledgergllineitem,
               a~accountingdocumenttype,
               a~profitcenter,
               a~segment,
               a~specialglcode,
               a~postingdate,
               a~netduedate,
               a~clearingaccountingdocument,
               a~amountincompanycodecurrency,
               a~amountintransactioncurrency,
               a~ledger,
               a~documentitemtext,
               a~transactioncurrency,
               a~invoicereference,
               a~invoicereferencefiscalyear,
               a~invoiceitemreference,
               b~customername,
               c~glaccountname,
               d~documentreferenceid
               FROM i_journalentryitem AS a
               LEFT OUTER JOIN i_customer AS b
               ON a~customer = b~customer
               LEFT OUTER JOIN i_glaccounttext AS c
               ON a~glaccount = c~glaccount
               LEFT OUTER JOIN i_journalentry AS d
               ON a~accountingdocument = d~accountingdocument
               WHERE a~customer  IN @lr_customer
*               AND a~accountingdocument IN @lr_accountingdocument
*               AND a~transactioncurrency IN @lr_transactioncurrency
               AND clearingaccountingdocument IS INITIAL
               AND a~customer IS NOT INITIAL
               AND a~ledger = @lc_0l
               AND a~postingdate LE @lv_date
               AND a~accountingdocumenttype NE 'WL'
*               INTO CORRESPONDING FIELDS OF TABLE @lt_aging.
               INTO TABLE @DATA(lt_aging_raw).

        " All the AccountDocument will fetched if posting date is a future date compared to key_date entered from the UI
        SELECT a~customer,
               a~assignmentreference,
               a~companycode,
               a~companycodecurrency,
               a~fiscalyear,
               a~glaccount,
               a~accountingdocument,
               a~ledgergllineitem,
               a~accountingdocumenttype,
               a~profitcenter,
               a~segment,
               a~specialglcode,
               a~postingdate,
               a~netduedate,
               a~clearingaccountingdocument,
               a~amountincompanycodecurrency,
               a~amountintransactioncurrency,
               a~ledger,
               a~documentitemtext,
               a~transactioncurrency,
               a~invoicereference,
               a~invoicereferencefiscalyear,
               a~invoiceitemreference,
               b~customername,
               c~glaccountname,
               d~documentreferenceid
                FROM i_journalentryitem AS a
               LEFT OUTER JOIN i_customer AS b
               ON a~customer = b~customer
               LEFT OUTER JOIN i_glaccounttext AS c
               ON a~glaccount = c~glaccount
               LEFT OUTER JOIN i_journalentry AS d
               ON a~accountingdocument = d~accountingdocument
              WHERE a~postingdate > @lv_date
              AND   a~customer IS NOT INITIAL
              AND   a~ledger = '0L'
              AND   a~financialaccounttype = 'D'
              AND   a~accountingdocumenttype = 'DZ'    " Testing
*              AND   a~transactioncurrency IN @lr_displaycurrency
              INTO TABLE @DATA(lt_aging1).

        IF lt_aging1 IS NOT INITIAL.
          DELETE ADJACENT DUPLICATES FROM lt_aging1 COMPARING customer accountingdocument ledger profitcenter ledgergllineitem.
        ENDIF.

        IF lt_aging1 IS NOT INITIAL.
          " Now the data will be fetched if the AccountDocument matches the Journal Entry from UI(if provided) and
          " the The AccountingDocument from the lt_aging1 matches the ClearingAccountingDocument from I_JournalEntryItem
          SELECT a~customer,
               a~assignmentreference,
               a~companycode,
               a~companycodecurrency,
               a~fiscalyear,
               a~glaccount,
               a~accountingdocument,
               a~ledgergllineitem,
               a~accountingdocumenttype,
               a~profitcenter,
               a~segment,
               a~specialglcode,
               a~postingdate,
               a~netduedate,
               a~clearingaccountingdocument,
               a~amountincompanycodecurrency,
               a~amountintransactioncurrency,
               a~ledger,
               a~documentitemtext,
               a~transactioncurrency,
               a~invoicereference,
               a~invoicereferencefiscalyear,
               a~invoiceitemreference,
               b~customername,
               c~glaccountname,
               d~documentreferenceid
              FROM i_journalentryitem AS a
               LEFT OUTER JOIN i_customer AS b
               ON a~customer = b~customer
               LEFT OUTER JOIN i_glaccounttext AS c
               ON a~glaccount = c~glaccount
               LEFT OUTER JOIN i_journalentry AS d
               ON a~accountingdocument = d~accountingdocument
              FOR ALL ENTRIES IN @lt_aging1
              WHERE a~customer IN @lr_customer
*                AND a~businessarea IN @lr_businessarea
*                AND a~accountingdocument IN @lr_accountingdocument
                AND a~clearingaccountingdocument = @lt_aging1-accountingdocument
                AND a~postingdate LE @lv_date
                AND a~customer IS NOT INITIAL
                AND a~ledger = '0L'
                AND a~financialaccounttype = 'D'
                AND a~accountingdocument NE @lt_aging1-accountingdocument
*                AND a~transactioncurrency IN @lr_displaycurrency
                INTO TABLE @DATA(lt_aging2).
        ENDIF.

        IF lt_aging2 IS NOT INITIAL.
          " The final AccountingDocument data with ClearingAccountingData will append with the main Internal Table for which the logic executes.
          APPEND LINES OF lt_aging2 TO lt_aging_raw.
        ENDIF.


        IF lt_aging_raw IS NOT INITIAL.
          " Remove duplicate entries based on supplier and accounting document
*          DELETE ADJACENT DUPLICATES FROM lt_aging COMPARING customer accountingdocument ledger profitcenter ledgergllineitem.
          DELETE ADJACENT DUPLICATES FROM lt_aging_raw COMPARING customer accountingdocument ledger profitcenter ledgergllineitem.

        ENDIF.

*        SORT lt_aging ASCENDING BY customer accountingdocument ledgergllineitem.
        SORT lt_aging_raw ASCENDING BY customer accountingdocument ledgergllineitem.


        " Process aging details and categorize amounts based on due dates

        IF lt_aging_raw IS NOT INITIAL.

          SELECT a~customer,
                 a~assignmentreference,
                 a~companycode,
                 a~companycodecurrency,
                 a~fiscalyear,
                 a~glaccount,
                 a~accountingdocument,
                 a~ledgergllineitem,
                 a~accountingdocumenttype,
                 a~profitcenter,
                 a~segment,
                 a~specialglcode,
                 a~postingdate,
                 a~netduedate,
                 a~clearingaccountingdocument,
                 a~amountincompanycodecurrency,
                 a~amountintransactioncurrency,
                 a~ledger,
                 a~documentitemtext,
                 a~transactioncurrency,
                 a~invoicereference,
                 a~invoicereferencefiscalyear,
                 a~invoiceitemreference,
                 b~customername,
                 c~glaccountname,
                 d~documentreferenceid
                FROM i_journalentryitem AS a
                 LEFT OUTER JOIN i_customer AS b
                 ON a~customer = b~customer
                 LEFT OUTER JOIN i_glaccounttext AS c
                 ON a~glaccount = c~glaccount
                 LEFT OUTER JOIN i_journalentry AS d
                 ON a~accountingdocument = d~accountingdocument
                FOR ALL ENTRIES IN @lt_aging_raw
                WHERE a~customer IN @lr_customer
                  AND a~postingdate LE @lv_date
                  AND a~customer IS NOT INITIAL
                  AND a~ledger = '0L'
*                  AND a~accountingdocument NE @lt_aging_raw-accountingdocument
                  AND a~invoicereference = @lt_aging_raw-accountingdocument
                  AND a~invoicereferencefiscalyear = @lt_aging_raw-fiscalyear
                  AND a~accountingdocumenttype = 'DZ'
                  AND a~clearingaccountingdocument IS INITIAL
                  AND a~invoicereference IS NOT INITIAL
                  INTO TABLE @DATA(lt_aging_dz).

          IF lt_aging_dz IS NOT INITIAL.
            " Remove customer entries based on supplier and accounting document
            DELETE ADJACENT DUPLICATES FROM lt_aging_dz COMPARING customer accountingdocument ledger profitcenter ledgergllineitem.

          ENDIF.

          LOOP AT lt_aging_raw ASSIGNING FIELD-SYMBOL(<fs_raw>).

            DATA(lv_sum) = 0.

            LOOP AT lt_aging_dz ASSIGNING FIELD-SYMBOL(<fs_dz>)
              WHERE invoicereference = <fs_raw>-accountingdocument
                AND invoicereferencefiscalyear = <fs_raw>-fiscalyear
                AND invoiceitemreference = <fs_raw>-ledgergllineitem.
              lv_sum = lv_sum + <fs_dz>-amountincompanycodecurrency.
            ENDLOOP.

            <fs_raw>-amountincompanycodecurrency = <fs_raw>-amountincompanycodecurrency + lv_sum.

          ENDLOOP.

          DELETE lt_aging_raw WHERE accountingdocumenttype = 'DZ' AND specialglcode IS INITIAL.



          LOOP AT lt_aging_raw INTO DATA(ls_aging_raw)
                               WHERE netduedate IS NOT INITIAL
                               GROUP BY ( customer            = ls_aging_raw-customer
                                          customername        = ls_aging_raw-customername
                                          companycodecurrency = ls_aging_raw-companycodecurrency )
                                  INTO DATA(group).

            ls_aging_details = VALUE ty_custaging(
                                      customer            = group-customer
                                      customername        = group-customername
                                      companycodecurrency = group-companycodecurrency ).

            LOOP AT GROUP group ASSIGNING FIELD-SYMBOL(<ls_aging>).
              DATA(ls_matdoc) = VALUE #( lt_aging_raw[ accountingdocument     = <ls_aging>-accountingdocument
                                                             ledgergllineitem = <ls_aging>-ledgergllineitem ] OPTIONAL ).

              CLEAR days.
              days = lv_date - <ls_aging>-netduedate .
              " Categorize amounts into aging buckets
              IF days > 0 AND days <= 30.
                ls_aging_details-amt1stdueperiod += ls_matdoc-amountincompanycodecurrency.
              ELSEIF days >= 31  AND days <= 60.
                ls_aging_details-amt2nddueperiod += ls_matdoc-amountincompanycodecurrency.
              ELSEIF days >= 61  AND days <= 90.
                ls_aging_details-amt3rddueperiod += ls_matdoc-amountincompanycodecurrency.
              ELSEIF days >= 91  AND days <= 120.
                ls_aging_details-amt4thdueperiod += ls_matdoc-amountincompanycodecurrency.
              ELSEIF days >= 121 AND days <= 150.
                ls_aging_details-amt5thdueperiod += ls_matdoc-amountincompanycodecurrency.
              ELSEIF days >= 151 AND days <= 180.
                ls_aging_details-amt6thdueperiod += ls_matdoc-amountincompanycodecurrency.
              ELSEIF days >= 181 AND days <= 365.
                ls_aging_details-amt7thdueperiod += ls_matdoc-amountincompanycodecurrency.
              ELSEIF days >= 366 AND days <= 2300.
                ls_aging_details-amt8thdueperiod += ls_matdoc-amountincompanycodecurrency.

                " Categorize amounts into future due buckets
              ELSEIF days < 0 AND days >= -30.
                ls_aging_details-futramt1thdueperd += ls_matdoc-amountincompanycodecurrency.
              ELSEIF days <= -31  AND days >= -60.
                ls_aging_details-futramt2thdueperd += ls_matdoc-amountincompanycodecurrency.
              ELSEIF days <= -61  AND days >= -90.
                ls_aging_details-futramt3thdueperd += ls_matdoc-amountincompanycodecurrency.
              ELSEIF days <= -91  AND days >= -120.
                ls_aging_details-futramt4thdueperd += ls_matdoc-amountincompanycodecurrency.
              ELSEIF days <= -121 AND days >= -150.
                ls_aging_details-futramt5thdueperd += ls_matdoc-amountincompanycodecurrency.
              ELSEIF days <= -151 AND days >= -180.
                ls_aging_details-futramt6thdueperd += ls_matdoc-amountincompanycodecurrency.
              ELSEIF days <= -181 AND days >= -365.
                ls_aging_details-futramt7thdueperd += ls_matdoc-amountincompanycodecurrency.
              ELSEIF days <= -366 AND days >= -2300.
                ls_aging_details-futramt8thdueperd += ls_matdoc-amountincompanycodecurrency.
              ENDIF.

              ls_aging_details-amountincompanycodecurrency += ls_matdoc-amountincompanycodecurrency.

              CLEAR: ls_matdoc, <ls_aging>.
            ENDLOOP.

            lv_duepaymenttotal = ls_aging_details-amt1stdueperiod + ls_aging_details-amt2nddueperiod +
                                 ls_aging_details-amt3rddueperiod + ls_aging_details-amt4thdueperiod +
                                 ls_aging_details-amt5thdueperiod + ls_aging_details-amt6thdueperiod +
                                 ls_aging_details-amt7thdueperiod + ls_aging_details-amt8thdueperiod.

            lv_futurepaymenttotal = ls_aging_details-futramt1thdueperd + ls_aging_details-futramt2thdueperd +
                                    ls_aging_details-futramt3thdueperd + ls_aging_details-futramt4thdueperd +
                                    ls_aging_details-futramt5thdueperd + ls_aging_details-futramt6thdueperd +
                                    ls_aging_details-futramt7thdueperd + ls_aging_details-futramt8thdueperd.

            ls_aging_details-overdueamount = lv_duepaymenttotal.
            ls_aging_details-futureamount  = lv_futurepaymenttotal.
            ls_aging_details-totalamount   = lv_duepaymenttotal + lv_futurepaymenttotal.

            APPEND ls_aging_details TO lt_aging_details.
            CLEAR: ls_aging_details, ls_aging_raw.

          ENDLOOP.
        ENDIF.


        " Set total number of records if requested
        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( lines( lt_aging_details ) ).
        ENDIF.
        " Paginate results and append to global table
        DATA(lv_start) = lv_skip + 1.
        DATA(lv_end) = lv_skip + lv_top.

        IF lv_end > lines( lt_aging_details ).
          lv_end = lines( lt_aging_details ).
        ENDIF.
        APPEND LINES OF lt_aging_details FROM lv_start TO lv_end TO gt_custaging.
*        APPEND LINES OF lt_aging_details TO gt_aging_details.
        " Set data in response object
        io_response->set_data( gt_custaging ).
        CLEAR: lt_aging_details, lt_aging.
      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
