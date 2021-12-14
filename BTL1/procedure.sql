CREATE or REPLACE PROCEDURE ChuyenSanPham(v_masp in CN1.SANPHAM.MASP%TYPE, 
    v_soluong in CN1.KHOSANPHAM_QLKHO.Soluong%TYPE,
    v_macnchuyen in CN1.CHINHANH.MACHINHANH%TYPE)
IS
    var_maspkhochuyen CN1.SANPHAM.MASP%TYPE;
    var_maspkhonhan CN1.SANPHAM.MASP%TYPE;
    var_soluongkhochuyen CN1.KHOSANPHAM_QLKHO.Soluong%TYPE;
BEGIN
    IF v_soluong < 1 THEN
        DBMS_OUTPUT.PUT_LINE('So luong phai lon hon 0');
    ELSE
    BEGIN
        IF v_macnchuyen = 'CN1' THEN
        BEGIN
            SELECT MASP
            INTO var_maspkhochuyen
            FROM CN1.KHOSANPHAM_QLKHO
            WHERE MASP = v_masp;
            
            SELECT SoLuong
            INTO var_soluongkhochuyen
            FROM CN1.KHOSANPHAM_QLKHO
            WHERE MASP = v_masp;

            IF var_soluongkhochuyen < v_soluong THEN
                DBMS_OUTPUT.PUT_LINE('So luong vuot qua so luong trong kho');
            ELSE
            BEGIN
                SELECT MASP
                INTO var_maspkhonhan
                FROM CN2.KHOSANPHAM_QLKHO@cn2_dblink
                WHERE MASP = v_masp;

                UPDATE CN1.KHOSANPHAM_QLKHO
                SET SoLuong = SoLuong - v_soluong
                WHERE MASP = v_masp;

                IF (var_soluongkhochuyen = v_soluong) THEN
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
        
                    IF (var_soluongkhochuyen = v_soluong) THEN
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

        IF v_macnchuyen = 'CN2' THEN
        BEGIN
            SELECT MASP
            INTO var_maspkhochuyen
            FROM CN2.KHOSANPHAM_QLKHO@cn2_dblink
            WHERE MASP = v_masp;

            SELECT SoLuong
            INTO var_soluongkhochuyen
            FROM CN2.KHOSANPHAM_QLKHO@cn2_dblink
            WHERE MASP = v_masp;

            IF var_soluongkhochuyen < v_soluong THEN
                DBMS_OUTPUT.PUT_LINE('So luong vuot qua so luong trong kho');
            ELSE
            BEGIN
                SELECT MASP
                INTO var_maspkhonhan
                FROM CN1.KHOSANPHAM_QLKHO
                WHERE MASP = v_masp;

                UPDATE CN2.KHOSANPHAM_QLKHO@cn2_dblink
                SET SoLuong = SoLuong - v_soluong
                WHERE MASP = v_masp;

                IF (var_soluongkhochuyen = v_soluong) THEN
                    UPDATE CN2.KHOSANPHAM_QLBH@cn2_dblink
                    SET TinhTrang = 'Het Hang'
                    WHERE MASP = v_masp;
                END IF;

                UPDATE CN1.KHOSANPHAM_QLKHO
                SET SoLuong = SoLuong + v_soluong
                WHERE MASP = v_masp;

                UPDATE CN1.KHOSANPHAM_QLBH
                SET TinhTrang = 'Con Hang'
                WHERE MASP = v_masp;

                DBMS_OUTPUT.PUT_LINE('Chuyen hang thanh cong');

                EXCEPTION
                WHEN NO_DATA_FOUND THEN
                BEGIN
                    INSERT INTO CN1.KHOSANPHAM_QLKHO
                    VALUES ('CN1', v_masp, v_soluong);
                
                    INSERT INTO CN1.KHOSANPHAM_QLBH
                    VALUES ('CN1',v_masp,'Con Hang',0);
    
                    UPDATE CN2.KHOSANPHAM_QLKHO@cn2_dblink
                    SET SoLuong = SoLuong - v_soluong
                    WHERE MASP = v_masp;
        
                    IF (var_soluongkhochuyen = v_soluong) THEN
                    UPDATE CN2.KHOSANPHAM_QLBH@cn2_dblink
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
    END;
    END IF;

    COMMIT;
END;
/


set lines 256;
set trimout on;
set tab off;
set serveroutput on size 30000;

select * from cn1.khosanpham_qlkho;
select * from cn2.khosanpham_qlkho@CN2_DBLINK WHERE MASP='ST03';
select * from cn1.khosanpham_QLBH WHERE MASP='ST03';
select * from cn2.khosanpham_QLBH@CN2_DBLINK;

-- TH1: Số lượng sản phẩm chuyển <= 0
EXEC ChuyenSanPham('ST01', 0, 'CN1');
EXEC ChuyenSanPham('ST01', 0, 'CN2');

-- TH2: Chi nhánh chuyển không có mã sản phẩm này
EXEC ChuyenSanPham('SS98', 2 , 'CN1');
EXEC ChuyenSanPham('SS98', 2 , 'CN2');

-- TH3: Số lượng sản phẩm chuyển vượt quá số lượng trong kho
EXEC ChuyenSanPham('ST01', 5000, 'CN1');
EXEC ChuyenSanPham('TV07', 5000, 'CN2');

-- TH4: Kho nhận chưa có mã sản phẩm này
EXEC ChuyenSanPham('ST03', 5 ,'CN1');


-- TH5: Chuyển sản phẩm bình thường
EXEC ChuyenSanPham('ST02', 5, 'CN1');
EXEC ChuyenSanPham('ST02', 5, 'CN2');