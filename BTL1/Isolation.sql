SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

alter session set ISOLATION_LEVEL= SERIALIZABLE;
alter session set ISOLATION_LEVEL= READ COMMITTED;
--mức cô lập hiện tại
declare 
trans_id varchar(100);
begin
trans_id:= dbms_transaction.local_transaction_id(TRUE);
end;
/

--Hiện
SELECT s.sid, s.serial#,
CASE BITAND(t.flag, POWER(2, 28))
WHEN 0 THEN 'READ COMMITTED'
ELSE 'SERIALIZABLE'
END AS isolation_level
FROM v$transaction t
JOIN v$session s ON t.addr = s.taddr;

---nonrepeatable read
--- máy 1:
select * from CN2.SANPHAM@cn2_dblink where MASP='TV05';

---máy 2:
update CN2.SANPHAM 
set Gia = 10000;
where MASP='TV05';

commit;

---phantom read
---máy 1:
INSERT INTO cn2.SANPHAM@cn2_dblink VALUES ('ST08','PHAN MAU KHONG BUI','HOP','VIETNAM',9000);
commit;

---máy 2:
SELECT * from cn2.sanpham where MASP = 'ST08';

---máy 1:
INSERT INTO cn2.SANPHAM@cn2_dblink VALUES ('ST09','PHAN MAU KHONG BUI','HOP','VIETNAM',9000);
commit;

---máy 2:
SELECT * from cn2.sanpham where MASP = 'ST09';

---lost update
---máy 1:
select * from cn2.sanpham@cn2_dblink where MASP='TV05';

update CN2.SANPHAM@cn2_dblink
set Gia = 10000
where MASP='TV05';

---máy 2:
update CN2.SANPHAM
set Gia = 20000
where MASP='TV05';
commit;

-- máy 1
commit;

-- máy 2
select * from cn2.sanpham where MASP='TV05';


---deadlock

---máy 1:
update SANPHAM 
 set Gia = 40000;
 where MASP='TV05';

update SANPHAM 
 set Gia = 20000;
 where MASP='TV07';

 ---máy 2:
update SANPHAM 
 set Gia = 30000;
 where MASP='TV07';

update SANPHAM 
 set Gia = 20000;
 where MASP='TV05';