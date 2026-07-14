CLASS zcl_itab_basics DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .


  PUBLIC SECTION.
    TYPES group TYPE c LENGTH 1.
    TYPES: BEGIN OF initial_type,
             group       TYPE group,
             number      TYPE i,
             description TYPE string,
           END OF initial_type,
           itab_data_type TYPE STANDARD TABLE OF initial_type WITH EMPTY KEY.

    METHODS fill_itab
           RETURNING
             VALUE(initial_data) TYPE itab_data_type.

    METHODS add_to_itab
           IMPORTING initial_data TYPE itab_data_type
           RETURNING
            VALUE(updated_data) TYPE itab_data_type.

    METHODS sort_itab
           IMPORTING initial_data TYPE itab_data_type
           RETURNING
            VALUE(updated_data) TYPE itab_data_type.

    METHODS search_itab
           IMPORTING initial_data TYPE itab_data_type
           RETURNING
             VALUE(result_index) TYPE i.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_itab_basics IMPLEMENTATION.
  METHOD fill_itab.
* Boyle zor yoldan yapilabiliyor.
*    DATA my_row TYPE initial_type.
*    my_row-group = 'A'.
*    my_row-number = 10.
*    my_row-description = 'Group A-2'.
*    APPEND my_row TO initial_data.

* Yeni yontem ile boyle oluyor hizli bir sekilde.
    initial_data = VALUE #(
      ( group = 'A' number = 10 description = 'Group A-2')
      ( group = 'B' number = 5 description = 'Group B')
      ( group = 'A' number = 6 description = 'Group A-1')
      ( group = 'C' number = 22 description = 'Group C-1')
      ( group = 'A' number = 13 description = 'Group A-3')
      ( group = 'C' number = 500 description = 'Group C-2')
    ). 

  ENDMETHOD.

  METHOD add_to_itab.
    updated_data = initial_data.

* Normal ekleme yapiyor. Sorted ve hashed de calismiyor.
*    DATA new_row TYPE initial_type.
*    new_row-group = 'A'.
*    new_row-number = 19.
*    new_row-description = 'Group A-4'.
*    APPEND new_row TO updated_data.

* APPEND sorted ve hashed tablolarda calismiyormus. O yuzden bununlada ekleme yapiliyor.
*    DATA new_row TYPE initial_type.
*    new_row-group = 'A'.
*    new_row-number = 19.
*    new_row-description = 'Group A-4'.
*    INSERT new_row INTO TABLE updated_data.

* En az degiskenle olan method. BASE ile onceki tablonun verilerini koruyor, sadece ekleme yapiyor.
*    updated_data = VALUE #( BASE initial_data ( group = 'A' number = 19 description = 'Group A-4' ) ).

* Bu en verimlilerden bir tanesi. Once bos row ekliyor. Sonra onun pointeri ile degerleri guncelliyor.
    DATA new_row TYPE initial_type.
    APPEND INITIAL LINE TO updated_data ASSIGNING FIELD-SYMBOL(<new_row>).
    <new_row>-group = 'A'.
    <new_row>-number = 19.
    <new_row>-description = 'Group A-4'.

  ENDMETHOD.

  METHOD sort_itab.
    updated_data = initial_data.
    
* Default ascending geliyormus.
    SORT updated_data BY group ASCENDING number DESCENDING.
    
  ENDMETHOD.

  METHOD search_itab.
    DATA(temp_data) = sort_itab( initial_data ).
* Yeni gelmis, biraz fazla kaynak harciyor ama kisa yaziliyor. Bosluklara dikkat!
*    result_index = LINE_INDEX( temp_data[ number = 6 ] ).

* Eski yontem. Field kullanilacaksa Transporting eklenmeden de calisir.
* TRANSPORTING NO FIELDS, sadece indeksleri aliyor. Fieldlar gelmedigi icin cok performansli.
* sy-subrc islemin sonucunu veriyor. 0 ise row bulundu demek.
* sy-tabix ise table index kisaltmasi. indexi veriyor.
    READ TABLE temp_data WITH KEY number = 6 TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      result_index = sy-tabix.
    ELSE.
      result_index = 0.
    ENDIF.
    
  ENDMETHOD.

ENDCLASS.
