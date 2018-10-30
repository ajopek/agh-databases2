CREATE VIEW WYCIECZKI_MIEJSCA_2 AS SELECT
      w.KRAJ,
      w.DATA,
      w.NAZWA,
      w.LICZBA_MIEJSC,
      w.liczba_wolnych_miejsc
    FROM WYCIECZKI w