CLASS zcl_stock_aging DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
    TYPES: BEGIN OF ty_stock_aging,

             product         TYPE i_productplantbasic-product,
             productname     TYPE i_producttext-productname,
             plant           TYPE i_productplantbasic-plant,
             storagelocation TYPE i_stockquantitycurrentvalue_2-storagelocation,
             materialtype    TYPE i_product-producttype,
             selectiondate   TYPE d,
             lt_30           TYPE string,
             lt_30_amt       TYPE string,
             bt_31_60        TYPE string,
             bt_31_60_amt    TYPE string,
             bt_61_90        TYPE string,
             bt_61_90_amt    TYPE string,
             bt_91_180       TYPE string,
             bt_91_180_amt   TYPE string,
             bt_181_365      TYPE string,
             bt_181_365_amt  TYPE string,
             gt_365          TYPE string,
             gt_365_amt      TYPE string,

           END OF ty_stock_aging.

    DATA: gt_stock_aging TYPE STANDARD TABLE OF ty_stock_aging.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_STOCK_AGING IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA: lt_stock_aging TYPE STANDARD TABLE OF ty_stock_aging.

    DATA: lv_productplant_con    TYPE string,
          lv_stock_con           TYPE string,
          lv_productplantmat_con TYPE string,
          lv_selectiondate       TYPE d,
          lv_price               TYPE p DECIMALS 2.
*          lv_qty                 TYPE p DECIMALS 3.

    CONSTANTS: lc_product         TYPE string VALUE 'PRODUCT',
               lc_plant           TYPE string VALUE 'PLANT',
               lc_dates           TYPE string VALUE 'SELECTIONDATE',
               lc_storagelocation TYPE string VALUE 'STORAGELOCATION',
               lc_materialtype    TYPE string VALUE 'MATERIALTYPE'.
    TYPES ty_qty TYPE i_stockquantitycurrentvalue_2-matlwrhsstkqtyinmatlbaseunit.
    TRY.
        DATA(lt_filters) = io_request->get_filter( )->get_as_ranges( ).
        IF lt_filters[] IS NOT INITIAL.
          DATA(lr_product) = VALUE #( lt_filters[ name = lc_product ]-range OPTIONAL ).
          DATA(lr_plant) = VALUE #( lt_filters[ name = lc_plant ]-range OPTIONAL ).
          DATA(lr_storagelocation) = VALUE #( lt_filters[ name = lc_storagelocation ]-range OPTIONAL ).
          DATA(lr_materialtype) = VALUE #( lt_filters[ name = lc_materialtype ]-range OPTIONAL ).
          DATA(lr_selectiondate) = VALUE #( lt_filters[ name = lc_dates ]-range OPTIONAL ).

          IF lr_selectiondate IS NOT INITIAL.
            lv_selectiondate = lr_selectiondate[ 1 ]-low.
          ENDIF.

          SELECT a~product,
                 a~plant,

                 b~productname,

                 c~producttype

          FROM i_productplantbasic AS a

          INNER JOIN i_producttext AS b
                ON a~product = b~product

          INNER JOIN i_product AS c
                ON a~product = c~product

          WHERE a~product IN @lr_product
          AND a~plant IN @lr_plant
          AND c~producttype IN @lr_materialtype
          INTO TABLE @DATA(lt_productbasic).


          IF lt_productbasic IS NOT INITIAL.
*         Select query to fetch Product, ValuationArea(Plant),InventoryValuationProcedure,
*                               StandardPrice and MovingAveragePrice from I_ProductValuation
            SELECT product,
                   valuationarea,
                   inventoryvaluationprocedure,
                   standardprice,
                   movingaverageprice
            FROM i_productvaluationbasic
            FOR ALL ENTRIES IN @lt_productbasic
            WHERE product = @lt_productbasic-product
            AND valuationarea = @lt_productbasic-plant
            AND valuationtype IS INITIAL
            INTO TABLE @DATA(lt_valuation).

*         Select query to fetch Material(Product), Plant, StorageLocation, MaterialBaseUnit
*                               GoodsMovementType and PostingDate from I_MaterialDocumentItem_2.
            SELECT material,
                   plant,
                   storagelocation,
                   materialbaseunit,
                   goodsmovementtype,
                   postingdate
            FROM i_materialdocumentitem_2
            WHERE material IN @lr_product
            AND plant IN @lr_plant
            AND storagelocation IN @lr_storagelocation
            AND postingdate LE @lv_selectiondate
