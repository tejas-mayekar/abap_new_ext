CLASS zcl_purchase_register DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    TYPES: BEGIN OF ty_purchreg,
             postingdate                 TYPE i_operationalacctgdocitem-postingdate,
             profitcenter                TYPE i_operationalacctgdocitem-profitcenter,
             businessplace               TYPE i_operationalacctgdocitem-businessplace,
             documenttype                TYPE i_operationalacctgdocitem-accountingdocumenttype,
             accountingdocument          TYPE i_operationalacctgdocitem-accountingdocument,
             journalentry                TYPE i_operationalacctgdocitem-accountingdocument,
             journalentryitem            TYPE i_operationalacctgdocitem-accountingdocumentitem,
             refdocno                    TYPE i_purchaseorderhistoryapi01-documentreferenceid,
             documentdate                TYPE i_operationalacctgdocitem-documentdate,
             refdocitem                  TYPE i_operationalacctgdocitem-numberofitems,
             supplier                    TYPE i_operationalacctgdocitem-supplier,
             suppliername                TYPE i_supplier-suppliername,
             supplierregion              TYPE i_supplier-region,
             supplierstate               TYPE i_supplier-region,
             suppliergstin               TYPE i_supplier-taxnumber3,
             supplierpanno               TYPE i_supplier-businesspartnerpannumber,
             material                    TYPE i_operationalacctgdocitem-product,
             materialdescription         TYPE i_productdescription_2-productdescription,
             unitofmeasure               TYPE i_operationalacctgdocitem-baseunit,
             materialbaseunit            TYPE i_operationalacctgdocitem-baseunit,
             hsncode                     TYPE i_operationalacctgdocitem-in_hsnorsaccode,
             purchaseorderdate           TYPE i_purchaseorderapi01-purchaseorderdate,
             purchaseorder               TYPE i_operationalacctgdocitem-purchasingdocument,
             purchaseorderitem           TYPE i_operationalacctgdocitem-purchasingdocumentitem,
             purchaseorderqty            TYPE i_operationalacctgdocitem-purchaseorderqty,
             grnquantity                 TYPE i_materialdocumentitem_2-quantityinbaseunit,
             amountintransactioncurrency TYPE i_operationalacctgdocitem-amountintransactioncurrency,
             transactioncurrency         TYPE i_operationalacctgdocitem-transactioncurrency,
             amountincompanycodecurrency TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             companycodecurrency         TYPE i_operationalacctgdocitem-companycodecurrency,
             glaccount                   TYPE i_operationalacctgdocitem-glaccount,
             glaccountname               TYPE i_glaccounttext-glaccountname,
             inventoryglaccount          TYPE i_operationalacctgdocitem-glaccount,
             cgstglaccount               TYPE i_operationalacctgdocitem-glaccount,
             sgstglaccount               TYPE i_operationalacctgdocitem-glaccount,
             igstglaccount               TYPE i_operationalacctgdocitem-glaccount,
             taxcode                     TYPE i_operationalacctgdocitem-taxcode,
             baseamount                  TYPE i_operationalacctgdocitem-originaltaxbaseamount,
             taxableamount               TYPE i_operationalacctgdocitem-taxbaseamountincocodecrcy,
             cgstrate                    TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             cgstamount                  TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             sgstrate                    TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             sgstamount                  TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             igstrate                    TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             igstamount                  TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             rcmcgstrate                 TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             rcmcgstamount               TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             rcmsgstrate                 TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             rcmsgstamount               TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             rcmigstrate                 TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             rcmigstamount               TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             withhldtaxamount            TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             netinvoiceamount            TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             totaltaxamount              TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             withhldtaxcode              TYPE i_operationalacctgdocitem-withholdingtaxcode,
             materialdocument            TYPE i_materialdocumentitem_2-materialdocument,
*             narration                   TYPE i_materialdocumentitem_2-materialdocumentitemtext,
             assignment                  TYPE i_operationalacctgdocitem-assignmentreference,
             reversalreference           TYPE i_journalentry-reversalreferencedocument,
             wedocno                     TYPE i_operationalacctgdocitem-accountingdocument,   "added by yash
             wepostingdt                 TYPE i_materialdocumentitem_2-postingdate,
             grndocumentdt               TYPE i_materialdocumentitem_2-documentdate,
             grnrefno                    TYPE i_materialdocumentheader_2-referencedocument,
