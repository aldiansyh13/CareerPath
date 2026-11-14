# Menyiapkan Firebase dan Gemini untuk CareerPath AI

Ikuti langkah 1–4 untuk semua versi. Di langkah 5 pilih satu cara menghubungkan Gemini sesuai tujuan APK. Pemilik proyek mengurus akun dan konsol. Agent mengurus kode di repo. Beri tahu agent hasil tiap langkah dengan pesan singkat seperti “Email/Password aktif di proyek demo”. Nilai key dan sandi tetap di perangkat pemilik.

## 1. Persiapkan komputer dan satu proyek tim

1. Siapkan akun Google, Flutter SDK, Android SDK melalui Android Studio, dan satu emulator atau HP dengan USB debugging. Dari terminal jalankan `flutter doctor` lalu `flutter devices`. Target awal: Android toolchain siap dan satu perangkat terlihat. [Instal Flutter](https://docs.flutter.dev/install)
2. Pemilik membuka [Firebase Console](https://console.firebase.google.com/), memilih **Create a project**, dan memberi nama proyek demo. Analytics opsional. Catat **Project ID** dari Project settings → General. Gunakan satu ID yang sama untuk Auth, Firestore, Android dan integrasi Gemini. Undang anggota melalui Users and permissions sesuai tugasnya.
3. Di folder aplikasi yang berisi pubspec.yaml, cek applicationId di android/app/build.gradle.kts atau build.gradle. Berikan ke agent **Project ID** dan **applicationId**. Keduanya pengenal proyek, berbeda fungsi dari kredensial untuk memanggil Gemini.
4. Pasang Firebase CLI sesuai sistem operasi. Bila Node.js dan npm sudah tersedia, gunakan perintah berikut. Jalankan login sendiri melalui browser. [Firebase CLI](https://firebase.google.com/docs/cli)

```sh
npm install -g firebase-tools
firebase login
firebase projects:list
dart pub global activate flutterfire_cli
```

Project ID harus muncul. Jika perintah flutterfire belum dikenali, tambahkan direktori bin cache Pub ke PATH sesuai petunjuk dari dart lalu buka ulang terminal.

## 2. Hubungkan Flutter Android

Dari root Flutter, jalankan perintah berikut. Ganti PROJECT_ID dengan ID di konsol. Pilih aplikasi Android dengan applicationId yang sesuai jika diminta.

```sh
flutter pub add firebase_core firebase_auth cloud_firestore provider
flutterfire configure --project=PROJECT_ID --platforms=android
```

Agent memakai lib/firebase_options.dart yang dihasilkan. Di main(), jalankan WidgetsFlutterBinding.ensureInitialized(), lalu tunggu Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform) sebelum runApp. Build ulang dengan flutter run. **Bukti berhasil:** aplikasi terbuka, inisialisasi berhasil dan aplikasi Android terdaftar di proyek yang benar. Konfigurasi client Firebase berisi pengenal proyek; akses data pengguna tetap bergantung pada Auth dan Rules. Tidak perlu mengunduh kunci privat Admin SDK untuk aplikasi Flutter. [Konfigurasi FlutterFire](https://firebase.google.com/docs/flutter/setup)

## 3. Aktifkan login

Di Firebase Console pilih **Authentication → Get started → Sign-in method → Email/Password**. Aktifkan opsi email dan password, lalu Save. Agent memakai Firebase Auth untuk mendaftar, masuk, memantau sesi dan keluar. Buat akun uji dari aplikasi. Periksa bahwa akun muncul di **Authentication → Users**, tutup dan buka ulang aplikasi, lalu uji keluar. Catat hasil di L-04. [Panduan Email/Password](https://firebase.google.com/docs/auth/flutter/password-auth)

## 4. Buat database dan batasi akses per akun

Di **Firestore Database → Create database**, gunakan database Standard dengan ID (default), pilih lokasi yang cocok untuk tim dan pengguna, lalu pilih **Production mode**. Di tab **Rules**, untuk proyek demo baru terapkan aturan di bawah dan tekan **Publish**. Jika proyek sudah berisi koleksi lain, gabungkan aturan milik aplikasi dan tinjau izin yang tumpang tindih sebelum menerbitkan. Simpan salinan aturan di repo. [Membuat Firestore](https://firebase.google.com/docs/firestore/quickstart) · [Aturan berdasarkan pengguna](https://firebase.google.com/docs/firestore/security/rules-conditions)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
      match /assessments/{assessmentId} {
        allow read, write: if request.auth != null && request.auth.uid == uid;
      }
    }
  }
}
```

Agent menulis profil ke users/{uid} dan hasil ke subkoleksi assessments milik UID aktif. Dokumen pertama muncul setelah aplikasi berhasil menulis. Uji lewat Rules Playground atau Emulator Suite dengan data uji: A boleh membaca/menulis profil dan hasil A, B ditolak untuk kedua path A, pengguna tanpa sesi ditolak. Dari aplikasi, masuk kembali sebagai A dan buka riwayat tanpa analisis ulang. Catat bukti; melihat dokumen melalui konsol admin saja belum menguji izin aplikasi.

## 5. Pilih jalur Gemini

| APK akan dipakai untuk apa? | Pilih | Yang perlu kamu siapkan |
|---|---|---|
| Demo tertutup pada HP tim sesuai PRD REST | A · Gemini Developer API langsung | Key khusus proyek demo dan model yang tersedia |
| APK dibagikan ke peserta, juri atau publik | B · Firebase AI Logic | Konfigurasi AI Logic dan App Check di proyek Firebase |

### A · REST untuk demo tertutup

1. Buka [Google AI Studio → API Keys](https://aistudio.google.com/apikey). Masuk dengan akun proyek. Jika Project ID belum tampil, impor proyek Google Cloud yang sama di AI Studio. Buat key untuk proyek tersebut. Pilih model Flash yang mendukung keluaran JSON dan tersedia di akunmu. Salin **ID model** persis dari antarmuka ke konfigurasi agent. Periksa kuota dan status billing sebelum uji.
2. Agent membuat .env.example dengan dua baris kosong: `GEMINI_API_KEY=` dan `GEMINI_MODEL=`. Pastikan .env masuk .gitignore, lalu pemilik menyalin contoh menjadi .env di root Flutter dan mengisi nilainya lewat editor lokal. Di PowerShell gunakan `Copy-Item .env.example .env` saat .env belum ada. Cek `git check-ignore .env` dan `git ls-files -- .env`; yang pertama harus menyebut .env, yang kedua harus kosong.
3. Untuk build demo PRD, agent menambahkan http dan flutter_dotenv, mendaftarkan .env sebagai asset demo, dan menyiapkan izin INTERNET Android untuk build rilis. GeminiService mengirim POST ke endpoint generateContent model terpilih dengan header x-goog-api-key dan meminta JSON. Kirim jurusan, semester, minat dan nilai skill yang diperlukan. Email, sandi dan UID tidak diperlukan untuk analisis.
4. Uji satu profil sintetis dari tombol Analisis. Periksa tiga karier, alasan, nilai 0–100, dan empat minggu per karier. Periksa juga timeout, JSON rusak dan kuota habis. Catat status serta durasi tanpa mencatat header atau data pribadi.
5. Memasukkan .env sebagai asset membuat key ikut masuk APK meski Git mengabaikan filenya. Simpan build ini di perangkat tim. Jika APK atau key sudah tersebar, cabut key di AI Studio, buat pengganti bila perlu, dan tinjau penggunaan. Untuk membagikan APK, pilih jalur B dan buat build bersih tanpa asset .env. [Pengelolaan key Gemini](https://ai.google.dev/gemini-api/docs/api-key)

### B · Firebase AI Logic untuk APK yang dibagikan

1. Buka proyek yang sama di Firebase Console → **AI Logic → Get started**. Pilih **Gemini Developer API** dan selesaikan wizard. Firebase mengatur akses Gemini melalui proxy. Key Gemini yang dikelola wizard tidak perlu disalin ke Flutter. Cek paket, kuota dan biaya model yang dipilih sebelum menyetujui perubahan billing. [Mulai dengan Firebase AI Logic](https://firebase.google.com/docs/ai-logic/get-started?platform=flutter)
2. Agent menjalankan `flutter pub add firebase_ai firebase_app_check`, memastikan konfigurasi FlutterFire mutakhir, dan mengganti isi GeminiService dengan SDK Firebase AI Logic untuk provider Google AI. Gunakan ID model yang didukung, response MIME application/json, dan skema hasil PRD. UI dan validator memakai kontrak analyzeCareer yang sama. Hapus ketergantungan pada key langsung dan asset .env dari build distribusi.
3. Untuk emulator/debug gunakan App Check debug provider dan daftarkan debug token melalui konsol di perangkat sendiri. Untuk build rilis daftarkan aplikasi Android dengan Play Integrity, masukkan fingerprint SHA-256 sertifikat penandatangan APK yang akan diuji, dan gunakan provider rilis. Cocokkan pengaturan integritas dengan cara APK dipasang, khususnya bila dikirim langsung ke juri. Uji **APK yang benar-benar akan dibagikan** di HP sasaran. Periksa request valid di metrik App Check sebelum mengaktifkan enforcement untuk AI Logic, lalu uji sekali lagi. [App Check untuk Gemini](https://firebase.google.com/docs/ai-logic/app-check)
4. Catat di HASIL-KERJA bahwa jalur Firebase AI Logic dipilih menggantikan REST langsung pada PRD. Uji alur asli, batas kuota dan hasil contoh lokal secara terpisah. APK layak dibagikan setelah uji rilis dan pemeriksaan asset memastikan tidak ada key Gemini langsung maupun token debug.

## 6. Bila tersendat

| Gejala | Pemeriksaan pertama | Bukti untuk lanjut |
|---|---|---|
| Project ID tidak muncul | Periksa akun firebase login dan undangan proyek | ID terlihat di firebase projects:list |
| Auth operation-not-allowed | Periksa provider Email/Password pada proyek yang dipakai APK | Akun uji baru muncul di Authentication |
| Firestore permission-denied | Cocokkan UID aktif, path dan rules yang dipublikasikan | A boleh mengakses hasil A, B ditolak |
| Gemini 403 / 404 | Periksa proyek, API aktif, izin/key, ID model dan App Check sesuai jalur | Satu permintaan profil sintetis berhasil |
| Gemini 429 | Periksa kuota dan penggunaan. Tawarkan coba lagi atau contoh lokal; hindari retry berulang | UI dapat digunakan, status hasil contoh jelas |
| Tidak punya akses konsol | Agent catat aksi pemilik dan cara membuktikan keberhasilan. Kerjakan UI, fixture dan validasi lokal yang independen | Uji cloud tetap MENUNGGU sampai ada bukti |

**Pesan yang aman untuk dikirim ke agent:** “Project ID saya …, applicationId …, Auth Email/Password sudah aktif, Firestore rules sudah dipublikasikan. Saya pilih jalur A/B, ID model …, status setup … . Lanjutkan dari checkpoint.” Saat membagikan error, sertakan kode error, langkah yang gagal dan jenis build. Hapus key, token dan data pengguna dari kutipan.
