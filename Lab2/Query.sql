-- Thực hiện truy vấn trên môi trường phân tán tại MÁY 2
-- Câu 1: Tìm Sinh Viên có sinh nhật trong Quý 3, Quý 4
SELECT *
FROM dhcntt.SINHVIEN@dhcntt_dblink
WHERE TO_CHAR(NGAYSINH, 'Q') > 2;

-- Câu 2: Tìm khoa có tất cả sinh viên có giới tính nam (GIOITINH = 1) đã đóng học phí trong học kì 1.
SELECT SV1.MAKHOA
FROM dhcntt.SINHVIEN@dhcntt_dblink SV1
WHERE GIOITINH = 1
AND NOT EXISTS (
	SELECT *
	FROM dhcntt.HOCPHI@dhcntt_dblink HP
	WHERE NOT EXISTS (
		SELECT * FROM dhcntt.SINHVIEN@dhcntt_dblink SV2
		WHERE SV2.MASV=HP.MASV
	)
);

-- Câu 3: Tìm khoa có số lượng sinh viên nhiều nhất
SELECT MAKHOA, COUNT(MASV)
FROM dhcntt.SINHVIEN@dhcntt_dblink
GROUP BY MAKHOA
HAVING COUNT(MASV) >= ALL( 
	SELECT COUNT(MASV)
	FROM dhcntt.SINHVIEN@dhcntt_dblink
	GROUP BY MAKHOA
	);

-- Câu 4: Với từng khoa đưa ra tổng số lượng sinh viên, tổng số tiền mà sinh viên đã đóng học phí.
SELECT MAKHOA, COUNT(SV.MASV) AS "SOSV", SUM(SOTIEN) AS "TongHP"
FROM dhcntt.SINHVIEN@dhcntt_dblink SV,
dhcntt.HOCPHI@dhcntt_dblink HP
WHERE SV.MASV = HP.MASV
GROUP BY MAKHOA;
