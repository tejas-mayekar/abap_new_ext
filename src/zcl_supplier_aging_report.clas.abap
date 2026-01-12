CLASS zcl_supplier_aging_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider.

    " Define a structure for aging details

    TYPES : BEGIN OF ty_aging_details,

              supplier                    TYPE i_journalentryitem-supplier,
*              netduedate                  TYPE i_journalentryitem-netduedate,
              date1                       TYPE i_journalentryitem-netduedate,
              amt1stdueperiod             TYPE p LENGTH 16 DECIMALS 2,
              amt2stdueperiod             TYPE p LENGTH 16 DECIMALS 2,
              amt3stdueperiod             TYPE p LENGTH 16 DECIMALS 2,
              amt4stdueperiod             TYPE p LENGTH 16 DECIMALS 2,
              amt5stdueperiod             TYPE p LENGTH 16 DECIMALS 2,
              amt6stdueperiod             TYPE p LENGTH 16 DECIMALS 2,
              amt7stdueperiod             TYPE p LENGTH 16 DECIMALS 2,
              amt8stdueperiod             TYPE p LENGTH 16 DECIMALS 2,
              futramt1thdueperd           TYPE p LENGTH 16 DECIMALS 2,
              futramt2thdueperd           TYPE p LENGTH 16 DECIMALS 2,
              futramt3thdueperd           TYPE p LENGTH 16 DECIMALS 2,
              futramt4thdueperd           TYPE p LENGTH 16 DECIMALS 2,
              futramt5thdueperd           TYPE p LENGTH 16 DECIMALS 2,
              futramt6thdueperd           TYPE p LENGTH 16 DECIMALS 2,
              futramt7thdueperd           TYPE p LENGTH 16 DECIMALS 2,
              futramt8thdueperd           TYPE p LENGTH 16 DECIMALS 2,
              total                       TYPE string,
              futureamount                TYPE string,
              overdueamount               TYPE string,
              amountincompanycodecurrency TYPE p LENGTH 16 DECIMALS 2,
              suppliername                TYPE i_supplier-suppliername,
*              amountintransactioncurrency TYPE p LENGTH 16 DECIMALS 2,
*              transactioncurrency         TYPE i_journalentryitem-transactioncurrency,
              companycodecurrency         TYPE i_journalentryitem-companycodecurrency,
            END OF ty_aging_details.
    " Table for aging details
    DATA : gt_aging_details TYPE STANDARD TABLE OF ty_aging_details.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SUPPLIER_AGING_REPORT IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    " Local variables for storing data and filters
    DATA: lt_aging_details TYPE TABLE OF ty_aging_details,
          lt_aging         TYPE TABLE OF ty_aging_details,
          ls_aging_details TYPE ty_aging_details.

    DATA: lr_supplier        TYPE RANGE OF i_journalentryitem-supplier,
          lr_date            TYPE RANGE OF i_journalentryitem-netduedate,
          lr_amt2stdueperiod TYPE RANGE OF i_journalentryitem-amountintransactioncurrency,
          lr_displaycurrency TYPE RANGE OF i_journalentryitem-transactioncurrency.

    DATA: days                    TYPE i,
          lv_firtduepaymentgtotal TYPE p LENGTH 16 DECIMALS 2,
          lv_futureduepayment     TYPE p LENGTH 16 DECIMALS 2,
          total                   TYPE p LENGTH 16 DECIMALS 2,
          futureamount            TYPE p LENGTH 16 DECIMALS 2,
          overdueamount           TYPE p LENGTH 16 DECIMALS 2.

    DATA: lv_amount  TYPE decfloat16.


