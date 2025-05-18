# Konfigurasi Todo App dengan MySQL

Aplikasi ini dapat dikonfigurasi untuk menggunakan MySQL melalui Prisma ORM. Anda tidak perlu menginstal MySQL secara manual jika sudah memilikinya.

## Konfigurasi Prisma dengan MySQL

### 1. Perbarui Schema Prisma

Buka file `schema.prisma` di direktori prisma dan ubah provider dari PostgreSQL ke MySQL:

```prisma
// backend/prisma/schema.prisma
datasource db {
  provider = "mysql"
  url      = env("DATABASE_URL")
}
```

### 2. Konfigurasi Connection URL

Edit file `.env` di direktori backend:

```
# Format DATABASE_URL untuk MySQL
DATABASE_URL="mysql://username:password@localhost:3306/nama_database"
```

### 3. Jalankan Migrasi Prisma

```bash
cd backend
npx prisma migrate dev --name init
```

Perintah ini akan membuat skema database di MySQL sesuai dengan model yang didefinisikan di `schema.prisma`.

### 4. Generate Prisma Client

```bash
npx prisma generate
```

## Menjalankan Aplikasi

### Backend (NestJS)

```bash
# Jalankan backend dengan host yang dapat diakses dari jaringan
cd backend
npm run start:dev -- --host 0.0.0.0
```

Server akan berjalan di `http://localhost:3000` (atau port yang dikonfigurasi di .env)

### Frontend (Flutter)

Sesuaikan IP address di file `setings.dart`:

```dart
final base_url = 'http://192.168.x.x:3000/api';
```

> **Catatan:** Ganti `192.168.x.x` dengan alamat IP jaringan komputer Anda. Temukan alamat IP dengan perintah `ipconfig` (Windows) atau `ifconfig` (Linux/Mac).

Kemudian jalankan aplikasi Flutter:

```bash
cd mobile_app
flutter pub get
flutter run
```

## Troubleshooting

- **Error koneksi database:** Pastikan kredensial MySQL dan alamat host benar
- **Error akses ditolak:** Pastikan pengguna MySQL memiliki hak akses yang cukup
- **Error koneksi API:** Verifikasi alamat IP di `setings.dart` sudah benar
- **Error saat migrasi:** Cek apakah struktur database kompatibel dengan skema Prisma
