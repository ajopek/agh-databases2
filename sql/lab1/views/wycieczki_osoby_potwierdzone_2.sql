CREATE VIEW WYCIECZKI_OSOBY_POTWIERDZONE_2 AS SELECT
      w.KRAJ,
      w.DATA,
      w.NAZWA,
      w.liczba_wolnych_miejsc,
      o.IMIE,
      o.NAZWISKO,
      r.STATUS
    FROM WYCIECZKI w
      JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI AND r.status = 'P'
      JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY