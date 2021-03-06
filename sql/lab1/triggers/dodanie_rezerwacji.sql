CREATE or replace TRIGGER avaliable_seats_update
  AFTER INSERT ON REZERWACJE
  FOR EACH ROW
  BEGIN
    UPDATE WYCIECZKI
      SET LICZBA_WOLNYCH_MIEJSC = WYCIECZKI.LICZBA_WOLNYCH_MIEJSC -1
    WHERE ID_WYCIECZKI = :NEW.ID_WYCIECZKI;
  END avaliable_seats_update;