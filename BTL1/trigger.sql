CREATE OR REPLACE TRIGGER trgg_cthd_soluongkho
BEFORE INSERT ON CN1.CTHD
FOR EACH ROW
DECLARE
    v_sl int;
BEGIN
    SELECT SoLuong
    INTO v_sl
    FROM cn1.KHOSANPHAM_QLKHO
    WHERE MASP = :NEW.MASP;

    IF :NEW.SoLuong > v_sl THEN
    BEGIN
        RAISE_APPLICATION_ERROR(-20001,'So trong kho khong du');
        ROLLBACK;
    END;
    ELSE
    BEGIN
        UPDATE cn1.KHOSANPHAM_QLKHO
        SET SoLuong = SoLuong - :NEW.SoLuong
        WHERE MASP = :NEW.MASP;

        IF :NEW.SoLuong = v_sl THEN
            UPDATE cn1.KHOSANPHAM_QLBH
            SET TinhTrang = 'Het Hang'
            WHERE MASP = :NEW.MASP;
        END IF;

    END;
    END IF;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('ERROR');
END;
/
