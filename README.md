# Volunite

## Deskripsi Aplikasi

**Volunite** adalah sebuah aplikasi mobile yang dirancang untuk mempertemukan para relawan (volunteer) dengan berbagai kegiatan dan organisasi sosial. Aplikasi ini bertujuan untuk memudahkan individu yang ingin berkontribusi dalam kegiatan sukarela untuk menemukan peluang yang sesuai dengan minat, lokasi, dan ketersediaan waktu mereka.

Bagi organisasi, Volunite menjadi platform untuk menjangkau calon relawan yang lebih luas dan mengelola kegiatan mereka dengan lebih efisien.

## Anggota Kelompok

Proyek ini dikerjakan oleh:

* **Alfi Syahrin** - **231402028**
* **Mayadi Alamsyah Putra Silalahi** - **231402046**
* **Naurah Alya Rahmah** - **231402049**
* **Ferdyan Darwis** - **231402092**
* **Paskal Irvaldi Manik** - **231402128**

## Fitur

Berikut adalah rencana fitur yang akan dikembangkan dalam aplikasi Volunite:

* **Registrasi & Profil Pengguna:** Mendaftar akun dan melengkapi profil dengan minat serta keahlian.

* **Riwayat Kegiatan:** Melihat semua riwayat kegiatan yang pernah diikuti sebagai portofolio digital.

* **Daftar Kegiatan:** Menampilkan daftar kegiatan yang tersedia untuk calon volunteer.

* **Pencarian & Filter:** Mencari kegiatan spesifik dan menyaring hasil berdasarkan kategori, lokasi, serta tanggal.

* **Detail Kegiatan:** Melihat informasi lengkap sebuah acara (deskripsi, tugas, jadwal, benefit).

* **Notifikasi:** Menerima pengingat jadwal, konfirmasi pendaftaran, dan rekomendasi kegiatan baru secara otomatis.

## Kebutuhan Instalasi

Untuk menjalankan dan mengembangkan aplikasi Volunite, pastikan sistem Anda memenuhi persyaratan berikut:

* **JDK (Java Development Kit):**
    * Versi Minimum: **OpenJDK 17**
    * [Link Download OpenJDK](https://openjdk.org/install/)

* **Flutter SDK:**
    * Versi Minimum: **3.10.0**
    * [Link Download Flutter SDK](https://docs.flutter.dev/get-started/install)

* **Android Studio:**
    * Versi Minimum: **2025.1.3**
    * [Link Download Android Studio](https://developer.android.com/studio)

## Cara Menjalankan Aplikasi

1.  **Clone Repository:**
    ```bash
    git clone https://github.com/Mayadi21/volunite.git
    cd volunite
    ```
2.  **Dapatkan Dependensi:**
    ```bash
    flutter pub get
    ```
3.  **Jalankan di Emulator/Perangkat:**
    * Pastikan ada emulator Android yang berjalan atau perangkat Android/iOS yang terhubung dan terdeteksi (`flutter devices`).
    ```bash
    flutter run
    ```
4. **setup & Jalankan Backend Server:**
    Aplikasi mobile ini memerlukan backend API agar dapat berfungsi sepenuhnya. Jalankan perintah berikut di terminal terpisah (pastikan Anda keluar dari folder volunite frontend terlebih dahulu):
    
    ```bash
    cd ..
    git clone https://github.com/Mayadi21/volunite_backend.git
    ```