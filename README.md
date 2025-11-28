# Toko Online Sederhana

Aplikasi toko online sederhana yang dibangun dengan Flutter, menggunakan local database untuk simulasi sistem e-commerce dengan workflow multi-layer customer service.

## Tech Stack

### Core Framework
- **Flutter SDK**: ^3.10.0
- **Dart SDK**: ^3.10.0

### State Management & Dependency Injection
- **flutter_riverpod**: ^3.0.3 - State management dengan provider pattern
- **riverpod_annotation**: ^3.0.3 - Code generation untuk Riverpod
- **riverpod_generator**: ^3.0.3 - Generator untuk Riverpod providers

### Database & Persistence
- **drift**: ^2.29.0 - Type-safe SQL database ORM untuk Flutter
- **drift_dev**: ^2.29.0 - Code generator untuk Drift
- **sqlite3_flutter_libs**: ^0.5.40 - SQLite native libraries
- **path_provider**: ^2.1.5 - Akses ke direktori sistem file
- **shared_preferences**: ^2.5.3 - Key-value storage sederhana
- **flutter_secure_storage**: ^9.2.4 - Secure storage untuk data sensitif

### Navigation & Routing
- **go_router**: ^17.0.0 - Declarative routing dengan deep linking support

### UI & Styling
- **google_fonts**: ^6.1.0 - Integrasi Google Fonts
- **dynamic_color**: ^1.8.1 - Material You dynamic colors
- **cached_network_image**: ^3.4.1 - Caching gambar dari network

### Media & Files
- **image_picker**: ^1.2.1 - Memilih gambar dari galeri/kamera
- **pdf**: ^3.11.1 - Generate PDF documents
- **printing**: ^5.13.4 - PDF printing dan sharing

### Utilities
- **intl**: ^0.20.2 - Internationalization dan formatting
- **logger**: ^2.6.2 - Logging utility
- **equatable**: ^2.0.7 - Value equality untuk models
- **freezed**: ^3.2.3 & **freezed_annotation**: ^3.1.0 - Code generation untuk immutable classes
- **path**: ^1.9.1 - Path manipulation

### Development Tools
- **build_runner**: ^2.10.4 - Code generation runner
- **flutter_lints**: ^6.0.0 - Linting rules
- **flutter_test**: Testing framework

## Arsitektur Aplikasi

### Struktur Direktori

```
lib/
├── core/                      # Core utilities dan konfigurasi
│   ├── clients/              # Storage clients (SharedPreferences, SecureStorage)
│   ├── constants/            # App constants
│   ├── db/                   # Database configuration (Drift)
│   ├── di/                   # Dependency Injection (Riverpod providers)
│   ├── enums/                # Enumerations
│   ├── errors/               # Error handling
│   ├── router/               # App routing (GoRouter)
│   ├── theme/               # App theming (colors, fonts, text styles)
│   └── utils/                # Utility functions (spacing)
│
├── features/                  # Feature modules (Clean Architecture)
│   ├── cart/                 # Keranjang belanja
│   │   ├── data/
│   │   │   ├── datasources/  # DAO & Tables
│   │   │   ├── models/       # Data models
│   │   │   └── repositories/ # Repository implementation
│   │   └── presentation/
│   │       ├── pages/        # UI pages
│   │       ├── providers/    # Riverpod providers
│   │       └── widgets/      # Feature-specific widgets
│   │
│   ├── order/                # Manajemen pesanan
│   │   ├── data/
│   │   └── presentation/
│   │       └── services/     # Invoice service
│   │
│   ├── product/              # Katalog produk
│   │   ├── data/
│   │   └── presentation/
│   │
│   └── user/                 # Manajemen user & auth
│       ├── data/
│       └── presentation/
│
└── shared/                    # Shared components
    ├── extensions/           # Extension methods (context, currency, string, dll)
    └── widgets/              # Reusable widgets (buttons, text fields, states)
```

### Layer Architecture

Aplikasi mengikuti **Semi Clean Architecture** dengan pemisahan layer:

1. **Presentation Layer**
   - UI (Pages & Widgets)
   - State Management (Riverpod Providers)
   - User Interaction Logic

2. **Data Layer**
   - Data Sources (Local Database dengan Drift)
   - Models (Data Transfer Objects)
   - Repositories (Abstraksi akses data)

