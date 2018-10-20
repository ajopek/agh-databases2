CREATE or REPLACE FUNCTION rezerwacje_osoby(
  person_id OSOBY.ID_OSOBY%TYPE
)
  RETURN UCZESTNICY_WYCIECZKI_TABLE PIPELINED
AS
  cursor osoba IS SELECT ID_OSOBY
        FROM OSOBY
        WHERE ID_OSOBY = person_id;
  osoba_result NUMBER;

  CURSOR uczestnicy IS
    SELECT
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
      WHERE o.ID_OSOBY = person_id;
  uczestnicy_result uczestnicy%ROWTYPE;

  proc_ret UCZESTNICY_WYCIECZKI_ROW := UCZESTNICY_WYCIECZKI_ROW(NULL, NULL, NULL, NULL, NULL, NULL, NULL);

  BEGIN

    OPEN osoba;
    fetch osoba into osoba_result;
    CLOSE osoba;

    IF osoba_result IS NULL THEN
      RAISE NO_DATA;
    END IF;

    OPEN uczestnicy;
    LOOP
      FETCH uczestnicy into uczestnicy_result;
      EXIT when uczestnicy%NOTFOUND;
      proc_ret.ID_WYCIECZKI := uczestnicy_result.ID_WYCIECZKI;
      proc_ret.NAZWA := uczestnicy_result.NAZWA;
      proc_ret.KRAJ := uczestnicy_result.KRAJ;
      proc_ret.DATA := uczestnicy_result.DATA;
      proc_ret.IMIE := uczestnicy_result.IMIE;
      proc_ret.NAZWISKO := uczestnicy_result.NAZWISKO;
      proc_ret.STATUS := uczestnicy_result.STATUS;
      PIPE ROW (proc_ret);
    END LOOP;
    CLOSE uczestnicy;
  END;