*             grnhsncode                  TYPE I_MaterialDocumentItem_2-YY1_MM_HSNCodeinMIGO_MMI,
             purchasegrp                 TYPE i_purchaseorderapi01-purchasinggroup,
             weglcode                    TYPE i_operationalacctgdocitem-glaccount,
             wbselement                  TYPE i_enterpriseproject-project,
             documentitemtext            TYPE i_operationalacctgdocitem-documentitemtext,       "  added by siddharth
             taxitemgroup                TYPE i_operationalacctgdocitem-taxitemgroup,           "  added by siddharth
             investmentprofile           TYPE i_enterpriseproject-investmentprofile,            "  added by siddharth
             "investmentprofiledesc       TYPE I_InvestmentProfileText-InvestmentProfileName,   "  added by siddharth
             narrationheaderdata         TYPE i_journalentry-accountingdocumentheadertext,      "  added by siddharth
             krhsncode                   TYPE i_operationalacctgdocitem-assignmentreference,    "  added by siddharth
             constructid                 TYPE i_fixedasset-fixedassetexternalid,                "  added by siddharth
             fiscalyear                  TYPE i_operationalacctgdocitem-fiscalyear,
           END OF ty_purchreg.

    DATA: gt_purchreg TYPE STANDARD TABLE OF ty_purchreg.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PURCHASE_REGISTER IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    TYPES: BEGIN OF ty_taxes,
             taxcode       TYPE i_operationalacctgdocitem-taxcode,
             cgstrate      TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             sgstrate      TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             igstrate      TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
             rcmapplicable TYPE string,
           END OF ty_taxes.

    CONSTANTS: lc_postingdate  TYPE string VALUE 'POSTINGDATE',
               lc_acctdocumnt  TYPE string VALUE 'ACCOUNTINGDOCUMENT',
               lc_journalentry TYPE string VALUE 'JOURNALENTRY',
               lc_taxcode      TYPE string VALUE 'TAXCODE',
               lc_cgst         TYPE string VALUE 'CGST',
               lc_sgst         TYPE string VALUE 'SGST',
               lc_igst         TYPE string VALUE 'IGST',
               lc_rcmappl      TYPE string VALUE 'RCMAPPLICABLE',
               lc_bo           TYPE if_cbo_dev_business_object=>tv_id VALUE 'YY1_TAXCONDITIONRATEPURCHA',
               lc_q            TYPE i_purchaseorderhistoryapi01-purchasinghistorycategory VALUE 'Q',
               lc_wrx          TYPE i_operationalacctgdocitem-transactiontypedetermination VALUE 'WRX',
               lc_kbs          TYPE i_operationalacctgdocitem-transactiontypedetermination VALUE 'KBS',
               lc_egk          TYPE i_operationalacctgdocitem-transactiontypedetermination VALUE 'EGK',
               lc_wit          TYPE i_operationalacctgdocitem-transactiontypedetermination VALUE 'WIT',
               lc_bsx          TYPE i_operationalacctgdocitem-transactiontypedetermination VALUE 'BSX',
               lc_jic          TYPE i_operationalacctgdocitem-transactiontypedetermination VALUE 'JIC',
               lc_jis          TYPE i_operationalacctgdocitem-transactiontypedetermination VALUE 'JIS',
               lc_jii          TYPE i_operationalacctgdocitem-transactiontypedetermination VALUE 'JII',
               lc_fr1          TYPE i_operationalacctgdocitem-transactiontypedetermination VALUE 'FR1',
               lc_fr3          TYPE i_operationalacctgdocitem-transactiontypedetermination VALUE 'FR3',
               lc_kr           TYPE i_operationalacctgdocitem-accountingdocumenttype VALUE 'KR',
               lc_kg           TYPE i_operationalacctgdocitem-accountingdocumenttype VALUE 'KG',
               lc_re           TYPE i_operationalacctgdocitem-accountingdocumenttype VALUE 'RE',
               lc_we           TYPE i_operationalacctgdocitem-accountingdocumenttype VALUE 'WE',
               lc_kd           TYPE i_operationalacctgdocitem-accountingdocumenttype VALUE 'KD',
               lc_m            TYPE i_operationalacctgdocitem-financialaccounttype VALUE 'M',
               lc_k            TYPE i_operationalacctgdocitem-financialaccounttype VALUE 'K',
               lc_101          TYPE i_materialdocumentitem_2-goodsmovementtype VALUE '101',
               lc_102          TYPE i_materialdocumentitem_2-goodsmovementtype VALUE '102',
               lc_mh_cgstgl    TYPE i_operationalacctgdocitem-glaccount VALUE '12605902',
               lc_mh_sgstgl    TYPE i_operationalacctgdocitem-glaccount VALUE '12605901',
               lc_mh_igstgl    TYPE i_operationalacctgdocitem-glaccount VALUE '12605900',
               lc_mp_cgstgl    TYPE i_operationalacctgdocitem-glaccount VALUE '12605905',
               lc_mp_sgstgl    TYPE i_operationalacctgdocitem-glaccount VALUE '12605904',
               lc_mp_igstgl    TYPE i_operationalacctgdocitem-glaccount VALUE '12605903',
               lc_joig         TYPE i_billingdocitemprcgelmntbasic-conditiontype VALUE 'JOIG',              "  added by siddharth
               lc_is           TYPE i_operationalacctgdocitem-taxcode VALUE 'IS',                           "  added by siddharth
               lc_1007         TYPE i_operationalacctgdocitem-plant VALUE '1007',
               lc_fiscalyear   TYPE string VALUE 'FISCALYEAR'.

    DATA: lr_posting_date  TYPE RANGE OF i_operationalacctgdocitem-postingdate,
          lr_acct_documnt  TYPE RANGE OF i_purchaseorderhistoryapi01-purchasinghistorydocument,
          lr_journal_entry TYPE RANGE OF i_operationalacctgdocitem-accountingdocument,
          lr_fiscalyear    TYPE RANGE OF i_operationalacctgdocitem-fiscalyear.

    DATA: lt_pur_data  TYPE STANDARD TABLE OF ty_purchreg,
          lt_tax_rates TYPE STANDARD TABLE OF ty_taxes.



    DATA: l_cgstamount    TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
          l_sgstamount    TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
          l_igstamount    TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
          l_rcmcgstamount TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
          l_rcmsgstamount TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
          l_rcmigstamount TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
          l_tdsamount     TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
          prev_accdoc     TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
          taxableamount   TYPE i_operationalacctgdocitem-taxbaseamountincocodecrcy. ",
    "lv_cgsrate type i_operationalacctgdocitem-amountincompanycodecurrency,

    DATA: isfirstrun TYPE abap_bool VALUE 'X'.                                " added by siddharth
    DATA: lv_referenced_document TYPE  string,                                "  added by siddharth
          referenced_document    TYPE  string.


    TRY.
        DATA(lv_top) = io_request->get_paging( )->get_page_size( ).
        IF lv_top < 0.
          lv_top = 1.
        ENDIF.

        DATA(lv_skip) = io_request->get_paging( )->get_offset( ).

        DATA(lt_filters) =  io_request->get_filter( )->get_as_ranges( ).
        IF lt_filters[] IS NOT INITIAL.
          LOOP AT lt_filters INTO DATA(lw_filters).
            CASE lw_filters-name.
              WHEN lc_postingdate.
                lr_posting_date = CORRESPONDING #( lw_filters-range ).

              WHEN lc_acctdocumnt.
                lr_acct_documnt = CORRESPONDING #( lw_filters-range ).

              WHEN lc_journalentry.
                lr_journal_entry = CORRESPONDING #( lw_filters-range ).
              WHEN lc_fiscalyear.
                lr_fiscalyear = CORRESPONDING #( lw_filters-range ).
            ENDCASE.

            CLEAR lw_filters.
          ENDLOOP.

          SELECT a~postingdate,
                 a~profitcenter,
                 a~businessplace,
                 a~accountingdocumenttype,
                 a~companycode,
                 a~accountingdocument,
                 a~accountingdocumentitem,
                 a~accountingdocumentitemtype,
                 a~fiscalyear,
                 a~documentdate,
                 a~numberofitems,
                 a~product,
                 a~baseunit,
                 a~in_hsnorsaccode,
                 a~purchasingdocument,
                 a~purchasingdocumentitem,
                 a~purchaseorderqty,
                 a~amountintransactioncurrency,
                 a~transactioncurrency,
                 a~amountincompanycodecurrency,
                 a~companycodecurrency,
                 a~glaccount,
                 a~taxcode,
                 a~withholdingtaxcode,
                 a~assignmentreference,
                 a~transactiontypedetermination,
                 a~supplier,
                 a~costcenter,
                 a~plant,
                 a~wbselementinternalid,
                 a~financialaccounttype,
                 a~reference3idbybusinesspartner,
                 a~documentitemtext,
                 a~taxbaseamountincocodecrcy,
                 a~taxitemgroup,
                 a~originalreferencedocument,
                 b~purchaseorderdate,
                 b~purchasinggroup,
                 c~suppliername,
                 c~region,
                 c~taxnumber3,
                 c~businesspartnerpannumber,
                 d~productdescription,
                 e~glaccountname,
                 f~documentreferenceid,
                 f~reversalreferencedocument,
                 f~accountingdocumentheadertext,                   "  added by siddharth
                 g~project,
                 g~investmentprofile                               "  added by siddharth
                 "h~FIXEDASSETEXTERNALID                           "  added by siddharth
            FROM i_operationalacctgdocitem AS a
            LEFT OUTER JOIN i_purchaseorderapi01 AS b
            ON a~purchasingdocument = b~purchaseorder
            LEFT OUTER JOIN i_supplier AS c
            ON a~supplier = c~supplier
            LEFT OUTER JOIN i_productdescription_2 AS d
            ON a~product = d~product
            LEFT OUTER JOIN i_glaccounttext AS e
            ON a~glaccount = e~glaccount
            LEFT OUTER JOIN i_journalentry AS f
            ON a~companycode = f~companycode
            AND a~accountingdocument = f~accountingdocument
            AND a~fiscalyear = f~fiscalyear
            LEFT OUTER JOIN i_enterpriseproject AS g
            ON a~wbselementinternalid = g~wbselementinternalid
            "LEFT OUTER JOIN I_FIXEDASSET as h
            "ON a~WBSElementInternalID = h~INVESTMENTPROJECTWBSELEMENT_2
            WHERE ( transactiontypedetermination IN ( @lc_wrx, @lc_kbs )
            OR ( ( transactiontypedetermination EQ @space AND a~costcenter NE @space )
            OR transactiontypedetermination IN ( @lc_egk, @lc_wit, @lc_jic, @lc_jii, @lc_jis, @lc_bsx, @lc_fr1, @lc_fr3 ) ) )
            AND a~postingdate IN @lr_posting_date
            AND a~accountingdocument IN @lr_journal_entry
            AND a~accountingdocumenttype IN ( @lc_re, @lc_kr, @lc_kg, @lc_kd )

            INTO TABLE @DATA(lt_accounting).
          IF sy-subrc EQ 0.
            DATA(lt_sto_documents) = lt_accounting.
            "DELETE lt_sto_documents WHERE documentreferenceid IS INITIAL.
            "IF lt_sto_documents[] IS NOT INITIAL.
            SELECT "a~documentreferenceid,
                   a~supplier,
                   a~accountingdocument,
                   a~transactiontypedetermination,
                   a~financialaccounttype,
                   a~fiscalyear,
                   b~suppliername,
                   b~region,
                   b~taxnumber3,
                   b~businesspartnerpannumber
              FROM i_operationalacctgdocitem AS a
              INNER JOIN i_supplier AS b
              ON a~supplier EQ b~supplier
              FOR ALL ENTRIES IN @lt_sto_documents
              WHERE  accountingdocument = @lt_sto_documents-accountingdocument
              AND a~fiscalyear IN @lr_fiscalyear
              INTO TABLE @DATA(lt_sto_suppliers).
          ENDIF.

          DATA(lt_purchase_orders) = lt_accounting.
          DELETE lt_purchase_orders WHERE purchasingdocument IS INITIAL.

          IF lt_purchase_orders[] IS NOT INITIAL.
            SELECT a~purchaseorder,
                   a~purchaseorderitem,
                   a~materialdocument,
                   a~materialdocumentitem,
                   a~materialdocumentitemtext,
                   a~quantityinbaseunit,
                   a~reversedmaterialdocument,
                   a~reversedmaterialdocumentitem,
                   a~reversedmaterialdocumentyear,
                   a~goodsmovementtype,
                   a~postingdate,
                   a~documentdate,