3. **Core & Shared**
   - Utilities, Extensions, Constants
   - Reusable Components
   - App Configuration

### Database Schema

Menggunakan **Drift** sebagai ORM dengan local SQLite database:

**Tables:**
- `users` - Data pengguna (customer, cs1, cs2)
- `products` - Katalog produk
- `carts` - Keranjang belanja per user
- `orders` - Data pesanan
- `order_items` - Detail item dalam pesanan

## Cara Menjalankan Aplikasi

### Prerequisites
- Flutter SDK 3.10.0 atau lebih tinggi
- Dart SDK 3.10.0 atau lebih tinggi
- Android Studio / VS Code dengan Flutter extension
- Android Emulator atau Physical Device

### Langkah Instalasi

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd toko_online_sederhana
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (Drift, Riverpod, Freezed)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run aplikasi**
   ```bash
   flutter run
   ```

### Build untuk Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## Simulasi Role Pengguna

Aplikasi memiliki 3 role pengguna dengan fungsi berbeda:

### 1. Pembeli (Customer)

**Login**: Pilih user dengan role "customer" di halaman auth

**Fitur yang tersedia:**
- Browse katalog produk
- Tambah produk ke keranjang
- Checkout pesanan
- Upload bukti transfer
- Lihat status pesanan
- Download invoice PDF

**Flow pemesanan:**
1. Pilih produk dan masukkan ke keranjang
2. Proses checkout dengan mengisi data pengiriman
3. Pesanan dibuat dengan status `MENUNGGU_UPLOAD_BUKTI`
4. Upload bukti pembayaran
5. Status berubah menjadi `MENUNGGU_VERIFIKASI_CS1`
6. Tunggu verifikasi dari CS Layer 1
7. Setelah disetujui CS1 dan CS2, pesanan akan diproses
8. Terima pesanan saat status `DIKIRIM`
9. Selesaikan pesanan menjadi `SELESAI`

### 2. CS Layer 1 Verifikasi Pembayaran

**Login**: Pilih user dengan role "cs1" di halaman auth

**Fitur yang tersedia:**
- Lihat daftar pesanan yang perlu diverifikasi
- Filter pesanan dengan status `MENUNGGU_VERIFIKASI_CS1`
- Periksa bukti pembayaran
- Konfirmasi atau tolak pesanan
- Jika dikonfirmasi, pesanan diteruskan ke CS2 dengan status `MENUNGGU_VERIFIKASI_CS2`
- Jika ditolak, pesanan dibatalkan dan stok dikembalikan

**Tanggung jawab:**
- Memverifikasi keaslian bukti pembayaran
- Memastikan jumlah transfer sesuai dengan total pesanan
- Menolak pesanan yang tidak valid

### 3. CS Layer 2 (Pemrosesan & Pengiriman)

**Login**: Pilih user dengan role "cs2" di halaman auth

**Fitur yang tersedia:**
- Lihat daftar pesanan yang sudah diverifikasi CS1
- Filter pesanan dengan status:
  - `MENUNGGU_DIPROSES_CS2` (baru masuk dari CS1)
  - `SEDANG_DIPROSES` (dalam proses pengemasan)
  - `DIKIRIM` (sudah dikirim)
- Proses pesanan dari verifikasi hingga pengiriman

**Flow kerja CS2:**
1. Pesanan masuk dengan status `MENUNGGU_DIPROSES_CS2`
2. Klik "Proses Pesanan" → status berubah `SEDANG_DIPROSES`
3. Setelah dikemas, klik "Kirim Pesanan" → status `DIKIRIM`
4. Customer menerima dan klik "Selesaikan" → status `SELESAI`

## Detail Implementasi

### Penyimpanan Data

**Metode**: **Local Database** dengan SQLite melalui Drift ORM

**Alasan menggunakan local storage:**
- Simulasi sistem tanpa backend server
- Persistent data antar sesi aplikasi
- Type-safe queries dengan Drift
- Automatic schema migrations
- Reactive queries dengan Stream support

**Lokasi database:**
- Android: `/data/data/com.example.toko_online_sederhana/databases/`
- iOS: Application Documents Directory

**Inisialisasi data:**
- Sample users otomatis dibuat saat pertama kali buka aplikasi
- Sample products juga dibuat otomatis
- Data persisten hingga aplikasi di-uninstall

