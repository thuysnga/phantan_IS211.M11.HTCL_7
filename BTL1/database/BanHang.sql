create database banhang

--tạo user chi nhánh để tạo data
--chi nhánh 1
CREATE USER cn1 IDENTIFIED BY cn1;
GRANT CONNECT, DBA to cn1;


--chi nhánh 2
CREATE USER cn2 IDENTIFIED BY cn2;
GRANT CONNECT,DBA to cn2;

--tạo user cần thiết
-- chi nhánh 1
CREATE USER cn2 IDENTIFIED BY cn2;
GRANT CONNECT to cn2;
GRANT SELECT ON CN1.chinhanh to cn2;
GRANT SELECT ON CN1.KHACHHANG to cn2;
GRANT SELECT ON CN1.NHANVIEN to cn2;
GRANT SELECT ON CN1.SANPHAM to cn2;
GRANT SELECT ON CN1.HOADON to cn2;
GRANT SELECT ON CN1.KHOSANPHAM_QLKHO to cn2;
GRANT SELECT ON CN1.KHOSANPHAM_QLBH to cn2;
GRANT SELECT ON CN1.CTHD to cn2;

CREATE USER GiamDoc IDENTIFIED BY giamdoc
GRANT CONNECT,DBA TO GiamDoc

CREATE USER quanly IDENTIFIED BY quanly;
GRANT CONNECT to quanly;
GRANT CREATE SESSION to quanly;
GRANT SELECT, INSERT, UPDATE, DELETE ON CN1.KHACHHANG to quanly;
GRANT SELECT, INSERT, UPDATE, DELETE ON CN1.NHANVIEN to quanly;
GRANT SELECT, INSERT, UPDATE, DELETE ON CN1.SANPHAM to quanly;
GRANT SELECT, INSERT, UPDATE, DELETE ON CN1.HOADON to quanly;
GRANT SELECT, INSERT, UPDATE, DELETE ON CN1.KHOSANPHAM_QLKHO to quanly;
GRANT SELECT, INSERT, UPDATE, DELETE ON CN1.KHOSANPHAM_QLBH to quanly;
GRANT SELECT, INSERT, UPDATE, DELETE ON CN1.CTHD to quanly;



CREATE USER nhanvien IDENTIFIED BY nhanvien;
GRANT CONNECT to nhanvien;
GRANT CREATE SESSION to nhanvien;
GRANT CREATE DATABASE LINK to nhanvien;
GRANT SELECT ON CN1.SANPHAM to nhanvien;
GRANT SELECT,UPDATE ON CN1.KHOSANPHAM_QLBH to nhanvien;
GRANT SELECT, INSERT ON CN1.HOADON TO nhanvien;
GRANT SELECT, INSERT ON CN1.CTHD TO nhanvien;



-- chi nhánh 2
CREATE USER cn1 IDENTIFIED BY cn1;
GRANT CONNECT to cn1;
GRANT CREATE SESSION to cn1;
GRANT SELECT ON CN2.chinhanh to cn1;
GRANT SELECT ON CN2.KHACHHANG to cn1;
GRANT SELECT ON CN2.NHANVIEN to cn1;
GRANT SELECT ON CN2.SANPHAM to cn1;
GRANT SELECT ON CN2.HOADON to cn1;
GRANT SELECT ON CN2.KHOSANPHAM_QLKHO to cn1;
GRANT SELECT ON CN2.KHOSANPHAM_QLBH to cn1;
GRANT SELECT ON CN2.CTHD to cn1;


CREATE USER GiamDoc IDENTIFIED BY giamdoc
GRANT CONNECT,DBA TO GiamDoc;

CREATE USER quanly IDENTIFIED BY quanly;
GRANT CONNECT to quanly;
GRANT CREATE SESSION to quanly;
GRANT SELECT, INSERT, UPDATE, DELETE ON CN2.KHACHHANG to quanly;
GRANT SELECT, INSERT, UPDATE, DELETE ON CN2.NHANVIEN to quanly;
GRANT SELECT, INSERT, UPDATE, DELETE ON CN2.SANPHAM to quanly;
GRANT SELECT, INSERT, UPDATE, DELETE ON CN2.HOADON to quanly;
GRANT SELECT, INSERT, UPDATE, DELETE ON CN2.KHOSANPHAM_QLKHO to quanly;
GRANT SELECT, INSERT, UPDATE, DELETE ON CN2.KHOSANPHAM_QLBH to quanly;
GRANT SELECT, INSERT, UPDATE, DELETE ON CN2.CTHD to quanly;


