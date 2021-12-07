CREATE OR REPLACE FUNCTION TongSoLuongBanTrongNam(v_masp in SANPHAM.MASP%TYPE)
RETURN NUMBER
IS
	v_tongsoluong NUMBER := 0;
	v_soluong CTHD.SoLuong%TYPE := 0;
	c_sohd HOADON.SoHD%TYPE;
	CURSOR cur_sohd IS
		SELECT SoHD
		FROM HOADON
		WHERE extract(year from NGHD) = extract(year from CURRENT_DATE);
BEGIN
	OPEN cur_sohd;
    LOOP
        FETCH cur_sohd INTO c_sohd;
        EXIT WHEN cur_sohd%NOTFOUND;

        v_soluong := 0;

        BEGIN
        SELECT SoLuong
        INTO v_soluong
        FROM CTHD
        WHERE SoHD = c_sohd
        AND MASP = v_masp;

        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        v_soluong := 0;
        END;

        v_tongsoluong := v_tongsoluong + v_soluong;
    END LOOP;
    CLOSE cur_sohd;

	RETURN v_tongsoluong;
END;
/


declare
	a NUMBER;
BEGIN
	a:= TongSoLuongBanTrongNam('SS01');
	DBMS_OUTPUT.PUT_LINE(a);
end;
/



INSERT INTO HOADON VALUES (1001,to_date('27/07/2021','dd/mm/yyyy'),'KH10','NV01','CN1','Da Thanh Toan');
INSERT INTO HOADON VALUES (1002,to_date('10/08/2020','dd/mm/yyyy'),'KH01','NV02','CN1','Chua Thanh Toan');
INSERT INTO HOADON VALUES (1003,to_date('23/08/2021','dd/mm/yyyy'),'KH02','NV06','CN1','Da Thanh Toan');


INSERT INTO CTHD VALUES (1001,'BC01',1,3000);
INSERT INTO CTHD VALUES (1001,'BC02',3,15000);
INSERT INTO CTHD VALUES (1002,'BC01',2,10000);
INSERT INTO CTHD VALUES (1002,'BB03',2,7000);
INSERT INTO CTHD VALUES (1002,'TV04',10,55000);
INSERT INTO CTHD VALUES (1003,'BC01',5,35000);