*  DATA: lt_collapsed_aging TYPE TABLE OF lt_aging_details,
*         ls_collapsed_aging LIKE LINE OF lt_collapsed_aging.

    " Define constants for field names and ranges
    CONSTANTS: lc_supplier                TYPE string VALUE 'SUPPLIER',
               lc_companycode             TYPE string VALUE 'COMPANYCODE',
               lc_customersuppliercountry TYPE string VALUE 'CUSTOMERSUPPLIERCOUNTRY',
               lc_companycodecurrency     TYPE string VALUE 'COMPANYCODECURRENCY',
               lc_ledgerllineitem         TYPE string VALUE 'LEDGERLLINEITEM',
               lc_accountingdocumentitem  TYPE string VALUE 'ACCOUNTINGDOCUMENTITEM',
               lc_date                    TYPE string VALUE 'DATE1',
               lc_30                      TYPE i VALUE 30,
               lc_amt2stdueperiod         TYPE string VALUE 'AMT2STUDUEPERIOD',
               lc_displaycurrency         TYPE string VALUE 'TRANSACTIONCURRENCY'.
    TRY.
        " Fetch filter parameters
        DATA(lt_filters) = io_request->get_filter( )->get_as_ranges( ).
        IF lt_filters[] IS NOT INITIAL.
          LOOP AT lt_filters INTO DATA(lw_filters).
            CASE lw_filters-name.

              WHEN lc_supplier.
                lr_supplier = CORRESPONDING #( lw_filters-range ).

                LOOP AT lr_supplier ASSIGNING FIELD-SYMBOL(<ls_supplier>).
                  <ls_supplier>-low = |{ <ls_supplier>-low ALPHA = IN }|.
                ENDLOOP.

              WHEN lc_date.
                lr_date = CORRESPONDING #( lw_filters-range ).
                DATA(lv_date) = lr_date[ 1 ]-low.

              WHEN lc_displaycurrency.
                lr_displaycurrency = CORRESPONDING #( lw_filters-range ).
            ENDCASE.

          ENDLOOP.
        ENDIF.

        " Query journal entry items based on filters
        SELECT a~supplier,
               a~assignmentreference,
               a~businessarea,
               a~companycode,
               a~customersuppliercountry,
               a~fiscalyear,
               a~documentitemtext,
               a~glaccount,
               a~accountingdocument,
               a~ledgergllineitem,
               a~accountingdocumentitem,
               a~profitcenter,
               a~segment,
               a~specialglcode,
               a~postingdate,
               a~netduedate,
               a~clearingaccountingdocument,
               a~amountincompanycodecurrency,
               a~ledger,
               b~suppliername,
               a~accountingdocumenttype,
               c~glaccountname,
               a~amountintransactioncurrency,
               a~transactioncurrency,
               a~companycodecurrency,
               a~invoicereference,
                 a~invoicereferencefiscalyear,
                 a~invoiceitemreference,
               d~documentreferenceid
            FROM i_journalentryitem AS a
            LEFT OUTER JOIN i_supplier AS b
                ON a~supplier = b~supplier
            LEFT OUTER JOIN i_glaccounttext AS c
                ON a~glaccount = c~glaccount
            LEFT OUTER JOIN i_journalentry AS d
                ON a~accountingdocument = d~accountingdocument
            WHERE   a~supplier IN @lr_supplier
                AND a~supplier IS NOT INITIAL
                AND a~clearingaccountingdocument IS INITIAL
                AND a~supplier IS NOT INITIAL
                AND a~ledger = '0L'
                AND a~postingdate LE @lv_date
*                AND a~transactioncurrency IN @lr_displaycurrency
            INTO TABLE @DATA(lt_aging_raw).

        " All the AccountDocument will fetched if posting date is a future date compared to key_date entered from the UI
        SELECT   a~supplier,
                   a~assignmentreference,
                   a~businessarea,
                   a~companycode,
                   a~customersuppliercountry,
                   a~fiscalyear,
                   a~documentitemtext,
                   a~glaccount,
                   a~accountingdocument,
                   a~ledgergllineitem,
                   a~accountingdocumentitem,
                   a~profitcenter,
                   a~segment,
                   a~specialglcode,
                   a~postingdate,
                   a~netduedate,
                   a~clearingaccountingdocument,
                   a~amountincompanycodecurrency,
                   a~ledger,
                   b~suppliername,
                   a~accountingdocumenttype,
                   c~glaccountname,
                   a~amountintransactioncurrency,
                   a~transactioncurrency,
                   a~companycodecurrency,
                   a~invoicereference,
                 a~invoicereferencefiscalyear,
                 a~invoiceitemreference,
                   d~documentreferenceid
                FROM i_journalentryitem AS a
                LEFT OUTER JOIN i_supplier AS b
                 ON a~supplier = b~supplier
                LEFT OUTER JOIN i_glaccounttext AS c
                ON a~glaccount = c~glaccount
                LEFT OUTER JOIN i_journalentry AS d
                ON a~accountingdocument = d~accountingdocument
          WHERE "a~supplier IN @lr_supplier
