CREATE or REPLACE PROCEDURE dodaj_rezerwacje(
  trip_id in WYCIECZKI.ID_WYCIECZKI%TYPE,
  person_id in OSOBY.ID_OSOBY%TYPE
) AS
  exist_trip NUMBER(1);
  new_id NUMBER;
  CURSOR trip IS
    SELECT KRAJ
    FROM WYCIECZKI_MIEJSCA
    WHERE DATA >= current_date
    AND LICZBA_WOLNYCH_MIEJSC > 0;
  trip_res NUMBER;
  no_seats_or_not_future EXCEPTION;
  PRAGMA EXCEPTION_INIT(no_seats_or_not_future, -123);
  ----------------- MODYFIKACJA ZAD 6 -----------------
  new_reservation_id NUMBER;
  -----------------------------------------------------
  BEGIN
    OPEN trip;
    fetch trip into trip_res;
    CLOSE trip;
    IF trip_res IS NULL THEN
      RAISE_APPLICATION_ERROR(-123, 'No seats avaliable or trip not in the future');
    END IF;
        INSERT into REZERWACJE(id_wycieczki, id_osoby, status)
            VALUES (trip_id, person_id, 'N' );

    ----------------- MODYFIKACJA ZAD 6 -----------------
    SELECT r.nr_rezerwacji INTO new_reservation_id FROM rezerwacje r
        WHERE trip_id = id_wycieczki AND id_osoby = person_id;
    INSERT INTO dziennik_rezerwacji(nr_rezerwacji, data, status)
        VALUES(new_reservation_id, current_date, 'N');
    -----------------------------------------------------

  END dodaj_rezerwacje;