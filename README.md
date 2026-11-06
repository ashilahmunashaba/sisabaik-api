# SisaBaik API - Sistem Pengelolaan Makanan Berlebih

Kesempatan kedua untuk makanan yang masih bernilai.

## Deskripsi

SisaBaik adalah platform yang menghubungkan makanan berlebih yang masih layak konsumsi dengan orang yang membutuhkannya. Aplikasi ini terdiri dari:

- **Backend REST API** (Node.js + Express + PostgreSQL) - Chapter 5-8
- **Frontend Vue.js** (Vue 3 + Vite) - Chapter 9

## Teknologi

### Backend

- Node.js ≥ 22.0.0
- Express 5.1.0
- PostgreSQL (lokal)
- JWT untuk autentikasi
- bcryptjs untuk hashing password

### Frontend

- Vue 3.5.43
- Vite 8.3.3
- Single File Components dengan Composition API

## Persyaratan Sistem

- **Node.js**: 22.18.0 atau lebih baru (untuk backend)
- **Node.js**: 22.18.0 atau ≥24.12.0 (untuk frontend)
- **npm**: 10.x atau lebih baru
- **PostgreSQL**: 14.x atau lebih baru
- **Browser**: Chrome, Firefox, Edge, atau Safari versi terbaru

## Instalasi

### Backend

\\Terminal

# Install dependencies

npm install

# Atau untuk reproduksi exact versions

npm ci

# Setup database (ikuti instruksi di database/README.md atau modul)

psql -h localhost -U postgres -d sisabaik_dev -f database/01_schema.sql
psql -h localhost -U postgres -d sisabaik_dev -f database/02_seed.sql
psql -h localhost -U postgres -d sisabaik_dev -f database/07_auth.sql

# Copy .env.example ke .env dan isi konfigurasi

cp .env.example .env

# Edit .env: PGPASSWORD, JWT_SECRET

\\

### Frontend

\\Terminal
cd frontend
npm install

# Atau untuk reproduksi exact versions

npm ci
\\

## Menjalankan Aplikasi

### Backend (Development)

\\Terminal

# Dari root project

npm run dev

# Server berjalan di http://127.0.0.1:3000

\\

### Frontend (Development)

\\Terminal

# Dari folder frontend

cd frontend
npm run dev

# Server berjalan di http://127.0.0.1:5173

\\

### Frontend (Production Build & Preview)

\\Terminal
cd frontend

# Build untuk production

npm run build

# Preview hasil build

npm run preview

# Preview berjalan di http://127.0.0.1:4173

\\

## Struktur Project

\\
sisabaik-api/
├── src/ # Backend source code
│ ├── config/ # Konfigurasi (auth)
│ ├── controllers/ # Request handlers
│ ├── db/ # Database connection
│ ├── lib/ # Helper functions
│ ├── middleware/ # Express middleware
│ ├── repositories/ # Data access layer
│ ├── routes/ # API routes
│ ├── services/ # Business logic
│ └── app.js # Express app configuration
├── frontend/ # Frontend Vue.js
│ ├── src/
│ │ ├── assets/ # SVG illustrations (4 files)
│ │ ├── components/ # Vue components
│ │ ├── data/ # Fixture data (memory-only)
│ │ ├── lib/ # Helper functions
│ │ ├── App.vue # Root component
│ │ ├── main.js # Vue app entry
│ │ └── style.css # Global styles
│ ├── index.html # HTML template
│ └── package.json # Frontend dependencies
├── database/ # SQL migration files
├── scripts/ # Helper scripts
├── public/ # Static files (Chapter 7-8)
├── docs/ # Documentation
├── server.js # Server entry point
└── package.json # Backend dependencies
\\

## Aset Visual (Frontend Chapter 9)

Frontend Chapter 9 menggunakan **4 file SVG lokal** yang disimpan di Frontend/src/assets/:

1. **brand-mark.svg** - Logo SisaBaik
2. **food-bread.svg** - Ilustrasi kategori roti & kue
3. **food-bowl.svg** - Ilustrasi makanan siap saji
4. **food-produce.svg** - Ilustrasi bahan segar

Ilustrasi digunakan sebagai gambar default untuk setiap kategori penawaran.

## Catatan Penting Chapter 9

### Data Fixture di Memori

Frontend Chapter 9 menggunakan **data fixture dalam memori** (Frontend/src/data/penawaran-latihan.js):

- **6 penawaran fixture** dengan berbagai status (aktif, draft, habis, lewat waktu)
- Data **hanya tersimpan di browser** dan **hilang saat refresh**
- **Tidak ada koneksi ke API backend** pada Chapter 9
- Tujuan: Fokus pembelajaran komponen Vue tanpa kompleksitas API

### Fitur Chapter 9

**Mode Pembeli:**

