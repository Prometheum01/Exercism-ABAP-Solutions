CLASS zcl_reverse_string DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS reverse_string
      IMPORTING
        input         TYPE string
      RETURNING
        VALUE(result) TYPE string.
ENDCLASS.

CLASS zcl_reverse_string IMPLEMENTATION.

  METHOD reverse_string.

*Aklima gelen en basit yontem hali hazirda var olan bir fonksiyon ile bu islemin yapilmasi.
*    result = reverse( input ).


*Hazir bir fonksiyon yoksa do dongusuyle substr ile sondan baslayarak bir string build edilir.

  DATA(lv_length) = strlen( input ).
  DATA(lv_index) = lv_length - 1.

  DO lv_length TIMES.
    DATA(lv_char) = substring( val = input off = lv_index len = 1 ).

    result = |{ result }{ lv_char }|.

    lv_index = lv_index - 1.
  ENDDO.
    
  ENDMETHOD.

ENDCLASS.
