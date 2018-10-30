CREATE OR REPLACE TRIGGER akutalizuj_wolne_miejsca_anulowanie
  AFTER UPDATE OF STATUS ON REZERWACJE
    FOR EACH ROW
  DECLARE
    CURSOR wolne_miejsca IS SELECT LICZBA_WOLNYCH_MIEJSC
      FROM WYCIECZKI
      WHERE WYCIECZKI.ID_WYCIECZKI = :NEW.ID_WYCIECZKI;
    wolne_miejsca_res NUMBER;
  BEGIN
    IF :NEW.STATUS = 'A' AND :OLD.STATUS != 'A' THEN
      UPDATE WYCIECZKI
        SET LICZBA_WOLNYCH_MIEJSC = WYCIECZKI.LICZBA_WOLNYCH_MIEJSC +1
        WHERE ID_WYCIECZKI = :NEW.ID_WYCIECZKI;
    ELSEIF :OLD.STATUS = 'A' and not :NEW.STATUS = 'A' THEN
          OPEN wolne_miejsca;
          fetch wolne_miejsca into wolne_miejsca_res;          
          CLOSE wolne_miejsca;
          
          IF wolne_miejsca_res < 1 THEN
            RAISE_APPLICATION_ERROR(-123, 'No seats avaliable, cannot update trip');
          END IF;

          UPDATE WYCIECZKI
            SET LICZBA_WOLNYCH_MIEJSC = prev_free_places -1
            WHERE ID_WYCIECZKI = :NEW.ID_WYCIECZKI;
      END IF;
  END akutalizuj_wolne_miejsca_anulowanie;