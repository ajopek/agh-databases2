CREATE or REPLACE PROCEDURE zmien_liczbe_miejsc(
  trip_id in WYCIECZKI.ID_WYCIECZKI%TYPE,
  num_of_seats in NUMBER) AS
  is_reserved NUMBER;
  is_trip_valid NUMBER(1);
  CURSOR future_trip IS SELECT ID_WYCIECZKI
    FROM WYCIECZKI
    WHERE DATA >= current_date
    AND ID_WYCIECZKI = trip_id;
  future_trip_res NUMBER;
  no_seats EXCEPTION;
  PRAGMA EXCEPTION_INIT(no_seats, -124);
  not_future EXCEPTION;
  PRAGMA EXCEPTION_INIT(not_future, -123);
  BEGIN
    OPEN future_trip;
    fetch future_trip into future_trip_res;
    CLOSE future_trip;
    
    IF future_trip_res IS NULL THEN
      RAISE_APPLICATION_ERROR(-123, 'Trip not in the future');
    END IF;    
    
    SELECT coalesce(count(r.NR_REZERWACJI), 0) INTO is_reserved
    FROM REZERWACJE r
    WHERE r.ID_WYCIECZKI = trip_id;
    
    IF num_of_seats < is_reserved THEN
      RAISE_APPLICATION_ERROR(-124, 'Too many seatas reserved');
    ELSE
      UPDATE WYCIECZKI w
        SET w.LICZBA_MIEJSC = num_of_seats
        ------------------ MODYFIKACJA ZAD 7 -------------------
        w.LICZBA_WOLNYCH_MIEJSC = num_of_seats - is_reserved
        --------------------------------------------------------
        WHERE w.ID_WYCIECZKI = trip_id;
    END IF;
  END;