*          AND   a~businessarea IN @lr_businessarea
*          AND   a~accountingdocument IN @lr_accountingdocument AND
                a~postingdate > @lv_date
          AND   a~supplier IS NOT INITIAL
          AND   a~ledger = '0L'
          AND   a~financialaccounttype = 'K'
          AND   a~accountingdocumenttype = 'KZ'
*          AND   a~transactioncurrency IN @lr_displaycurrency
          INTO TABLE @DATA(lt_aging1).

        IF lt_aging1 IS NOT INITIAL.
          DELETE ADJACENT DUPLICATES FROM lt_aging1 COMPARING supplier accountingdocument ledger profitcenter ledgergllineitem.
        ENDIF.


        IF lt_aging1 IS NOT INITIAL.
          " Now the data will be fetched if the AccountDocument matches the Journal Entry from UI(if provided) and
          " the The AccountingDocument from the lt_aging1 matches the ClearingAccountingDocument from I_JournalEntryItem
          SELECT a~supplier,
                 a~assignmentreference,
                 a~businessarea,
                 a~companycode,
                 a~customersuppliercountry,
                 a~fiscalyear,
                 a~documentitemtext,
                 a~glaccount,
                 a~accountingdocument,
                 a~ledgergllineitem,
                 a~accountingdocumentitem,
                 a~profitcenter,
                 a~segment,
                 a~specialglcode,
                 a~postingdate,
                 a~netduedate,
                 a~clearingaccountingdocument,
                 a~amountincompanycodecurrency,
                 a~ledger,
                 b~suppliername,
                 a~accountingdocumenttype,
                 c~glaccountname,
                 a~amountintransactioncurrency,
                 a~transactioncurrency,
                 a~companycodecurrency,
                 a~invoicereference,
                 a~invoicereferencefiscalyear,
                 a~invoiceitemreference,
                 d~documentreferenceid
              FROM i_journalentryitem AS a
              LEFT OUTER JOIN i_supplier AS b
               ON a~supplier = b~supplier
              LEFT OUTER JOIN i_glaccounttext AS c
              ON a~glaccount = c~glaccount
              LEFT OUTER JOIN i_journalentry AS d
              ON a~accountingdocument = d~accountingdocument
              FOR ALL ENTRIES IN @lt_aging1
              WHERE a~supplier IN @lr_supplier
*                AND a~businessarea IN @lr_businessarea
*                AND a~accountingdocument IN @lr_accountingdocument
                AND a~clearingaccountingdocument = @lt_aging1-accountingdocument
                AND a~fiscalyear = @lt_aging1-fiscalyear
                AND a~postingdate LE @lv_date
                AND a~supplier IS NOT INITIAL
                AND a~ledger = '0L'
                AND a~financialaccounttype = 'K'
                AND a~accountingdocument NE @lt_aging1-accountingdocument
*                AND a~transactioncurrency IN @lr_displaycurrency
                INTO TABLE @DATA(lt_aging2).
        ENDIF.

        IF lt_aging2 IS NOT INITIAL.
          " The final AccountingDocument data with ClearingAccountingData will append with the main Internal Table for which the logic executes.
          APPEND LINES OF lt_aging2 TO lt_aging_raw.
        ENDIF.



        SORT lt_aging_raw ASCENDING BY accountingdocument ledgergllineitem.
        " Remove duplicate entries based on supplier and accounting document
        IF lt_aging_raw IS NOT INITIAL.
          DELETE ADJACENT DUPLICATES FROM lt_aging_raw COMPARING supplier accountingdocument ledgergllineitem profitcenter ledger.
        ENDIF.

*        IF lt_aging_raw IS NOT INITIAL.
*          lt_aging = CORRESPONDING #( lt_aging_raw ).
*        ENDIF.
        IF lt_aging_raw IS NOT INITIAL.

""""""""""""""""""""""""""Code Commented By Bikram Biswas 09.10.2025 Start""""""""""""""""""""""""""""""""""""""""""""