*                AND (  goodsmovementtype = '101'
*                    OR goodsmovementtype = '201'
*                    OR goodsmovementtype = '261'
*                    OR goodsmovementtype = '561'
*                    OR goodsmovementtype = '701'
*                    OR goodsmovementtype = '702' )
            INTO TABLE @DATA(lt_material).

*         Select query to fetch Product, Plant, StorageLocation, InventorySpecialStockType
*                               and MatlWrhsStkQtyInMatlBaseUnit from I_StockQuantityCurrentValue_2.
*            SELECT product,
*            plant,
*            storagelocation,
*            inventoryspecialstocktype,
*            matlwrhsstkqtyinmatlbaseunit
*            FROM i_stockquantitycurrentvalue_2(
*                    p_displaycurrency = 'INR' ) AS a
*            WHERE "(lv_stock_con)
*                  a~product IN @lr_product
*                  AND a~plant IN @lr_plant
*                  AND a~producttype IN @lr_materialtype
*                  AND a~storagelocation IN @lr_storagelocation
*                  AND inventoryspecialstocktype IS INITIAL
*                  AND product IS NOT INITIAL
*                  AND valuationareatype = 1
*            INTO TABLE @DATA(lt_stockquantity).


* Added 06.10.2025 instead of the above select query to find the stock quantity as per the selection date
* instead of finding the stock based on current date.
            SELECT material AS product,
                   plant,
                   storagelocation,
                   inventoryspecialstocktype,
                   matlwrhsstkqtyinmatlbaseunit
                   FROM i_materialstock_2
                WHERE material IN @lr_product
                    AND plant IN @lr_plant
                    AND storagelocation IN @lr_storagelocation
                    AND inventoryspecialstocktype IS INITIAL
                    AND material IS NOT INITIAL
                    AND matldoclatestpostgdate LE @lv_selectiondate
                INTO TABLE @DATA(lt_stockquantity).

* End 06.10.2025

          ENDIF.

        ENDIF.






        SORT lt_stockquantity BY product plant storagelocation.
        LOOP AT lt_stockquantity INTO DATA(ls_stock) GROUP BY ( product         = ls_stock-product
                                                                plant           = ls_stock-plant
                                                     ) INTO DATA(group_key).

          SORT lt_material BY material plant postingdate DESCENDING.

*          DATA(lv_days) = 0.
*         Find latest posting date for product/plant from lt_material
          READ TABLE lt_material INTO DATA(ls_mat)
                                 WITH KEY material = group_key-product
                                          plant    = group_key-plant.
          IF sy-subrc = 0.
            DATA(lv_materialbaseunit) = ls_mat-materialbaseunit. " Getting the Base unit for a Product.

*           Find the difference of number of days between the input date and posting date
            IF ls_mat-postingdate IS NOT INITIAL.
              DATA(lv_days) = lv_selectiondate - ls_mat-postingdate.
*               DATA(lv_days) =  ls_mat-postingdate - lv_selectiondate.
            ELSE.
              CONTINUE.
            ENDIF.
          ELSE.
            CONTINUE.
          ENDIF.

          DATA(ls_stock_aging) = VALUE ty_stock_aging(
                                       product         = group_key-product
                                       plant           = group_key-plant
                                 ).

          ls_stock_aging-selectiondate = lv_selectiondate.

*         Get product name and material type from lt_productbasic based on Product and Plant From lt_stockquantity
          READ TABLE lt_productbasic INTO DATA(ls_prod)
                                     WITH KEY product = group_key-product
                                              plant   = group_key-plant.

          IF sy-subrc = 0.
            ls_stock_aging-productname  = ls_prod-productname.
            ls_stock_aging-materialtype = ls_prod-producttype.
          ENDIF.

