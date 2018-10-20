CREATE or REPLACE FUNCTION przyszle_rezerwacje_osoby(
  person_id in OSOBY.ID_OSOBY%TYPE
)
  RETURN UCZESTNICY_WYCIECZKI_TABLE PIPELINED
AS
  cursor osoba IS SELECT ID_OSOBY
    FROM OSOBY    WHERE ID_OSOBY = person_id;
  osoba_result NUMBER;

  CURSOR rezerw_osoby IS
    SELECT w.id_wycieczki, w.kraj, w.data, w.nazwa, o.imie, o.nazwisko, r.status
    FROM REZERWACJE r
    JOIN wycieczki w ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
    JOIN osoby o ON o.ID_OSOBY = r.ID_OSOBY
    WHERE w.DATA > current_date AND o.ID_OSOBY = person_id;
  rezerw_osoby_result cur%ROWTYPE;

  proc_res UCZESTNICY_WYCIECZKI_ROW :=
    UCZESTNICY_WYCIECZKI_ROW(NULL, NULL, NULL, NULL, NULL, NULL, NULL );
  BEGIN

    OPEN osoba;
    fetch osoba into osoba_result;
    CLOSE osoba;

    IF osoba_result IS NULL THEN
      RAISE NO_DATA;
    END IF;

    OPEN rezerw_osoby;
    LOOP
      FETCH rezerw_osoby into rezerw_osoby_result;
      EXIT when rezerw_osoby%NOTFOUND;
      proc_res.ID_WYCIECZKI := rezerw_osoby_result.ID_WYCIECZKI;
      proc_res.KRAJ := rezerw_osoby_result.KRAJ;
      proc_res.DATA := rezerw_osoby_result.DATA;
      proc_res.NAZWA := rezerw_osoby_result.NAZWA;
      proc_res.IMIE := rezerw_osoby_result.IMIE;
      proc_res.NAZWISKO := rezerw_osoby_result.NAZWISKO;
      proc_res.STATUS := rezerw_osoby_result.STATUS;
      PIPE ROW (proc_res);
    END LOOP;
    CLOSE rezerw_osoby;
  END;