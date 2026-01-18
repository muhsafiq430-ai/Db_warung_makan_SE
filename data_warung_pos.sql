
-- =====================================================
-- DATABASE : data_warung
-- SISTEM   : POS Warung Makan SE
-- =====================================================

DROP DATABASE IF EXISTS data_warung;
CREATE DATABASE data_warung;
USE data_warung;

-- ======================
-- TABLE PELANGGAN
-- ======================
CREATE TABLE tabel_pelanggan (
    id_pelanggan CHAR(5) PRIMARY KEY,
    nama_pelanggan VARCHAR(50) NOT NULL,
    jenis_layanan VARCHAR(20) NOT NULL
);

-- ======================
-- TABLE KASIR
-- ======================
CREATE TABLE tabel_kasir (
    id_kasir CHAR(5) PRIMARY KEY,
    nama_kasir VARCHAR(50) NOT NULL,
    no_telepon VARCHAR(15)
);

-- ======================
-- TABLE BARANG
-- ======================
CREATE TABLE tabel_barang (
    id_barang CHAR(5) PRIMARY KEY,
    nama_barang VARCHAR(100) NOT NULL,
    harga_barang INT NOT NULL
);

-- ======================
-- TABLE TRANSAKSI
-- ======================
CREATE TABLE tabel_transaksi (
    no_nota VARCHAR(17) PRIMARY KEY,
    waktu DATETIME NOT NULL,
    total_bayar INT NOT NULL,
    transfer INT NOT NULL,
    id_pelanggan CHAR(5) NOT NULL,
    id_kasir CHAR(5) NOT NULL,
    CONSTRAINT fk_pelanggan FOREIGN KEY (id_pelanggan)
        REFERENCES tabel_pelanggan(id_pelanggan),
    CONSTRAINT fk_kasir FOREIGN KEY (id_kasir)
        REFERENCES tabel_kasir(id_kasir)
);

-- ======================
-- TABLE DETAIL TRANSAKSI
-- ======================
CREATE TABLE tabel_detail_transaksi (
    no_nota VARCHAR(17),
    id_barang CHAR(5),
    jumlah INT NOT NULL,
    PRIMARY KEY (no_nota, id_barang),
    CONSTRAINT fk_transaksi FOREIGN KEY (no_nota)
        REFERENCES tabel_transaksi(no_nota),
    CONSTRAINT fk_barang FOREIGN KEY (id_barang)
        REFERENCES tabel_barang(id_barang)
);

-- ======================
-- INSERT DATA (DML)
-- ======================
INSERT INTO tabel_pelanggan VALUES
('PLG01','Fatin','Free Table');

INSERT INTO tabel_kasir VALUES
('KSR01','Yuti','08123456789');

INSERT INTO tabel_barang VALUES
('BRG01','Nasi Ayam Geprek Lv 2',9000),
('BRG02','Es Teh Jumbo',2000),
('BRG03','Nasi Ayam Sambal Ijo',12000),
('BRG04','Es Jeruk',3000),
('BRG05','Tahu Goreng',1000),
('BRG06','Tempe Goreng',1000);

-- ======================
-- TRANSACTION (TCL)
-- ======================
START TRANSACTION;

INSERT INTO tabel_transaksi VALUES
('CS/27/251018/0090','2025-10-18 12:25:00',28000,28000,'PLG01','KSR01');

INSERT INTO tabel_detail_transaksi VALUES
('CS/27/251018/0090','BRG01',1),
('CS/27/251018/0090','BRG02',1),
('CS/27/251018/0090','BRG03',1),
('CS/27/251018/0090','BRG04',1),
('CS/27/251018/0090','BRG05',2),
('CS/27/251018/0090','BRG06',2);

COMMIT;

-- ======================
-- UPDATE
-- ======================
UPDATE tabel_barang
SET harga_barang = 9500
WHERE id_barang = 'BRG01';

-- ======================
-- JOIN QUERY
-- ======================
SELECT t.no_nota, p.nama_pelanggan, b.nama_barang, d.jumlah,
       b.harga_barang, (d.jumlah * b.harga_barang) AS subtotal
FROM tabel_transaksi t
JOIN tabel_pelanggan p ON t.id_pelanggan = p.id_pelanggan
JOIN tabel_detail_transaksi d ON t.no_nota = d.no_nota
JOIN tabel_barang b ON d.id_barang = b.id_barang;

-- ======================
-- GROUP BY + AGREGASI
-- ======================
SELECT b.nama_barang, SUM(d.jumlah) AS total_terjual
FROM tabel_detail_transaksi d
JOIN tabel_barang b ON d.id_barang = b.id_barang
GROUP BY b.nama_barang;

-- ======================
-- HAVING
-- ======================
SELECT b.nama_barang, SUM(d.jumlah) AS total_terjual
FROM tabel_detail_transaksi d
JOIN tabel_barang b ON d.id_barang = b.id_barang
GROUP BY b.nama_barang
HAVING SUM(d.jumlah) >= 2;

-- ======================
-- VIEW
-- ======================
CREATE VIEW view_laporan_penjualan AS
SELECT t.no_nota, t.waktu, p.nama_pelanggan, t.total_bayar
FROM tabel_transaksi t
JOIN tabel_pelanggan p ON t.id_pelanggan = p.id_pelanggan;

-- ======================
-- SUBQUERY
-- ======================
SELECT nama_barang
FROM tabel_barang
WHERE id_barang IN (
    SELECT id_barang
    FROM tabel_detail_transaksi
    GROUP BY id_barang
    HAVING SUM(jumlah) > 1
);
