create or replace view WYCIECZKI_OSOBY as
SELECT
  w.KRAJ,
  w.DATA,
  w.NAZWA,
  o.IMIE,
  o.NAZWISKO,
  r.STATUS
  FROM WYCIECZKI w
  JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
  JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY
/

create or replace view WYCIECZKI_OSOBY_POTWIERDZONE as
SELECT
  wo.KRAJ,
  wo.DATA,
  wo.NAZWA,
  wo.IMIE,
  wo.NAZWISKO,
  wo.STATUS
  FROM WYCIECZKI_OSOBY wo
  where wo.STATUS = 'P' or wo.STATUS = 'Z'
/

create or replace view WYCIECZKI_PRZYSZLE as
SELECT
  w.KRAJ,
  w.DATA,
  w.NAZWA
  FROM WYCIECZKI w
  where w.DATA > CURRENT_DATE
/

create or replace view WYCIECZKI_MIEJSCA as
SELECT
  w.KRAJ,
  w.DATA,
  w.NAZWA,
  w.LICZBA_MIEJSC,
  w.LICZBA_MIEJSC - count(r.NR_REZERWACJI) as liczba_wolnych_miejsc
  FROM WYCIECZKI w
  left JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI and r.STATUS != 'A'
  group by w.ID_WYCIECZKI, w.KRAJ, w.data, w.nazwa, w.LICZBA_MIEJSC
/

create or replace view REZERWACJE_DO_ANULOWANIA as
SELECT
  r.NR_REZERWACJI
  FROM REZERWACJE r
  JOIN WYCIECZKI W on r.ID_WYCIECZKI = W.ID_WYCIECZKI
  where CURRENT_DATE - w.data > 0 and CURRENT_DATE - w.data < 7 and r.STATUS = 'N'
/

create or replace view DOSTEPNE_WYCIECZKI as
SELECT
  wm.KRAJ,
  wm.DATA,
  wm.NAZWA,
  wm.LICZBA_MIEJSC,
  wm.LICZBA_WOLNYCH_MIEJSC
  FROM wycieczki_miejsca wm
  where wm.LICZBA_WOLNYCH_MIEJSC > 0 and wm.DATA > CURRENT_DATE
/

