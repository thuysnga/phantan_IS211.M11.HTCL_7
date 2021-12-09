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

            DBMS_OUTPUT.PUT_LINE('Chuyen hang thanh cong');

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

                DBMS_OUTPUT.PUT_LINE('Chuyen hang thanh cong');
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

-- TH1: Chi nhánh chuyển không có mã sản phẩm này
EXEC ChuyenSanPham('SS98', 2);

-- TH2: Số lượng sản phẩm chuyển <= 0
EXEC ChuyenSanPham('ST01', 0);

-- TH3: Số lượng sản phẩm chuyển vượt quá số lượng trong kho
EXEC ChuyenSanPham('ST01', 5000);

-- TH4: Kho nhận chưa có mã sản phẩm này
EXEC ChuyenSanPham('ST01', 5);

-- TH5: Chuyển sản phẩm bình thường
EXEC ChuyenSanPham('ST01', 5);


-- cn2
CREATE or REPLACE PROCEDURE ChuyenSanPham(v_masp in CN2.SANPHAM.MASP%TYPE, 
    v_soluong in CN2.KHOSANPHAM_QLKHO.Soluong%TYPE)
IS
    var_maspkho1 CN2.SANPHAM.MASP%TYPE;
    var_maspkho2 CN2.SANPHAM.MASP%TYPE;
    var_soluongkho1 CN2.KHOSANPHAM_QLKHO.Soluong%TYPE;
    var_soluongkho2 CN2.KHOSANPHAM_QLKHO.Soluong%TYPE;
BEGIN
    IF v_soluong < 1 THEN
        DBMS_OUTPUT.PUT_LINE('So luong phai lon hon 0');
    ELSE
    BEGIN
        SELECT MASP
        INTO var_maspkho2
        FROM CN2.KHOSANPHAM_QLKHO
        WHERE MASP = v_masp;

        SELECT SoLuong
        INTO var_soluongkho2
        FROM CN2.KHOSANPHAM_QLKHO
        WHERE MASP = v_masp;

        IF var_soluongkho2 < v_soluong THEN
            DBMS_OUTPUT.PUT_LINE('So luong vuot qua so luong trong kho');
        ELSE
        BEGIN
            SELECT MASP
            INTO var_maspkho1
            FROM CN1.KHOSANPHAM_QLKHO@cn1_dblink
            WHERE MASP = v_masp;

            UPDATE CN2.KHOSANPHAM_QLKHO
            SET SoLuong = SoLuong - v_soluong
            WHERE MASP = v_masp;

            IF (var_soluongkho2 = v_soluong) THEN
                UPDATE CN2.KHOSANPHAM_QLBH
                SET TinhTrang = 'Het Hang'
                WHERE MASP = v_masp;
            END IF;

            UPDATE CN1.KHOSANPHAM_QLKHO@cn1_dblink
            SET SoLuong = SoLuong + v_soluong
            WHERE MASP = v_masp;

            UPDATE CN1.KHOSANPHAM_QLBH@cn1_dblink
            SET TinhTrang = 'Con Hang'
            WHERE MASP = v_masp;

            DBMS_OUTPUT.PUT_LINE('Chuyen hang thanh cong');

            EXCEPTION
            WHEN NO_DATA_FOUND THEN
            BEGIN
                INSERT INTO CN1.KHOSANPHAM_QLKHO@cn1_dblink
                VALUES ('CN2', v_masp, v_soluong);
            
                INSERT INTO CN1.KHOSANPHAM_QLBH@cn1_dblink
                VALUES ('CN2',v_masp,'Con Hang',0);

                UPDATE CN2.KHOSANPHAM_QLKHO
                SET SoLuong = SoLuong - v_soluong
                WHERE MASP = v_masp;

                IF (var_soluongkho1 = v_soluong) THEN
                UPDATE CN2.KHOSANPHAM_QLBH
                SET TinhTrang = 'Het Hang'
                WHERE MASP = v_masp;
                END IF;

                DBMS_OUTPUT.PUT_LINE('Chuyen hang thanh cong');
            END;
        END;
        END IF;

        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Kho hang 2 khong co san pham nay');
    END;
    END IF;

    COMMIT;
END;
/