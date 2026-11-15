# CareerPath AI

Aplikasi Android untuk membantu mahasiswa menemukan arah karier lewat asesmen minat dan skill, lalu mendapatkan **3 rekomendasi karier** beserta **skill gap** dan **roadmap 30 hari** dari Gemini. Hasil disimpan agar bisa dibuka kembali tanpa memanggil AI lagi.

Tagline: *Temukan karier cocok & rencana belajar 30 hari.*

> Status: MVP hackathon. Hasil adalah **saran awal**, bukan keputusan karier final.

## Fitur

- **Welcome & navigasi awal** — Masuk/Daftar, Mulai asesmen, dan Jelajahi contoh hasil (offline).
- **Auth email & kata sandi (Firebase Auth)** — daftar, masuk, keluar, sesi bertahan, pesan error Bahasa Indonesia. Tanpa konfigurasi Firebase, aplikasi tetap berjalan dalam **mode lokal** (login opsional).
- **Profil** — nama, jurusan, semester (validasi semester 1–14), tersimpan lokal dan/atau `users/{uid}`.
- **Asesmen minat** — 8 pertanyaan pilihan ganda dengan progress bar; tombol lanjut aktif hanya jika lengkap.
- **Asesmen skill** — 6 slider nilai 1–5 dengan indikator terisi.
- **Ringkasan & persetujuan** — jawaban dapat ditinjau, ada persetujuan penggunaan data sebelum analisis; submit ganda dicegah.
- **Analisis Gemini (REST)** — meminta JSON valid: `summary` + tepat **3 karier dari 8 katalog**, `match_score` 0–100, alasan berbasis jawaban, `skills_owned`, `skills_missing`, dan roadmap 4 minggu. Respons divalidasi sebelum ditampilkan.
- **Hasil & detail** — 3 kartu karier, label *Contoh hasil (offline)* bila relevan, disclaimer, skill dimiliki/kurang, roadmap 4 minggu.
- **Career Journey** — pilih satu rekomendasi sebagai fokus, lanjutkan checklist roadmap 30 hari dari Beranda, lihat minggu aktif dan langkah berikutnya, lalu simpan progres secara lokal agar tetap ada setelah aplikasi dibuka ulang.
- **Riwayat** — hasil disimpan ke penyimpanan lokal dan Firestore (bila login) serta dapat dibuka tanpa panggilan Gemini baru.
- **Fallback & mode demo** — jika Gemini gagal/belum dikonfigurasi, tersedia hasil contoh berlabel jelas.
- **Ketahanan** — loading, pesan error dengan tombol coba lagi, state kosong, dan pemisahan error analisis vs error simpan.

## Kebutuhan

- Pemeriksaan kode dan tes terakhir memakai Flutter **3.29.3** / Dart **3.7.2** (proyek memakai `sdk: ^3.4.0`).
- Android SDK + perangkat/emulator Android untuk build APK.
- Konfigurasi Android untuk SDK Flutter tersebut: Gradle **8.10.2**, Android Gradle Plugin **8.7.0**, Kotlin **1.8.22**, Java **17**, dan NDK bawaan Flutter (**26.3.11579264**). Jangan menaikkan Gradle ke 9.x secara terpisah: plugin Flutter SDK ini masih memakai API Groovy lama.
- Plugin memberi peringatan kebutuhan NDK **27.0.12077973**. Build debug x64 berhasil dengan NDK bawaan; instalasi NDK 27 lokal belum lengkap (`source.properties` tidak ada). Lengkapi instalasinya melalui Android SDK Manager sebelum mengganti `ndkVersion`.
- (Opsional) Proyek Firebase dan API key Gemini untuk fitur cloud & AI.

## Menjalankan

```bash
flutter pub get
flutter run
```

## Konfigurasi `.env` (Gemini)

