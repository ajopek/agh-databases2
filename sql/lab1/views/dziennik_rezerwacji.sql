CREATE TABLE dziennik_rezerwacji
(
  ID NUMBER PRIMARY KEY,
  NR_REZERWACJI NUMBER references REZERWACJE,
  DATA DATE,
  STATUS CHAR(1)
);