*                     a~YY1_MM_HSNCodeinMIGO_MMI,
                   b~purchasinghistorydocument,
                   b~documentreferenceid,
                   b~referencedocument,
                   b~referencedocumentitem,
                   "c~ReferenceDocument
                   d~producttype
              FROM i_materialdocumentitem_2 AS a
              INNER JOIN i_purchaseorderhistoryapi01 AS b
              ON a~purchaseorder = b~purchaseorder
              AND a~purchaseorderitem = b~purchaseorderitem
              AND a~materialdocument = b~referencedocument   "
              AND a~materialdocumentitem = b~referencedocumentitem
              INNER JOIN i_materialdocumentheader_2 AS c
              ON a~materialdocument = c~materialdocument
              INNER JOIN i_product AS d
              ON a~material = d~product
              FOR ALL ENTRIES IN @lt_purchase_orders
              WHERE a~purchaseorder EQ @lt_purchase_orders-purchasingdocument
              AND a~purchaseorderitem EQ @lt_purchase_orders-purchasingdocumentitem
              AND a~goodsmovementtype IN ( @lc_101, @lc_102 )
              AND b~purchasinghistorycategory EQ @lc_q
              AND b~purchasinghistorydocument IN @lr_acct_documnt
              INTO TABLE @DATA(lt_purchasing).


            SELECT
                   a~purchaseorder,
                   a~purchaseorderitem,
                   a~materialdocument,
                   a~materialdocumentitem,
                   a~materialdocumentitemtext,
                   a~quantityinbaseunit,
                   a~reversedmaterialdocument,
                   a~reversedmaterialdocumentitem,
                   a~reversedmaterialdocumentyear,
                   a~goodsmovementtype,
                   a~postingdate,
                   a~documentdate,
                   b~purchasinghistorydocument,
                   b~documentreferenceid,
                   b~referencedocument,
                   b~referencedocumentitem,
                   d~producttype,
                   e~materialdocument AS service_matdoc
              FROM i_materialdocumentitem_2 AS a
              INNER JOIN i_purchaseorderhistoryapi01 AS b
                ON a~purchaseorder = b~purchaseorder
               AND a~purchaseorderitem = b~purchaseorderitem
              INNER JOIN i_materialdocumentheader_2 AS c
                ON a~materialdocument = c~materialdocument
              INNER JOIN i_product AS d
                ON a~material = d~product
              LEFT OUTER JOIN i_serviceentrysheetapi01 AS e
                ON e~serviceentrysheet = b~referencedocument
               AND e~purchaseorder      = a~purchaseorder
              FOR ALL ENTRIES IN @lt_purchase_orders
              WHERE a~purchaseorder     = @lt_purchase_orders-purchasingdocument
                AND a~purchaseorderitem = @lt_purchase_orders-purchasingdocumentitem
                AND a~goodsmovementtype IN ( @lc_101, @lc_102 )
                AND b~purchasinghistorycategory = @lc_q
                AND b~purchasinghistorydocument IN @lr_acct_documnt
                AND d~producttype = 'ZSER'
              INTO TABLE @DATA(lt_purchasing2).


            IF lt_purchasing2 IS NOT INITIAL.
              LOOP AT lt_purchasing2 ASSIGNING FIELD-SYMBOL(<fs_purch2>).
                IF <fs_purch2>-materialdocument EQ <fs_purch2>-service_matdoc.
                  <fs_purch2>-referencedocument = <fs_purch2>-service_matdoc.
                ENDIF.
                APPEND <fs_purch2> TO lt_purchasing.
                CLEAR <fs_purch2>.
              ENDLOOP.
            ENDIF.


            IF lt_purchasing IS NOT INITIAL.
              DATA(lt_cancelled) = lt_purchasing.
              DELETE lt_cancelled WHERE goodsmovementtype EQ lc_101.

              DATA(lt_matdoc) = lt_purchasing.
              DELETE lt_matdoc WHERE goodsmovementtype EQ lc_102.

              IF lt_cancelled[] IS NOT INITIAL.
                LOOP AT lt_matdoc ASSIGNING FIELD-SYMBOL(<ls_matdoc>).
                  IF line_exists( lt_cancelled[ reversedmaterialdocument = <ls_matdoc>-materialdocument ] ).
                    DELETE lt_matdoc INDEX sy-tabix.
                  ENDIF.
                ENDLOOP.
                UNASSIGN <ls_matdoc>.
              ENDIF.
            ENDIF.
          ENDIF.

          SELECT "a~BILLINGDOCUMENT,                                                  "  added by siddharth
                 a~documentreferenceid,
                 b~conditionratevalue,
                 c~billingdocument,
                 c~billingdocumentitem,
                 c~product
          FROM i_billingdocument AS a
          LEFT OUTER JOIN i_billingdocitemprcgelmntbasic AS b
          ON a~billingdocument = b~billingdocument
          LEFT OUTER JOIN i_billingdocumentitem AS c
          ON a~billingdocument = c~billingdocument
          AND b~billingdocumentitem = c~billingdocumentitem
          FOR ALL ENTRIES IN @lt_sto_documents
          WHERE a~documentreferenceid EQ @lt_sto_documents-documentreferenceid
          AND b~conditiontype = @lc_joig
          INTO TABLE @DATA(lt_billingdocpric).                                         "  added by siddharth

          LOOP AT lt_purchasing INTO DATA(ls_purchasing).                              "  added by siddharth
            lv_referenced_document = ls_purchasing-documentreferenceid.
            TRANSLATE lv_referenced_document TO UPPER CASE.
            ls_purchasing-documentreferenceid = lv_referenced_document.
            MODIFY lt_purchasing FROM ls_purchasing.
          ENDLOOP.

          LOOP AT lt_accounting INTO DATA(ls_accounting).                              "  added by siddharth
            referenced_document = ls_accounting-originalreferencedocument+0(10).
            ls_accounting-originalreferencedocument = referenced_document.
            MODIFY lt_accounting FROM ls_accounting.
          ENDLOOP.


          DATA(lo_data_retrieval) = cl_cbo_developer_access=>business_object( lc_bo )->root_node( )->data_retrieval( ).
          DATA(lt_records) = lo_data_retrieval->get_records( )->resolve( ).
          IF lt_records[] IS NOT INITIAL.
            LOOP AT lt_records ASSIGNING FIELD-SYMBOL(<ls_records>).
              DATA(ls_data_object) = <ls_records>->get_data_object( )->get_reference( ).
              APPEND VALUE #( taxcode  = ls_data_object->(lc_taxcode)
                              cgstrate = ls_data_object->(lc_cgst)
                              sgstrate = ls_data_object->(lc_sgst)
                              igstrate = ls_data_object->(lc_igst)
                              rcmapplicable = ls_data_object->(lc_rcmappl) ) TO lt_tax_rates.

            ENDLOOP.
            UNASSIGN <ls_records>.
          ENDIF.

          SELECT accountingdocument,
                 glaccount,
                 reference3idbybusinesspartner,
                 transactiontypedetermination,
                 accountingdocumenttype
            FROM i_operationalacctgdocitem
            FOR ALL ENTRIES IN @lt_accounting
            WHERE reference3idbybusinesspartner EQ @lt_accounting-reference3idbybusinesspartner
            AND reference3idbybusinesspartner IS NOT INITIAL
            AND transactiontypedetermination EQ @lc_wrx
            AND accountingdocumenttype EQ @lc_we
            INTO TABLE @DATA(lt_weaccounting).


          IF sy-subrc EQ 0.
            SELECT accountingdocument,
                   glaccount,
                   transactiontypedetermination
            FROM i_operationalacctgdocitem
              FOR ALL ENTRIES IN @lt_weaccounting
              WHERE accountingdocument EQ @lt_weaccounting-accountingdocument
              AND transactiontypedetermination EQ @lc_bsx
              INTO TABLE @DATA(lt_weglaccounting).
          ENDIF.

          LOOP AT lt_accounting ASSIGNING FIELD-SYMBOL(<ls_accounting>)
               WHERE ( transactiontypedetermination EQ lc_wrx
                            OR transactiontypedetermination EQ lc_fr1
                            OR transactiontypedetermination EQ lc_fr3 )