- Katalog penawaran dengan filter pencarian & kategori
- Kartu penawaran dengan ilustrasi, harga, diskon, dan countdown
- Ringkasan ketersediaan (penawaran tersedia, unit, penyedia)
- Empty state ketika filter tidak cocok
- Pilihan makanan (tanpa checkout nyata)

**Mode Penyedia (Simulasi Penyedia Rina):**

- Form penawaran baru dengan validasi lengkap
- Daftar penawaran milik penyedia (semua status)
- Ringkasan: total penawaran, tersedia, unit tersedia
- Validasi form: harga, stok, tanggal masa depan

### Integrasi Backend (Belum di Chapter 9)

Backend dari Chapter 5-8 tetap tersedia dengan fitur:

- ✅ Pendaftaran mandiri pembeli & penyedia
- ✅ Verifikasi profil penyedia (melalui script CLI)
- ✅ Login dengan JWT (15 menit expiry)
- ✅ Autentikasi & otorisasi berbasis peran
- ✅ CRUD penawaran (hanya penyedia terverifikasi)
- ✅ CRUD pesanan (dengan transaksi atomik & row locking)
- ✅ Validasi berlapis & keamanan (helmet, rate limiting)

**Integrasi frontend-backend akan dilakukan pada Chapter 10-11** dengan:

- Fetch API untuk komunikasi client-server
- State management untuk data dari server
- Session handling dengan JWT
- Error handling untuk response API

## API Endpoints (Backend Chapter 7-8)

### Public

- \GET /api/health\ - Health check
- \GET /api/penawaran\ - Daftar penawaran (publik)
- \GET /api/penawaran/:id\ - Detail penawaran

### Authentication

- \POST /api/auth/registrasi\ - Daftar pembeli
- \POST /api/auth/registrasi-penyedia\ - Daftar penyedia
- \POST /api/auth/login\ - Login
- \GET /api/auth/saya\ - Profil akun (requires auth)
- \POST /api/auth/logout\ - Logout (requires auth)

### Penawaran (Requires Authentication)

- \GET /api/penawaran/milik-saya\ - Daftar penawaran milik sendiri
- \POST /api/penawaran\ - Buat penawaran (penyedia terverifikasi)
- \PUT /api/penawaran/:id\ - Update penawaran (pemilik)
- \DELETE /api/penawaran/:id\ - Hapus penawaran (pemilik)

### Pesanan (Requires Authentication)

- \GET /api/pesanan\ - Daftar pesanan sendiri
- \GET /api/pesanan/:id\ - Detail pesanan
- \POST /api/pesanan\ - Buat pesanan (pembeli)

## Testing

\\Terminal

# Backend

npm run api:test # Test API endpoints (Chapter 7)

# Frontend - Manual testing

cd frontend
npm run dev

# Buka http://127.0.0.1:5173

# Test: filter, form validation, state changes

# Frontend - Build verification

npm run build
npm run preview

# Verifikasi compilation success

\\

## Scripts npm

### Backend (Root)

\\Terminal
npm run dev # Development dengan watch mode
npm start # Production mode
npm run db:check # Cek koneksi database
npm run db:order # Test transaksi pesanan
npm run api:test # Test API endpoints
\\

### Frontend

\\Terminal
npm run dev # Development server (5173)
npm run build # Production build
npm run preview # Preview build (4173)
\\

## Environment Variables

Backend memerlukan file .env (lihat .env.example):

\\env
PORT=3000
PGHOST=localhost
PGPORT=5432
PGDATABASE=sisabaik_dev
PGUSER=postgres
PGPASSWORD=your_password_here
JWT_SECRET=your_64_hex_chars_here
\\

**Catatan Keamanan:**

- .env sudah masuk .gitignore
- Jangan commit password, JWT secret, atau hash
- Generate JWT_SECRET: \
  ode -e "console.log(require('crypto').randomBytes(32).toString('hex'))"\

## Git Workflow

\\Terminal

# Cek status

git status

# Pastikan node_modules & dist tidak tracked

git check-ignore frontend/node_modules frontend/dist

# Stage perubahan

git add frontend README.md docs/

# Review sebelum commit

git diff --staged

# Commit

git commit -m "feat: descriptive message"
\\

## Dokumentasi Tambahan

- \docs/hasil-uji-chapter9.md\ - Hasil pengujian Chapter 9
- \database/\ - SQL schema dan migration files
- Modul lengkap tersedia di folder \modul/\

## Lisensi

Project ini dibuat untuk keperluan pembelajaran mata kuliah Pengembangan Web - DGT1.62.7009, Program Studi Bisnis Digital, Semester Ganjil 2026/2027.

## Kontributor

- Nama: [NAMA_MAHASISWA]
- NIM: [NIM_MAHASISWA]
- Dosen Pengampu: Randi Proska Sandra

---

**Versi:** 1.0.1 (Frontend Chapter 9)  
**Terakhir diperbarui:** November 2026
