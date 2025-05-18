# Konfigurasi Todo App dengan MySQL

Untuk mengganti database aplikasi dari PostgreSQL ke MySQL, Anda perlu melakukan perubahan pada sisi backend (NestJS). Aplikasi Flutter tidak perlu diubah karena hanya berkomunikasi dengan API.

## Langkah-langkah Konfigurasi MySQL

### 1. Instalasi MySQL

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install mysql-server

# Windows
# Download dan install MySQL dari https://dev.mysql.com/downloads/installer/
```

### 2. Buat Database

```bash
# Masuk ke MySQL
mysql -u root -p

# Buat database baru
CREATE DATABASE todo_list;
CREATE USER 'todouser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON todo_list.* TO 'todouser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 3. Konfigurasi NestJS untuk MySQL

#### Instal dependencies MySQL

```bash
cd backend
npm install --save @nestjs/typeorm typeorm mysql2
```

#### Edit file .env

```
# Ganti DATABASE_URL dengan format koneksi MySQL
DATABASE_URL="mysql://todouser:password@localhost:3306/todo_list"
```

#### Perbarui konfigurasi database di NestJS

```typescript
import { TypeOrmModule } from "@nestjs/typeorm";

@Module({
  imports: [
    ConfigModule.forRoot(),
    TypeOrmModule.forRoot({
      type: "mysql",
      host: "localhost",
      port: 3306,
      username: "todouser",
      password: "password",
      database: "todo_list",
      entities: [__dirname + "/**/*.entity{.ts,.js}"],
      synchronize: true, // Hanya gunakan true di development!
    }),
    // ...module lainnya
  ],
})
export class AppModule {}
```

### 4. Jalankan Aplikasi

```bash
# Jalankan backend dengan host yang dapat diakses dari jaringan
cd backend
npm run start:dev -- --host 0.0.0.0

# Di terminal terpisah, jalankan aplikasi mobile
cd mobile_app
flutter run
```

## Pengaturan IP Address

Pastikan untuk memperbarui `setings.dart` dengan IP address yang benar:

```dart
final base_url = 'http://192.168.x.x:3000/api';
```

## Migrasi Data

Jika Anda memiliki data yang perlu dimigrasikan dari PostgreSQL ke MySQL:

1. Export data dari PostgreSQL

```bash
pg_dump -U username -d todo_app > todo_backup.sql
```

2. Konversi sintaks SQL jika diperlukan (ada beberapa perbedaan antara PostgreSQL dan MySQL)

3. Import ke MySQL

```bash
mysql -u todouser -p todo_list < todo_backup_converted.sql
```

Dengan langkah-langkah ini, aplikasi Todo List Anda akan menggunakan MySQL sebagai database backend.
