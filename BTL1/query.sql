--Cau 1: Tim san pham duoc mua voi so luong > 5 o 2 chi nhanh
SELECT S1.MASP, S1.TENSP
FROM CN1.CTHD C1 JOIN CN1.SANPHAM S1 ON C1.MASP = S1.MASP
WHERE C1.SOLUONG > 5
UNION
SELECT S2.MASP, S2.TENSP
FROM CN2.CTHD@cn2_qh_dblink C2 JOIN CN2.SANPHAM@cn2_qh_dblink S2 ON C2.MASP = S2.MASP
WHERE C2.SOLUONG > 5;

--Cau 2: Tim san pham con hang, khuyen mai = 25% o 2 chi nhanh
SELECT S1.MASP, S1.TENSP
FROM CN1.KHOSANPHAM_QLBH B1 JOIN CN1.SANPHAM S1 ON B1.MASP = S1.MASP
WHERE B1.TINHTRANG = 'Con Hang' AND B1.KHUYENMAI = 25
UNION
SELECT S2.MASP, S2.TENSP
FROM CN2.KHOSANPHAM_QLBH@cn2_qh_dblink B2 JOIN CN2.SANPHAM@cn2_qh_dblink S2 ON B2.MASP = S2.MASP
WHERE B2.TINHTRANG = 'Con Hang' AND B2.KHUYENMAI = 25;

--Cau 3: Tim khach hang da mua hang o ca 2 chi nhanh
SELECT K1.MAKH, K1.HOTEN
FROM CN1.HOADON H1 JOIN CN1.KHACHHANG K1 ON H1.MAKH = K1.MAKH
INTERSECT
SELECT K2.MAKH, K2.HOTEN
FROM CN2.HOADON@cn2_qh_dblink H2 JOIN CN2.KHACHHANG@cn2_qh_dblink K2 ON H2.MAKH = K2.MAKH;

--Cau 4: Tim san pham chi con hang o chi nhanh 1
SELECT S1.MASP, S1.TENSP
FROM CN1.KHOSANPHAM_QLBH B1 JOIN CN1.SANPHAM S1 ON B1.MASP = S1.MASP
WHERE B1.TINHTRANG = 'Con Hang'
MINUS
SELECT S2.MASP, S2.TENSP
FROM CN2.KHOSANPHAM_QLBH@cn2_qh_dblink B2 JOIN CN2.SANPHAM@cn2_qh_dblink S2 ON B2.MASP = S2.MASP
WHERE B2.TINHTRANG = 'Con Hang';

--Cau 5: Tim tong so luong hoa don da mua toan san pham san xuat Viet Nam o 2 chi nhanh:
SELECT COUNT(SOHD) AS "SO_LUONG_HOA_DON_MUA_SAN_PHAM_VIET_NAM"
FROM (SELECT * FROM CN1.HOADON H1
WHERE NOT EXISTS (
SELECT * FROM CN1.SANPHAM S1
WHERE S1.NUOCSX = 'Viet Nam' AND NOT EXISTS (
SELECT * FROM CN1.CTHD C1
WHERE H1.SOHD = C1.SOHD and C1.MASP = S1.MASP
)
)
UNION
SELECT * FROM CN2.HOADON@cn2_qh_dblink H2
WHERE NOT EXISTS (
SELECT * FROM CN2.SANPHAM@cn2_qh_dblink S2
WHERE S2.NUOCSX = 'Viet Nam' AND NOT EXISTS (
SELECT * FROM CN2.CTHD@cn2_qh_dblink C2
WHERE H2.SOHD = C2.SOHD and C2.MASP = S2.MASP
)
)
);

--Cau 6: Dem so nhan vien o 2 chi nhanh 
SELECT C.MACHINHANH, COUNT(MANV) AS "SO_NHAN_VIEN"
FROM (SELECT *
FROM CN1.NHANVIEN
UNION
SELECT *
FROM CN2.NHANVIEN@cn2_qh_dblink ) N JOIN CN1.CHINHANH C ON N.MACHINHANH = C.MACHINHANH
GROUP BY C.MACHINHANH;

--Cau 7: Tim san pham Trung Quoc co khuyen mai cao nhat 
SELECT S.MASP, S.TENSP, MAX(KHUYENMAI) AS "KHUYENMAI_CAONHAT"
FROM (SELECT *
FROM CN1.KHOSANPHAM_QLBH
UNION
SELECT *
FROM CN2.KHOSANPHAM_QLBH@cn2_qh_dblink) B JOIN CN1.SANPHAM S ON B.MASP = S.MASP
WHERE S.NUOCSX = 'TRUNGQUOC'
GROUP BY S.MASP, S.TENSP;

--Cau 8: Tinh tong cac hoa don o 2 chi nhanh 
SELECT C.MACHINHANH, SUM(TRIGIA) AS "TONG_CAC_HOA_DON"
FROM (SELECT *
FROM CN1.CTHD T1 JOIN CN1.HOADON H1 ON T1.SOHD = H1.SOHD
UNION
SELECT *
FROM CN2.CTHD@cn2_qh_dblink T2 JOIN CN2.HOADON@cn2_qh_dblink H2 ON T2.SOHD = H2.SOHD ) D 
JOIN CN1.CHINHANH C 
ON D.MACHINHANH = C.MACHINHANH
GROUP BY C.MACHINHANH;

--Cau 9: Gia trung binh cua cac san pham
SELECT TENSP, AVG(GIA) AS "GIA_TRUNG BINH"
FROM SANPHAM
GROUP BY TENSP;

--Cau 10: Tim cac hoa don chua thanh toan cua nam 2020
SELECT C1.MACHINHANH, H1.SOHD 
FROM CN1.HOADON H1 JOIN CN1.CHINHANH C1 ON H1.MACHINHANH = C1.MACHINHANH 
WHERE EXTRACT(YEAR FROM H1.NGHD) = 2020 AND H1.TRANGTHAI = 'Chua Thanh Toan'
UNION 
SELECT C2.MACHINHANH, H2.SOHD 
FROM CN2.HOADON@cn2_qh_dblink H2 JOIN CN2.CHINHANH@cn2_qh_dblink C2 ON H2.MACHINHANH = C2.MACHINHANH 
WHERE EXTRACT(YEAR FROM H2.NGHD) = 2020 AND H2.TRANGTHAI = 'Chua Thanh Toan';