*                    OR ( transactiontypedetermination EQ space AND costcenter IS NOT INITIAL ).
                  OR ( transactiontypedetermination EQ lc_kbs AND costcenter IS NOT INITIAL )
                  OR ( transactiontypedetermination EQ space AND costcenter IS NOT INITIAL ).
            DATA(ls_supplier) = VALUE #( lt_sto_suppliers[ accountingdocument           = <ls_accounting>-accountingdocument
                                                        "transactiontypedetermination = lc_egk
                                                        financialaccounttype = lc_k ] OPTIONAL ).
            "IF ls_supplier IS INITIAL.
            " ls_supplier = VALUE #( lt_accounting[ accountingdocument = <ls_accounting>-accountingdocument
            "                                       transactiontypedetermination = lc_kbs
            "                                      FinancialAccountType = lc_k ] OPTIONAL ).
            " IF ls_supplier IS INITIAL.
            "   DATA(ls_sto_suppliers) = VALUE #( lt_sto_suppliers[ documentreferenceid = <ls_accounting>-documentreferenceid ] OPTIONAL ).
            "   IF ls_sto_suppliers IS NOT INITIAL.
            "     ls_supplier = CORRESPONDING #( ls_sto_suppliers ).
            "     ls_supplier-supplier = ls_sto_suppliers-soldtoparty.
            "   ENDIF.
            "  ENDIF.
            " ENDIF.

            DATA(ls_matdoc) = VALUE #( lt_purchasing[ purchaseorder     = <ls_accounting>-purchasingdocument
                                                      purchaseorderitem = <ls_accounting>-purchasingdocumentitem ] OPTIONAL ).

            DATA(ls_matdoc1) = VALUE #( lt_purchasing[ purchaseorder     = <ls_accounting>-purchasingdocument
