CLASS zcl_itab_combination DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF alphatab_type,
             cola TYPE string,
             colb TYPE string,
             colc TYPE string,
           END OF alphatab_type.
    TYPES alphas TYPE STANDARD TABLE OF alphatab_type.

    TYPES: BEGIN OF numtab_type,
             col1 TYPE string,
             col2 TYPE string,
             col3 TYPE string,
           END OF numtab_type.
    TYPES nums TYPE STANDARD TABLE OF numtab_type.

    TYPES: BEGIN OF combined_data_type,
             colx TYPE string,
             coly TYPE string,
             colz TYPE string,
           END OF combined_data_type.
    TYPES combined_data TYPE STANDARD TABLE OF combined_data_type WITH EMPTY KEY.

    METHODS perform_combination
      IMPORTING
        alphas             TYPE alphas
        nums               TYPE nums
      RETURNING
        VALUE(combined_data) TYPE combined_data.

  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.

CLASS zcl_itab_combination IMPLEMENTATION.

  METHOD perform_combination.

*Dongu ile alpha tablosunun satirlarini donuyoruz.

  LOOP AT alphas INTO DATA(ls_row_alpha).
*Row index ile nums tablosundan gerekli row cekilecegi icin aliniyor.
*Column index ise columnlarin alinmasinda kullaniliyor.
    DATA(lv_row_index) = sy-tabix.
    DATA(lv_col_index) = 1.

    READ TABLE nums INTO DATA(ls_row_num) INDEX lv_row_index.

    IF sy-subrc = 0.
      DATA ls_combined TYPE combined_data_type.
      DO.
*Pointerlar ile burada fieldlara erisiyioruz. ne zaman value bulunamiyor, rowun sonuna geliyoruz o zaman donguden cikiyor.
        ASSIGN COMPONENT lv_col_index OF STRUCTURE ls_row_alpha TO FIELD-SYMBOL(<lv_value_alpha>).
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.

        ASSIGN COMPONENT lv_col_index OF STRUCTURE ls_row_num TO FIELD-SYMBOL(<lv_value_num>).
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.

        ASSIGN COMPONENT lv_col_index OF STRUCTURE ls_combined TO FIELD-SYMBOL(<lv_combined_value>).
        <lv_combined_value> = |{ <lv_value_alpha> }{ <lv_value_num> }|.
        lv_col_index = lv_col_index + 1.
        
      ENDDO.
      
    APPEND ls_combined TO combined_data.
    
    ENDIF.

  ENDLOOP.

  ENDMETHOD.

ENDCLASS.
