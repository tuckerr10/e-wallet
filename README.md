# E-Wallet Application (Frontend)

Tugas ini disusun untuk memenuhi **Ujian Akhir Semester (UAS) Mobile Application**.

**Nama**: Moh Frendy Aprianto  
**NIM**: 1123150125  

Aplikasi ini adalah bagian **Frontend** dari sistem E-Wallet komprehensif, yang memungkinkan pengguna untuk melakukan pembayaran, transfer saldo, kelola uang (top-up), serta terintegrasi langsung dengan ekosistem merchant (Bagstore). Aplikasi ini dibangun dengan standar arsitektur industri untuk memastikan skalabilitas dan maintainability.

---

## 🎥 Video Presentasi / Demo
🔗 [Tonton Demonstrasi Aplikasi di YouTube](https://youtu.be/tzie9l5RnwQ?si=2drLyATr8UgkY9q4)

---

## 🔗 Tautan Repository Ekosistem
Sistem E-Wallet ini terhubung dengan beberapa servis lainnya. Berikut adalah struktur repository keseluruhan project:
- **Frontend E-Wallet (Saat ini)**: [https://github.com/tuckerr10/e-wallet.git](https://github.com/tuckerr10/e-wallet.git)
- **Backend E-Wallet**: [https://github.com/tuckerr10/e-wallet-back-end.git](https://github.com/tuckerr10/e-wallet-back-end.git)
- **Frontend Merchant (Bagstore)**: [https://github.com/tuckerr10/uts_1123150125_bagstore.git](https://github.com/tuckerr10/uts_1123150125_bagstore.git)
- **Backend Merchant (Bagstore)**: [https://github.com/tuckerr10/bag-store-be-UAS.git](https://github.com/tuckerr10/bag-store-be-UAS.git)

---

## 🛠️ Teknologi & Packages yang Digunakan

Aplikasi ini dikembangkan menggunakan **Flutter** dengan pendekatan *Clean Architecture*. Berikut adalah rincian teknologi dan library utama yang digunakan:

### 1. State Management & Architecture
- **flutter_bloc & equatable**: Digunakan sebagai pattern BLoC (Business Logic Component) untuk memisahkan UI dan business logic secara reaktif.
- **get_it**: Sebagai Dependency Injection (DI) locator untuk mengatur instance repositories, datasources, dan blocs.
- **Clean Architecture**: Membagi kode menjadi layer `Domain`, `Data`, dan `Presentation` untuk modularitas tinggi.

### 2. Networking & Integrasi API
- **dio**: HTTP client handal untuk menghandle request REST API, interceptors, form data, dan timeout handling.
- **pretty_dio_logger**: Untuk kebutuhan debugging response/request log di console.

### 3. Keamanan & Local Storage
- **flutter_secure_storage**: Untuk menyimpan data sensitif (seperti token JWT dan PIN) secara aman berkat enkripsi bawaan sistem operasi (Keystore/Keychain).
- **shared_preferences**: Untuk menyimpan konfigurasi aplikasi yang sifatnya non-sensitif (seperti status onboarding).

### 4. Navigasi & Deep Linking
- **go_router**: Digunakan untuk manajemen rute yang kompleks, deklaratif, dan berbasis path (URL-based routing).
- **app_links & url_launcher**: Untuk menangani pembayaran via intent eksternal atau deep links dari aplikasi Bagstore ke E-Wallet ini.

### 5. Firebase Services
- **firebase_auth & google_sign_in**: Digunakan untuk autentikasi pengguna secara instan via Google.
- **firebase_messaging**: Menghandle Cloud Messaging (FCM) dan Push Notifications.

### 6. Fitur Pendukung Lanjutan
- **mobile_scanner**: Fitur scan QR Code untuk melakukan pembayaran dengan cepat ke merchant.
- **flutter_local_notifications**: Menampilkan notifikasi lokal secara real-time pada device.
- **cached_network_image & shimmer**: Mengoptimalkan rendering gambar dari network dan menyediakan animasi *loading state* (skeleton UI).
- **intl**: Digunakan untuk konversi format mata uang (Rupiah) dan formatting waktu/tanggal.

---

## 📂 Struktur Folder Project

Mengadopsi pola *Clean Architecture* dan *Feature-First*, berikut adalah struktur utama di dalam direktori `lib/`:

```text
lib/
├── core/                   # Logika pendukung (Router, Utils, Constants, Network Info)
│   ├── router/             # Konfigurasi GoRouter
│   ├── services/           # Deeplink & Notification Services
│   └── utils/              # Helper, formatters, etc.
│
├── data/                   # Layer Data (API, Database lokal, Models)
│   ├── datasources/        # Remote (Dio) & Local Datasources
│   ├── models/             # Data transfer object (JSON parser)
│   └── repositories/       # Implementasi repository (Contract resolver)
│
├── domain/                 # Layer Domain (Aturan Bisnis Murni)
│   ├── entities/           # Entitas inti
│   ├── repositories/       # Abstraksi (Interface) Repository
│   └── usecases/           # Eksekutor operasi per fitur
│
├── injection/              # File konfigurasi get_it untuk injeksi dependensi
│
├── presentation/           # Layer Presentasi (UI & State)
│   ├── blocs/              # Manajemen state (AuthBloc, TransactionBloc, dll)
│   ├── pages/              # Halaman utama (Home, Login, History, Topup, Transfer)
│   └── widgets/            # Komponen UI Reusable (Custom Button, TabBar, Row)
│
└── main.dart               # Entry point aplikasi
```

---

## 🚀 Cara Menjalankan Aplikasi

Ikuti panduan berikut untuk build dan run project E-Wallet ini secara lokal:

1. **Pastikan Requirements Terpenuhi**
   Pastikan Anda sudah menginstal Flutter SDK (>=3.0.0) dan environment Android Studio/Xcode sudah siap.
   ```bash
   flutter doctor
   ```

2. **Clone Repository**
   ```bash
   git clone https://github.com/tuckerr10/e-wallet.git
   cd e-wallet
   ```

3. **Install Dependensi Package**
   ```bash
   flutter pub get
   ```

4. **Konfigurasi Lingkungan (Opsional tapi Penting)**
   Pastikan Service **Backend E-Wallet** sudah berjalan (entah di localhost atau hosting). Jika di localhost, Anda mungkin perlu menyesuaikan `BASE_URL` di konfigurasi network (Dio) agar mengarah ke `10.0.2.2` (Emulator Android) atau IP lokal mesin Anda.

5. **Jalankan Aplikasi**
   Pilih emulator atau real device, lalu ketikkan:
   ```bash
   flutter run
   ```

---

## 📱 Screenshot / Tampilan Aplikasi

Berikut adalah dokumentasi tampilan (16 screen) dari fungsionalitas aplikasi E-Wallet.
*(Silakan drag-and-drop foto-foto screenshot Anda ke bagian ini saat mengedit README.md langsung dari GitHub, lalu ganti teks URL fotonya).*

| | | | |
|:---:|:---:|:---:|:---:|
| ![Screen 1](link_gambar_1) | ![Screen 2](link_gambar_2) | ![Screen 3](link_gambar_3) | ![Screen 4](link_gambar_4) |
| ![Screen 5](link_gambar_5) | ![Screen 6](link_gambar_6) | ![Screen 7](link_gambar_7) | ![Screen 8](link_gambar_8) |
| ![Screen 9](link_gambar_9) | ![Screen 10](link_gambar_10) | ![Screen 11](link_gambar_11) | ![Screen 12](link_gambar_12) |
| ![Screen 13](link_gambar_13) | ![Screen 14](link_gambar_14) | ![Screen 15](link_gambar_15) | ![Screen 16](link_gambar_16) |
