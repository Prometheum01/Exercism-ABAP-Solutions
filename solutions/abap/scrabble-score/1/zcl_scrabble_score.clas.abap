CLASS zcl_scrabble_score DEFINITION PUBLIC .

  PUBLIC SECTION.
    METHODS score
      IMPORTING
        input         TYPE string OPTIONAL
      RETURNING
        VALUE(result) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_scrabble_score IMPLEMENTATION.
  METHOD score.
*Aklima gelen ilk soru su oldu: bu letterlarin scorelarini nerede tutacagimiz oldu.
*Simdilik sanirim bunlari case ile hard coded yapacagim.
*Gelen inputu loop ile her karakterini donup her karaktere if ile kontrol yapip score hesaplanacak.

    DATA(lv_input_upper) = to_upper( input ).
    DATA(lv_input_length) = strlen( input ).
    DATA(lv_index) = 0.

    DO lv_input_length TIMES.
      DATA(lv_character) = substring( val = lv_input_upper off = lv_index len = 1 ).

      CASE lv_character.
        WHEN 'A' OR 'E' OR 'I' OR 'O' OR 'U' OR 'L' OR 'N' OR 'R' OR 'S' OR 'T'.
          result = result + 1.
        WHEN 'D' OR 'G'.
          result = result + 2.
        WHEN 'B' OR 'C' OR 'M' OR 'P'.
          result = result + 3.
        WHEN 'F' OR 'H' OR 'V' OR 'W' OR 'Y'.
          result = result + 4.
        WHEN 'K'.
          result = result + 5.
        WHEN 'J' OR 'X'.
          result = result + 8.
        WHEN 'Q' OR 'Z'.
          result = result + 10.
        WHEN OTHERS.
          result = result + 0.
      ENDCASE.
      
      lv_index = lv_index + 1.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
