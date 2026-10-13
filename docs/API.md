# Sisabaik API Documentation

## 1. Base URL

Server pengembangan berjalan secara lokal pada:

```text
http://127.0.0.1:3000
```

Seluruh endpoint API menggunakan prefix `/api`.

## 2. Daftar Endpoint

| Method | Endpoint             | Fungsi                                                  | Status Berhasil |
| ------ | -------------------- | ------------------------------------------------------- | --------------- |
| GET    | `/api/health`        | Memeriksa server dan akses database                     | 200             |
| GET    | `/api/penawaran`     | Mengambil daftar penawaran                              | 200             |
| GET    | `/api/penawaran/:id` | Mengambil detail penawaran                              | 200             |
| POST   | `/api/penawaran`     | Membuat penawaran                                       | 201             |
| PUT    | `/api/penawaran/:id` | Mengganti atribut penawaran yang dapat diedit           | 200             |
| DELETE | `/api/penawaran/:id` | Menghapus penawaran yang tidak memiliki riwayat pesanan | 204             |
| GET    | `/api/pesanan`       | Mengambil daftar ringkasan pesanan                      | 200             |
| GET    | `/api/pesanan/:id`   | Mengambil detail pesanan beserta item                   | 200             |
| POST   | `/api/pesanan`       | Membuat pesanan dalam transaksi database                | 201             |

## 3. Query Parameter

Endpoint `GET /api/penawaran` mendukung parameter berikut:

- `q`: pencarian.
- `kategori`: filter kategori.
- `page`: nomor halaman.
- `limit`: jumlah data per halaman.

Endpoint `GET /api/pesanan` mendukung paginasi menggunakan parameter `page` dan `limit`.

Contoh:

```text
GET /api/penawaran?q=roti&kategori=roti&page=1&limit=10
GET /api/pesanan?page=1&limit=10
```

## 4. Membuat Penawaran

Endpoint:

```text
POST /api/penawaran
Content-Type: application/json
```

Field yang dikirim:

```json
{
  "penyediaId": "1",
  "nama": "Roti tawar",
  "kategori": "roti",
  "hargaNormal": 15000,
  "hargaPenawaran": 8000,
  "stok": 10,
  "satuan": "paket",
  "status": "aktif",
  "berakhirPada": "2026-12-31T23:59:59.000Z"
}
```

Response berhasil menggunakan status `201 Created`, berisi data penawaran yang dibuat dan header `Location` yang menunjuk resource baru.

## 5. Memperbarui Penawaran

Endpoint:

```text
PUT /api/penawaran/:id
Content-Type: application/json
```

Semua field yang dapat diedit wajib dikirim:

- `penyediaId`
- `nama`
- `kategori`
- `hargaNormal`
- `hargaPenawaran`
- `stok`
- `satuan`
- `status`
- `berakhirPada`

ID dan `dibuatPada` tidak dikirim sebagai field pembaruan. Penyedia pemilik penawaran tidak boleh diganti setelah penawaran dibuat.

Endpoint `PUT` mengganti seluruh atribut yang dapat diedit. Pengiriman sebagian field saja akan ditolak.

## 6. Membuat Pesanan

Endpoint:

```text
POST /api/pesanan
Content-Type: application/json
```

Contoh request:

```json
{
  "emailPembeli": "siti.pembeli@example.test",
  "items": [
    {
      "penawaranId": "1",
      "kuantitas": 1
    }
  ]
}
```

Pesanan dibuat dalam satu transaksi database agar perubahan data pesanan dan stok tetap konsisten.

Satu pesanan hanya boleh berisi penawaran dari satu penyedia. Jika penawaran berasal dari penyedia berbeda, request harus ditolak.

Response berhasil menggunakan status `201 Created` dan menyertakan data pesanan beserta item serta header `Location`.

## 7. Format Response

### Response berhasil

```json
{
  "success": true,
  "data": {}
}
```

Untuk endpoint koleksi, response juga dapat menyertakan metadata paginasi:

```json
{
  "success": true,
  "data": [],
  "meta": {
    "jumlah": 0,
    "page": 1,
    "limit": 10,
    "totalPages": 0
  }
}
```

`meta.jumlah` menunjukkan jumlah seluruh data yang sesuai dengan filter, bukan hanya jumlah data pada halaman saat ini.

### Response gagal

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Pesan kesalahan yang dapat dibaca."
  }
}
```

Response error menggunakan `success: false`, kode error yang stabil, dan pesan yang dapat dipahami client.

## 8. Status HTTP dan Penanganan Error

| Status | Arti                                           |
| ------ | ---------------------------------------------- |
| 200    | Request berhasil                               |
| 201    | Resource berhasil dibuat                       |
| 204    | Resource berhasil dihapus, tanpa response body |
| 400    | Request atau parameter tidak valid             |
| 404    | Resource tidak ditemukan                       |
| 409    | Konflik data atau aturan bisnis                |
| 415    | Content-Type tidak didukung                    |
| 422    | Data gagal validasi                            |
| 500    | Kesalahan internal server                      |

Status error yang dikembalikan untuk setiap kondisi mengikuti implementasi aktual API.

## 9. Aturan Bisnis

1. Harga penawaran tidak boleh melebihi harga normal.
2. Field wajib harus dikirim sesuai kontrak endpoint.
3. ID penawaran dan pesanan tidak dibuat sendiri oleh client.
4. Penyedia pemilik penawaran tidak dapat diganti setelah penawaran dibuat.
5. Pesanan hanya dapat melibatkan satu penyedia.
6. Pembelian harus menjaga konsistensi stok melalui transaksi database.
7. Penawaran yang sudah memiliki riwayat pesanan tidak boleh dihapus.
8. Penghapusan yang berhasil menggunakan status `204` tanpa body.
9. API ini masih digunakan secara lokal untuk pembelajaran dan belum menerapkan autentikasi serta otorisasi.

## 10. Catatan

Dokumentasi ini harus selalu disesuaikan dengan endpoint, validasi, query, dan status HTTP yang benar-benar diterapkan dalam kode proyek. Jangan mendokumentasikan fitur yang belum diimplementasikan.
