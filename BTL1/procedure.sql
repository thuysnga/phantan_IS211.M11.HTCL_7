CREATE or REPLACE PROCEDURE ChuyenSanPham(v_masp in CN1.SANPHAM.MASP%TYPE, 
    v_soluong in CN1.KHOSANPHAM_QLKHO.Soluong%TYPE)
IS
    var_maspkho1 CN1.SANPHAM.MASP%TYPE;
    var_maspkho2 CN1.SANPHAM.MASP%TYPE;
    var_soluongkho1 CN1.KHOSANPHAM_QLKHO.Soluong%TYPE;
    var_soluongkho2 CN1.KHOSANPHAM_QLKHO.Soluong%TYPE;
BEGIN
    IF v_soluong < 1 THEN
        DBMS_OUTPUT.PUT_LINE('So luong phai lon hon 0');
    ELSE
    BEGIN
        SELECT MASP
        INTO var_maspkho1
        FROM CN1.KHOSANPHAM_QLKHO
        WHERE MASP = v_masp;
        DBMS_OUTPUT.PUT_LINE('Lay masp ok');

        SELECT SoLuong
        INTO var_soluongkho1
        FROM CN1.KHOSANPHAM_QLKHO
        WHERE MASP = v_masp;

        IF var_soluongkho1 < v_soluong THEN
            DBMS_OUTPUT.PUT_LINE('So luong vuot qua so luong trong kho');
        ELSE
        BEGIN
            SELECT MASP
            INTO var_maspkho2
            FROM CN2.KHOSANPHAM_QLKHO@cn2_dblink
            WHERE MASP = v_masp;
            DBMS_OUTPUT.PUT_LINE('Lay masp 2 ok');

            UPDATE CN1.KHOSANPHAM_QLKHO
            SET SoLuong = SoLuong - v_soluong
            WHERE MASP = v_masp;

            IF (var_soluongkho1 = v_soluong) THEN
                UPDATE CN1.KHOSANPHAM_QLBH
                SET TinhTrang = 'Het Hang'
                WHERE MASP = v_masp;
            END IF;

            UPDATE CN2.KHOSANPHAM_QLKHO@cn2_dblink
            SET SoLuong = SoLuong + v_soluong
            WHERE MASP = v_masp;

            UPDATE CN2.KHOSANPHAM_QLBH@cn2_dblink
            SET TinhTrang = 'Con Hang'
            WHERE MASP = v_masp;

            EXCEPTION
            WHEN NO_DATA_FOUND THEN
            BEGIN
                INSERT INTO CN2.KHOSANPHAM_QLKHO@cn2_dblink
                VALUES ('CN2', v_masp, v_soluong);
            
                INSERT INTO CN2.KHOSANPHAM_QLBH@cn2_dblink
                VALUES ('CN2',v_masp,'Con Hang',0);

                UPDATE CN1.KHOSANPHAM_QLKHO
                SET SoLuong = SoLuong - v_soluong
                WHERE MASP = v_masp;

                IF (var_soluongkho1 = v_soluong) THEN
                UPDATE CN1.KHOSANPHAM_QLBH
                SET TinhTrang = 'Het Hang'
                WHERE MASP = v_masp;
                END IF;
            END;
        END;
        END IF;

        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Kho hang 1 khong co san pham nay');
    END;
    END IF;

    COMMIT;
END;
/

set serveroutput on size 30000;

-- may 1 khong co sp
EXEC ChuyenSanPham('SS98', 2);

-- so luong chuyen phai lon hon 0
EXEC ChuyenSanPham('ST01', 0);

-- so luong may 1 khong du
EXEC ChuyenSanPham('ST01', 5000);

-- may 2 chua co sp do 
EXEC ChuyenSanPham('ST01', 5);

-- chuyen bt 
EXEC ChuyenSanPham('ST01', 5);
