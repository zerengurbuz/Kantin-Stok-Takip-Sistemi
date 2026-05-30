USE kantin_stok_takip;
CREATE DATABASE kantin_stok_takip;

CREATE TABLE kategoriler
(
    kategori_id INT AUTO_INCREMENT,
    kategori_ad VARCHAR(100) NOT NULL,
    aciklama VARCHAR(250),
    PRIMARY KEY(kategori_id)
);

CREATE TABLE urunler
(
    urun_id INT AUTO_INCREMENT,
    kategori_id INT NOT NULL,
    urun_ad VARCHAR(150) NOT NULL,
    barkod_no VARCHAR(50) UNIQUE,
    birim_fiyat DECIMAL(10,2) NOT NULL,
    stok_miktar INT NOT NULL DEFAULT 0,
    kritik_stok INT NOT NULL DEFAULT 5,
    birim VARCHAR(20) NOT NULL,
    durum VARCHAR(20) DEFAULT 'Aktif',
    PRIMARY KEY(urun_id),
    FOREIGN KEY(kategori_id) REFERENCES kategoriler(kategori_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK(birim_fiyat >= 0),
    CHECK(stok_miktar >= 0),
    CHECK(kritik_stok >= 0)
);

CREATE TABLE tedarikciler
(
    tedarikci_id INT AUTO_INCREMENT,
    firma_ad VARCHAR(150) NOT NULL,
    telefon VARCHAR(20),
    mail VARCHAR(100),
    adres VARCHAR(250),
    PRIMARY KEY(tedarikci_id)
);

CREATE TABLE personeller
(
    personel_id INT AUTO_INCREMENT,
    ad VARCHAR(50) NOT NULL,
    soyad VARCHAR(50) NOT NULL,
    telefon VARCHAR(20),
    kullanici_ad VARCHAR(50) UNIQUE NOT NULL,
    sifre VARCHAR(100) NOT NULL,
    yetki VARCHAR(30) DEFAULT 'Personel',
    PRIMARY KEY(personel_id)
);

CREATE TABLE stok_girisleri
(
    stok_giris_id INT AUTO_INCREMENT,
    urun_id INT NOT NULL,
    tedarikci_id INT NOT NULL,
    giris_tarih DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    giris_miktar INT NOT NULL,
    alis_fiyat DECIMAL(10,2) NOT NULL,
    aciklama VARCHAR(250),
    PRIMARY KEY(stok_giris_id),
    FOREIGN KEY(urun_id) REFERENCES urunler(urun_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(tedarikci_id) REFERENCES tedarikciler(tedarikci_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK(giris_miktar > 0),
    CHECK(alis_fiyat >= 0)
);

CREATE TABLE satislar
(
    satis_id INT AUTO_INCREMENT,
    personel_id INT NOT NULL,
    satis_tarih DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    odeme_tur VARCHAR(30) NOT NULL,
    toplam_tutar DECIMAL(10,2) NOT NULL DEFAULT 0,
    PRIMARY KEY(satis_id),
    FOREIGN KEY(personel_id) REFERENCES personeller(personel_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK(odeme_tur IN ('Nakit', 'Kredi Kartı', 'Yemek Kartı'))
);

CREATE TABLE satis_detaylari
(
    satis_detay_id INT AUTO_INCREMENT,
    satis_id INT NOT NULL,
    urun_id INT NOT NULL,
    adet INT NOT NULL,
    birim_fiyat DECIMAL(10,2) NOT NULL,
    ara_toplam DECIMAL(10,2) NOT NULL,
    PRIMARY KEY(satis_detay_id),
    FOREIGN KEY(satis_id) REFERENCES satislar(satis_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(urun_id) REFERENCES urunler(urun_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK(adet > 0),
    CHECK(birim_fiyat >= 0),
    CHECK(ara_toplam >= 0)
);

DELIMITER $$

CREATE PROCEDURE KategoriEkle(
    IN p_kategori_ad VARCHAR(100),
    IN p_aciklama VARCHAR(250)
)
BEGIN
    INSERT INTO kategoriler(kategori_ad, aciklama)
    VALUES(p_kategori_ad, p_aciklama);
END $$

CREATE PROCEDURE KategoriGuncelle(
    IN p_kategori_id INT,
    IN p_kategori_ad VARCHAR(100),
    IN p_aciklama VARCHAR(250)
)
BEGIN
    UPDATE kategoriler
    SET kategori_ad = p_kategori_ad,
        aciklama = p_aciklama
    WHERE kategori_id = p_kategori_id;
END $$

CREATE PROCEDURE KategoriSil(IN p_kategori_id INT)
BEGIN
    DELETE FROM kategoriler
    WHERE kategori_id = p_kategori_id;
END $$

CREATE PROCEDURE KategorileriListele()
BEGIN
    SELECT * FROM kategoriler;
END $$

CREATE PROCEDURE UrunEkle(
    IN p_kategori_id INT,
    IN p_urun_ad VARCHAR(150),
    IN p_barkod_no VARCHAR(50),
    IN p_birim_fiyat DECIMAL(10,2),
    IN p_stok_miktar INT,
    IN p_kritik_stok INT,
    IN p_birim VARCHAR(20),
    IN p_durum VARCHAR(20)
)
BEGIN
    INSERT INTO urunler
    (kategori_id, urun_ad, barkod_no, birim_fiyat, stok_miktar, kritik_stok, birim, durum)
    VALUES
    (p_kategori_id, p_urun_ad, p_barkod_no, p_birim_fiyat, p_stok_miktar, p_kritik_stok, p_birim, p_durum);
END $$

CREATE PROCEDURE UrunGuncelle(
    IN p_urun_id INT,
    IN p_kategori_id INT,
    IN p_urun_ad VARCHAR(150),
    IN p_barkod_no VARCHAR(50),
    IN p_birim_fiyat DECIMAL(10,2),
    IN p_stok_miktar INT,
    IN p_kritik_stok INT,
    IN p_birim VARCHAR(20),
    IN p_durum VARCHAR(20)
)
BEGIN
    UPDATE urunler
    SET kategori_id = p_kategori_id,
        urun_ad = p_urun_ad,
        barkod_no = p_barkod_no,
        birim_fiyat = p_birim_fiyat,
        stok_miktar = p_stok_miktar,
        kritik_stok = p_kritik_stok,
        birim = p_birim,
        durum = p_durum
    WHERE urun_id = p_urun_id;
END $$

CREATE PROCEDURE UrunSil(IN p_urun_id INT)
BEGIN
    DELETE FROM urunler
    WHERE urun_id = p_urun_id;
END $$

CREATE PROCEDURE UrunleriListele()
BEGIN
    SELECT 
        u.urun_id,
        k.kategori_ad,
        u.urun_ad,
        u.barkod_no,
        u.birim_fiyat,
        u.stok_miktar,
        u.kritik_stok,
        u.birim,
        u.durum
    FROM urunler u
    INNER JOIN kategoriler k ON u.kategori_id = k.kategori_id;
END $$

CREATE PROCEDURE TedarikciEkle(
    IN p_firma_ad VARCHAR(150),
    IN p_telefon VARCHAR(20),
    IN p_mail VARCHAR(100),
    IN p_adres VARCHAR(250)
)
BEGIN
    INSERT INTO tedarikciler(firma_ad, telefon, mail, adres)
    VALUES(p_firma_ad, p_telefon, p_mail, p_adres);
END $$

CREATE PROCEDURE TedarikciGuncelle(
    IN p_tedarikci_id INT,
    IN p_firma_ad VARCHAR(150),
    IN p_telefon VARCHAR(20),
    IN p_mail VARCHAR(100),
    IN p_adres VARCHAR(250)
)
BEGIN
    UPDATE tedarikciler
    SET firma_ad = p_firma_ad,
        telefon = p_telefon,
        mail = p_mail,
        adres = p_adres
    WHERE tedarikci_id = p_tedarikci_id;
END $$

CREATE PROCEDURE TedarikciSil(IN p_tedarikci_id INT)
BEGIN
    DELETE FROM tedarikciler
    WHERE tedarikci_id = p_tedarikci_id;
END $$

CREATE PROCEDURE TedarikcileriListele()
BEGIN
    SELECT * FROM tedarikciler;
END $$

CREATE PROCEDURE PersonelEkle(
    IN p_ad VARCHAR(50),
    IN p_soyad VARCHAR(50),
    IN p_telefon VARCHAR(20),
    IN p_kullanici_ad VARCHAR(50),
    IN p_sifre VARCHAR(100),
    IN p_yetki VARCHAR(30)
)
BEGIN
    INSERT INTO personeller(ad, soyad, telefon, kullanici_ad, sifre, yetki)
    VALUES(p_ad, p_soyad, p_telefon, p_kullanici_ad, p_sifre, p_yetki);
END $$

CREATE PROCEDURE PersonelGuncelle(
    IN p_personel_id INT,
    IN p_ad VARCHAR(50),
    IN p_soyad VARCHAR(50),
    IN p_telefon VARCHAR(20),
    IN p_kullanici_ad VARCHAR(50),
    IN p_sifre VARCHAR(100),
    IN p_yetki VARCHAR(30)
)
BEGIN
    UPDATE personeller
    SET ad = p_ad,
        soyad = p_soyad,
        telefon = p_telefon,
        kullanici_ad = p_kullanici_ad,
        sifre = p_sifre,
        yetki = p_yetki
    WHERE personel_id = p_personel_id;
END $$

CREATE PROCEDURE PersonelSil(IN p_personel_id INT)
BEGIN
    DELETE FROM personeller
    WHERE personel_id = p_personel_id;
END $$

CREATE PROCEDURE PersonelleriListele()
BEGIN
    SELECT * FROM personeller;
END $$

CREATE PROCEDURE StokGirisiEkle(
    IN p_urun_id INT,
    IN p_tedarikci_id INT,
    IN p_giris_miktar INT,
    IN p_alis_fiyat DECIMAL(10,2),
    IN p_aciklama VARCHAR(250)
)
BEGIN
    INSERT INTO stok_girisleri
    (urun_id, tedarikci_id, giris_miktar, alis_fiyat, aciklama)
    VALUES
    (p_urun_id, p_tedarikci_id, p_giris_miktar, p_alis_fiyat, p_aciklama);
END $$

CREATE PROCEDURE StokGirisiGuncelle(
    IN p_stok_giris_id INT,
    IN p_urun_id INT,
    IN p_tedarikci_id INT,
    IN p_giris_miktar INT,
    IN p_alis_fiyat DECIMAL(10,2),
    IN p_aciklama VARCHAR(250)
)
BEGIN
    UPDATE stok_girisleri
    SET urun_id = p_urun_id,
        tedarikci_id = p_tedarikci_id,
        giris_miktar = p_giris_miktar,
        alis_fiyat = p_alis_fiyat,
        aciklama = p_aciklama
    WHERE stok_giris_id = p_stok_giris_id;
END $$

CREATE PROCEDURE StokGirisiSil(IN p_stok_giris_id INT)
BEGIN
    DELETE FROM stok_girisleri
    WHERE stok_giris_id = p_stok_giris_id;
END $$

CREATE PROCEDURE StokGirisleriniListele()
BEGIN
    SELECT 
        sg.stok_giris_id,
        u.urun_ad,
        t.firma_ad,
        sg.giris_tarih,
        sg.giris_miktar,
        sg.alis_fiyat,
        sg.aciklama
    FROM stok_girisleri sg
    INNER JOIN urunler u ON sg.urun_id = u.urun_id
    INNER JOIN tedarikciler t ON sg.tedarikci_id = t.tedarikci_id;
END $$

CREATE PROCEDURE SatisEkle(
    IN p_personel_id INT,
    IN p_odeme_tur VARCHAR(30)
)
BEGIN
    INSERT INTO satislar(personel_id, odeme_tur, toplam_tutar)
    VALUES(p_personel_id, p_odeme_tur, 0);
END $$

CREATE PROCEDURE SatisGuncelle(
    IN p_satis_id INT,
    IN p_personel_id INT,
    IN p_odeme_tur VARCHAR(30)
)
BEGIN
    UPDATE satislar
    SET personel_id = p_personel_id,
        odeme_tur = p_odeme_tur
    WHERE satis_id = p_satis_id;
END $$

CREATE PROCEDURE SatisSil(IN p_satis_id INT)
BEGIN
    DELETE FROM satislar
    WHERE satis_id = p_satis_id;
END $$

CREATE PROCEDURE SatislariListele()
BEGIN
    SELECT 
        s.satis_id,
        CONCAT(p.ad, ' ', p.soyad) AS personel,
        s.satis_tarih,
        s.odeme_tur,
        s.toplam_tutar
    FROM satislar s
    INNER JOIN personeller p ON s.personel_id = p.personel_id;
END $$

CREATE PROCEDURE SatisDetayEkle(
    IN p_satis_id INT,
    IN p_urun_id INT,
    IN p_adet INT
)
BEGIN
    DECLARE v_birim_fiyat DECIMAL(10,2);

    SELECT birim_fiyat INTO v_birim_fiyat
    FROM urunler
    WHERE urun_id = p_urun_id;

    INSERT INTO satis_detaylari
    (satis_id, urun_id, adet, birim_fiyat, ara_toplam)
    VALUES
    (p_satis_id, p_urun_id, p_adet, v_birim_fiyat, p_adet * v_birim_fiyat);
END $$

CREATE PROCEDURE SatisDetayGuncelle(
    IN p_satis_detay_id INT,
    IN p_satis_id INT,
    IN p_urun_id INT,
    IN p_adet INT
)
BEGIN
    DECLARE v_birim_fiyat DECIMAL(10,2);

    SELECT birim_fiyat INTO v_birim_fiyat
    FROM urunler
    WHERE urun_id = p_urun_id;

    UPDATE satis_detaylari
    SET satis_id = p_satis_id,
        urun_id = p_urun_id,
        adet = p_adet,
        birim_fiyat = v_birim_fiyat,
        ara_toplam = p_adet * v_birim_fiyat
    WHERE satis_detay_id = p_satis_detay_id;
END $$

CREATE PROCEDURE SatisDetaySil(IN p_satis_detay_id INT)
BEGIN
    DELETE FROM satis_detaylari
    WHERE satis_detay_id = p_satis_detay_id;
END $$

CREATE PROCEDURE SatisDetaylariListele()
BEGIN
    SELECT 
        sd.satis_detay_id,
        sd.satis_id,
        u.urun_ad,
        sd.adet,
        sd.birim_fiyat,
        sd.ara_toplam
    FROM satis_detaylari sd
    INNER JOIN urunler u ON sd.urun_id = u.urun_id;
END $$

CREATE FUNCTION fn_UrunStokDurumu(p_urun_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE v_stok INT;
    DECLARE v_kritik INT;
    DECLARE sonuc VARCHAR(50);

    SELECT stok_miktar, kritik_stok
    INTO v_stok, v_kritik
    FROM urunler
    WHERE urun_id = p_urun_id;

    IF v_stok = 0 THEN
        SET sonuc = 'Stok Yok';
    ELSEIF v_stok <= v_kritik THEN
        SET sonuc = 'Kritik Stok';
    ELSE
        SET sonuc = 'Stok Yeterli';
    END IF;

    RETURN sonuc;
END $$

CREATE FUNCTION fn_SatisToplamTutar(p_satis_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE toplam DECIMAL(10,2);

    SELECT IFNULL(SUM(ara_toplam), 0)
    INTO toplam
    FROM satis_detaylari
    WHERE satis_id = p_satis_id;

    RETURN toplam;
END $$

CREATE TRIGGER trg_stok_giris_arttir
AFTER INSERT ON stok_girisleri
FOR EACH ROW
BEGIN
    UPDATE urunler
    SET stok_miktar = stok_miktar + NEW.giris_miktar
    WHERE urun_id = NEW.urun_id;
END $$

CREATE TRIGGER trg_satis_stok_kontrol
BEFORE INSERT ON satis_detaylari
FOR EACH ROW
BEGIN
    DECLARE mevcut_stok INT;

    SELECT stok_miktar INTO mevcut_stok
    FROM urunler
    WHERE urun_id = NEW.urun_id;

    IF NEW.adet > mevcut_stok THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stok yetersiz! Satış işlemi yapılamaz.';
    END IF;
END $$

CREATE TRIGGER trg_satis_stok_azalt
AFTER INSERT ON satis_detaylari
FOR EACH ROW
BEGIN
    UPDATE urunler
    SET stok_miktar = stok_miktar - NEW.adet
    WHERE urun_id = NEW.urun_id;

    UPDATE satislar
    SET toplam_tutar = toplam_tutar + NEW.ara_toplam
    WHERE satis_id = NEW.satis_id;
END $$

DELIMITER ;

INSERT INTO kategoriler(kategori_ad, aciklama)
VALUES
('İçecek', 'Soğuk ve sıcak içecekler'),
('Atıştırmalık', 'Çikolata, cips ve benzeri ürünler'),
('Yiyecek', 'Tost, sandviç ve unlu mamuller');

INSERT INTO personeller(ad, soyad, telefon, kullanici_ad, sifre, yetki)
VALUES
('Zeren', 'Gürbüz', '05550000000', 'zeren', '12345', 'Yönetici'),
('Ali', 'Yılmaz', '05551112233', 'ali', '12345', 'Personel');

INSERT INTO tedarikciler(firma_ad, telefon, mail, adres)
VALUES
('ABC Gıda', '03780000000', 'abcgida@mail.com', 'Bartın Merkez'),
('Lezzet Toptan', '03781112233', 'lezzet@mail.com', 'Bartın');

INSERT INTO urunler(kategori_id, urun_ad, barkod_no, birim_fiyat, stok_miktar, kritik_stok, birim, durum)
VALUES
(1, 'Su', '1001', 10.00, 20, 5, 'Adet', 'Aktif'),
(1, 'Meyve Suyu', '1002', 25.00, 15, 5, 'Adet', 'Aktif'),
(2, 'Çikolata', '2001', 30.00, 10, 4, 'Adet', 'Aktif'),
(3, 'Tost', '3001', 60.00, 8, 3, 'Adet', 'Aktif');

show tables;
select*from urunler;