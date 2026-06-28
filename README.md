<div align="center">

# 💸 E-Wallet Frenzy (Frontend)

**Tugas Ujian Akhir Semester (UAS) Mobile Application**

<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" /> <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" /> <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=white" />

Aplikasi Frontend E-Wallet komprehensif untuk pembayaran, transfer saldo, top-up, dan integrasi merchant.

**Moh Frendy Aprianto • 1123150125**

---

### 🎥 [Tonton Video Presentasi / Demo di YouTube](https://youtu.be/tzie9l5RnwQ?si=2drLyATr8UgkY9q4) 🎥

</div>

<br>

## 🌐 Ekosistem Aplikasi
Aplikasi ini terhubung dengan berbagai service pendukung. Berikut adalah daftar repository terkait:

| Komponen | Link Repository |
|:---|:---|
| 📱 **Frontend E-Wallet** | *(Anda di sini)* |
| ⚙️ **Backend E-Wallet** | [e-wallet-back-end](https://github.com/tuckerr10/e-wallet-back-end.git) |
| 🛍️ **Frontend Bagstore** | [uts_1123150125_bagstore](https://github.com/tuckerr10/uts_1123150125_bagstore.git) |
| 🗄️ **Backend Bagstore** | [bag-store-be-UAS](https://github.com/tuckerr10/bag-store-be-UAS.git) |

<br>

## 🛠️ Teknologi & Arsitektur Utama

Aplikasi dibangun dengan berpegang pada prinsip **Clean Architecture** (Domain, Data, Presentation) untuk memastikan skalabilitas dan kode yang bersih.

- 🏗️ **State Management & DI**: Menggunakan `flutter_bloc` dipadukan dengan `get_it` sebagai service locator.
- 🔗 **Networking & API**: `dio` untuk HTTP Client yang handal dengan dukungan `pretty_dio_logger`.
- 🔐 **Keamanan & Storage**: `flutter_secure_storage` untuk menyimpan JWT/PIN dengan aman (terenkripsi), dan `shared_preferences`.
- 🧭 **Navigasi & Deep Link**: Rute dikelola deklaratif via `go_router`. Transaksi antar aplikasi via `app_links` & `url_launcher`.
- 🔥 **Firebase**: Terintegrasi `firebase_auth`, `google_sign_in`, dan Cloud Messaging (`firebase_messaging`).
- 📸 **Fitur Lainnya**: QR Scanner (`mobile_scanner`), Local Notif (`flutter_local_notifications`), Skeleton Loading (`shimmer`).

<br>

## 📂 Struktur Folder
<details>
<summary><b>Klik untuk melihat struktur direktori <code>lib/</code></b></summary>

```text
lib/
├── core/                   # Logika pendukung (Router, Utils, Constants, Network Info)
├── data/                   # Layer Data (API, Datasources, Models, Repositories Impl)
├── domain/                 # Layer Domain (Entities, Usecases, Repo Interfaces)
├── injection/              # Konfigurasi Dependency Injection (get_it)
├── presentation/           # Layer UI (Blocs, Pages, Widgets)
└── main.dart               # Entry point aplikasi
```
</details>

<br>

## 🚀 Cara Menjalankan Project

1. **Pastikan Flutter Terinstal** (versi 3.0.0 ke atas).  
   ```bash
   flutter doctor
   ```
2. **Clone Repo Ini**
   ```bash
   git clone https://github.com/tuckerr10/e-wallet.git
   cd e-wallet
   ```
3. **Download Dependensi**
   ```bash
   flutter pub get
   ```
4. **Jalankan Aplikasi**
   > *Pastikan Backend E-Wallet lokal/server sudah berjalan agar API berfungsi dengan baik.*
   ```bash
   flutter run
   ```

<br>

## 📱 Screenshot Aplikasi

*(Note: Silakan drag-and-drop screenshot Anda langsung ke tabel ini melalui editor GitHub)*

| | | | |
|:---:|:---:|:---:|:---:|
| ![Screen 1](path_gambar_1) | ![Screen 2](path_gambar_2) | ![Screen 3](path_gambar_3) | ![Screen 4](path_gambar_4) |
| ![Screen 5](path_gambar_5) | ![Screen 6](path_gambar_6) | ![Screen 7](path_gambar_7) | ![Screen 8](path_gambar_8) |
| ![Screen 9](path_gambar_9) | ![Screen 10](path_gambar_10) | ![Screen 11](path_gambar_11) | ![Screen 12](path_gambar_12) |
| ![Screen 13](path_gambar_13) | ![Screen 14](path_gambar_14) | ![Screen 15](path_gambar_15) | ![Screen 16](path_gambar_16) |