*         Get price from lt_valuation based on Product and Plant from lt_stockquantity
          CLEAR lv_price.
          READ TABLE lt_valuation INTO DATA(ls_val)
                                  WITH KEY product       = group_key-product
                                           valuationarea = group_key-plant.
          IF sy-subrc = 0.
            lv_price = SWITCH #( ls_val-inventoryvaluationprocedure " If the InventoryValuationProcedure
                          WHEN 'S' THEN ls_val-standardprice        " is equal to 'S' then get the StandardPrice
                          WHEN 'V' THEN ls_val-movingaverageprice   " is equal to 'V' then get the MovingAveragePrice
                          ELSE 0 ).                                 " else assign 0.
          ENDIF.

          DATA(lv_qty) = REDUCE i_stockquantitycurrentvalue_2-matlwrhsstkqtyinmatlbaseunit(
                            INIT qty TYPE i_stockquantitycurrentvalue_2-matlwrhsstkqtyinmatlbaseunit
                            FOR <lfs_stock> IN lt_stockquantity                             " Looping through lt_stockquantity
                            WHERE ( product         = group_key-product                     " Based on Product
                                AND plant           = group_key-plant                       " Plant
                                )
                            NEXT qty = qty + <lfs_stock>-matlwrhsstkqtyinmatlbaseunit ).    " find the sum of the MatlWrhsStkQtyInMatlBaseUnit

          " Assign to aging bucket based on the number of days
          IF lv_days BETWEEN 0 AND 30.
            ls_stock_aging-lt_30     = lv_qty.
            ls_stock_aging-lt_30_amt = lv_qty * lv_price.

          ELSEIF lv_days BETWEEN 31 AND 60.
            ls_stock_aging-bt_31_60     = lv_qty.
            ls_stock_aging-bt_31_60_amt = lv_qty * lv_price.

          ELSEIF lv_days BETWEEN 61 AND 90.
            ls_stock_aging-bt_61_90     = lv_qty.
            ls_stock_aging-bt_61_90_amt = lv_qty * lv_price.

          ELSEIF lv_days BETWEEN 91 AND 180.
            ls_stock_aging-bt_91_180     = lv_qty.
            ls_stock_aging-bt_91_180_amt = lv_qty * lv_price.

          ELSEIF lv_days BETWEEN 181 AND 365.
            ls_stock_aging-bt_181_365     = lv_qty.
            ls_stock_aging-bt_181_365_amt = lv_qty * lv_price.

          ELSEIF lv_days > 365.
            ls_stock_aging-gt_365     = lv_qty.
            ls_stock_aging-gt_365_amt = lv_qty * lv_price.
          ENDIF.

*         Adding the Material Base Unit with the Quantity
          ls_stock_aging-lt_30 = |{ COND string( WHEN ls_stock_aging-lt_30 IS NOT INITIAL
                                                        THEN ls_stock_aging-lt_30 ELSE 0 ) } { lv_materialbaseunit }|.

          ls_stock_aging-bt_31_60 = |{ COND string( WHEN ls_stock_aging-bt_31_60 IS NOT INITIAL
                                                        THEN ls_stock_aging-bt_31_60 ELSE 0 ) } { lv_materialbaseunit }|.

          ls_stock_aging-bt_61_90 = |{ COND string( WHEN ls_stock_aging-bt_61_90 IS NOT INITIAL
                                                        THEN ls_stock_aging-bt_61_90 ELSE 0 ) } { lv_materialbaseunit }|.

          ls_stock_aging-bt_91_180 = |{ COND string( WHEN ls_stock_aging-bt_91_180 IS NOT INITIAL
                                                        THEN ls_stock_aging-bt_91_180 ELSE 0 ) } { lv_materialbaseunit }|.

          ls_stock_aging-bt_181_365 = |{ COND string( WHEN ls_stock_aging-bt_181_365 IS NOT INITIAL
                                                        THEN ls_stock_aging-bt_181_365 ELSE 0 ) } { lv_materialbaseunit }|.

          ls_stock_aging-gt_365 = |{ COND string( WHEN ls_stock_aging-gt_365 IS NOT INITIAL
                                                        THEN ls_stock_aging-gt_365 ELSE 0 ) } { lv_materialbaseunit }|.

*         Add the data to the final internal table lt_stock_aging
          APPEND ls_stock_aging TO lt_stock_aging.
          CLEAR: ls_stock_aging, lv_qty, ls_mat, ls_prod, ls_val.

        ENDLOOP.

        DATA(lv_skip) = io_request->get_paging(  )->get_offset(  ).
        DATA(lv_top) = io_request->get_paging(  )->get_page_size(  ).
        IF lv_top < 0.
          lv_top = 1.
        ENDIF.

        DATA(lv_start) = lv_skip + 1.
        DATA(lv_end) = lv_skip + lv_top.

        APPEND LINES OF lt_stock_aging FROM lv_start TO lv_end TO gt_stock_aging.
        io_response->set_total_number_of_records( lines( lt_stock_aging ) ).
        io_response->set_data( gt_stock_aging ).

      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
