-- tạo và grant quyền
CREATE USER cn1 IDENTIFIED BY cn1;
GRANT CONNECT, DBA to cn1;
GRANT SELECT ON CN1.SACH to cn2;
GRANT SELECT ON CN1.CHINHANH to cn2;
GRANT SELECT ON CN1.NHANVIEN to cn2;
GRANT SELECT ON CN1.KHOSACH_NVBH to cn2;
GRANT SELECT ON CN1.KHOSACH_QLKHO to cn2;

CREATE USER giamdoc IDENTIFIED BY giamdoc;
GRANT CONNECT to giamdoc;
GRANT CREATE SESSION to giamdoc;
GRANT CREATE DATABASE LINK to giamdoc;
GRANT SELECT ON CN1.SACH to giamdoc;
GRANT SELECT ON CN1.CHINHANH to giamdoc;
GRANT SELECT ON CN1.NHANVIEN to giamdoc;
GRANT SELECT ON CN1.KHOSACH_NVBH to giamdoc;
GRANT SELECT ON CN1.KHOSACH_QLKHO to giamdoc;
CREATE DATABASE LINK giamdoc_dblink connect to giamdoc identifid by giamdoc using ‘cn2_link’;

CREATE USER quanlykho IDENTIFIED BY quanlykho;
GRANT CONNECT to quanlykho;
GRANT CREATE SESSION to quanlykhoa;
GRANT SELECT ON CN1.KHOSACH_QLKHO to quanlykho;
GRANT SELECT ON CN1.SACH to quanlykho;

CREATE USER nhanvien IDENTIFIED BY nhanvien;
GRANT CONNECT to nhanvien;
GRANT CREATE SESSION to nhanvien;
GRANT CREATE DATABASE LINK to nhanvien;
GRANT SELECT ON CN1.SACH to nhanvien;
GRANT SELECT ON CN1.KHOSACH_NVBH to nhanvien;
CREATE DATABASE LINK nga_link connect to nhanvien identifid by nhanvien using 'cn2_link';





-- tạo bảng sách và thêm dữ liệu
CREATE TABLE SACH(
	MaSach varchar2(5) PRIMARY KEY,
	TenSach varchar2(50),
	NgayXB date,
	TacGia varchar2(50),
	GiaTien number,
	NhaXuatBan varchar2(50),
	LanIn number
);

INSERT INTO SACH VALUES ('Book1', 'SpyxFamily T.6', to_date('29/10/2021','dd/mm/yyyy'), 'Endou Tatsuya', 25000, 'Kim Dong', 1);
INSERT INTO SACH VALUES ('Book2', 'S. Family T.6 L', to_date('29/10/2021','dd/mm/yyyy'), 'Endou Tatsuya', 45000, 'Kim Dong', 1);
INSERT INTO SACH VALUES ('Book3', 'Th. Lũng B.H', NULL, 'Agatha Christie ', 120000, 'Tre', 1);
INSERT INTO SACH VALUES ('Book4', 'Black Jack 3', to_date('25/10/2021','dd/mm/yyyy'), 'Osamu Tezuka', 30000, 'Tre', 1); 
INSERT INTO SACH VALUES ('Book5', 'One Piece 90', to_date('11/10/2021','dd/mm/yyyy'), 'Eiichiro Oda', 19500, 'Kim Dong', 2);

-- tạo và thêm dữ liệu bảng chinhanh
CREATE TABLE CHINHANH (
	MaChiNhanh varchar2(4) primary key,
	TenChiNhanh varchar2(50),
	SoDT varchar2(10)
);

INSERT INTO ChiNhanh VALUES ('CN01','Quan 3, TPHCM','0939013913');

-- tạo và thêm dữ liệu bảng nhanvien
CREATE TABLE NHANVIEN( 
	MaNV varchar2(4) PRIMARY KEY, 
	TenNV varchar2(50), 
	DiaChi varchar2(20), 
	SoDT varchar2(10), 
	Luong number, 
	MaChiNhanh varchar2(4)
);

-- tạo và thêm dữ liệu vào bảng nhanvien
CREATE TABLE NHANVIEN( 
	MaNV varchar2(4) PRIMARY KEY, 
	TenNV varchar2(50), 
	DiaChi varchar2(20), 
	SoDT varchar2(10), 
	Luong number, 
	MaChiNhanh varchar2(4)
);

-- THEM KHOA NGOAI
ALTER TABLE NHANVIEN ADD CONSTRAINT FK_CHINHANH_NHANVIEN FOREIGN KEY (MaChiNhanh) REFERENCES CHINHANH(MaChiNhanh);

INSERT INTO NHANVIEN VALUES ('NV03','Ho Trong Khang','Binh Dinh','0858595208',5200000,'CN01');
INSERT INTO NHANVIEN VALUES ('NV04','Ho Huu Thang','Bien Hoa',NULL,5200000,'CN01');
INSERT INTO NHANVIEN VALUES ('NV06','Tran Thi Ngoc An','Binh Dinh','0944052874',5200000,'CN01');

-- tạo bảng KHOSACH_QLKHO và thêm dữ liệu
CREATE TABLE KHOSACH_QLKHO (
	MaChiNhanh varchar2(4),
	MaSach varchar2(5),
	SoLuong number,
	NgayCapNhat date,
	CONSTRAINT PK_KHOSACH_QLKHO PRIMARY KEY (MaChiNhanh, MaSach)
);

-- THEM KHOA NGOAI
ALTER TABLE KHOSACH_QLKHO ADD CONSTRAINT FK_KHOSACH_QLKHO_CHINHANH FOREIGN KEY (MaChiNhanh) REFERENCES CHINHANH(MaChiNhanh);
ALTER TABLE KHOSACH_QLKHO ADD CONSTRAINT FK_KHOSACH_QLKHO_SACH FOREIGN KEY (MaSach) REFERENCES SACH(MaSach);

INSERT INTO KHOSACH_QLKHO VALUES ('CN01', 'Book1', 0, to_date('29/10/2021','dd/mm/yyyy'));
INSERT INTO KHOSACH_QLKHO VALUES ('CN01', 'Book3', 510, to_date('30/10/2021','dd/mm/yyyy'));
INSERT INTO KHOSACH_QLKHO VALUES ('CN01', 'Book5', 100, to_date('30/10/2021','dd/mm/yyyy'));

-- tạo bảng KHOSACH_NVBH và thêm dữ liệu
CREATE TABLE KHOSACH_NVBH (
	MaChiNhanh varchar2(4),
	MaSach varchar2(5),
	TinhTrang varchar2(8),
	KhuyenMai number,
	CONSTRAINT PK_KHOSACH_NVBH PRIMARY KEY (MaChiNhanh, MaSach)
);
-- TAO KHOA NGOAI
ALTER TABLE KHOSACH_NVBH ADD CONSTRAINT FK_KHOSACH_NVBH_CHINHANH FOREIGN KEY (MaChiNhanh) REFERENCES CHINHANH(MaChiNhanh);
ALTER TABLE KHOSACH_NVBH ADD CONSTRAINT FK_KHOSACH_NVBH_SACH FOREIGN KEY (MaSach) REFERENCES SACH(MaSach);

INSERT INTO KHOSACH_NVBH VALUES ('CN01', 'Book1', 'Het Hang', 0);
INSERT INTO KHOSACH_NVBH VALUES ('CN01', 'Book3', 'Con Hang', 20);
INSERT INTO KHOSACH_NVBH VALUES ('CN01', 'Book5', 'Con Hang', 20);
