CREATE OR REPLACE TYPE WYCIECZKI_MIEJSCA_ROW AS OBJECT (
  NAZWA        VARCHAR2(100),
  KRAJ         VARCHAR2(50),
  DATA         DATE,
  LICZBA_MIEJSC NUMBER,
  LICZBA_WOLNYCH_MIEJSC NUMBER
);

CREATE OR REPLACE TYPE WYCIECZKI_MIEJSCA_TABLE AS TABLE OF WYCIECZKI_MIEJSCA_ROW;

CREATE or REPLACE FUNCTION dostepne_wycieczki_proc(
  country in WYCIECZKI.KRAJ%TYPE,
  data_od in DATE,
  data_do in DATE
)
  proc_resURN WYCIECZKI_MIEJSCA_TABLE PIPELINED
AS
  wycieczki_miejscaSOR wycieczka IS
    SELECT ID_WYCIECZKI
    FROM WYCIECZKI
    WHERE KRAJ = country AND DATA BETWEEN data_od AND data_do;
  wycieczka_res NUMBER;

  wycieczki_miejscaSOR wycieczki_miejsca IS
    SELECT
      w.KRAJ,
      w.DATA,
      w.NAZWA,
      w.LICZBA_MIEJSC,
      w.liczba_miejsc - (
        SELECT coalesce(count(r.NR_REZERWACJI), 0)
        from REZERWACJE r
          where r.ID_WYCIECZKI = w.ID_WYCIECZKI
      ) as wolne_miejsca
    FROM WYCIECZKI w
  where (
          SELECT coalesce(count(r.NR_REZERWACJI), 0)
          from REZERWACJE r
          where r.ID_WYCIECZKI = w.ID_WYCIECZKI
        ) < w.LICZBA_MIEJSC AND w.KRAJ = country and w.DATA BETWEEN data_od AND data_do;

  wycieczki_miejsca_res wycieczki_miejsca%ROWTYPE;
  proc_res WYCIECZKI_MIEJSCA_ROW := WYCIECZKI_MIEJSCA_ROW(NULL, NUL
L, NULL, NULL, NULL);
  BEGIN
    OPEN wycieczka;
    fetch wycieczka into wycieczka_res;
    CLOSE wycieczka;
    
    IF wycieczka_res IS NULL THEN      
        RAISE NO_DATA;
    END IF;

    OPEN wycieczki_miejsca;
    LOOP
      FETCH wycieczki_miejsca into wycieczki_miejsca_res;
      EXIT when wycieczki_miejsca%NOTFOUND;
      proc_res.KRAJ := wycieczki_miejsca_res.KRAJ;
      proc_res.DATA := wycieczki_miejsca_res.DATA;
      proc_res.NAZWA := wycieczki_miejsca_res.NAZWA;
      proc_res.LICZBA_MIEJSC := wycieczki_miejsca_res.LICZBA_MIEJSC;
      proc_res.LICZBA_WOLNYCH_MIEJSC := wycieczki_miejsca_res.wolne_miejsca;
      PIPE ROW (proc_res);
    END LOOP;
    CLOSE wycieczki_miejsca;
  END;