1. Salin contoh: `copy .env.example .env` (Windows) atau `cp .env.example .env`.
2. Isi dua variabel berikut dengan kredensial milik pemilik proyek:
   ```dotenv
   GEMINI_API_KEY=<api key dari Google AI Studio>
   # Boleh berisi beberapa model dipisah koma (rotasi saat 404/429):
   GEMINI_MODEL=gemini-3.1-flash-lite,gemini-3.8-flash,gemini-flash-latest
   ```
   Urutan daftar adalah urutan percobaan: model pertama dipakai lebih dulu; jika
   dicabut Google (HTTP 404) atau kuota harian habis (HTTP 429), `GeminiService`
   otomatis lanjut ke model berikutnya dan layar analisis menampilkan status
   perpindahannya. Kuota gratis Gemini hanya 20 request/hari/model, jadi rotasi
   melipatgandakan jatah harian tanpa mengganti kode.
3. **Jangan commit `.env`.** File ini sudah ada di `.gitignore`; hanya `.env.example` yang boleh masuk repo.
4. Jalankan ulang aplikasi. Tanpa key, tombol “Analisis dengan AI” menampilkan pesan konfigurasi dan pengguna dapat memakai “Gunakan contoh hasil (tanpa AI)”.

> Catatan rilis: `.env` ikut dibundel sebagai asset untuk demo tertutup. Untuk APK distribusi publik, pindahkan panggilan Gemini/OpenAI beserta API key ke backend; `.gitignore` tidak melindungi key yang sudah dibundel ke APK (lihat `PANDUAN-FIREBASE-GEMINI.md`).

## API key OpenAI sebagai cadangan Gemini

Isi di file **`.env` pada folder utama proyek**, sejajar `pubspec.yaml`:

```dotenv
OPENAI_API_KEY=<isi OpenAI API key Anda>
OPENAI_MODEL=gpt-4.1-mini
```

Gunakan API key dari platform OpenAI, bukan kata sandi/token sesi ChatGPT. Setelah menyimpan, lakukan **hot restart** atau jalankan ulang aplikasi agar `.env` dimuat ulang. Contoh kosong tersedia di `.env.example`.

Alur: Gemini (termasuk retry yang sudah ada) → jika gagal dan OpenAI dikonfigurasi, satu permintaan ke OpenAI Responses API → validasi hasil → simpan seperti biasa. Jika Gemini belum dikonfigurasi, OpenAI juga dapat menjadi cadangan. Tanpa key OpenAI, perilaku error Gemini tetap dipertahankan; jika kedua layanan gagal, tersedia tombol contoh offline. Batas waktu OpenAI adalah 90 detik per permintaan, sehingga fallback menambah waktu tunggu total.

