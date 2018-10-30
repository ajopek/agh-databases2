CREATE or REPLACE FUNCTION dostepne_wycieczki_proc_3(
  country in WYCIECZKI.KRAJ%TYPE,
  od in DATE,
  do in DATE
)
  RETURN WYCIECZKI_MIEJSCA_TABLE PIPELINED
AS
  CURSOR wycieczki_miejsca IS
    SELECT
      w.KRAJ,
      w.DATA,
      w.NAZWA,
      w.LICZBA_MIEJSC,
    ---------- MODYFIKACJA ZAD 7 --------------------
      w.LICZBA_WOLNYCH_MIEJSC
    FROM WYCIECZKI w
  where w.liczba_wolnych_miejsc > 0 AND w.KRAJ = country and w.DATA BETWEEN od AND do;
    -------------------------------------------------
  wycieczki_miejsca_res wycieczki_miejsca%ROWTYPE;

  CURSOR wycieczka IS
    SELECT ID_WYCIECZKI
    FROM WYCIECZKI
    WHERE KRAJ = country AND DATA BETWEEN od AND do;
  wycieczka_res NUMBER;

  proc_res WYCIECZKI_MIEJSCA_ROW := WYCIECZKI_MIEJSCA_ROW(NULL, NULL, NULL, NULL, NULL);
  BEGIN
    OPEN wycieczka;
    fetch wycieczka into wycieczka_res;
    CLOSE wycieczka;

    IF wycieczka_res IS NULL THEN
        RAISE NO_DATA_FOUND;
    END IF;

    OPEN wycieczki_miejsca;
    LOOP
      FETCH wycieczki_miejsca into wycieczki_miejsca_res;
      EXIT when wycieczki_miejsca%NOTFOUND;
      proc_res.KRAJ := wycieczki_miejsca_res.KRAJ;
      proc_res.DATA := wycieczki_miejsca_res.DATA;
      proc_res.NAZWA := wycieczki_miejsca_res.NAZWA;
      proc_res.LICZBA_MIEJSC := wycieczki_miejsca_res.LICZBA_MIEJSC;
      proc_res.LICZBA_WOLNYCH_MIEJSC := wycieczki_miejsca_res.liczba_wolnych_miejsc;
      PIPE ROW (proc_res);
    END LOOP;
    CLOSE wycieczki_miejsca;
  END;