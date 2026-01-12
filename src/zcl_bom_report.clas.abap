CLASS zcl_bom_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    "Structure for the internal table to contain the final data which will be displayed at the UI
    TYPES: BEGIN OF ty_bom_report,
             plant                       TYPE i_materialbomlink-plant,
             billofmaterialvariantusage  TYPE i_materialbomlink-billofmaterialvariantusage,
             billofmaterialvariant       TYPE i_materialbomlink-billofmaterialvariant,
             billofmaterial              TYPE i_materialbomlink-billofmaterial,
             material                    TYPE i_materialbomlink-material,
             productdescription          TYPE i_productdescription_2-productdescription,
             bomheaderquantityinbaseunit TYPE i_billofmaterialwithkeydate-bomheaderquantityinbaseunit,
             bomheaderbaseunit           TYPE i_billofmaterialwithkeydate-bomheaderbaseunit,
             billofmaterialitemnumber    TYPE i_bomcomponentwithkeydate-billofmaterialitemnumber,
             billofmaterialitemcategory  TYPE i_bomcomponentwithkeydate-billofmaterialitemcategory,
             billofmaterialcomponent     TYPE i_bomcomponentwithkeydate-billofmaterialcomponent,
             componentdescription        TYPE i_bomcomponentwithkeydate-componentdescription,
             billofmaterialitemquantity  TYPE i_bomcomponentwithkeydate-billofmaterialitemquantity,
             billofmaterialitemunit      TYPE i_bomcomponentwithkeydate-billofmaterialitemunit,
             componentscrapinpercent     TYPE i_bomcomponentwithkeydate-componentscrapinpercent,
             operationscrapinpercent     TYPE i_bomcomponentwithkeydate-operationscrapinpercent,
             materialiscoproduct         TYPE i_bomcomponentwithkeydate-materialiscoproduct,
             createdbyuser               TYPE i_billofmaterialwithkeydate-createdbyuser,
             lastchangedbyuser           TYPE i_billofmaterialwithkeydate-lastchangedbyuser,
             billofmaterialstatus        TYPE string,
           END OF ty_bom_report.

    "Internal Table which contains the final result
    DATA: gt_bom_report TYPE STANDARD TABLE OF ty_bom_report.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BOM_REPORT IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
* Internal table for holding the final result internally.
    DATA: lt_bom_report TYPE STANDARD TABLE OF ty_bom_report.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
* Constants to be used to fetch filter data from the filters passed from the UI.
    CONSTANTS: lc_material              TYPE string VALUE 'MATERIAL',
               lc_plant                 TYPE string VALUE 'PLANT',
               lc_billofmaterialvariant TYPE string VALUE 'BILLOFMATERIALVARIANT',
               lc_billofmaterial        TYPE string VALUE 'BILLOFMATERIAL'.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    DATA: lr_material1       TYPE RANGE OF i_materialbomlink-material,
          lr_billofmaterial TYPE RANGE OF i_materialbomlink-billofmaterial.

    DATA: lv_bomstatus TYPE string.
    TRY.

        DATA(lt_filters) = io_request->get_filter(  )->get_as_ranges(  ).

        IF lt_filters[] IS NOT INITIAL.
          DATA(lr_material)              = VALUE #( lt_filters[ name = lc_material ]-range OPTIONAL ).
*          DATA(lr_plant)                 = VALUE #( lt_filters[ name = lc_plant ]-range OPTIONAL ).
*          DATA(lr_billofmaterialvariant) = VALUE #( lt_filters[ name = lc_billofmaterialvariant ]-range OPTIONAL ).
*          DATA(lr_billofmaterial)        = VALUE #( lt_filters[ name = lc_billofmaterial ]-range OPTIONAL ).


