CREATE OR REPLACE FUNCTION TongSoLuongBanTrongNam(v_masp in CN1.SANPHAM.MASP%TYPE)
RETURN NUMBER
IS
    v_tongsoluong NUMBER := 0;
    v_soluong CN1.CTHD.SoLuong%TYPE := 0;
    c_sohd1 CN1.HOADON.SoHD%TYPE;
    c_sohd2 CN1.HOADON.SoHD%TYPE;
    CURSOR cur_sohdcn1 IS
        SELECT SoHD
        FROM CN1.HOADON
        WHERE extract(year from NGHD) = extract(year from CURRENT_DATE);
    CURSOR cur_sohdcn2 IS
        SELECT SoHD
        FROM CN2.HOADON@cn2_dblink
        WHERE extract(year from NGHD) = extract(year from CURRENT_DATE);
BEGIN
BEGIN
    OPEN cur_sohdcn1;
    LOOP
        FETCH cur_sohdcn1 INTO c_sohd1;
        EXIT WHEN cur_sohdcn1%NOTFOUND;

        v_soluong := 0;

        BEGIN
            SELECT SoLuong
            INTO v_soluong
            FROM CN1.CTHD
            WHERE SoHD = c_sohd1
            AND MASP = v_masp;

            EXCEPTION
            WHEN NO_DATA_FOUND THEN
            v_soluong := 0;
        END;

        v_tongsoluong := v_tongsoluong + v_soluong;
    END LOOP;
    CLOSE cur_sohdcn1;
END;

BEGIN
    OPEN cur_sohdcn2;
    LOOP
        FETCH cur_sohdcn2 INTO c_sohd2;
        EXIT WHEN cur_sohdcn2%NOTFOUND;

        v_soluong := 0;

        BEGIN
            SELECT SoLuong
            INTO v_soluong
            FROM CN2.CTHD@cn2_dblink
            WHERE SoHD = c_sohd2
            AND MASP = v_masp;

            EXCEPTION
            WHEN NO_DATA_FOUND THEN
            v_soluong := 0;
        END;

        v_tongsoluong := v_tongsoluong + v_soluong;
    END LOOP;
    CLOSE cur_sohdcn2;
END;

    RETURN v_tongsoluong;
END;
/

set serveroutput on size 30000;

DECLARE
    SL NUMBER;
BEGIN
    SL:= TongSoLuongBanTrongNam('ST01');
    DBMS_OUTPUT.PUT_LINE(SL);
END;
/


-- CN2
CREATE OR REPLACE FUNCTION TongSoLuongBanTrongNam(v_masp in CN2.SANPHAM.MASP%TYPE)
RETURN NUMBER
IS
    v_tongsoluong NUMBER := 0;
    v_soluong CN2.CTHD.SoLuong%TYPE := 0;
    c_sohd1 CN2.HOADON.SoHD%TYPE;
    c_sohd2 CN2.HOADON.SoHD%TYPE;
    CURSOR cur_sohdcn2 IS
        SELECT SoHD
        FROM CN2.HOADON
        WHERE extract(year from NGHD) = extract(year from CURRENT_DATE);
    CURSOR cur_sohdcn1 IS
        SELECT SoHD
        FROM CN1.HOADON@cn1_dblink
        WHERE extract(year from NGHD) = extract(year from CURRENT_DATE);
BEGIN
BEGIN
    OPEN cur_sohdcn2;
    LOOP
        FETCH cur_sohdcn2 INTO c_sohd2;
        EXIT WHEN cur_sohdcn2%NOTFOUND;

        v_soluong := 0;

        BEGIN
            SELECT SoLuong
            INTO v_soluong
            FROM CN2.CTHD
            WHERE SoHD = c_sohd2
            AND MASP = v_masp;

            EXCEPTION
            WHEN NO_DATA_FOUND THEN
            v_soluong := 0;
        END;

        v_tongsoluong := v_tongsoluong + v_soluong;
    END LOOP;
    CLOSE cur_sohdcn2;
END;

BEGIN
    OPEN cur_sohdcn1;
    LOOP
        FETCH cur_sohdcn1 INTO c_sohd1;
        EXIT WHEN cur_sohdcn1%NOTFOUND;

        v_soluong := 0;

        BEGIN
            SELECT SoLuong
            INTO v_soluong
            FROM CN1.CTHD@cn1_dblink
            WHERE SoHD = c_sohd1
            AND MASP = v_masp;

            EXCEPTION
            WHEN NO_DATA_FOUND THEN
            v_soluong := 0;
        END;

        v_tongsoluong := v_tongsoluong + v_soluong;
    END LOOP;
    CLOSE cur_sohdcn1;
END;

    RETURN v_tongsoluong;
END;
/
