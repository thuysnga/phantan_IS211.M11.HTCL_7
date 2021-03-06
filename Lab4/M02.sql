CREATE USER M02 IDENTIFIED BY M02
GRANT CONNECT,RESOURCE,CREATE ROLE TO M02


create table CUSTOMER(
CUSID varchar2(10) primary key,
CUSNAME varchar2(50),
BALANCE number
)
create table BRANCH(
BRANCHID varchar2(5) primary key,
BRANCHNAME varchar2(50)
)

create table TRANSACT(
BRANCHID varchar2(5),
CUSID varchar2(10),
AMOUNT number,
TRANSACTIONTYPE char(10),
CONSTRAINT PK_TRANSACT PRIMARY KEY(BRANCHID, CUSID)
)

ALTER TABLE TRANSACT ADD CONSTRAINT FK_ TRANSACT_CUSTOMER FOREIGN KEY (CUSID) REFERENCES CUSTOMER(CUSID)

ALTER TABLE TRANSACT ADD CONSTRAINT FK_ TRANSACT_BRANCH FOREIGN KEY (BRANCHID) REFERENCES BRANCH(BRANCHID)

insert into CUSTOMER values('KH03','Nguyen Nam',100000);
insert into CUSTOMER values('KH04','Tran Bao',1000000);
insert into BRANCH values('CN01','Vietcombank Quan 1');
insert into BRANCH values('CN02','Vietcombank Quan 2');
insert into BRANCH values('CN03','Vietcombank Quan 3');
insert into BRANCH values('CN04','Vietcombank Quan 4');

--Create a role_TRANSACT (belongs to Server2) as below:
CREATE ROLE ROLE_TRANSACT NOT IDENTIFIED;

GRANT Insert,select ON TRANSACT TO ROLE_TRANSACT;
GRANT select on CUSTOMER to ROLE_TRANSACT;

-- Create an user GUEST (belongs to Server2)
CREATE USER GUEST IDENTIFIED BY GUEST
GRANT CONNECT TO GUEST

--Assign role_TRANSACT to guest
GRANT ROLE_TRANSACT  to GUEST

CREATE DATABASE LINK DBL_M01 CONNECT TO GUEST IDENTIFIED BY GUEST USING 'M01'
select db_link from user_db_links

-- Create a trigger
CREATE OR REPLACE TRIGGER Update_Balance
 AFTER INSERT ON TRANSACT
 FOR EACH ROW
 BEGIN
    IF :NEW.TRANSACTIONTYPE = 'Deposit' THEN
            UPDATE CUSTOMER
            SET CUSTOMER.BALANCE=CUSTOMER.BALANCE + :NEW.AMOUNT
            WHERE CUSTOMER.CUSID=:NEW.CUSID;
    ELSE
            UPDATE CUSTOMER
            SET CUSTOMER.BALANCE=CUSTOMER.BALANCE - :NEW.AMOUNT
            WHERE CUSTOMER.CUSID=:NEW.CUSID;
    END IF;
END;


-- Create a procedure DEPOSIT
create or replace procedure Deposit(v_CUSID in varchar2,v_money in Number)
As
	dem int;
Begin
    select count(CUSID) into dem from CUSTOMER where CUSID = v_CUSID;
            if(dem>0) then
            	insert into TRANSACT values('CN02',v_CUSID,v_money, 'Deposit');
            else
            select count(CUSID) into dem from M01.CUSTOMER@DBL_M01 where CUSID = v_CUSID;
            if(dem>0) then
                insert into M01.TRANSACT@DBL_M01 values('CN02',v_CUSID,v_money, 'Deposit');    
            end if;
    end if;
 COMMIT;
 End;

-- Create a procedure WITHDRAW

create or replace procedure Withdraw(v_CUSID in varchar2,v_money in Number)
As
	dem int;
Begin
    select count(CUSID) into dem from CUSTOMER where CUSID = v_CUSID;
        if(dem>0) then
            insert into TRANSACT values('CN02',v_CUSID,v_money, 'Withdraw');
        else
            select count(CUSID) into dem from M01.CUSTOMER@DBL_M01 where CUSID = v_CUSID;
            if(dem>0) then
            	insert into M01.TRANSACT@DBL_M01 values('CN02',v_CUSID,v_money, 'Withdraw');
            end if;
       end if;
   COMMIT;
End;