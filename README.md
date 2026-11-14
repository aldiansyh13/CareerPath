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
- **Riwayat** — hasil disimpan ke penyimpanan lokal dan Firestore (bila login) serta dapat dibuka tanpa panggilan Gemini baru.
- **Fallback & mode demo** — jika Gemini gagal/belum dikonfigurasi, tersedia hasil contoh berlabel jelas.
- **Ketahanan** — loading, pesan error dengan tombol coba lagi, state kosong, dan pemisahan error analisis vs error simpan.

## Kebutuhan

- Flutter **3.50+** / Dart **3.14+** (proyek memakai `sdk: ^3.4.0`).
- Android SDK + perangkat/emulator Android untuk build APK.
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
   GEMINI_MODEL=<model Flash yang mendukung JSON, mis. gemini-2.0-flash>
   ```
3. **Jangan commit `.env`.** File ini sudah ada di `.gitignore`; hanya `.env.example` yang boleh masuk repo.
4. Jalankan ulang aplikasi. Tanpa key, tombol “Analisis dengan AI” menampilkan pesan konfigurasi dan pengguna dapat memakai “Gunakan contoh hasil (tanpa AI)”.

> Catatan rilis: `.env` ikut dibundel sebagai asset agar demo tertutup berjalan. Untuk APK distribusi publik, pindahkan panggilan Gemini ke backend atau Firebase AI Logic + App Check agar key tidak dapat diekstrak dari APK (lihat `PANDUAN-FIREBASE-GEMINI.md`).

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

APK dihasilkan di `build/app/outputs/flutter-apk/app-release.apk`. Untuk build saat ini, `google-services.json` **wajib** ada karena plugin Google Services aktif.

> **Status build (2026-11-14): TERHAMBAT.** `flutter build apk --release` gagal dengan `File google-services.json is missing`. Jalankan `flutterfire configure --project=careerpath-e3adb --platforms=android` di mesin build (file hasilnya tidak di-commit), lalu ulangi build. Setelah itu masih ada pekerjaan rilis: `lib/main.dart` harus memakai `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` dan nama aplikasi/`applicationId` masih default (`flutter_application_1` / `com.example.flutter_application_1`). Detail: [`HASIL-KERJA.md`](HASIL-KERJA.md#l-10).

## Uji

```bash
flutter analyze
flutter test
dart run tool/qa_live_gemini.dart   # butuh .env + akses ke endpoint Gemini
```

> Jika `flutter test` menggantung saat mengambil dependensi (jaringan pub.dev lambat), jalankan `flutter test --no-pub` setelah `flutter pub get` pernah berhasil. Di lingkungan QA, perintah inilah yang menghasilkan 27/27 lulus.

Artefak QA (dimiliki peran D):

| File | Isi |
| --- | --- |
| `test/widget_test.dart` | Aplikasi terbuka ke layar welcome dan menampilkan tombol contoh offline |
| `test/qa_validators_test.dart` | Katalog 8/8/6, kontrak JSON hasil AI, penolakan respons tidak valid |
| `test/qa_local_store_provider_test.dart` | Simpan/muat profil & riwayat lokal, reset asesmen, skenario batas skill 1/5 |
| `test/qa_flow_test.dart` | Alur end-to-end lokal: profil → 8 minat → 6 skill → persetujuan → hasil contoh → detail → riwayat → ulangi |
| `tool/qa_live_gemini.dart` | Menjalankan 5 skenario AI live terhadap Gemini; mencetak skor/karier/durasi tanpa key atau respons mentah. Opsi: `--only=1..5`, `--timeout=90` |

### Status QA terbaru (2026-11-14)

| Pemeriksaan | Hasil |
| --- | --- |
| `flutter analyze` | LULUS: 0 error, 0 warning; 23 info (deprecation `material.dart` + `avoid_print` hanya di `tool/`) |
| `flutter test` | **LULUS 27/27** (widget, validator, local store/provider, alur lokal) |
| 5 skenario AI live | **BELUM**: endpoint Gemini tidak terjangkau dari lingkungan QA (timeout); harus diulang dari jaringan/HP pemilik |
| Build APK rilis | **GAGAL**: `google-services.json` tidak ada; APK belum dihasilkan |
| Uji HP (login, offline, layar kecil, tekan ganda) | **BELUM**: menunggu perangkat & akses Firebase |
| Keamanan repo | LULUS: `.env` ignored & tidak pernah ter-commit, tidak ada key Gemini di repo, izin `INTERNET` ada |

Hasil uji terbaru, bug log + PIC, dan sisa pekerjaan dicatat di [`HASIL-KERJA.md`](HASIL-KERJA.md#l-08).

## Struktur proyek

```text
lib/
  data/       katalog 8 karier, 8 pertanyaan minat, 6 skill, hasil contoh
  models/     CareerResult, UserProfile, AssessmentRecord
  providers/  AssessmentProvider (state asesmen)
  screens/    welcome, auth, profile, interest, skill, summary, analyzing, result, detail, home
  services/   gemini_service, app_backend (Firebase/lokal), local_store
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

## Dokumen

- [`CareerPath AI - Hackathon 1 Brainstorming.md`](CareerPath%20AI%20-%20Hackathon%201%20Brainstorming.md)
- [`CareerPath AI - Hackathon 2 PRD.md`](CareerPath%20AI%20-%20Hackathon%202%20PRD.md)
- [`CareerPath AI - Hackathon 3 To-Do dan Laporan Progres.md`](CareerPath%20AI%20-%20Hackathon%203%20To-Do%20dan%20Laporan%20Progres.md)
- [`PANDUAN-FIREBASE-GEMINI.md`](PANDUAN-FIREBASE-GEMINI.md)
- [`HASIL-KERJA.md`](HASIL-KERJA.md) — log progres & QA
- [`PITCH-DEMO.md`](PITCH-DEMO.md) — slide, naskah 3 menit, rencana cadangan

## Tangkapan layar

Belum tersedia di repo. Tambahkan hasil tangkapan layar demo ke `docs/screenshots/` sebelum pengumpulan (welcome, hasil 3 kartu, detail roadmap) agar README dan slide memakai bukti asli.
