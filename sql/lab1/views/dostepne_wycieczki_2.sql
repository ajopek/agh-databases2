CREATE VIEW DOSTEPNE_WYCIECZKI_2 AS SELECT
      w.KRAJ,
      w.DATA,
      w.NAZWA,      
      w.LICZBA_MIEJSC,
      w.liczba_wolnych_miejsc
    FROM WYCIECZKI w
  where w.liczba_wolnych_miejsc > 0