CREATE USER nhanvien IDENTIFIED BY nhanvien;
GRANT CONNECT to nhanvien;
GRANT CREATE SESSION to nhanvien;
GRANT CREATE DATABASE LINK to nhanvien;
GRANT SELECT ON CN2.SANPHAM to nhanvien;
GRANT SELECT,UPDATE ON CN2.KHOSANPHAM_QLBH to nhanvien;
GRANT SELECT, INSERT ON CN2.HOADON TO nhanvien;
GRANT SELECT, INSERT ON CN2.CTHD TO nhanvien;



create table chinhanh(
machinhanh varchar(4),
tenchinhanh varchar(40),
CONSTRAINT P_CN PRIMARY KEY (machinhanh) 
);

--nhân bản
create table KHACHHANG (
	MAKH varchar(5),
	HOTEN varchar(50),
	DCHI varchar(50),
	SODT varchar(11),
    NGSINH DATE,
	CONSTRAINT P_KHACH PRIMARY KEY (MAKH) 
);

---phân mảnh ngang
create table NHANVIEN(
	MANV varchar(10),
	HOTEN varchar(50),
	SODT varchar(11),
    NGVL DATE,
	machinhanh varchar(4),
    CONSTRAINT P_NV PRIMARY KEY(MANV)
);

---nhân bản
create table SANPHAM(
    MASP varchar(10),
    TENSP varchar(50),
    DVT varchar(50),
    NUOCSX varchar(30),
    GIA int,
    CONSTRAINT P_Hang PRIMARY KEY(MASP)
);

--phân mảnh ngang
create table HOADON(
    SOHD int ,
    NGHD DATE,
    MAKH varchar(5),
    MANV varchar(10),
	machinhanh varchar(4),
    CONSTRAINT P_HD PRIMARY KEY(SOHD)
);
--phân mảnh ngang
create table CTHD(
	SOHD int ,
	MASP varchar(10),
	SoLuong int,
	TRIGIA INT,
	CONSTRAINT P_CTHD PRIMARY KEY(SOHD)
);

--phân mảnh dọc
create table KHOSANPHAM_QLKHO(
	machinhanh varchar(4),
    MASP varchar(10),
	Soluong int,
	CONSTRAINT qlkho_kho PRIMARY KEY(machinhanh,MASP)
);
--phân mảnh dọc
create table KHOSANPHAM_QLBH(
	machinhanh varchar(4),
    MASP varchar(10),
	TinhTrang varchar(20),
	KhuyenMai int,
	CONSTRAINT qlbh_kho PRIMARY KEY(machinhanh,MASP)
);


alter table NHANVIEN
add CONSTRAINT NV_CN_FK FOREIGN KEY (machinhanh) REFERENCES chinhanh(machinhanh);

alter table HOADON 
add CONSTRAINT hoadon_NV_FK FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV);

alter table HOADON 
add CONSTRAINT hoadon_khach_FK FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH) ;

alter table CTHD 
add CONSTRAINT CTHD_HD_FK FOREIGN KEY (SOHD) REFERENCES HOADON(SOHD) ;

alter table KHOSANPHAM_QLKHO 
add CONSTRAINT Kho_SP_FK FOREIGN KEY (MASP) REFERENCES SANPHAM(MASP);

alter table KHOSANPHAM_QLKHO 
add CONSTRAINT Kho_CN_FK FOREIGN KEY (machinhanh) REFERENCES chinhanh(machinhanh);

alter table KHOSANPHAM_QLBH 
add CONSTRAINT bh_CN_FK FOREIGN KEY (machinhanh) REFERENCES chinhanh(machinhanh);

alter table KHOSANPHAM_QLBH 
add CONSTRAINT bh_SP_FK FOREIGN KEY (MASP) REFERENCES SANPHAM(MASP);


CREATE SEQUENCE seq_HD
START WITH 1001
INCREMENT BY 1;

