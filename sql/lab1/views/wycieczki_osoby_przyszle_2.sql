CREATE VIEW WYCIECZKI_PRZYSZLE_2 AS select 
  w.kraj, 
  w.data, 
  w.nazwa, 
  w.liczba_wolnych_miejsc,
  o.imie, 
  o.nazwisko, 
  r.status
  from REZERWACJE r
  inner join wycieczki w on w.ID_WYCIECZKI = r.ID_WYCIECZKI
  inner join osoby o on o.ID_OSOBY = r.ID_OSOBY
  where w.DATA > current_date