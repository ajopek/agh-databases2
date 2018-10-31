CREATE or REPLACE PROCEDURE zmien_status_rezerwacji(
  reservation_id in REZERWACJE.NR_REZERWACJI%TYPE,
  stat in REZERWACJE.STATUS%TYPE
) AS
  status_invalid BOOLEAN;
  cur_stat REZERWACJE.STATUS%TYPE ;
  trip_id WYCIECZKI.ID_WYCIECZKI%TYPE;
  ----------- MODYFIKACJA ZAD 7 -----------
  CURSOR avaliable_seats IS 
    SELECT w.liczba_wolnych_miejsc
    FROM WYCIECZKI w;  
  -----------------------------------------
    avaliable_seats_res NUMBER;
  CURSOR reservation_exists IS
    SELECT NR_REZERWACJI
    FROM REZERWACJE r
      INNER JOIN WYCIECZKI w ON r.ID_WYCIECZKI = w.ID_WYCIECZKI
    WHERE r.NR_REZERWACJI = reservation_id and w.DATA > current_date;
  reservation_exists_res NUMBER;
  wrong_status EXCEPTION;
  PRAGMA EXCEPTION_INIT(wrong_status, -121);
  no_seats EXCEPTION;
  PRAGMA EXCEPTION_INIT(no_seats, -122);
  no_future_trip EXCEPTION;
  PRAGMA EXCEPTION_INIT(no_future_trip, -123);
  BEGIN
    IF stat not in ('P', 'N', 'Z', 'A') THEN
      RAISE_APPLICATION_ERROR(-121, 'Status needs to be either N, Z, P or A');
    END IF;
    
    OPEN avaliable_seats;
    FETCH avaliable_seats into avaliable_seats_res;
    CLOSE avaliable_seats;
    
    IF avaliable_seats_res IS NULL THEN
      RAISE_APPLICATION_ERROR(-122, 'No seats left');
    END IF;
    
    OPEN reservation_exists;
    fetch reservation_exists into reservation_exists_res;
    CLOSE reservation_exists;
    
    IF reservation_exists_res IS NULL THEN
      RAISE_APPLICATION_ERROR(-123, 'No such future trip');
    END IF;
    SELECT r.STATUS into cur_stat 
      from REZERWACJE r
      WHERE r.NR_REZERWACJI = reservation_id;
    
    SELECT r.ID_WYCIECZKI into trip_id 
      from REZERWACJE r
      WHERE r.NR_REZERWACJI = reservation_id;
    
    UPDATE REZERWACJE
        SET STATUS = stat
        WHERE NR_REZERWACJI = reservation_id;

    ----------------- MODYFIKACJA ZAD 8 -----------------
    ----------------- MODYFIKACJA ZAD 6 USUNIETA --------
    -----------------------------------------------------
    
    ----------------- MODYFIKACJA ZAD 7 -----------------
    IF cur_stat = 'A' AND not stat = 'A' THEN      
        UPDATE WYCIECZKI
            SET LICZBA_WOLNYCH_MIEJSC = LICZBA_WOLNYCH_MIEJSC-1
            WHERE ID_WYCIECZKI=trip_id;
    ELSEIF stat = 'A' and not cur_stat = 'A' THEN
        UPDATE WYCIECZKI
            SET LICZBA_WOLNYCH_MIEJSC = LICZBA_WOLNYCH_MIEJSC+1
            WHERE ID_WYCIECZKI = trip_id;
    END IF;
    -----------------------------------------------------
  END zmien_status_rezerwacji;