*          SELECT a~customer,
*                   a~assignmentreference,
*                   a~companycode,
*                   a~companycodecurrency,
*                   a~fiscalyear,
*                   a~glaccount,
*                   a~accountingdocument,
*                   a~ledgergllineitem,
*                   a~accountingdocumenttype,
*                   a~profitcenter,
*                   a~segment,
*                   a~specialglcode,
*                   a~postingdate,
*                   a~netduedate,
*                   a~clearingaccountingdocument,
*                   a~amountincompanycodecurrency,
*                   a~amountintransactioncurrency,
*                   a~ledger,
*                   a~documentitemtext,
*                   a~transactioncurrency,
*                   a~invoicereference,
*                   a~invoicereferencefiscalyear,
*                   a~invoiceitemreference,
*                   b~customername,
*                   c~glaccountname,
*                   d~documentreferenceid
*                  FROM i_journalentryitem AS a
*                   LEFT OUTER JOIN i_customer AS b
*                   ON a~customer = b~customer
*                   LEFT OUTER JOIN i_glaccounttext AS c
*                   ON a~glaccount = c~glaccount
*                   LEFT OUTER JOIN i_journalentry AS d
*                   ON a~accountingdocument = d~accountingdocument
*                  FOR ALL ENTRIES IN @lt_aging_raw
*                  WHERE a~Supplier IN @lr_supplier
*                    AND a~postingdate LE @lv_date
*                    AND a~Supplier IS NOT INITIAL
*                    AND a~ledger = '0L'
*                  AND a~accountingdocument NE @lt_aging_raw-accountingdocument
**                    AND a~invoicereference = @lt_aging_raw-accountingdocument
**                    AND a~invoicereferencefiscalyear = @lt_aging_raw-fiscalyear
*                    AND a~accountingdocumenttype = 'KZ'
**                    AND a~clearingaccountingdocument IS INITIAL
**                    AND a~invoicereference IS NOT INITIAL
*                    INTO TABLE @DATA(lt_aging_kz).
*
*          IF lt_aging_kz IS NOT INITIAL.
*            " Remove customer entries based on supplier and accounting document
*            DELETE ADJACENT DUPLICATES FROM lt_aging_kz COMPARING customer accountingdocument ledger profitcenter ledgergllineitem.
*
*          ENDIF.

*          LOOP AT lt_aging_raw ASSIGNING FIELD-SYMBOL(<fs_raw>).
*
*            DATA(lv_sum) = 0.
*
*            LOOP AT lt_aging_kz ASSIGNING FIELD-SYMBOL(<fs_kz>)
*              WHERE invoicereference = <fs_raw>-accountingdocument
*                AND invoicereferencefiscalyear = <fs_raw>-fiscalyear
*                AND invoiceitemreference = <fs_raw>-ledgergllineitem.
*              lv_sum = lv_sum + <fs_kz>-amountincompanycodecurrency.
*            ENDLOOP.
*
*            <fs_raw>-amountincompanycodecurrency = <fs_raw>-amountincompanycodecurrency + lv_sum.
*
*          ENDLOOP.
*
*          DELETE lt_aging_raw WHERE accountingdocumenttype = 'KZ' AND specialglcode IS INITIAL.

""""""""""""""""""""""""""Code Commented By Bikram Biswas 09.10.2025 End""""""""""""""""""""""""""""""""""""""""""""


          " Process aging details and categorize amounts based on due dates
          "Sorting the data based on the supllier.
          SORT lt_aging_raw BY supplier.