*                                                      documentreferenceid  = <ls_accounting>-documentreferenceid
                                                      purchaseorderitem = <ls_accounting>-purchasingdocumentitem
                                                      purchasinghistorydocument = <ls_accounting>-originalreferencedocument
                                                       ] OPTIONAL ).



            DATA(ls_taxcalcgst) = VALUE #( lt_accounting[ accountingdocument = <ls_accounting>-accountingdocument
                                                          taxitemgroup = <ls_accounting>-taxitemgroup
                                                          transactiontypedetermination = lc_jic
                                                       ] OPTIONAL ).
            DATA(ls_taxcalsgst) = VALUE #( lt_accounting[ accountingdocument = <ls_accounting>-accountingdocument
                                                          taxitemgroup = <ls_accounting>-taxitemgroup
                                                          transactiontypedetermination = lc_jis
                                                      ] OPTIONAL ).
            DATA(ls_taxcaligst) = VALUE #( lt_accounting[ accountingdocument = <ls_accounting>-accountingdocument
                                                          taxitemgroup = <ls_accounting>-taxitemgroup
                                                          transactiontypedetermination = lc_jii
                                                      ] OPTIONAL ).

            DATA(ls_tax_rates) = VALUE #( lt_tax_rates[ taxcode = <ls_accounting>-taxcode ] OPTIONAL ).

            DATA(ls_stotax_rates) = VALUE #( lt_billingdocpric[ documentreferenceid = <ls_accounting>-documentreferenceid
                                                                product = <ls_accounting>-product ] OPTIONAL ).

            IF ls_tax_rates IS NOT INITIAL.
              IF ls_tax_rates-rcmapplicable EQ abap_true.                                                                        "added by siddharth
                l_rcmcgstamount = ls_taxcalcgst-taxbaseamountincocodecrcy * ( ls_tax_rates-cgstrate / 100 ).
                l_rcmsgstamount = ls_taxcalsgst-taxbaseamountincocodecrcy * ( ls_tax_rates-sgstrate / 100 ).
                l_rcmigstamount = ls_taxcaligst-taxbaseamountincocodecrcy * ( ls_tax_rates-igstrate / 100 ).

              ELSE.
                l_cgstamount = ls_taxcalcgst-taxbaseamountincocodecrcy * ( ls_tax_rates-cgstrate / 100 ).
                l_sgstamount = ls_taxcalsgst-taxbaseamountincocodecrcy * ( ls_tax_rates-sgstrate / 100 ).
                l_igstamount = ls_taxcaligst-taxbaseamountincocodecrcy * ( ls_tax_rates-igstrate / 100 ).
                IF <ls_accounting>-taxcode = 'IS'.
                  l_igstamount = <ls_accounting>-taxbaseamountincocodecrcy * ( ls_stotax_rates-conditionratevalue / 100 ).
                ENDIF.
              ENDIF.
            ENDIF.


            DATA(ls_taxcal) = VALUE #( lt_accounting[ accountingdocument = <ls_accounting>-accountingdocument
                                                      transactiontypedetermination = lc_jic
                                                      taxitemgroup = <ls_accounting>-taxitemgroup ] OPTIONAL ).
            DATA(ls_taxcal1) = VALUE #( lt_accounting[ accountingdocument = <ls_accounting>-accountingdocument
                                                     transactiontypedetermination = lc_jii
                                                     taxitemgroup = <ls_accounting>-taxitemgroup ] OPTIONAL ).
            DATA(ls_bsx) = VALUE #( lt_accounting[ accountingdocument = <ls_accounting>-accountingdocument
                                                     transactiontypedetermination = lc_bsx
                                                      ] OPTIONAL ).

            IF ls_bsx-transactiontypedetermination = lc_bsx.                                                      "added by siddharth
              IF ls_taxcal-transactiontypedetermination = lc_jic.
                taxableamount = ls_taxcal-taxbaseamountincocodecrcy.
              ELSEIF ls_taxcal-transactiontypedetermination = lc_jis.
                taxableamount = ls_taxcal-taxbaseamountincocodecrcy.
              ELSEIF ls_taxcal1-transactiontypedetermination = lc_jii.
                taxableamount = ls_taxcal1-taxbaseamountincocodecrcy.
              ENDIF.
            ELSE.

              DATA(ls_tax_rate) = VALUE #( lt_tax_rates[ taxcode = <ls_accounting>-taxcode ] OPTIONAL ).
              IF ls_tax_rates IS NOT INITIAL.
                IF ls_tax_rates-rcmapplicable EQ abap_true.
                  l_rcmcgstamount = <ls_accounting>-amountincompanycodecurrency * ( ls_tax_rates-cgstrate / 100 ).
                  l_rcmsgstamount = <ls_accounting>-amountincompanycodecurrency * ( ls_tax_rates-sgstrate / 100 ).
                  l_rcmigstamount = <ls_accounting>-amountincompanycodecurrency * ( ls_tax_rates-igstrate / 100 ).
                ELSE.
                  l_cgstamount = <ls_accounting>-amountincompanycodecurrency * ( ls_tax_rates-cgstrate / 100 ).
                  l_sgstamount = <ls_accounting>-amountincompanycodecurrency * ( ls_tax_rates-sgstrate / 100 ).
                  l_igstamount = <ls_accounting>-amountincompanycodecurrency * ( ls_tax_rates-igstrate / 100 ).
                  IF <ls_accounting>-taxcode = 'IS'.
                    l_igstamount = <ls_accounting>-amountincompanycodecurrency * ( ls_stotax_rates-conditionratevalue / 100 ).
                  ENDIF.
                  taxableamount = <ls_accounting>-amountincompanycodecurrency.
                ENDIF.
              ENDIF.

            ENDIF.

            IF <ls_accounting>-plant IS NOT INITIAL.
              DATA(l_plant) = <ls_accounting>-plant.
            ELSEIF <ls_accounting>-costcenter IS NOT INITIAL.
              l_plant = <ls_accounting>-costcenter+0(4).
            ENDIF.



            DATA(ls_tds) = VALUE #( lt_accounting[ accountingdocument = <ls_accounting>-accountingdocument
                                                   transactiontypedetermination = lc_wit ] OPTIONAL ).

            IF <ls_accounting>-accountingdocument = ls_tds-accountingdocument.

              AT NEW accountingdocument.
                IF <ls_accounting>-accountingdocumentitem = '002'.
                  IF ls_tds-amountincompanycodecurrency IS NOT INITIAL.
                    l_tdsamount = ls_tds-amountincompanycodecurrency.
                  ENDIF.
                ENDIF.
                ls_tds-amountincompanycodecurrency = 0.
              ENDAT.
            ENDIF.


            APPEND VALUE #( postingdate                 = <ls_accounting>-postingdate
                            profitcenter                = <ls_accounting>-profitcenter
                            businessplace               = <ls_accounting>-businessplace
                            documenttype                = <ls_accounting>-accountingdocumenttype
                            "accountingdocument          = ls_matdoc-purchasinghistorydocument
                            accountingdocument          = ls_matdoc1-purchasinghistorydocument
                            journalentry                = <ls_accounting>-accountingdocument
                            journalentryitem            = <ls_accounting>-accountingdocumentitem
                            refdocno                    = <ls_accounting>-documentreferenceid
                            documentdate                = <ls_accounting>-documentdate
                            refdocitem                  = <ls_accounting>-numberofitems
                            supplier                    = ls_supplier-supplier
                            suppliername                = ls_supplier-suppliername
                            supplierregion              = ls_supplier-region
                            supplierstate               = ls_supplier-region
                            suppliergstin               = ls_supplier-taxnumber3
                            supplierpanno               = ls_supplier-businesspartnerpannumber
                            material                    = <ls_accounting>-product
                            materialdescription         = <ls_accounting>-productdescription
                            unitofmeasure               = <ls_accounting>-baseunit
                            materialbaseunit            = <ls_accounting>-baseunit
                            hsncode                     = <ls_accounting>-in_hsnorsaccode
                            purchaseorderdate           = <ls_accounting>-purchaseorderdate
                            purchaseorder               = <ls_accounting>-purchasingdocument
                            purchaseorderitem           = <ls_accounting>-purchasingdocumentitem
                            purchaseorderqty            = <ls_accounting>-purchaseorderqty
                            grnquantity                 = ls_matdoc-quantityinbaseunit
                            amountintransactioncurrency = <ls_accounting>-amountintransactioncurrency
                            transactioncurrency         = <ls_accounting>-transactioncurrency
                            amountincompanycodecurrency = <ls_accounting>-amountincompanycodecurrency
                            companycodecurrency         = <ls_accounting>-companycodecurrency
                            glaccount                   = <ls_accounting>-glaccount
                            glaccountname               = <ls_accounting>-glaccountname
                            cgstglaccount               = COND #( WHEN l_plant EQ lc_1007 THEN lc_mp_cgstgl ELSE lc_mh_cgstgl )
                            sgstglaccount               = COND #( WHEN l_plant EQ lc_1007 THEN lc_mp_sgstgl ELSE lc_mh_sgstgl )
                            igstglaccount               = COND #( WHEN l_plant EQ lc_1007 THEN lc_mp_igstgl ELSE lc_mh_igstgl )
                            taxcode                     = <ls_accounting>-taxcode
                            baseamount                  = <ls_accounting>-amountincompanycodecurrency
                            taxableamount               = taxableamount
                            cgstrate                    = COND #( WHEN ls_tax_rates-rcmapplicable EQ abap_false THEN ls_tax_rates-cgstrate )
                            cgstamount                  = l_cgstamount
                            sgstrate                    = COND #( WHEN ls_tax_rates-rcmapplicable EQ abap_false THEN ls_tax_rates-sgstrate )
                            sgstamount                  = l_sgstamount
                            "igstrate                    = ls_tax_rates-igstrate
                            igstrate                    = COND #( WHEN <ls_accounting>-taxcode EQ lc_is THEN ls_stotax_rates-conditionratevalue
                                                                ELSE COND #( WHEN ls_tax_rates-rcmapplicable EQ abap_false THEN ls_tax_rates-igstrate ) )
                            igstamount                  = l_igstamount
                            rcmcgstrate                 = COND #( WHEN ls_tax_rates-rcmapplicable EQ abap_true THEN ls_tax_rates-cgstrate )
                            rcmcgstamount               = l_rcmcgstamount
                            rcmsgstrate                 = COND #( WHEN ls_tax_rates-rcmapplicable EQ abap_true THEN ls_tax_rates-sgstrate )
                            rcmsgstamount               = l_rcmsgstamount
                            rcmigstrate                 = COND #( WHEN ls_tax_rates-rcmapplicable EQ abap_true THEN ls_tax_rates-igstrate )
                            rcmigstamount               = l_rcmigstamount
                            "withhldtaxamount            = VALUE #( lt_accounting[ accountingdocument = <ls_accounting>-accountingdocument
                            "                                                      transactiontypedetermination = lc_wit ]-amountincompanycodecurrency OPTIONAL )
                            "withhldtaxamount            = ls_tds-AmountInCompanyCodeCurrency
                            withhldtaxamount            = l_tdsamount                                                              " added by siddharth
                            netinvoiceamount            = <ls_accounting>-amountincompanycodecurrency + l_cgstamount + l_sgstamount + l_igstamount + l_rcmcgstamount + l_rcmsgstamount + l_rcmigstamount +  l_tdsamount  "added by siddharth
                                                         " VALUE #( lt_accounting[ accountingdocument = <ls_accounting>-accountingdocument
                                                         "                         transactiontypedetermination = lc_wit ]-amountincompanycodecurrency OPTIONAL )
                            totaltaxamount              = l_cgstamount + l_sgstamount + l_igstamount + l_rcmcgstamount + l_rcmsgstamount + l_rcmigstamount
                            withhldtaxcode              = VALUE #( lt_accounting[ accountingdocument = <ls_accounting>-accountingdocument
                                                                                  transactiontypedetermination = lc_wit ]-withholdingtaxcode OPTIONAL )
                            "materialdocument            = ls_matdoc-materialdocument
                            materialdocument            = ls_matdoc1-materialdocument
