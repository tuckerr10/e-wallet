# E-Wallet Application (Frontend)

Tugas ini disusun untuk memenuhi **Ujian Akhir Semester (UAS) Mobile Application**.

**Nama**: Moh Frendy Aprianto  
**NIM**: 1123150125  

## Video Presentasi / Demo
🔗 [Tonton di YouTube](https://youtu.be/tzie9l5RnwQ?si=2drLyATr8UgkY9q4)

## Tautan Repository Terkait
Berikut adalah link repository untuk bagian lain dari ekosistem aplikasi ini:
- **Backend E-Money**: [https://github.com/tuckerr10/e-wallet-back-end.git](https://github.com/tuckerr10/e-wallet-back-end.git)
- **Backend Bagstore**: [https://github.com/tuckerr10/bag-store-be-UAS.git](https://github.com/tuckerr10/bag-store-be-UAS.git)
- **Frontend Bagstore**: [https://github.com/tuckerr10/uts_1123150125_bagstore.git](https://github.com/tuckerr10/uts_1123150125_bagstore.git)

---

## Struktur Folder Project (E-Wallet Frontend)

Aplikasi frontend ini dibangun menggunakan framework **Flutter**. Berikut adalah gambaran umum dari struktur foldernya:

```text
e-money-front-end/
│
├── android/           # Kode native untuk platform Android
├── ios/               # Kode native untuk platform iOS
├── lib/               # Kode utama aplikasi (Dart)
│   ├── core/          # Utils, Services (seperti notifikasi), Router
│   ├── data/          # Models, Repositories, Datasources API
│   ├── domain/        # Logic domain, Use Cases
│   ├── injection/     # Setup Dependency Injection
│   ├── presentation/  # UI: Pages, Widgets, Blocs/Cubits
│   └── main.dart      # Entry point aplikasi
│
├── assets/            # Gambar, Icon, dan file aset lainnya
├── test/              # Unit testing dan widget testing
├── pubspec.yaml       # Konfigurasi package/dependensi Flutter
└── README.md          # Dokumentasi ini
```

---

## Cara Menjalankan Aplikasi

Untuk menjalankan frontend e-wallet ini di mesin lokal Anda, ikuti langkah-langkah berikut:

1. **Pastikan Flutter Terinstal**
   Pastikan Anda sudah menginstal Flutter SDK. Periksa dengan menjalankan:
   ```bash
   flutter doctor
   ```

2. **Clone Repository Ini**
   ```bash
   git clone https://github.com/tuckerr10/e-wallet.git
   cd e-wallet
   ```

3. **Install Dependensi**
   Jalankan perintah ini untuk mengunduh semua package yang diperlukan:
   ```bash
   flutter pub get
   ```

4. **Jalankan Aplikasi**
   Pastikan Anda telah menyambungkan emulator atau perangkat fisik (Android/iOS). Kemudian jalankan:
   ```bash
   flutter run
   ```
   > **Catatan**: Jika Anda ingin menjalankan ke environment tertentu, pastikan backend E-Money sudah berjalan di lokal/server dan URL API di aplikasi sudah disesuaikan agar terhubung.

---

## Screenshot Aplikasi

Berikut adalah 16 tampilan (screenshot) dari aplikasi E-Wallet ini. 
*(Tips: Nanti saat memindahkan gambar, ganti URL di dalam kurung di bawah ini dengan link gambar yang Anda drag-and-drop ke GitHub).*

| | | | |
|:---:|:---:|:---:|:---:|
| ![Screen 1](link_gambar_1) | ![Screen 2](link_gambar_2) | ![Screen 3](link_gambar_3) | ![Screen 4](link_gambar_4) |
| ![Screen 5](link_gambar_5) | ![Screen 6](link_gambar_6) | ![Screen 7](link_gambar_7) | ![Screen 8](link_gambar_8) |
| ![Screen 9](link_gambar_9) | ![Screen 10](link_gambar_10) | ![Screen 11](link_gambar_11) | ![Screen 12](link_gambar_12) |
| ![Screen 13](link_gambar_13) | ![Screen 14](link_gambar_14) | ![Screen 15](link_gambar_15) | ![Screen 16](link_gambar_16) |