CREATE SEQUENCE seq_CTHD
START WITH 1001
INCREMENT BY 1;


INSERT INTO chinhanh VALUES ('CN1','Chinhanh SG');
INSERT INTO chinhanh VALUES ('CN2','Chinhanh HN');



INSERT INTO NHANVIEN VALUES ('NV01','NGUYEN NHU NHUT','09273456781',to_date('13/04/2006','dd/mm/yyyy'),'CN1');
INSERT INTO NHANVIEN VALUES ('NV02','LE THI PHI YEN','09875673901',to_date('21/04/2006','dd/mm/yyyy'),'CN1');
INSERT INTO NHANVIEN VALUES ('NV03','NGUYEN VAN BAO','09970473821',to_date('27/04/2006','dd/mm/yyyy'),'CN1');
INSERT INTO NHANVIEN VALUES ('NV04','NGO THANH TUAN','09137584981',to_date('24/06/2006','dd/mm/yyyy'),'CN1');
INSERT INTO NHANVIEN VALUES ('NV05','NGUYEN THI TRUC THANH','09185903871',to_date('20/07/2006','dd/mm/yyyy'),'CN1');
INSERT INTO NHANVIEN VALUES ('NV06','NGUYEN VAN A','09273456782',to_date('13/04/2001','dd/mm/yyyy'),'CN1');
INSERT INTO NHANVIEN VALUES ('NV07','LE THI PHI A','09875673902',to_date('21/04/2001','dd/mm/yyyy'),'CN1');
INSERT INTO NHANVIEN VALUES ('NV08','NGUYEN THI A','09970473822',to_date('27/04/2001','dd/mm/yyyy'),'CN1');
INSERT INTO NHANVIEN VALUES ('NV09','NGO THANH A','09137584982',to_date('24/06/2001','dd/mm/yyyy'),'CN1');
INSERT INTO NHANVIEN VALUES ('NV10','NGUYEN THI TRUC A','09185903872',to_date('20/07/2001','dd/mm/yyyy'),'CN1');
INSERT INTO NHANVIEN VALUES ('NV11','NGUYEN VAN B','09273456783',to_date('13/04/2002','dd/mm/yyyy'),'CN2');
INSERT INTO NHANVIEN VALUES ('NV12','LE THI PHI B','09875673903',to_date('21/04/2002','dd/mm/yyyy'),'CN2');
INSERT INTO NHANVIEN VALUES ('NV13','NGUYEN THI B','09970473823',to_date('27/04/2002','dd/mm/yyyy'),'CN2');
INSERT INTO NHANVIEN VALUES ('NV014','NGO THANH B','09137584983',to_date('24/06/2002','dd/mm/yyyy'),'CN2');
INSERT INTO NHANVIEN VALUES ('NV15','NGUYEN THI TRUC B','09185903873',to_date('20/07/2003','dd/mm/yyyy'),'CN2');
INSERT INTO NHANVIEN VALUES ('NV16','NGUYEN VAN C','09273456784',to_date('13/04/2004','dd/mm/yyyy'),'CN2');
INSERT INTO NHANVIEN VALUES ('NV17','LE THI PHI C','09875673904',to_date('21/04/2004','dd/mm/yyyy'),'CN2');
INSERT INTO NHANVIEN VALUES ('NV18','NGUYEN THI C','09970473824',to_date('27/04/2004','dd/mm/yyyy'),'CN2');
INSERT INTO NHANVIEN VALUES ('NV19','NGO THANH C','09137584984',to_date('24/06/2004','dd/mm/yyyy'),'CN2');
INSERT INTO NHANVIEN VALUES ('NV20','NGUYEN THI TRUC C','09185903874',to_date('20/07/2004','dd/mm/yyyy'),'CN2');