### Mekanisme Auto Cancel 24 Jam

**Implementasi:**

Pesanan yang berada dalam status `MENUNGGU_UPLOAD_BUKTI` selama lebih dari 24 jam akan otomatis dibatalkan.

**Lokasi kode:**
- File: `lib/features/order/data/repositories/order_repository.dart`
- Method: `checkAndCancelExpiredOrders()`

**Cara kerja:**
1. Background check berjalan setiap kali aplikasi dibuka atau order list di-load
2. Sistem menghitung selisih waktu antara `createdAt` dengan waktu sekarang
3. Jika selisih > 24 jam dan status masih `MENUNGGU_UPLOAD_BUKTI`:
   - Status diubah menjadi `DIBATALKAN`
   - Stok produk dikembalikan (jika sudah dikurangi)
   - Timestamp `updatedAt` diperbarui

**Trigger otomatis:**
```dart
// Di OrderProvider saat load orders
await ref.read(orderRepositoryProvider).checkAndCancelExpiredOrders();
```

**Formula perhitungan:**
```dart
final now = DateTime.now();
final diff = now.difference(order.createdAt);
if (diff.inHours >= 24 && order.status == 'MENUNGGU_UPLOAD_BUKTI') {
  // Cancel order
}
```

### Flow Status Pesanan

```
[CUSTOMER] Create Order
    ↓
MENUNGGU_UPLOAD_BUKTI (max 24 jam)
    ↓ (upload bukti)
MENUNGGU_VERIFIKASI_CS1
    ↓ (CS1 approve)
MENUNGGU_DIPROSES_CS2
    ↓ (CS2 proses)
SEDANG_DIPROSES
    ↓ (CS2 kirim)
DIKIRIM
    ↓ (Customer terima)
SELESAI

    * Setiap tahap bisa → DIBATALKAN
    * Auto cancel jika > 24 jam di MENUNGGU_UPLOAD_BUKTI
```

### Manajemen Stok

**Pengurangan stok:**
- Stok dikurangi saat CS1 **menerima** pesanan (approve payment)
- Bukan saat checkout, untuk mencegah stok terkunci tanpa pembayaran

**Pengembalian stok:**
- Otomatis saat pesanan dibatalkan (manual atau auto-cancel)
- Ditangani di repository layer

**Implementasi:**
```dart
// Saat CS1 approve
await productRepository.reduceStock(orderId);

// Saat cancel
await productRepository.restoreStock(orderId);
```

### PDF Invoice

**Library**: `pdf` package + `printing` package

**Fitur:**
- Generate invoice dengan layout profesional
- Menampilkan detail lengkap:
  - Informasi pembeli
  - Daftar produk (nama, qty, harga, subtotal)
  - Total pembayaran
  - Status pesanan
  - Bukti pembayaran (jika ada)
- Export/share PDF ke aplikasi lain
- Preview sebelum download

**Lokasi**: `lib/features/order/presentation/services/invoice_service.dart`

## Testing & Verification

### Menjalankan Dart Analyze

```bash
flutter analyze
```

Aplikasi harus lolos tanpa warning atau error.

### Testing Flow Lengkap

1. **Setup awal**
   - Run aplikasi
   - Pastikan sample data sudah ada

2. **Test sebagai Customer**
   - Login sebagai customer
   - Add produk ke cart
   - Checkout
   - Upload bukti bayar
   - Lihat invoice PDF

3. **Test sebagai CS1**
   - Login sebagai cs1
   - Lihat pesanan pending
   - Approve/reject pesanan

4. **Test sebagai CS2**
   - Login sebagai cs2
   - Proses pesanan approved
   - Ubah status hingga DIKIRIM

5. **Test Auto Cancel**
   - Buat pesanan baru
   - Ubah `createdAt` di database menjadi 25 jam yang lalu (manual edit)
   - Restart app/reload order list
   - Verify status berubah DIBATALKAN

## Troubleshooting

### Error: "MissingPluginException"
```bash
flutter clean
flutter pub get
flutter run
```

### Error saat generate code
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Database tidak terupdate
- Uninstall aplikasi dari device
- Install ulang untuk fresh database

### Bukti pembayaran tidak muncul
- Pastikan permission storage sudah diberikan
- Check path file image masih valid


---
