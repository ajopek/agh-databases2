CREATE or replace PROCEDURE przelicz
  AS
  avaliable_seats NUMBER;
  BEGIN
    FOR trip IN (SELECT * FROM wycieczki)
      LOOP
      SELECT trip.LICZBA_MIEJSC - coalesce(count(r.NR_REZERWACJI), 0)
        INTO avaliable_seats
        FROM REZERWACJE r
        WHERE r.ID_WYCIECZKI = trip.ID_WYCIECZKI;
      UPDATE WYCIECZKI w
        SET w.LICZBA_WOLNYCH_MIEJSC = avaliable_seats
        WHERE w.ID_WYCIECZKI = trip.ID_WYCIECZKI;
    END LOOP;
END;