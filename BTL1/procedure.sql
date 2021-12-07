-- procedure: chuyen hang tu chi nhanh nay sang chi nhanh kia
CREATE or REPLACE PROCEDURE ChuyenSanPham(v_masp in SANPHAM.MASP%TYPE, v_soluong in KHOSANPHAM_QLKHO.Soluong%TYPE)
IS
    var_maspkho SANPHAM.MASP%TYPE;
    var_maspkho2 SANPHAM.MASP%TYPE;
    var_soluongkho KHOSANPHAM_QLKHO.Soluong%TYPE;
    var_soluongkho2 KHOSANPHAM_QLKHO.Soluong%TYPE;
BEGIN
    SELECT MASP
    INTO var_maspkho
    FROM KHOSANPHAM_QLKHO
    WHERE MASP = v_masp;
    DBMS_OUTPUT.PUT_LINE('Lay masp ok');
    
    SELECT SoLuong
    INTO var_soluongkho
    FROM KHOSANPHAM_QLKHO
    WHERE MASP = v_masp;

    IF var_soluongkho < v_soluong THEN
    DBMS_OUTPUT.PUT_LINE('So luong vuot qua so luong trong kho');
    ELSE
    BEGIN
        SELECT MASP
        INTO var_maspkho2
        FROM maythunghiem2.KHOSANPHAM_QLKHO
        WHERE MASP = v_masp;
        DBMS_OUTPUT.PUT_LINE('Lay masp 2 ok');
        
        UPDATE KHOSANPHAM_QLKHO
        SET SoLuong = SoLuong - v_soluong
        WHERE MASP = v_masp;

        UPDATE maythunghiem2.KHOSANPHAM_QLKHO
        SET SoLuong = SoLuong + v_soluong
        WHERE MASP = v_masp;

        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN
            INSERT maythunghiem2.KHOSANPHAM_QLKHO
            VALUES ('CN02', 'v_masp', v_soluong);
            
            UPDATE KHOSANPHAM_QLKHO
            SET SoLuong = SoLuong - v_soluong
            WHERE MASP = v_masp;
        END;
    END;
    END IF;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Kho hang 1 khong co san pham nay');

    COMMIT;
END;

EXEC ChuyenSanPham('ST01', 2);
EXEC ChuyenSanPham('ST01', 8);
EXEC ChuyenSanPham('BB11', 2);
EXEC ChuyenSanPham('ST07', 10);

CREATE USER maythunghiem2 IDENTIFIED BY maythunghiem2;