*          lr_material = VALUE #(
*                        FOR wa IN VALUE #( lt_filters[ name = lc_material ]-range OPTIONAL )
*                          ( low = |{ wa-low ALPHA = IN }|
*                            high = wa-high
*                            sign = wa-sign
*                            option = wa-option
*                          )
*                        ).


          DATA(lr_plant) = VALUE #( lt_filters[ name = lc_plant ]-range OPTIONAL ).

          DATA(lr_billofmaterialvariant) = VALUE #( lt_filters[ name = lc_billofmaterialvariant ]-range OPTIONAL ).

          lr_billofmaterial = VALUE #(
                              FOR wa IN VALUE #( lt_filters[ name = lc_billofmaterial ]-range OPTIONAL )
                              (
                                low = |{ wa-low ALPHA = IN }|
                                high = wa-high
                                sign = wa-sign
                                option = wa-option
                              )
                            ).
        ENDIF.
        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*Fetch data based on the logic provided in FS
        SELECT
            a~plant,
            a~billofmaterialvariantusage,
            a~billofmaterialvariant,
            a~billofmaterial,
            a~material,
            b~billofmaterialitemnumber,
            b~billofmaterialitemcategory,
            b~billofmaterialcomponent,
            b~componentdescription,
            b~billofmaterialitemquantity,
            b~billofmaterialitemunit,
            b~componentscrapinpercent,
            b~operationscrapinpercent,
            b~materialiscoproduct,
            c~bomheaderquantityinbaseunit,
            c~bomheaderbaseunit,
            c~createdbyuser,
            c~lastchangedbyuser,
            c~billofmaterialstatus,
            d~productdescription
            FROM i_materialbomlink AS a
                LEFT OUTER JOIN i_bomcomponentwithkeydate AS b ON
                        a~billofmaterialvariant  = b~billofmaterialvariant
                    AND a~billofmaterial         = b~billofmaterial
                    AND a~billofmaterialcategory = b~billofmaterialcategory
                LEFT OUTER JOIN i_billofmaterialwithkeydate AS c ON
                        a~billofmaterialvariant      = c~billofmaterialvariant
                    AND a~billofmaterial             = c~billofmaterial
                    AND a~billofmaterialcategory     = c~billofmaterialcategory
                    AND a~billofmaterialvariantusage = c~billofmaterialvariantusage
                LEFT OUTER JOIN i_productdescription_2 AS d ON
                        a~material = d~product
            WHERE
                    a~plant                 IN @lr_plant
                AND a~material              IN @lr_material
                AND a~billofmaterial        IN @lr_billofmaterial
                AND a~billofmaterialvariant IN @lr_billofmaterialvariant
                AND d~language              = @sy-langu
            INTO TABLE @DATA(lt_bom_data).


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

*Insert the data to the final result table.

        LOOP AT lt_bom_data INTO DATA(ls_bom_data).
          APPEND VALUE #( plant                         = ls_bom_data-plant
                          billofmaterialvariantusage    = ls_bom_data-billofmaterialvariantusage
                          billofmaterialvariant         = ls_bom_data-billofmaterialvariant
                          billofmaterial                = ls_bom_data-billofmaterial
                          material                      = ls_bom_data-material
                          productdescription            = ls_bom_data-productdescription
                          bomheaderquantityinbaseunit   = ls_bom_data-bomheaderquantityinbaseunit
                          bomheaderbaseunit             = ls_bom_data-bomheaderbaseunit
                          billofmaterialitemnumber      = ls_bom_data-billofmaterialitemnumber
                          billofmaterialitemcategory    = ls_bom_data-billofmaterialitemcategory
                          billofmaterialcomponent       = ls_bom_data-billofmaterialcomponent
                          componentdescription          = ls_bom_data-componentdescription
                          billofmaterialitemquantity    = ls_bom_data-billofmaterialitemquantity
                          billofmaterialitemunit        = ls_bom_data-billofmaterialitemunit
                          componentscrapinpercent       = ls_bom_data-componentscrapinpercent
                          operationscrapinpercent       = ls_bom_data-operationscrapinpercent
                          materialiscoproduct           = ls_bom_data-materialiscoproduct
                          createdbyuser                 = ls_bom_data-createdbyuser
                          lastchangedbyuser             = ls_bom_data-lastchangedbyuser
                          billofmaterialstatus          = COND #( WHEN ls_bom_data-billofmaterialstatus EQ '01' THEN 'Active'
                                                                  WHEN ls_bom_data-billofmaterialstatus EQ '02' THEN 'Inactive' )
           ) TO lt_bom_report.

           CLEAR ls_bom_data.
        ENDLOOP.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*Logic for pagination.
        DATA(lv_skip) = io_request->get_paging(  )->get_offset(  ).
        DATA(lv_top) = io_request->get_paging(  )->get_page_size(  ).
        IF lv_top < 0.
          lv_top = 1.
        ENDIF.

        DATA(lv_start) = lv_skip + 1.
        DATA(lv_end) = lv_skip + lv_top.

        APPEND LINES OF lt_bom_report FROM lv_start TO lv_end TO gt_bom_report.
        io_response->set_total_number_of_records( lines( lt_bom_report ) ).
        io_response->set_data( gt_bom_report ).

      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
