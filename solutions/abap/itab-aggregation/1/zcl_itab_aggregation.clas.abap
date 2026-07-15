CLASS zcl_itab_aggregation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES group TYPE c LENGTH 1.
    TYPES: BEGIN OF initial_numbers_type,
             group  TYPE group,
             number TYPE i,
           END OF initial_numbers_type,
           initial_numbers TYPE STANDARD TABLE OF initial_numbers_type WITH EMPTY KEY.

    TYPES: BEGIN OF aggregated_data_type,
             group   TYPE group,
             count   TYPE i,
             sum     TYPE i,
             min     TYPE i,
             max     TYPE i,
             average TYPE f,
           END OF aggregated_data_type,
           aggregated_data TYPE STANDARD TABLE OF aggregated_data_type WITH EMPTY KEY.

    METHODS perform_aggregation
      IMPORTING
        initial_numbers        TYPE initial_numbers
      RETURNING
        VALUE(aggregated_data) TYPE aggregated_data.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_itab_aggregation IMPLEMENTATION.
  METHOD perform_aggregation.
  
*Gruplamak icin once siraliyoruz.
    DATA(lt_numbers) = initial_numbers.
    SORT lt_numbers BY group.

*Kullanilacak local variablelar tanimlaniyor.
    DATA ls_result TYPE aggregated_data_type.
    DATA lv_min TYPE i.
    DATA lv_max TYPE i.

*LOOP at group by ile parcalaniyor.
    LOOP AT lt_numbers INTO DATA(ls_sum)
      GROUP BY  ( group = ls_sum-group )
      INTO DATA(ls_group_key).

*CLEAR ile local degiskenler tanimlaniyor.
      CLEAR: ls_result, lv_min, lv_max.

      ls_result-group = ls_group_key-group.

*Group icinde satirlar donuyor.
      LOOP AT GROUP ls_group_key INTO DATA(ls_group_row).
        IF ls_result-count = 0.
          lv_min = ls_group_row-number.
          lv_max = ls_group_row-number.
        ELSE.
          IF lv_min > ls_group_row-number.
            lv_min = ls_group_row-number.
          ENDIF.
          IF lv_max < ls_group_row-number.
            lv_max = ls_group_row-number.
          ENDIF.
        ENDIF.
        ls_result-count = ls_result-count + 1.
        ls_result-sum = ls_result-sum + ls_group_row-number.

      ENDLOOP.

      ls_result-average = ls_result-sum / ls_result-count.
      ls_result-min = lv_min.
      ls_result-max = lv_max.
      APPEND ls_result TO aggregated_data.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