Persetujuan asesmen menyebut kedua penyedia. OpenAI memakai Structured Outputs dan `store: false`; raw body error serta API key tidak dicetak. Hasil OpenAI adalah analisis AI, bukan hasil contoh. Pengujian otomatis memakai respons tiruan; akses model dan kuota akun perlu diuji setelah key diisi. Rujukan: [OpenAI quickstart](https://developers.openai.com/api/docs/quickstart) dan [Structured Outputs](https://developers.openai.com/api/docs/guides/structured-outputs).

## Konfigurasi Firebase (opsional untuk mode lokal)

Proyek referensi: `careerpath-e3adb`.

1. Aktifkan **Authentication → Email/Password** dan **Cloud Firestore** di Firebase Console.
2. Pasang CLI lalu hubungkan proyek:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure --project=careerpath-e3adb --platforms=android
   ```
3. `flutterfire configure` menghasilkan `lib/firebase_options.dart` dan `android/app/google-services.json`. **`google-services.json` tidak boleh di-commit** (sudah di `.gitignore`).
4. Pastikan `main.dart` menginisialisasi Firebase dengan opsi platform:
   ```dart
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   ```
5. Publikasikan **Firestore Rules** per-UID (contoh ada di `PANDUAN-FIREBASE-GEMINI.md`); jangan memakai mode test terbuka.
6. Data yang dipakai: profil di `users/{uid}` dan hasil di `users/{uid}/assessments/{assessmentId}` (`createdAt`, `input`, `result`, `isSample`).

Jika Firebase belum siap, aplikasi otomatis memakai penyimpanan lokal (`shared_preferences`) dan menampilkan keterangan “Mode lokal”.

## Build rilis

```bash
flutter build apk --release
```

APK rilis dihasilkan di `build/app/outputs/flutter-apk/app-release.apk`. Plugin Google Services saat ini dinonaktifkan di `android/app/build.gradle.kts`; aplikasi menginisialisasi Firebase memakai `DefaultFirebaseOptions.currentPlatform` dari `lib/firebase_options.dart`.

> Build rilis belum diverifikasi ulang setelah bug fixing. Nama aplikasi/`applicationId` masih default (`flutter_application_1` / `com.example.flutter_application_1`), dan signing rilis masih menggunakan debug key. Inisialisasi Firebase di `main.dart` sudah dipulihkan. Lihat hasil terbaru di [`HASIL-KERJA.md`](HASIL-KERJA.md#bug-fixing-habib--2026-11-14).

## Uji

```bash
flutter analyze
flutter test
dart run tool/qa_live_gemini.dart   # butuh .env + akses ke endpoint Gemini
dart run tool/qa_live_openai.dart    # uji live cadangan OpenAI (butuh kredit akun)
```

> Jika `flutter test` menggantung saat mengambil dependensi (jaringan pub.dev lambat), jalankan `flutter test --concurrency=1 --no-pub` setelah `flutter pub get` pernah berhasil. Pemeriksaan terbaru menghasilkan 115/115 tes lulus.

> **Timeout Gemini:** aplikasi menunggu maksimal 90 detik per permintaan. HTTP 503 memicu satu retry setelah jeda 2 detik untuk seluruh analisis; timeout dan HTTP 429 tidak diulang otomatis. Uji live terbaru pada `gemini-flash-latest` menerima HTTP 503 setelah 49,4 detik (model sedang menerima permintaan tinggi). Retry tidak menjamin layanan sudah pulih; contoh offline tetap tersedia.

> **Diagnosa uji AI live (2026-11-14):** endpoint Gemini kini **terjangkau** (discovery HTTP 200), tetapi panggilan `generateContent` berakhir **HTTP 429 — kuota/limit API key habis**, didahului 503/timeout. Ganti key atau tambah kuota pemilik, lalu jalankan ulang alat QA. Alat otomatis berhenti setelah 429 agar tidak menunggu lama; 503 berarti layanan Gemini sedang sibuk (coba lagi nanti).

> **Rotasi model (2026-11-14):** `GEMINI_MODEL` kini menerima daftar model dipisah koma. Model lama `gemini-2.5-flash` sudah dicabut Google (404) dan model utama kehabisan kuota harian free tier (429, 20 request/hari/model), sehingga analisis langsung gagal. `GeminiService` mencoba daftar model berurutan saat 404/429 (callback `onModelSwitch` mengabarkan ke layar); error lain (401, timeout, 503) tidak dirotasi. QA live terbaru: **5/5 skenario LULUS** pada `gemini-3.1-flash-lite` dengan `responseSchema` aktif (latensi 2,5–30,5 detik).

Artefak QA (dimiliki peran D):

| File | Isi |
| --- | --- |
| `test/widget_test.dart` | Aplikasi terbuka ke layar welcome dan menampilkan tombol contoh offline |
| `test/qa_validators_test.dart` | Katalog 8/8/6, kontrak JSON hasil AI, penolakan respons tidak valid |
| `test/qa_local_store_provider_test.dart` | Simpan/muat profil & riwayat lokal, reset asesmen, skenario batas skill 1/5 |
| `test/qa_flow_test.dart` | Alur end-to-end lokal: profil → 8 minat → 6 skill → persetujuan → hasil contoh → detail → riwayat → ulangi |
| `tool/qa_live_gemini.dart` | Menjalankan 5 skenario AI live terhadap Gemini; mencetak skor/karier/durasi tanpa key atau respons mentah. Opsi: `--only=1..5`, `--timeout=90`, `--model=<nama>`; memahami daftar `GEMINI_MODEL` dan berpindah model otomatis saat 404/429; berhenti dengan pesan jelas saat kuota semua model habis (429) atau layanan sibuk (503) |

### Status QA terbaru (2026-11-14)

| Pemeriksaan | Hasil |
| --- | --- |
| `flutter analyze --no-pub` | **LULUS: No issues found** |
| `flutter test --concurrency=1 --no-pub` | **LULUS 115/115**, termasuk Career Journey, isolasi akun, rollback penyimpanan, alur lokal, regresi timeout/retry Gemini, dan rotasi model |
| 5 skenario AI live | **LULUS 5/5** pada `gemini-3.1-flash-lite` (2026-11-14, rotasi aktif, `responseSchema` diterima); latensi 2,5–30,5 detik |
| Build APK rilis | **BELUM DIUJI ULANG** setelah bug fixing; status lama tidak mewakili konfigurasi saat ini |
| Build APK debug emulator x64 | **LULUS** setelah menyelaraskan versi toolchain Android; APK: `build/app/outputs/flutter-apk/app-debug.apk` |
| Uji HP (login, offline, layar kecil, tekan ganda) | **BELUM**: menunggu perangkat & akses Firebase |
| Keamanan repo | LULUS: `.env` ignored & tidak pernah ter-commit, nilai key tidak ada di file tracked, izin `INTERNET` ada |

Hasil uji terbaru, bug log + PIC, dan sisa pekerjaan dicatat di [`HASIL-KERJA.md`](HASIL-KERJA.md#l-08).

## Struktur proyek

```text
lib/
  data/       katalog 8 karier, 8 pertanyaan minat, 6 skill, hasil contoh
  models/     CareerResult, UserProfile, AssessmentRecord, CareerJourney
  providers/  AssessmentProvider (asesmen), JourneyProvider (roadmap aktif)
  screens/    welcome, auth, profile, interest, skill, summary, analyzing, result, detail, home
  services/   gemini_service (rotasi model), openai_service, career_analysis_service (fallback), app_backend (Firebase/lokal), local_store
  utils/      tema, konstanta copy, validators
  widgets/    progress_header, career_card
test/         uji widget, validator, penyimpanan, dan alur QA
tool/         alat QA manual (5 skenario AI live: qa_live_gemini.dart)
```

## Tim

| Peran | Nama | Fokus |
| --- | --- | --- |
| A | Aldi | UI/UX, layar & navigasi |
| B | Lutfi | Firebase, auth, data & penyimpanan |
| C | Faji | Gemini, prompt, validasi & fallback |
| D | Sabrina | QA, dokumentasi, pitch & rilis |
| E | Habib | Bug fixing, stabilitas alur/data, dan tes regresi |

## Dokumen

- [`CareerPath AI - Hackathon 1 Brainstorming.md`](CareerPath%20AI%20-%20Hackathon%201%20Brainstorming.md)
- [`CareerPath AI - Hackathon 2 PRD.md`](CareerPath%20AI%20-%20Hackathon%202%20PRD.md)
- [`CareerPath AI - Hackathon 3 To-Do dan Laporan Progres.md`](CareerPath%20AI%20-%20Hackathon%203%20To-Do%20dan%20Laporan%20Progres.md)
- [`PANDUAN-FIREBASE-GEMINI.md`](PANDUAN-FIREBASE-GEMINI.md)
- [`HASIL-KERJA.md`](HASIL-KERJA.md) — log progres & QA
- [`PITCH-DEMO.md`](PITCH-DEMO.md) — slide, naskah 3 menit, rencana cadangan

## Tangkapan layar

Belum tersedia di repo. Tambahkan hasil tangkapan layar demo ke `docs/screenshots/` sebelum pengumpulan (welcome, hasil 3 kartu, detail roadmap) agar README dan slide memakai bukti asli.
