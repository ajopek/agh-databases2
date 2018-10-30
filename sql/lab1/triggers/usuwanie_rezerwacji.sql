CREATE TRIGGER reservation_delete
  BEFORE DELETE on REZERWACJE
  BEGIN
    RAISE_APPLICATION_ERROR(-123, 'You cannot delete a reservation, try changing reservation status');
  END;