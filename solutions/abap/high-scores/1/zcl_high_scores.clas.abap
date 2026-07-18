CLASS zcl_high_scores DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES integertab TYPE STANDARD TABLE OF i WITH EMPTY KEY.
    METHODS constructor
      IMPORTING
        scores TYPE integertab.

    METHODS list_scores
      RETURNING
        VALUE(result) TYPE integertab.

    METHODS latest
      RETURNING
        VALUE(result) TYPE i.

    METHODS personalbest
      RETURNING
        VALUE(result) TYPE i.

    METHODS personaltopthree
      RETURNING
        VALUE(result) TYPE integertab.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA scores_list TYPE integertab.

ENDCLASS.


CLASS zcl_high_scores IMPLEMENTATION.

  METHOD constructor.
    me->scores_list = scores.
  ENDMETHOD.

  METHOD list_scores.
    " add solution here
    result = scores_list.
  ENDMETHOD.

  METHOD latest.
    " add solution here
    DATA(lv_count) = lines( scores_list ).
    result = scores_list[ lv_count ].
  ENDMETHOD.

  METHOD personalbest.
    " add solution here
    DATA(work_area) = scores_list.
    SORT work_area BY table_line DESCENDING.

    result = work_area[ 1 ].
  ENDMETHOD.

  METHOD personaltopthree.
    " add solution here
    DATA(work_area) = scores_list.
    DATA(lv_count) = lines( work_area ).
    SORT work_area BY table_line DESCENDING.

    DATA(lv_top_count) = 3.

    DO lv_count TIMES.
      IF sy-index > lv_top_count.
        EXIT.
      ELSE.
        APPEND work_area[ sy-index ] TO result.
      ENDIF.
    ENDDO.
  ENDMETHOD.


ENDCLASS.