*
          LOOP AT lt_aging_raw INTO DATA(ls_aging_line)
               WHERE netduedate IS NOT INITIAL
               GROUP BY ( supplier            = ls_aging_line-supplier
                          suppliername        = ls_aging_line-suppliername
                          companycodecurrency = ls_aging_line-companycodecurrency
                        )
               INTO DATA(group).

            " Clear structure per supplier
            ls_aging_details = VALUE ty_aging_details(
              supplier             = |{ group-supplier ALPHA = OUT }|
              suppliername         = group-suppliername
              companycodecurrency  = group-companycodecurrency
            ).

            LOOP AT GROUP group ASSIGNING FIELD-SYMBOL(<ls_aging>).

              CLEAR days.
              days = lv_date - <ls_aging>-netduedate .

              " Categorize amounts into aging buckets
              IF days >= 0 AND days <= 30.
                ls_aging_details-amt1stdueperiod += <ls_aging>-amountincompanycodecurrency.
              ELSEIF days >= 31  AND days <= 60.
                ls_aging_details-amt2stdueperiod += <ls_aging>-amountincompanycodecurrency.
              ELSEIF days >= 61  AND days <= 90.
                ls_aging_details-amt3stdueperiod += <ls_aging>-amountincompanycodecurrency.
              ELSEIF days >= 91  AND days <= 120.
                ls_aging_details-amt4stdueperiod += <ls_aging>-amountincompanycodecurrency.
              ELSEIF days >= 121 AND days <= 150.
                ls_aging_details-amt5stdueperiod += <ls_aging>-amountincompanycodecurrency.
              ELSEIF days >= 151 AND days <= 180.
                ls_aging_details-amt6stdueperiod += <ls_aging>-amountincompanycodecurrency.
              ELSEIF days >= 181 AND days <= 365.
                ls_aging_details-amt7stdueperiod += <ls_aging>-amountincompanycodecurrency.
              ELSEIF days >= 366 AND days <= 2000.
                ls_aging_details-amt8stdueperiod += <ls_aging>-amountincompanycodecurrency.


                " Categorize amounts into future due buckets
              ELSEIF days < 0 AND days >= -30.
                ls_aging_details-futramt1thdueperd += <ls_aging>-amountincompanycodecurrency.
              ELSEIF days <= -31  AND days >= -60.
                ls_aging_details-futramt2thdueperd += <ls_aging>-amountincompanycodecurrency.
              ELSEIF days <= -61  AND days >= -90.
                ls_aging_details-futramt3thdueperd += <ls_aging>-amountincompanycodecurrency.
              ELSEIF days <= -91  AND days >= -120.
                ls_aging_details-futramt4thdueperd += <ls_aging>-amountincompanycodecurrency.
              ELSEIF days <= -121 AND days >= -150.
                ls_aging_details-futramt5thdueperd += <ls_aging>-amountincompanycodecurrency.
              ELSEIF days <= -151 AND days >= -180.
                ls_aging_details-futramt6thdueperd += <ls_aging>-amountincompanycodecurrency.
              ELSEIF days <= -181 AND days >= -365.
                ls_aging_details-futramt7thdueperd += <ls_aging>-amountincompanycodecurrency.
              ELSEIF days <= -366 AND days >= -2000.
                ls_aging_details-futramt8thdueperd += <ls_aging>-amountincompanycodecurrency.
              ENDIF.

              " Capture details from any line (can be first)
*                ls_aging_details-netduedate = <ls_aging>-netduedate.
              ls_aging_details-amountincompanycodecurrency += <ls_aging>-amountincompanycodecurrency.
              CLEAR: <ls_aging>.
            ENDLOOP.

            " Final aggregation per supplier group
            lv_firtduepaymentgtotal = ls_aging_details-amt1stdueperiod + ls_aging_details-amt2stdueperiod +
                                      ls_aging_details-amt3stdueperiod + ls_aging_details-amt4stdueperiod +
                                      ls_aging_details-amt5stdueperiod + ls_aging_details-amt6stdueperiod +
                                      ls_aging_details-amt7stdueperiod + ls_aging_details-amt8stdueperiod.

            lv_futureduepayment = ls_aging_details-futramt1thdueperd + ls_aging_details-futramt2thdueperd +
                                  ls_aging_details-futramt3thdueperd + ls_aging_details-futramt4thdueperd +
                                  ls_aging_details-futramt5thdueperd + ls_aging_details-futramt6thdueperd +
                                  ls_aging_details-futramt7thdueperd + ls_aging_details-futramt8thdueperd.

            ls_aging_details-overdueamount = lv_firtduepaymentgtotal.
            ls_aging_details-futureamount  = lv_futureduepayment.
            ls_aging_details-total         = lv_firtduepaymentgtotal + lv_futureduepayment.

            APPEND ls_aging_details TO lt_aging_details.
            CLEAR: ls_aging_details, ls_aging_line.

          ENDLOOP.


        ENDIF.

        " Fetch pagination details from the request
        DATA(lv_top) = io_request->get_paging( )->get_page_size( ).
        IF lv_top <= 0.
          lv_top = 1.
        ENDIF.

        DATA(lv_skip) = io_request->get_paging( )->get_offset( ).
        " Set total number of records if requested
        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( lines( lt_aging_details ) ).
        ENDIF.
        " Paginate results and append to global table
        DATA(lv_start) = lv_skip + 1.
        DATA(lv_end) = lv_skip + lv_top.
        DATA(lv_lines) =  lines( lt_aging_details ).
        IF lv_end > lines( lt_aging_details ).
          lv_end = lines( lt_aging_details ).
        ENDIF.
        APPEND LINES OF lt_aging_details FROM lv_start TO lv_end TO gt_aging_details.
*        APPEND LINES OF lt_aging_details TO gt_aging_details.
        " Set data in response object
        io_response->set_data( gt_aging_details ).
        CLEAR: lt_aging_details, lt_aging.
      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