INSERT INTO KHACHHANG VALUES ('KH01','NGUYEN VAN A','TPHCM','08823451',to_date('22/10/1960','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH02','TRAN NGOC HAN','HN','0908256478',to_date('03/04/1974','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH03','TRAN NGOC LINH','HN','0938776266',to_date('10/06/1980','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH04','TRAN MINH LONG','TPHCM','0917325476',to_date('09/03/1965','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH05','LE NHAT MINH','DN','08246108',to_date('10/03/1950','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH06','LE HOAI THUONG','TPHCM','08631738',to_date('31/12/1981','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH07','NGUYEN VAN TAM','VT','0916783565',to_date('06/06/1971','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH08','PHAN THI THANH','TPHCM','0938435756',to_date('10/01/1971','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH09','LE HA VINH','TPHCM','08654763',to_date('03/03/1979','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH10','HA DUY LAP','DN','08768904',to_date('02/05/1983','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH11','NGUYEN VAN C','THHCM','08823451',to_date('22/10/1960','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH12','TRAN NGOC A','TPHCM','0908256478',to_date('03/04/1974','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH13','TRAN NGOC A','VT','0938776266',to_date('10/06/1980','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH14','TRAN MINH A','TPHCM','0917325476',to_date('09/03/1965','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH15','LE NHAT A','DN','08246108',to_date('10/03/1950','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH16','LE HOAI A','NT','08631738',to_date('31/12/1981','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH17','NGUYEN VAN A','TPHCM','0916783565',to_date('06/06/1971','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH18','PHAN THI A','TPHCM','0938435756',to_date('10/01/1971','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH19','LE HA A','VT','08654763',to_date('03/03/1979','dd/mm/yyyy'));
INSERT INTO KHACHHANG VALUES ('KH20','HA DUY A','HN','08768904',to_date('02/05/1983','dd/mm/yyyy'));



INSERT INTO SANPHAM VALUES ('BC01','BUT CHI','CAY','SINGAPORE',3000);
INSERT INTO SANPHAM VALUES ('BC02','BUT CHI','CAY','SINGAPORE',5000);
INSERT INTO SANPHAM VALUES ('BC03','BUT CHI','CAY','VIETNAM',3500);
INSERT INTO SANPHAM VALUES ('BC04','BUT CHI','HOP','VIETNAM',30000);
INSERT INTO SANPHAM VALUES ('BB01','BUT BI','CAY','VIETNAM',5000);
INSERT INTO SANPHAM VALUES ('BB02','BUT BI','CAY','TRUNGQUOC',7000);
INSERT INTO SANPHAM VALUES ('BB03','BUT BI','HOP','THAILAN',100000);
INSERT INTO SANPHAM VALUES ('TV01','TAP 100 TRANG GIAY MONG','QUYEN','TRUNGQUOC',2500);
INSERT INTO SANPHAM VALUES ('TV02','TAP 200 TRANG GIAY MONG','QUYEN','TRUNGQUOC',4500);
INSERT INTO SANPHAM VALUES ('TV03','TAP 100 TRANG GIAY TOT','QUYEN','VIETNAM',3000);
INSERT INTO SANPHAM VALUES ('TV04','TAP 200 TRANG GIAY TOT','QUYEN','VIETNAM',5500);
INSERT INTO SANPHAM VALUES ('TV05','TAP 100 TRANG ','CHUC','VIETNAM',23000);
INSERT INTO SANPHAM VALUES ('TV06','TAP 200 TRANG ','CHUC','VIETNAM',53000);
INSERT INTO SANPHAM VALUES ('TV07','TAP 100 TRANG ','CHUC','TRUNGQUOC',34000);
INSERT INTO SANPHAM VALUES ('ST01','SO TAY 500 TRANG','QUYEN','TRUNGQUOC',40000);
INSERT INTO SANPHAM VALUES ('ST02','SO TAY LOAI 1','QUYEN','VIETNAM',55000);
INSERT INTO SANPHAM VALUES ('ST03','SO TAY LOAI 2','QUYEN','VIETNAM',51000);
INSERT INTO SANPHAM VALUES ('ST04','SO TAY','QUYEN','THAILAN',55000);
INSERT INTO SANPHAM VALUES ('ST05','SO TAY MONG','QUYEN','THAILAN',20000);
INSERT INTO SANPHAM VALUES ('ST06','PHAN VIET BANG','HOP','VIETNAM',5000);
INSERT INTO SANPHAM VALUES ('ST07','PHAN KHONG BUI','HOP','VIETNAM',7000);



INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN1','TV07',0);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN1','ST01',5);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN1','BC03',0);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN1','ST01',5);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN1','TV03',5);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN1','TV06',0);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN1','ST02',5);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN1','BC04',0);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN1','BB02',5);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN1','ST07',0);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN2','TV07',5);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN2','TV05',7);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN2','BB03',5);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN2','BC01',1);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN2','BC03',5);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN2','BB02',3);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN2','TV06',2);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN2','ST04',0);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN2','ST06',0);
INSERT INTO KHOSANPHAM_QLKHO VALUES ('CN2','ST07',4);


INSERT INTO KHOSANPHAM_QLBH VALUES ('CN1','TV07','Het Hang',20);
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN1','ST01','Con Hang',5);
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN1','BC03','Het Hang',20);
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN1','ST01','Con Hang',10);
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN1','TV03','Con Hang',5);
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN1','TV06','Het Hang',20);
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN1','ST02','Con Hang',10);
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN1','BC04','Het Hang',20);
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN1','BB02','Con Hang',5);
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN1','ST07','Het Hang',20);
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN2','TV07','Con Hang',5) 
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN2','TV05','Con Hang',18);
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN2','BB03','Con Hang',15);
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN2','BC01','Con Hang',15);
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN2','BC03','Con Hang',5);
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN2','BB02','Con Hang',30);
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN2','TV06','Con Hang',20);
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN2','ST04','Het Hang',20);
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN2','ST06','Het Hang',20);
INSERT INTO KHOSANPHAM_QLBH VALUES ('CN2','ST07','Con Hang',10);




INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('27/07/2006','dd/mm/yyyy'),'KH10','NV01','CN1');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('10/08/2006','dd/mm/yyyy'),'KH01','NV12','CN1');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('23/08/2006','dd/mm/yyyy'),'KH02','NV13','CN1');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('01/09/2006','dd/mm/yyyy'),'KH12','NV11','CN1');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('20/10/2006','dd/mm/yyyy'),'KH11','NV02','CN1');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('16/10/2006','dd/mm/yyyy'),'KH11','NV13','CN1');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('28/10/2006','dd/mm/yyyy'),'KH03','NV13','CN1');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('28/10/2006','dd/mm/yyyy'),'KH01','NV03','CN1');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('28/10/2006','dd/mm/yyyy'),'KH03','NV14','CN1');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('01/11/2006','dd/mm/yyyy'),'KH01','NV15','CN1');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('04/11/2006','dd/mm/yyyy'),'KH14','NV13','CN1');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('30/11/2006','dd/mm/yyyy'),'KH15','NV14','CN1');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('12/12/2006','dd/mm/yyyy'),'KH06','NV01','CN2');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('31/12/2006','dd/mm/yyyy'),'KH03','NV12','CN2');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('01/01/2007','dd/mm/yyyy'),'KH16','NV01','CN2');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('01/01/2007','dd/mm/yyyy'),'KH17','NV02','CN2');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('02/01/2007','dd/mm/yyyy'),'KH08','NV17','CN2');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('13/01/2007','dd/mm/yyyy'),'KH18','NV18','CN2');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('13/01/2007','dd/mm/yyyy'),'KH19','NV03','CN2');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('14/01/2007','dd/mm/yyyy'),'KH09','NV04','CN2');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('16/01/2007','dd/mm/yyyy'),'KH20','NV03','CN2');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('16/01/2007','dd/mm/yyyy'),'KH12','NV03','CN2');
INSERT INTO HOADON VALUES (seq_HD.nextval,to_date('17/01/2007','dd/mm/yyyy'),'KH13','NV20','CN2');


INSERT INTO CTHD VALUES (seq_CTHD.nextval,'BC01','1',3000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'BC02',3,15000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'BB01',2,10000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'BB03',2,7000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'TV04',10,55000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'BB02',5,35000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'ST04',4,22000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'TV02',2,9000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'BC03',5,17500);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'ST07',4,28000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'TV05',2,46000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'ST01',8,320000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'ST02',3,165000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'TV05',10,230000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'ST07',5,35000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'ST03',1,51000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'ST06',5,300000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'ST02',2,110000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'ST06',4,20000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'TV04',20,110000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'ST07',6,42000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'TV01',4,10000);
INSERT INTO CTHD VALUES (seq_CTHD.nextval,'ST01',4,160000);