CREATE OR REPLACE TYPE UCZESTNICY_WYCIECZKI_ROW AS OBJECT (
  ID_WYCIECZKI NUMBER,
  NAZWA        VARCHAR2(100),
  KRAJ         VARCHAR2(50),
  DATA         DATE,
  IMIE         VARCHAR2(50),
  NAZWISKO     VARCHAR2(50),
  STATUS       CHAR
);

CREATE OR REPLACE TYPE UCZESTNICY_WYCIECZKI_TABLE
  AS TABLE OF UCZESTNICY_WYCIECZKI_ROW;

CREATE OR REPLACE FUNCTION uczestnicy_wycieczki(
  id_wycieczki WYCIECZKI.ID_WYCIECZKI%TYPE
)
  RETURN UCZESTNICY_WYCIECZKI_TABLE PIPELINED
AS
  cursor wycieczka IS
        SELECT ID_WYCIECZKI
        FROM WYCIECZKI w
        WHERE w.ID_WYCIECZKI = id_wycieczki;
  wycieczka_result NUMBER;
  CURSOR uczestnicy IS SELECT
      w.ID_WYCIECZKI,
      w.NAZWA,
      w.KRAJ,
      w.DATA,
      o.IMIE,
      o.NAZWISKO,
      r.STATUS
    FROM WYCIECZKI w
    JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
    JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY
    WHERE w.ID_WYCIECZKI = trip_id;
  uczestnicy_result uczestnicy%ROWTYPE;
  proc_res UCZESTNICY_WYCIECZKI_ROW :=
    UCZESTNICY_WYCIECZKI_ROW(NULL, NULL, NULL, NULL, NULL, NULL, NULL);
  BEGIN

    OPEN wycieczka;
    fetch wycieczka into wycieczka_result;
    CLOSE wycieczka;

    IF wycieczka_result IS NULL THEN
      RAISE NO_DATA;
    END IF;

    OPEN uczestnicy;
    LOOP
      FETCH uczestnicy INTO uczestnicy_result;
      EXIT WHEN uczestnicy%NOTFOUND;
      proc_res.ID_WYCIECZKI := uczestnicy_result.ID_WYCIECZKI;
      proc_res.NAZWA := uczestnicy_result.NAZWA;
      proc_res.KRAJ := uczestnicy_result.KRAJ;
      proc_res.DATA := uczestnicy_result.DATA;
      proc_res.IMIE := uczestnicy_result.IMIE;
      proc_res.NAZWISKO := uczestnicy_result.NAZWISKO;
      proc_res.STATUS := uczestnicy_result.STATUS;
      PIPE ROW (proc_res);
    END LOOP;
    CLOSE uczestnicy;
  END;