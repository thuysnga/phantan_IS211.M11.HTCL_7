-- Câu 1: Tài khoản nhân viên: Đưa ra thông tin sách với tınh tr ̀ ạng ‘Het Hang’ của tất cả các chi nhánh. Thông tin hiển thị (MaChiNhanh, MaSach, TenSach)
SELECT N.MACHINHANH, S.MASACH, S.TENSACH
FROM CN1.SACH S JOIN CN1.KHOSACH_NVBH N ON S.MASACH = N.MASACH
WHERE N.TINHTRANG = 'Het Hang'
UNION
SELECT N2.MACHINHANH, S2.MASACH, S2.TENSACH
FROM CN2.SACH@nga_link S2 JOIN CN2.KHOSACH_NVBH@nga_link N2 ON 
S2.MASACH = N2.MASACH
WHERE N2.TINHTRANG = 'Het Hang';

-- Câu 2: Tài khoản giám đốc: Tım s ̀ ách với tınh tr ̀ ạng ‘Con Hang’ và số lượng sách trong kho lớn hơn 120 tại tất cả chi nhánh. Thông tin hiển thị (MaSach, TenSach)
SELECT S.MASACH, S.TENSACH
FROM CN1.KHOSACH_NVBH N JOIN CN1.SACH S ON N.MASACH = S.MASACH 
JOIN CN1.KHOSACH_QLKHO Q ON S.MASACH = Q.MASACH
WHERE N.TINHTRANG = 'Con Hang' AND Q.SOLUONG > 120
UNION
SELECT S2.MASACH, S2.TENSACH
FROM CN2.KHOSACH_NVBH@giamdoc_dblink N2 JOIN 
CN2.SACH@giamdoc_dblink S2 ON N2.MASACH = S2.MASACH JOIN 
CN2.KHOSACH_QLKHO@giamdoc_dblink Q2 ON S2.MASACH = Q2.MASACH
WHERE N2.TINHTRANG = 'Con Hang' AND Q2.SOLUONG > 120;

-- Câu 3: Tài khoản quản lý kho: Đưa ra thông tin sách gồm tên sách, ngày xuất bản, tác giả, giá tiền, số lượng, lần in, ngày nhập với những sách của chi nhánh mınh quản lý của nhà xuất bản ‘Kim Dong’.
-- Tại chi nhánh 1:
SELECT S.TENSACH, S.NGAYXB, S.TACGIA, S.GIATIEN, Q.SOLUONG, 
S.LANIN, Q.NGAYCAPNHAT
FROM CN1.SACH S JOIN CN1.KHOSACH_QLKHO Q ON S.MASACH = Q.MASACH
WHERE S.NHAXUATBAN = 'Kim Dong';

-- Tại Chi nhánh 2:
SELECT S.TENSACH, S.NGAYXB, S.TACGIA, S.GIATIEN, Q.SOLUONG, 
S.LANIN, Q.NGAYCAPNHAT
FROM CN2.SACH S JOIN CN2.KHOSACH_QLKHO Q ON S.MASACH = Q.MASACH
WHERE S.NHAXUATBAN = 'Kim Dong';

-- Câu 4: Tài khoản giám đốc: Đưa ra thông tin sách (Mã sách, tên sách) được phân phối đến tất cả chi nhánh với tình trạng còn hàng.
SELECT S.MASACH, S.TENSACH
FROM CN1.SACH S JOIN CN1.KHOSACH_NVBH N ON S.MASACH = N.MASACH 
where N.tinhtrang = 'Con Hang'
AND S.MASACH IN (
	SELECT S2.MASACH 
	FROM CN2.SACH@giamdoc_dblink S2 JOIN CN2.KHOSACH_NVBH@giamdoc_dblink N2 ON S2.MASACH = N2.MASACH 
	where N2.tinhtrang = 'Con Hang'
);

-- Câu 5: Tài khoản giám đốc: Tìm sách được phân phối tại chi nhánh 1 và chi nhánh 2.
SELECT S.MASACH, S.TENSACH
FROM CN1.SACH S JOIN CN1.KHOSACH_NVBH N ON S.MASACH = N.MASACH
AND S.MASACH IN (
	SELECT S2.MASACH 
	FROM CN2.SACH@giamdoc_dblink S2 JOIN CN2.KHOSACH_NVBH@giamdoc_dblink N2 ON S2.MASACH = N2.MASACH
);

Câu 6: Tài khoản nhân viên: Đưa ra thông tin mã sách, tên sách, sách có khuyến mãi cao nhất, tổng số chi nhánh phân phối sách của những sách thuộc nhà xuất bản ‘Kim Dong’.
SELECT S.MASACH, S.TENSACH, MAX(KHUYENMAI) AS 
"KHUYENMAI_CAONHAT", COUNT(MACHINHANH) AS "TONG_CHINHANH"
FROM (
	SELECT *
	FROM CN2.KHOSACH_NVBH 
	UNION
	SELECT *
	FROM CN1.KHOSACH_NVBH@nhanvien3_dblink 
) N JOIN CN2.SACH S ON N.MASACH = S.MASACH
WHERE NHAXUATBAN = 'Kim Dong'
GROUP BY S.MASACH, S.TENSACH;
