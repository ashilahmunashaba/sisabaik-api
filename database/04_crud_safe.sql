BEGIN;

INSERT INTO pengguna (nama_lengkap, email, peran)
VALUES ('Pengguna Latihan', 'latihan@example.test', 'pembeli')
RETURNING id, nama_lengkap, email, peran;

SELECT id, nama_lengkap, email, aktif
FROM pengguna
WHERE email = 'latihan@example.test';

UPDATE pengguna
SET nama_lengkap = 'Pengguna Latihan Diperbarui', aktif = FALSE
WHERE email = 'latihan@example.test'
RETURNING id, nama_lengkap, aktif;

DELETE FROM pengguna
WHERE email = 'latihan@example.test'
RETURNING id, email;

ROLLBACK;

SELECT COUNT(*) AS jumlah_baris_latihan
FROM pengguna
WHERE email = 'latihan@example.test';