*                            narration                   = ls_matdoc-materialdocumentitemtext
                            assignment                  = <ls_accounting>-assignmentreference

                            wedocno                     = VALUE #( lt_weaccounting[ reference3idbybusinesspartner = <ls_accounting>-reference3idbybusinesspartner   "added by yash
                                                                                  transactiontypedetermination = lc_wrx
                                                                                  accountingdocumenttype = lc_we ]-accountingdocument OPTIONAL )
                            wepostingdt                 = ls_matdoc-postingdate                                                                                       "added by yash
                            grndocumentdt               = ls_matdoc-documentdate                                                                                       "added by yash
                            grnrefno                    = ls_matdoc-referencedocument                                                                                  "added by yash
*                              grnhsncode                  = ls_matdoc-YY1_MM_HSNCodeinMIGO_MMI                                                                             "added by yash
                            purchasegrp                 = <ls_accounting>-purchasinggroup                                                                                  "added by yash
                            weglcode                    = VALUE #( lt_weglaccounting[ accountingdocument = VALUE #( lt_weaccounting[ reference3idbybusinesspartner = <ls_accounting>-reference3idbybusinesspartner
                                                                                      transactiontypedetermination = lc_wrx
                                                                                      accountingdocumenttype = lc_we ]-accountingdocument OPTIONAL ) ]-glaccount OPTIONAL )          "added by yash
                            wbselement                  = <ls_accounting>-project                                                                                                  "added by yash
                            reversalreference           = <ls_accounting>-reversalreferencedocument
                            documentitemtext            = <ls_accounting>-documentitemtext
                            taxitemgroup                = <ls_accounting>-taxitemgroup
                            investmentprofile           = <ls_accounting>-investmentprofile                 "  added by siddharth
                            narrationheaderdata         = <ls_accounting>-accountingdocumentheadertext      "   added by siddharth
                            krhsncode                   = <ls_accounting>-assignmentreference               "  added by siddharth
                          ) TO lt_pur_data.

            CLEAR: ls_supplier, ls_matdoc, ls_tax_rates, ls_taxcalcgst, ls_taxcalsgst, ls_taxcaligst, ls_taxcal, ls_taxcal1, taxableamount, l_tdsamount, ls_tds,
                   l_cgstamount, l_sgstamount, l_igstamount, l_rcmcgstamount, l_rcmsgstamount, l_rcmigstamount, l_plant, ls_tax_rates.
          ENDLOOP.

          SORT lt_pur_data ASCENDING BY journalentry journalentryitem.
        ENDIF.
        " ENDIF.

        DATA(skip) = io_request->get_paging( )->get_offset( ).
        DATA(top) = io_request->get_paging( )->get_page_size( ).
        IF top < 0.
          top = 1.
        ENDIF.

        DATA(lv_start) = skip + 1.
        DATA(lv_end) = skip + top.

        APPEND LINES OF lt_pur_data  FROM lv_start TO lv_end TO gt_purchreg.
        io_response->set_total_number_of_records( lines( lt_pur_data ) ).
        io_response->set_data( gt_purchreg ).

        CLEAR lt_pur_data.
      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
