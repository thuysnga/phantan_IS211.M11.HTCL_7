-- trigger: sá»‘ sÃ¡ch luÃ´n pháº£i lá»›n hÆ¡n 1

-- procedure: bÃ¡n sÃ¡ch

CREATE or REPLACE PROCEDURE BanSanPham(var_masp in SANPHAM.MASP%TYPE)
IS
BEGIN

END;


-- trigger: thá»±c hiá»‡n trÃªn KHOSACH_QLKHO, nháº­p vÃ o mÃ£ sáº£n pháº©m, xem tÃ¬nh tráº¡ng sáº£n pháº©m (cÃ²n hay háº¿t) vÃ  sá»‘ lÆ°á»£ng cÃ²n láº¡i

CREATE OR REPLACE function getTinhTrang(var_masp in KHOSACH_QLKHO.MASP%TYPE) RETURN int
IS
	var_soluong int;
	dem int;
BEGIN
	dem := -1;
	select count(var_masp) into dem from KHOSACH_QLKHO where MASP = var_masp;
	if (dem!= -1) then
		select SoLuong into var_soluong from KHOSACH_QLKHO where MASP = var_masp;
	end if;
	return var_soluong;
END getTinhTrang;

SELECT MaSP, getSoLuong('TV07') FROM KHOSACH_QLKHO;
SELECT getSoLuong('ST01') FROM KHOSACH_QLKHO;

CREATE OR REPLACE PROCEDURE BaiThiHTCL1.proc_quanlynhanvien(manv_in IN PHANCONG.MANV%TYPE)
IS
    var_soluong number;
    var_tennhanvien NHANVIEN.HOTEN%TYPE;
    var_nhiemvu     PHANCONG.NHIEMVU%TYPE;
    var_mahang      CHUYENBAY.MAHANG%TYPE;
    var_xuatphat    CHUYENBAY.XUATPHAT%TYPE;
    var_diemden     CHUYENBAY.DIEMDEN%TYPE;
    var_batdau      CHUYENBAY.BATDAU%TYPE;
    var_tgbay       CHUYENBAY.TGBAY%TYPE;
    cur_machuyenbay PHANCONG.MACB%TYPE;
    CURSOR CUR IS SELECT PHANCONG.MACB
                    FROM BaiThiHTCL1.PHANCONG
                    WHERE PHANCONG.MANV = manv_in;
BEGIN
    SELECT NV.HOTEN,COUNT(*) INTO var_tennhanvien, var_soluong
    FROM BaiThiHTCL1.NHANVIEN NV, BaiThiHTCL1.PHANCONG PC
    WHERE NV.MANV = PC.MANV AND 
    NV.MANV = manv_in
    GROUP BY NV.MANV,NV.HOTEN;
    
    DBMS_OUTPUT.PUT_LINE('** THONG TIN CHUYEN BAY CUA NHAN VIEN: '|| var_tennhanvien || ' **');
    DBMS_OUTPUT.PUT_LINE('** SO LUONG CHUYEN BAY THAM GIA: '|| var_soluong || ' **');
    OPEN CUR;
    LOOP 
        FETCH CUR INTO cur_machuyenbay;
        DBMS_OUTPUT.PUT_LINE('=============================================');
        EXIT WHEN CUR%NOTFOUND;
        SELECT 
              NHIEMVU, MAHANG, XUATPHAT, DIEMDEN, BATDAU, TGBAY 
              INTO
                  var_nhiemvu, var_mahang, var_xuatphat, 
                  var_diemden, var_batdau, var_tgbay
        FROM  
              BaiThiHTCL1.PHANCONG,BaiThiHTCL1.CHUYENBAY
        WHERE 
              PHANCONG.MACB = CHUYENBAY.MACB AND
              CHUYENBAY.MACB = cur_machuyenbay AND PHANCONG.MANV = manv_in ;
        
       
        DBMS_OUTPUT.PUT_LINE('NHIEM VU ' || var_nhiemvu);
        DBMS_OUTPUT.PUT_LINE('CHUYEN BAY: '||cur_machuyenbay||' ,HANG: '||var_mahang);
        DBMS_OUTPUT.PUT_LINE('XUAT PHAT: '||var_xuatphat||' ,DIEM DEN: '||var_diemden);
        DBMS_OUTPUT.PUT_LINE('THOI GIAN BAT DAU: '||var_batdau);
        DBMS_OUTPUT.PUT_LINE('THOI GIAN BAY: '||var_tgbay);
    
    END LOOP;
    CLOSE CUR;
END;


CREATE or REPLACE PROCEDURE BanSanPham(var_masp in SANPHAM.MASP%TYPE)
IS
	var_soluong number;
BEGIN
	SELECT SoLuong INTO var_soluong
	FROM KHOSACH_QLKHO
	WHERE MASP = var_masp;
	DBMS_OUTPUT.PUT_LINE('** MÃ S?N PH?M: '|| var_masp || ' **');
	DBMS_OUTPUT.PUT_LINE('** S? L??NG: '|| var_soluong || ' **');
END BanSanPham;
COMMIT;

BEGIN 
    BanSanPham('ST01');
END;

CREATE or REPLACE PROCEDURE thu
BEGIN
    DBMS_OUTPUT.PUT_LINE('THU: ');
END;

BEGIN 
    thu(1);
END;

Begin
DBMS_OUTPUT.PUT_LINE('THU: ');
end;


CREATE or REPLACE PROCEDURE BanSanPham(var_masp in SANPHAM.MASP%TYPE)
IS
	var_soluong number;
BEGIN
	SELECT SoLuong INTO var_soluong
	FROM KHOSACH_QLKHO
	WHERE MASP = var_masp;
	DBMS_OUTPUT.PUT_LINE('** MÃ SẢN PHẨM: '|| var_masp || ' **');
	DBMS_OUTPUT.PUT_LINE('** SỐ LƯỢNG: '|| var_soluong || ' **');
END;


BEGIN 
    BanSanPham('ST01');
END;

CREATE or REPLACE PROCEDURE TIMKIEM(var_masp SANPHAM.MASP%type)
IS
BEGIN
  select MASP
  where MASP = var_masp;
  exception
    when no_data_found then
      dbms_output.put_line('không tìm thấy');
    when others then
      dbms_output.put_line('Không xác định được lỗi gì =))');
END;

-- Thực thi thủ tục TIMKIEM
DECLARE
    var_masp SANPHAM.MASP%TYPE;
    tenmon SANPHAM.tenmh%TYPE;
    sotinchi SANPHAM.sotc%TYPE;
BEGIN
    TIMKIEM('&Nhap_ma_mon_hoc', var_masp);
    dbms_output.put_line(
        'ten mon:' || to_char(tenmon) ||
        ' so tc: ' || to_char(sotincchi) ||
);
END;