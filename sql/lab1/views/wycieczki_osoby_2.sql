CREATE VIEW WYCIECZKI_OSOBY_2 AS SELECT
      w.ID_WYCIECZKI,
      w.NAZWA,
      w.KRAJ,
      w.DATA,
      w.liczba_wolnych_miejsc,
      o.IMIE,
      o.NAZWISKO,
      r.STATUS,
    FROM WYCIECZKI w
      JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
      JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY