# Hasil kerja CareerPath AI

Satu log untuk seluruh sesi. Saat memulai, isi posisi terakhir dari keadaan repo aktual. Template kosong ini belum menyatakan fitur apa pun selesai.

## Posisi terakhir

| Yang perlu diketahui agent berikut | Isi saat checkpoint |
|---|---|
| Waktu dan penanggung jawab | 2026-11-14, Sabrina (agent, peran D: QA/dokumentasi/pitch/rilis), branch `sabrina` |
| Blok, ID laporan, tugas aktif | **L-08 (QA & stabilisasi) SELESAI untuk bagian yang bisa diuji lokal; uji AI live dicoba ulang dan TERHAMBAT oleh kuota key. L-10 (build rilis) TERHAMBAT.** Artefak D: 27 uji otomatis, bug log, audit keamanan repo, README, `PITCH-DEMO.md`, alat uji AI live. Uji cloud/HP, build rilis, dan 5 skenario AI live menunggu tindakan pemilik (lihat hambatan). |
| Kondisi kode dan uji terakhir | `flutter analyze --no-pub` → **0 error, 0 warning**, 25 info (16 `deprecated_member_use` `material.dart` + 9 `avoid_print` di `tool/`). `flutter test --no-pub` → **27/27 LULUS** (widget, validator/kontrak JSON, local store/provider, alur end-to-end lokal). `dart run tool/qa_live_gemini.dart --timeout=90` → **0/5**: skenario 1–2 HTTP 503, skenario 3–5 timeout 90 dtk. Probe langsung `generateContent` → **HTTP 429 kuota habis**. Domain Gemini kini **terjangkau** (discovery endpoint HTTP 200), jadi hambatan jaringan sebelumnya sudah hilang; sisa hambatan adalah kuota/limit key. `flutter build apk --release` tetap **GAGAL**: `google-services.json` tidak ada. |
| Pilihan integrasi Gemini | Tetap **Jalur A (REST Gemini Developer API)**: `lib/services/gemini_service.dart` membaca `.env`, `responseMimeType: application/json`, timeout 40 dtk, validasi 3 karier dari 8 katalog/4 minggu/skor. Tidak ada perubahan transport oleh peran D. Jalur B (Firebase AI Logic + App Check) tetap rencana untuk APK distribusi. |
| Hambatan / tindakan pemilik | (1) **Faji/pemilik:** ganti/isi ulang kuota `GEMINI_API_KEY` (HTTP 429 “exceeded your current quota”) lalu jalankan `dart run tool/qa_live_gemini.dart` dari jaringan yang bisa mengakses Gemini; pertimbangkan model Flash yang tersedia untuk key tersebut. (2) **Lutfi/pemilik:** sediakan `android/app/google-services.json` (`flutterfire configure --project=careerpath-e3adb --platforms=android`) dan ubah `lib/main.dart` agar memakai `DefaultFirebaseOptions.currentPlatform`; file `lib/firebase_options.dart` sudah ada tetapi belum diimpor. (3) **Lutfi:** simpan & publish `firestore.rules` per-UID, uji akun A vs B. (4) **Aldi:** cegah submit ganda “Analisis dengan AI”, rapikan nama aplikasi. |
| Tindakan berikut | Isi kuota/key Gemini → jalankan 5 skenario AI live → perbaiki bug Fatal di bug log → ulangi `flutter build apk --release` → pasang di ≥2 HP → jalankan checklist QA §3 To-Do pada APK rilis → isi L-10 dan angka final di `PITCH-DEMO.md`. |
| Bukti selesai untuk tindakan berikut | 5/5 skenario AI live LULUS (tanpa 429/503/timeout); `app-release.apk` ada; akun uji muncul di Auth; dokumen `users/{uid}/assessments` muncul di Firestore; tidak ada overflow/error offline; video demo & slide tersimpan; semua bukti dicatat di L-10. |
| Waktu dan penanggung jawab | 2026-11-14, Faji (agent, peran C: AI) |
| Blok, ID laporan, tugas aktif | L-05/L-08 SELESAI (parsial): jalur Gemini diperkuat (prompt + `responseSchema` dengan batas array + fallback tanpa schema, retry sekali saat kontrak JSON dilanggar, parsing/validasi aman, error Bahasa Indonesia, timeout, cegah panggilan ganda), fallback contoh tetap tersedia. 26 uji unit LULUS. Live: `gemini-3.6-flash` berhasil 11 panggilan nyata (3+8), lalu 1 kegagalan kontrak roadmap setelah retry dan kuota 429; 10 panggilan berturut-turut & 5 skenario QA UI belum terbukti. |
| Kondisi kode dan uji terakhir | `flutter pub get` LULUS. `flutter analyze --no-pub` → 15 info `deprecated_member_use` yang sudah ada sebelumnya (import `material.dart`; bukan error kode). `flutter test test/validators_test.dart test/gemini_service_test.dart --concurrency=1 --no-pub` → LULUS 26/26. `flutter test --concurrency=1` → 26 test AI LULUS + 1 GAGAL pada `test/widget_test.dart` (pumpAndSettle timeout; test lama, di luar scope AI, belum diperbaiki). Build/run perangkat BELUM DIUJI. |
| Pilihan integrasi Gemini | Jalur A (REST Gemini Developer API) diimplementasi: `lib/services/gemini_service.dart` membaca `.env` (`GEMINI_API_KEY`, `GEMINI_MODEL`), POST `generateContent`, `responseMimeType: application/json` + `responseSchema` (batas 3 karier/4 minggu/minimal 2 skills & aksi, fallback tanpa schema bila API menolak), retry sekali dengan instruksi perbaikan bila hasil melanggar kontrak, validasi 3 karier dari katalog/4 minggu/skor. Model live yang terbukti: `gemini-3.6-flash`. `.env` placeholder lokal (gitignored), `.env.example` ada. Jalur B (Firebase AI Logic + App Check) BELUM, dicatat untuk APK distribusi. |
| Hambatan / tindakan pemilik | Firebase Project + `flutterfire configure --project=<ID> --platforms=android` untuk menghasilkan `firebase_options.dart` & aktifkan Auth/Firestore+Rules masih menunggu. API key/model Gemini sudah tersedia dan live call terbukti, tetapi kuota/rate limit sempat 429 dan jaringan IPv6 lingkungan labil; 1 dari 12 panggilan live melanggar kontrak roadmap setelah retry. Perlu uji UI di emulator/HP (`flutter run`) dan ulang 10 panggilan saat kuota/jaringan stabil. |
| Tindakan berikut | Jalankan alur asesmen nyata di emulator/HP (L-05), ulangi 10 panggilan berturut-turut setelah kuota pulih untuk memverifikasi schema yang baru diperketat, lalu 5 skenario QA AI (L-08). Catat latensi; target <15 detik belum selalu tercapai (live 14-20 detik). Perbaikan `test/widget_test.dart` yang gagal adalah tugas Aldi/Lutfi (UI/Firebase), bukan scope AI. |
| Bukti selesai untuk tindakan berikut | `flutter analyze` tanpa error, 26 uji unit AI LULUS, 11 panggilan Gemini nyata mengembalikan 3 karier dari katalog + roadmap 4 minggu, fallback contoh berlabel, riwayat terbuka tanpa panggil Gemini ulang; bukti dicatat di HASIL-KERJA. |
| Waktu dan penanggung jawab | 2026-11-14, Aldi (Orang 1 — UI/UX, Layar & Navigasi) via agent; checkpoint sebelumnya: Iceman (agent) |
| Blok, ID laporan, tugas aktif | L-02 SELESAI (3 sesi: uji otomatis + toolchain build). Build Android **LULUS** & APK terinstall di HP 22101320G (Redmi, Android 13). Tindakan berikut: uji manual alur di HP (app sudah terpasang), lalu lanjut butir Orang 1 tersisa (ikon/splash, konsistensi copy). |
| Kondisi kode dan uji terakhir | `flutter analyze` → LULUS (0 issues). `flutter test` → LULUS (**11 test**). `flutter build apk --debug` → LULUS (193 MB, 14/11 18:45) + `flutter install --debug` ke HP → LULUS. **Firebase OFF sementara** (google-services dinonaktifkan di `app/build.gradle.kts` karena `google-services.json` belum ada — lihat sesi toolchain). Uji alur manual di HP: BELUM DIUJI. |
| Pilihan integrasi Gemini | Jalur A (REST Gemini Developer API) diimplementasi: `lib/services/gemini_service.dart` membaca `.env` (`GEMINI_API_KEY`, `GEMINI_MODEL`), POST `generateContent`, `responseMimeType: application/json`, validasi 3 karier dari katalog/4 minggu/skor. `.env` placeholder dibuat lokal (gitignored), `.env.example` ditambahkan. Jalur B (Firebase AI Logic + App Check) BELUM, dicatat untuk APK distribusi. |
| Hambatan / tindakan pemilik | Butuh akun/konsol: (1) Firebase Project + `flutterfire configure --project=<ID> --platforms=android` untuk menghasilkan `firebase_options.dart` & aktifkan Auth/Firestore+Rules, (2) AI Studio: buat API key proyek & pilih model Flash JSON, isi `.env`, (3) uji di emulator/HP (`flutter run`). Tanpa ini app berjalan mode lokal + contoh hasil; analisis AI & sinkron cloud tidak aktif. |
| Tindakan berikut | **HP**: buka aplikasi "CareerPath AI" yang sudah terpasang → uji alur welcome→minat→skill→ringkasan→hasil contoh, catat hasil di HASIL-KERJA. **Orang 2/pemilik**: `flutterfire configure` (hasilkan `firebase_options.dart` + `google-services.json`), serahkan file ke repo, lalu aktifkan kembali `id("com.google.gms.google-services")` di `android/app/build.gradle.kts` dan ganti init `Firebase.initializeApp()` ke `DefaultFirebaseOptions.currentPlatform`. Orang 1 lanjut: ikon/splash, konsistensi copy. |
| Bukti selesai untuk tindakan berikut | Ada `firebase_options.dart`, akun uji muncul di Auth, dokumen `users/{uid}/assessments` muncul di Firestore, analisis AI mengembalikan JSON valid & tampil, riwayat terbuka tanpa panggil Gemini ulang; bukti dicatat di HASIL-KERJA. |

## Catatan pekerjaan

Tambahkan entri di bawah judul ID terkait. Buat judul stabil seperti `## L-02` saat pertama dipakai. Tautan dari indeks To-Do ke judul itu berbentuk `[L-02](HASIL-KERJA.md#l-02)` bila kedua file satu folder. Boleh ada beberapa tugas dan sesi di bawah ID yang sama. Perbarui posisi terakhir di atas setiap kali pekerjaan berpindah.

## L-01

- Waktu, nama/peran, branch/commit bila tersedia: 2026-11-14, Iceman (agent), repo non-git
- Tugas, tujuan dan kriteria selesai: Inventaris repo & dokumen (.md), tentukan kebutuhan Gemini/Firebase, siapkan fondasi proyek sesuai PRD/To-Do (struktur, data 8 karier/8 pertanyaan/6 skill, konfigurasi dasar). Selesai bila struktur & data tersedia, keputusan integrasi & kebutuhan cloud tercatat.
- Status: SELESAI (parsial: artefak lokal siap; setup akun/cloud MENUNGGU pemilik)
- Perubahan nyata dan path file:
  - Data: `lib/data/careers.dart` (8 karier), `questions.dart` (8 pertanyaan), `skills.dart` (6 skill), `sample_result.dart` (contoh input+hasil & roadmap 4 minggu)
  - Model: `lib/models/career_result.dart`, `user_profile.dart`
  - Service/util: `lib/services/gemini_service.dart`, `local_store.dart`, `app_backend.dart`; `lib/utils/{constants,validators,app_theme}.dart`
  - State: `lib/providers/assessment_provider.dart`
  - UI: `lib/screens/{welcome,auth,profile,home,interest,skill,summary,analyzing,result,career_detail}_screen.dart`, `lib/widgets/{progress_header,career_card}.dart`, `lib/main.dart`
  - Konfig: `pubspec.yaml` (deps provider/http/flutter_dotenv/shared_preferences/firebase_*; asset .env & .env.example), `.env.example`, `.env` (placeholder lokal), `.gitignore` (ignore .env & kredensial Firebase), `android/app/src/main/AndroidManifest.xml` (+INTERNET), `test/widget_test.dart`
- Package, konfigurasi nonrahasia atau keputusan: Jalur Gemini A (REST) dipilih untuk demo tertutup; env `GEMINI_API_KEY`, `GEMINI_MODEL`. Firebase di-init best-effort (fallback lokal bila belum dikonfigurasi). Riwayat lokal via `shared_preferences`, cloud via Firestore bila user login & Firebase siap. Katalog karier tetap 8 item (validasi respons AI).
- Uji oleh agent — perintah, hasil aktual (LULUS / GAGAL / BELUM DIUJI):
  - `flutter pub get` → LULUS (dependensi terpasang)
  - `flutter analyze` → 15 info `deprecated_member_use` (lint env menyarankan `material_ui`; tidak ada error/warning kode) → dapat dikompilasi secara statis; perlu konfirmasi build aktual
  - `flutter test` → BELUM DIUJI
  - `flutter run/build apk` → BELUM DIUJI (butuh device/SDK setup pemilik)
- Uji manual oleh manusia — langkah, perangkat dan hasil, atau MENUNGGU: MENUNGGU (HP/emulator, akun Firebase/Gemini, verifikasi alur login→asesmen→AI→simpan→riwayat)
- Kendala, tindakan perbaikan dan yang tersisa: Tidak ada kredensial/akses konsol cloud; `firebase_options.dart` belum ada (butuh `flutterfire configure`). `RadioGroup` API digunakan (Flutter baru); jika SDK target lebih lama perlu fallback.
- Gerbang blok dan butir To-Do yang diperbarui: Fondasi Blok A/B (struktur, data, UI statis+alur, service kerangka) terbuat, namun butir To-Do tidak dicentang karena bukti uji manual/cloud belum ada. L-02/L-03 s.d. L-07 menunggu verifikasi & setup.
- Tindakan berikut, lokasi mulai dan tanda berhasil: Lakukan setup sesuai `PANDUAN-FIREBASE-GEMINI.md`; uji `flutter run` lalu skenario 5 QA & simpan bukti ke HASIL-KERJA; mulai dari `lib/main.dart` (aktifkan options) dan konsol Firebase/AI Studio.

## L-08

- Waktu, nama/peran, branch/commit bila tersedia: 2026-11-14, Sabrina (agent, peran D), branch `sabrina`
- Tugas, tujuan dan kriteria selesai: QA & stabilisasi (To-Do Blok D). Jalankan uji otomatis, 5 skenario AI, audit keamanan/repo, catat bug + PIC, dan dokumentasikan. Selesai bila bukti uji nyata tercatat, bug triase, dan sisa pekerjaan cloud/HP jelas.
- Status: **SELESAI (parsial)** — bagian lokal/otomatis selesai; uji cloud, AI live, dan perangkat **TERHAMBAT** oleh akses/jaringan.
- Perubahan nyata dan path file:
  - `test/widget_test.dart` — boot ke welcome + tombol contoh offline (mock `SharedPreferences`).
  - `test/qa_validators_test.dart` — katalog 8/8/6, validasi kontrak JSON, penolakan respons invalid (jumlah karier, katalog, duplikat, skor, roadmap, summary/aksi kosong).
  - `test/qa_local_store_provider_test.dart` — simpan/muat profil & riwayat lokal, urutan terbaru, clear saat logout, state provider, skenario semua skill 1 dan 5.
  - `test/qa_flow_test.dart` — alur end-to-end lokal: profil → 8 minat → 6 skill → persetujuan → hasil contoh 3 kartu → detail (skill + roadmap 4 minggu) → riwayat tanpa Gemini → ulangi asesmen.
  - `tool/qa_live_gemini.dart` — alat QA 5 skenario AI live; memperbaiki bug `_argValue` (sebelumnya `undefined_function`), opsi `--only`/`--timeout` kini berfungsi, ringkasan menghitung skenario yang benar-benar dijalankan.
  - `HASIL-KERJA.md` — laporan ini + bug log + audit keamanan.
- Package, konfigurasi nonrahasia atau keputusan: Tidak menambah package. Uji memakai `flutter_test` + mock `shared_preferences`. Alat live membaca `.env` lokal (gitignored) dan **tidak pernah mencetak key/isi respons mentah**.
- Uji oleh agent — perintah, hasil aktual (LULUS / GAGAL / BELUM DIUJI):
  - `flutter analyze` → **LULUS** (0 error, 0 warning; 23 info: 16 `deprecated_member_use`, 7 `avoid_print` hanya di `tool/`). Sebelum perbaikan alat: 2 error `undefined_function` di `tool/qa_live_gemini.dart`.
  - `flutter test --no-pub` → **LULUS 27/27** (4 file uji; termasuk 4 uji alur end-to-end + 23 uji unit/widget lain). Catatan: `flutter test` tanpa `--no-pub` sempat menggantung pada pengambilan dependensi di lingkungan ini; `--no-pub` dipakai karena `pub get` sudah berhasil sebelumnya.
  - `dart run tool/qa_live_gemini.dart --timeout=90` → **GAGAL 0/5**, semuanya `TimeoutException` 90 dtk. Diagnosis lingkungan: `https://generativelanguage.googleapis.com` tidak terjangkau (curl IPv4/IPv6 timeout 25–30 dtk) sedangkan `https://example.com` HTTP 200. **Bukan bukti kode AI gagal**; uji live harus diulang dari jaringan/HP pemilik.
  - `flutter build apk --release` → **GAGAL**. Penyebab utama: `File google-services.json is missing` pada `:app:processReleaseGoogleServices`; penyebab kedua: `Could not close incremental caches ... shared_preferences_android` (cache Kotlin lokal). Detail di L-10.
- Uji manual oleh manusia — langkah, perangkat dan hasil, atau MENUNGGU:
  - **MENUNGGU** HP/emulator: 5 skenario AI live, login/daftar/sesi, aturan Firestore dua akun, offline/error, tekan analisis dua kali, lifecycle, layar 5 inci, APK rilis di ≥2 HP.
  - Sudah bisa diuji tanpa cloud: alur lokal (profil → hasil contoh → detail → riwayat → ulangi) tercakup uji widget.
- Kendala, tindakan perbaikan dan yang tersisa:
  - Endpoint Gemini diblokir/timeout dari lingkungan ini → tidak bisa mengklaim kualitas AI live; alat & data skenario sudah siap.
  - Build rilis butuh `google-services.json` (tidak boleh di-commit) dan init Firebase yang benar.
  - Belum ada file `firestore.rules` di repo dan belum ada bukti rules dipublish/diuji.
  - Bug kode yang ditemukan dicatat di tabel bug di bawah; peran D **tidak mengubah** kode fitur milik A/B/C agar tidak menabrak tugas lain.
- Gerbang blok dan butir To-Do yang diperbarui: Gerbang D **BELUM** (5 skenario AI/HP belum). Butir To-Do yang dicentang hanya yang terbukti: hasil 3 kartu, detail roadmap, riwayat lokal, ulangi asesmen (3.3); `.env` ignored/tidak tracked, tidak ada key Gemini di repo, izin INTERNET, README setup (3.6); hapus `print` + analyze (E); izin INTERNET untuk rilis (F). Indeks §4.4 diisi untuk L-08.
- Tindakan berikut, lokasi mulai dan tanda berhasil: Mulai dari bug Fatal #1–#2 (build & init Firebase). Setelah `google-services.json` ada dan `main.dart` memakai `DefaultFirebaseOptions.currentPlatform`, ulangi `flutter analyze`, `flutter test`, `flutter build apk --release`, lalu QA HP. Tanda berhasil: APK rilis terpasang, login cloud & riwayat tersimpan, 5 skenario AI live lulus, bug log diperbarui.

#### Sesi lanjutan 2026-11-14 — uji AI live setelah jaringan pulih

- **Tujuan:** mengulang 5 skenario AI live yang sebelumnya terblokir jaringan, tanpa mengubah kode fitur A/B/C.
- **Uji oleh agent:**
  - Probe `https://generativelanguage.googleapis.com/$discovery/rest?version=v1beta` → **HTTP 200**. Hambatan jaringan lama **sudah hilang**; domain Gemini kini terjangkau dari lingkungan QA.
  - `dart run tool/qa_live_gemini.dart --timeout=90` (model `gemini-flash-latest`, 5 skenario) → **GAGAL 0/5, total 330 dtk**: skenario 1 HTTP **503** (24,9 dtk), skenario 2 HTTP **503** (35,4 dtk), skenario 3–5 `TimeoutException` 90 dtk.
  - Probe `generateContent` minimal (prompt “Balas hanya: OK”) → percobaan pertama timeout 45 dtk; percobaan kedua **HTTP 429** `You exceeded your current quota, please check your plan and billing details` (0,9 dtk).
  - `dart run tool/qa_live_gemini.dart --only=1 --timeout=20` setelah alat diperbaiki → **HTTP 429 `RESOURCE_EXHAUSTED`** dalam 632 ms; alat mencetak pesan kuota yang jelas dan menghentikan sisa skenario (terbukti berfungsi).
  - `flutter analyze --no-pub` → **0 error, 0 warning, 25 info** (2 info `avoid_print` baru dari pesan diagnosa 429/503 di alat QA). `flutter test --no-pub` → **27/27 LULUS**.
- **Kesimpulan:** kegagalan live **bukan** bukti kode/validasi AI salah. Endpoint & kredensial terbaca, tetapi **kuota/limit API key habis** (429); 503/timeout adalah gejala layanan sibuk/kuota. Uji live harus diulang setelah pemilik mengganti key atau menambah kuota, idealnya dengan model Flash yang tersedia untuk key tersebut.
- **Perbaikan alat QA (milik peran D):** `tool/qa_live_gemini.dart` kini menampilkan `status: message` singkat dari error API (maks. 180 karakter, tanpa respons mentah/key), memberi petunjuk khusus untuk **429 (kuota habis)** dan **503 (layanan sibuk)**, serta **menghentikan sisa skenario** saat 429 agar tidak menunggu lama. Exit code tetap 1 bila ada kegagalan.
- **Tidak diubah:** `lib/**` (fitur A/B/C), `android/**`, `firestore.rules` (belum ada), dan `.env` (hanya dibaca; key tidak pernah dicetak).

### Bug log (triase peran D)

| No | Deskripsi singkat | Langkah mengulang | Tingkat | PIC | Status |
|---|---|---|---|---|---|
| 1 | Build rilis gagal: `google-services.json` tidak ditemukan | `flutter build apk --release` | **Fatal** (rilis) | Lutfi/pemilik | TERBUKA |
| 2 | Firebase tidak diinisialisasi dengan opsi proyek: `lib/main.dart` masih `Firebase.initializeApp()` tanpa `DefaultFirebaseOptions`, padahal `lib/firebase_options.dart` ada | Buka `lib/main.dart:24-30`; jalankan app → login hanya mode lokal / Auth tidak aktif | **Fatal** (fitur cloud) | Lutfi | TERBUKA |
| 3 | “Analisis dengan AI” bisa dikirim ganda: `SummaryScreen` langsung `Navigator.push` tiap ketukan tanpa guard `_submitting` | Isi asesmen → ringkasan → centang setuju → ketuk tombol dua kali cepat → amati dua layar analisis/dua permintaan | **Besar** | Aldi | TERBUKA — **terbukti** dengan uji sementara: 2 ketukan = 2 push (`PUSHES=2`); uji tidak di-commit agar suite tetap hijau |
| 4 | Nama aplikasi masih `flutter_application_1`; `applicationId`/`namespace` masih `com.example.flutter_application_1` | Lihat `AndroidManifest.xml` (`android:label`) dan `android/app/build.gradle.kts` | **Besar** (branding/rilis) | Aldi (label) / Lutfi (ID) | TERBUKA |
| 5 | `firestore.rules` belum ada di repo; belum ada bukti rules per-UID dipublish & diuji A vs B | `git ls-files` (tidak ada rules); uji dua akun di Rules Playground/emulator | **Fatal** (keamanan) | Lutfi | TERBUKA |
| 6 | Alat QA `tool/qa_live_gemini.dart` error `_argValue` tidak terdefinisi; opsi `--only`/`--timeout` tidak dipakai | `flutter analyze` sebelum perbaikan | Kecil (alat QA) | Sabrina | **SELESAI** (diperbaiki, analyze bersih) |
| 7 | Cache Kotlin `shared_preferences_android` gagal ditutup saat build rilis | Ulangi `flutter build apk --release`; bila perlu `flutter clean` | Kecil (lingkungan build) | Pemilik build | TERBUKA (menunggu #1) |
| 8 | `.env` ikut dibundel sebagai asset APK (key dapat diekstrak) | Periksa `pubspec.yaml` assets; hanya untuk demo tertutup | Risiko diterima (demo) | Pemilik | DITERIMA — jangan bagikan APK publik; gunakan jalur B bila distribusi |
| 9 | Kuota/limit `GEMINI_API_KEY` habis: live test berakhir HTTP **429** (`exceeded your current quota`), didahului 503/timeout | `dart run tool/qa_live_gemini.dart --timeout=90` → 0/5; probe `generateContent` minimal → 429 | **Fatal** (demo AI live) | Faji/pemilik key | TERBUKA — ganti key/tambah kuota, lalu ulangi 5 skenario |

### Audit keamanan & kebersihan repo (bukti 2026-11-14)

- `.env` **diabaikan** Git: `git check-ignore -v .env` → `.gitignore:46:.env`; `git ls-files -- .env` kosong; `git log --all -- .env` kosong (tidak pernah ter-commit). **LULUS.** Audit ulang 2026-11-14 saat `.env` berisi key asli: key hanya dicetak panjangnya (53 karakter), tidak pernah nilainya; `git grep` nilai key di file yang di-track → 0 hasil.
- `.env.example` berisi nilai kosong (`GEMINI_API_KEY=`, `GEMINI_MODEL=`), aman di-commit. **LULUS.**
- Tidak ada key Gemini (pola `AIza…`) di file yang di-track selain `lib/firebase_options.dart`. File itu berisi **client API key Firebase** (bukan Gemini) untuk proyek `careerpath-e3adb`; aman untuk klien tetapi tetap batasi API key di Google Cloud. **LULUS dengan catatan.**
- Tidak ada key/isi `.env` di README, `PITCH-DEMO.md`, atau dokumen PRD/panduan (hanya placeholder). **LULUS.**
- Izin `android.permission.INTERNET` ada di `android/app/src/main/AndroidManifest.xml`. **LULUS.**
- `google-services.json`, `firebase_app_id_file.json`, service-account JSON sudah masuk `.gitignore` dan tidak di-track. **LULUS.**
- Tidak ada file `build/`, `*.apk`, atau `*.aab` yang di-track (`git ls-files build` kosong). **LULUS** — APK lokal yang mungkin memuat `.env` tidak ikut repo.
- README menjelaskan cara membuat `.env`, setup Firebase/`flutterfire`, build, uji, dan penanganan 429/503. **LULUS** (tangkapan layar masih kosong).
- Belum diverifikasi: rules Firestore terpublish, dua akun A/B, sesi bertahan, perilaku offline di perangkat. **MENUNGGU akses cloud/HP.**

## L-10

- Waktu, nama/peran, branch/commit bila tersedia: 2026-11-14, Sabrina (agent, peran D), branch `sabrina`
- Tugas, tujuan dan kriteria selesai: build rilis + uji akhir + kesiapan demo (To-Do Blok F/G). Selesai bila APK rilis terpasang & checklist QA §3 lulus, slide/naskah/video siap, README & log lengkap.
- Status: **TERHAMBAT** — APK rilis belum bisa dibuat tanpa `google-services.json`; uji 2 HP, video, dan slide final menunggu perangkat/tim.
- Perubahan nyata dan path file:
  - `README.md` — fitur, kebutuhan, cara run, setup `.env`/Firebase, build, uji, struktur, tim, dokumen, status QA terbaru, dan blocker rilis.
  - `PITCH-DEMO.md` — 7 slide, naskah 3 menit, skenario demo, Plan B, Q&A juri, checklist pra-demo/pengumpulan; angka yang sudah terbukti diisi, placeholder survei/akun ditandai jelas.
  - `HASIL-KERJA.md` — status build & kesiapan rilis.
- Package, konfigurasi nonrahasia atau keputusan: Tidak menambah package. Keputusan: APK rilis **tidak** dibuat/dibagikan sebelum `google-services.json` tersedia dan init Firebase diperbaiki; `.env` sebagai asset hanya untuk demo tertutup.
- Uji oleh agent — perintah, hasil aktual (LULUS / GAGAL / BELUM DIUJI):
  - `flutter build apk --release` → **GAGAL** setelah 1 m 27 s. Log: `Execution failed for task ':app:processReleaseGoogleServices'` → `File google-services.json is missing`; juga `:shared_preferences_android:compileReleaseKotlin` → `Could not close incremental caches`. Tidak ada APK yang dihasilkan.
  - Pemeriksaan statis manifest → `INTERNET` **ADA**; label aplikasi masih default.
  - `flutter analyze` / `flutter test` → lihat L-08 (LULUS dengan info / 27/27).
- Uji manual oleh manusia — langkah, perangkat dan hasil, atau MENUNGGU: **MENUNGGU**. Langkah: setelah build berhasil, pasang `app-release.apk` di 2 HP, jalankan seluruh checklist §3 To-Do pada mode rilis, rekam video demo, latihan pitch 2× dengan timer, siapkan akun demo + 1 riwayat.
- Kendala, tindakan perbaikan dan yang tersisa: (1) `google-services.json` + init Firebase (Lutfi/pemilik), (2) rules & uji dua akun, (3) bug #3–#4 (Aldi/Lutfi), (4) APK rilis & 2 perangkat, (5) video, slide final, angka survei, akun demo, (6) tangkapan layar asli — percobaan render headless via golden test menggantung di lingkungan ini dan file uji sementara sudah dihapus, jadi screenshot harus diambil dari HP/emulator. Tidak ada key yang dicetak/di-commit selama QA.
- Gerbang blok dan butir To-Do yang diperbarui: Gerbang F **BELUM** (APK rilis belum ada). Yang dicentang: izin INTERNET (F), README (G, kecuali tangkapan layar). Indeks §4.4 diisi untuk L-10.
- Tindakan berikut, lokasi mulai dan tanda berhasil: Setelah bug Fatal #1–#2 selesai, jalankan ulang build; bila APK ada, uji di HP dan perbarui bagian ini + `PITCH-DEMO.md` dengan angka nyata. Tanda berhasil: APK rilis terpasang di 2 HP, video demo di 2 tempat, semua checkbox §3.7 tercentang, L-10 berubah menjadi SELESAI.
## L-02

- Waktu, nama/peran, branch/commit bila tersedia: 2026-11-14, Aldi (Orang 1 — UI/UX, Layar & Navigasi) via agent, repo non-git
- Tugas, tujuan dan kriteria selesai: Perbaiki error kompilasi layar asesmen minat agar UI bisa dibangun di Flutter 3.32.8 (Blok B, peran A) dan buktikan perilaku tombol lanjut. Kriteria: `flutter analyze` 0 error, `flutter test` lulus, tombol "Lanjut ke penilaian skill" hanya aktif setelah 8/8 jawaban.
- Status: SELESAI (uji otomatis; uji manual HP MENUNGGU)
- Perubahan nyata dan path file:
  - `lib/screens/interest_screen.dart`: ganti `RadioGroup` (API baru, tidak ada di stable 3.32.8) → `Column` + `RadioListTile` klasik dengan `groupValue`/`onChanged` per opsi. Pilihan tetap tersimpan ke provider via `setInterest`.
  - `test/widget_test.dart`: tambah `SharedPreferences.setMockInitialValues({})` + `TestWidgetsFlutterBinding.ensureInitialized()`; tanpa mock, balasan platform message tidak diproses di zona FakeAsync test → future `getProfile()` menggantung → `pumpAndSettle` timeout (akar masalah ditemukan lewat test sementara yang sudah dihapus). Tambah asertivitas copy welcome (Masuk/Daftar, Jelajahi contoh hasil offline).
  - `test/interest_screen_test.dart` (baru): uji 8/8 — semua soal tampil, tombol lanjut `onPressed == null` sebelum lengkap, 8 jawaban tersimpan di provider, tombol aktif setelah lengkap, subtitle "8 dari 8 pertanyaan terisi".
- Package, konfigurasi nonrahasia atau keputusan: Tanpa dependensi baru; API `RadioListTile` klasik (Flutter 3.32.8). Mock `SharedPreferences` hanya di test, bukan di kode produksi.
- Uji oleh agent — perintah, hasil aktual (LULUS / GAGAL / BELUM DIUJI):
  - `flutter analyze` → LULUS (No issues found; sebelumnya 3 error)
  - `flutter test` → LULUS (2 test: boot-to-welcome + tombol lanjut 8/8)
- Uji manual oleh manusia — langkah, perangkat dan hasil, atau MENUNGGU: MENUNGGU (HP/emulator: buka app → Mulai asesmen → isi 8 pertanyaan → tombol lanjut aktif tepat; kembali tidak menghapus jawaban)
- Kendala, tindakan perbaikan dan yang tersisa: Tidak ada. Catatan: `RadioGroup` hanya muncul jika Flutter dinaikkan; jika tim pakai Flutter lebih lama, kode tetap kompatibel.
- Gerbang blok dan butir To-Do yang diperbarui: Indeks §4.4 baris L-02 diisi. Butir Blok B belum dicentang karena gerbang butuh bukti navigasi penuh di perangkat.
- Tindakan berikut, lokasi mulai dan tanda berhasil: Uji manual alur welcome→profil→minat→skill→ringkasan→hasil contoh di HP; bila lolos, centang butir Blok B (peran A) dan lanjut butir Orang 1 berikutnya (mis. konsistensi copy/overflow layar kecil).

### Sesi 2 (lanjutan, 2026-11-14) — kelengkapan Must UI mandiri (tanpa dependensi tim)

- Status: SELESAI (uji otomatis; uji manual HP MENUNGGU) — temuan berharga: uji layar kecil menangkap **bug overflow nyata di WelcomeScreen (52px di layar 5")** yang sebelumnya tidak terdeteksi; sudah diperbaiki jadi scrollable.
- Tugas, tujuan dan kriteria selesai: (1) tombol **Keluar** di layar Profil sesuai checklist Orang 1; (2) bukti layout aman di layar kecil 5" tanpa overflow (widget test 9 layar utama); (3) nama app rapi di launcher (label Android masih `flutter_application_1`). Kriteria: analyze 0 error, test lulus (termasuk test layar kecil tanpa exception), label `CareerPath AI`.
- Perubahan nyata dan path file:
  - `lib/screens/profile_screen.dart`: tambah tombol "Keluar dari akun" (hanya tampil bila sudah login) → `AppBackend.signOut()` + reset provider + kembali ke welcome, pola sama dengan beranda (service Orang 2 tidak diubah).
  - `lib/screens/welcome_screen.dart`: bungkus `LayoutBuilder + SingleChildScrollView + ConstrainedBox(minHeight)` ganti `Spacer` — muat & scroll di layar kecil, tetap rapi di layar besar. (Fix bug overflow 52px.)
  - `android/app/src/main/AndroidManifest.xml`: `android:label` → `CareerPath AI`.
  - `ios/Runner/Info.plist`: `CFBundleDisplayName`/`CFBundleName` → `CareerPath AI`.
  - `test/small_screen_test.dart` (baru): 9 layar diuji pada 320×568 @2x, semua tanpa exception overflow; helper scroll untuk konten di bawah lipatan ListView.
- Package, konfigurasi nonrahasia atau keputusan: Tanpa dependensi baru; ukuran layar tes 320×568 (5" standar QA To-Do §3.5).
- Uji oleh agent — perintah, hasil aktual (LULUS / GAGAL / BELUM DIUJI):
  - `flutter analyze` → LULUS (0 issues)
  - `flutter test` → LULUS (11 test: boot, tombol minat 8/8, 9 layar layar-kecil)
- Uji manual oleh manusia — langkah, perangkat dan hasil, atau MENUNGGU: MENUNGGU (HP: login → profil → tombol Keluar berfungsi; nama "CareerPath AI" tampil di launcher; welcome tidak overflow di HP kecil)

### Sesi 2026-11-14 — perbaikan toolchain build Android (berlaku untuk semua tim)

- Waktu, nama/peran: 2026-11-14, Aldi (Orang 1) via agent; pemilik mesin menjalankan `flutter run` di HP pribadi (22101320G)
- Status: **SELESAI** — `flutter build apk --debug` LULUS dan APK terinstall ke HP. (Catatan: alur manual di HP masih BELUM DIUJI — aplikasi baru terpasang, belum diverifikasi terbuka/jalan.)
- Temuan: build gagal berlapis. (1) `:gradle:compileKotlin` — project era 2026 (Gradle 9.5 + AGP 9.3.1 + Kotlin 2.4.20) vs Flutter 3.32.8 + hanya JDK 25 (turunkan Gradle tidak mungkin tanpa JDK 21) → 2 error di SDK Flutter sendiri. (2) `app/build.gradle.kts` — aksesor `android{}` jadi deprecation-ERROR di AGP 9.3.1 (DSL lama wajib karena plugin Flutter 3.32.8 masih pakai `applicationVariants`), plugin `org.jetbrains.kotlin.android` hilang dari blok plugins, `minSdk` 21 < 23 syarat firebase-auth. (3) `:shared_preferences_android:compileDebugKotlin` gagal reproducible `Could not close incremental caches (.tab)`. (4) `stripDebugDebugSymbols` Access denied (file temp terkunci — dibersihkan, hilang). (5) `google-services.json` tidak ada di repo (milik Orang 2/pemilik).
- Perubahan nyata dan path file:
  - SDK Flutter lokal (`D:\flutter_windows_3.32.8-stable\flutter` — git checkout, bisa dibatalkan): `packages/flutter_tools/gradle/src/main/kotlin/FlutterPlugin.kt` (hapus `fileMode = 420`, dihapus di Gradle 9) dan `FlutterPluginUtils.kt` (`toLowerCase()` → `lowercase()`).
  - `android/app/build.gradle.kts`: tambah `@file:Suppress("DEPRECATION")`; tambah `id("org.jetbrains.kotlin.android")`; **komentari sementara `id("com.google.gms.google-services")`** (google-services.json belum ada → Firebase OFF / mode lokal; Orang 2 aktifkan kembali dengan menghapus `// ` setelah file dari `flutterfire configure` tersedia); `minSdk = maxOf(flutter.minSdkVersion, 23)`.
  - `android/gradle.properties`: tambah `kotlin.incremental=false` (workaround error cache Kotlin; hapus setelah build stabil).
  - Unduhan otomatis terkait build: NDK 26.3.11579264, SDK Platform 34/35 (di `C:\Users\Asus\AppData\Local\Android\Sdk`).
- Uji oleh agent — perintah, hasil aktual:
  - `flutter build apk --debug` → **LULUS** (`√ Built build\app\outputs\flutter-apk\app-debug.apk`, 193 MB, 14/11/2026 18:45)
  - `flutter install --debug -d a94e0c14` → **LULUS** (HP 22101320G, Redmi, Android 13 API 33, 11,3 dtk)
  - `flutter analyze` → LULUS (0 issues, sesi L-02); `flutter test` → LULUS (11 test, sesi L-02)
- Uji manual oleh manusia: **BELUM DIUJI** — buka aplikasi di HP, cek welcome/tampilan/label `CareerPath AI`, alur welcome→minat→skill→hasil contoh. Login/Firebase tidak aktif (google-services dinonaktifkan sementara).
- Kendala, tindakan perbaikan dan yang tersisa: (1) `google-services.json` + aktifkan lagi plugin google-services (Orang 2/pemilik); (2) warning NDK 28.2.13676358 diminta plugin firebase — hanya warning, belum diubah (hindari unduhan NDK besar ke C: yang sisa 10,7 GB); (3) patch SDK Flutter bersifat lokal — bila Flutter di-upgrade, patch otomatis hilang (justru diinginkan) dan `android.newDsl=false`/`kotlin.incremental=false`/`@file:Suppress` sebaiknya dievaluasi ulang.
- Gerbang blok dan butir To-Do yang diperbarui: tidak ada yang dicentang (butuh bukti uji manual alur di HP).

### Template entri

- Waktu, nama/peran, branch/commit bila tersedia:
- Tugas, tujuan dan kriteria selesai:
- Status: SEDANG / SELESAI / TERHAMBAT
- Perubahan nyata dan path file:
- Package, konfigurasi nonrahasia atau keputusan:
- Uji oleh agent — perintah, hasil aktual (LULUS / GAGAL / BELUM DIUJI):
- Uji manual oleh manusia — langkah, perangkat dan hasil, atau MENUNGGU:
- Kendala, tindakan perbaikan dan yang tersisa:
- Gerbang blok dan butir To-Do yang diperbarui:
- Tindakan berikut, lokasi mulai dan tanda berhasil:

## L-05

- Waktu, nama/peran, branch/commit bila tersedia: 2026-11-14, Faji (agent, peran C: AI), branch lokal `lutfi` (belum commit)
- Tugas, tujuan dan kriteria selesai: Menyambungkan "Analisis dengan AI" ke input asesmen nyata, memaksa output JSON valid, menangani error jaringan/kuota/model/format dengan pesan yang dapat dipahami, dan mencegah panggilan ganda. Selesai bila parser menguji fixture valid/tidak valid dan alur menampilkan error + opsi coba lagi/contoh.
- Status: SELESAI (parsial: 26 uji otomatis LULUS; live service 11 panggilan sukses dengan `gemini-3.6-flash`; 10 panggilan berturut-turut, alur UI, dan 5 skenario QA belum terbukti)
- Perubahan nyata dan path file:
  - `lib/services/gemini_service.dart`: injeksi `http.Client` untuk uji; isConfigured aman saat dotenv belum dimuat; guard `_requestInFlight` anti-panggilan ganda; decode UTF-8; ekstraksi teks aman; pemetaan error 400/401/403/404/429/5xx, timeout, offline, dan TLS handshake; deteksi `promptFeedback.blockReason`, `finishReason` (STOP/MAX_TOKENS/dll); pembersihan pagar markdown + ekstraksi objek JSON; `responseSchema` dengan batas `minItems`/`maxItems`/`minimum`/`maximum` + retry tanpa schema bila API menolak; retry sekali dengan instruksi perbaikan bila JSON atau kontrak hasil melanggar validasi.
  - `lib/utils/validators.dart`: judul katalog dinormalisasi (spasi/kapitalisasi) dan diurutkan skor tertinggi; validasi `skills_owned`/`skills_missing` (daftar teks tidak kosong), judul+aksi roadmap, week 1-4, skor 0-100, larangan semua 100.
  - `lib/screens/summary_screen.dart`: tombol "Analisis dengan AI" tidak bisa membuka dua layar analisis (klik ganda).
  - `lib/screens/analyzing_screen.dart`: guard `_busy` saat retry + pesan error tak terduga yang ramah; error Gemini/konfigurasi/validasi diteruskan apa adanya.
- Package, konfigurasi nonrahasia atau keputusan: Jalur A REST dipertahankan; `GEMINI_API_KEY`/`GEMINI_MODEL` dari `.env`. Model live yang terbukti: `gemini-3.6-flash` (model `gemini-flash-latest` timeout; `gemini-2.5-flash-lite` sudah tidak tersedia untuk pengguna baru). `responseSchema` memakai katalog 8 karier (enum) dengan fallback otomatis. Tidak ada package baru; test memakai `package:http/testing.dart` bawaan `http`.
- Uji oleh agent — perintah, hasil aktual (LULUS / GAGAL / BELUM DIUJI):
  - `flutter test test/validators_test.dart test/gemini_service_test.dart --concurrency=1 --no-pub` → LULUS 26/26.
  - `flutter analyze --no-pub` → 15 info `deprecated_member_use` lama (import `material.dart`), tanpa error.
  - `flutter test --concurrency=1` → 26 test AI LULUS + 1 GAGAL di `test/widget_test.dart` (pumpAndSettle timeout; test lama di luar AI, tidak diubah).
  - Live `gemini-3.6-flash` via service: 3/3 LULUS (17, 15, 15 detik), lalu 8/8 LULUS berturut-turut (14-20 detik) sebelum panggilan ke-9 gagal kontrak roadmap setelah retry; percobaan lanjut kena kuota 429. Total 11 panggilan nyata LULUS.
- Uji manual oleh manusia — langkah, perangkat dan hasil, atau MENUNGGU: SEBAGIAN (live service sudah; UI belum). Langkah UI: jalankan app, login→profil→8 minat→6 skill→centang persetujuan→Analisis; pastikan loading, 3 kartu hasil, detail roadmap, dan riwayat muncul. Ulangi 10x saat kuota stabil, lalu matikan internet untuk melihat pesan + tombol "Coba lagi"/"Lihat contoh hasil".
- Kendala, tindakan perbaikan dan yang tersisa: 1/12 panggilan live melanggar kontrak roadmap setelah retry; schema sudah diperketat (`minItems`/`maxItems`) tetapi belum diverifikasi ulang karena kuota 429 dan jaringan IPv6 labil. Latensi live 14-20 detik, belum konsisten <15 detik. `test/widget_test.dart` gagal karena isu lama (bukan AI); perlu diperbaiki pemilik UI/Firebase.
- Gerbang blok dan butir To-Do yang diperbarui: Butir To-Do Blok C "parse JSON ke model `CareerResult` dengan `try/catch`" dicentang (bukti 26 uji). Butir "kirim data asli ke Gemini" sudah terbukti di level service, tetapi alur UI end-to-end dan QA 10 panggilan tetap terbuka.
- Tindakan berikut, lokasi mulai dan tanda berhasil: Setelah kuota pulih, jalankan app → alur asesmen dan ulangi 10 panggilan; mulai dari `lib/services/gemini_service.dart` bila masih ada pelanggaran roadmap. Berhasil bila 10 panggilan berturut-turut parse valid, 3 karier dari katalog, alasan menyebut data pengguna, roadmap 4 minggu, dan error offline ramah.

## L-08

- Waktu, nama/peran, branch/commit bila tersedia: 2026-11-14, Faji (agent, peran C: AI), branch lokal `lutfi` (belum commit)
- Tugas, tujuan dan kriteria selesai: Stabilisasi kualitas AI — prompt lebih ketat (3 karier berbeda, skor bervariasi, alasan berbasis data, roadmap 4 minggu dengan aksi konkret), parser defensif, pesan error ramah, dan fallback contoh berlabel. Selesai bila perilaku gagal/valid terbukti lewat test otomatis; 5 skenario QA nyata tetap butuh device/key.
- Status: SELESAI (parsial: prompt/schema/parser teruji otomatis dan 11 panggilan live sukses; 5 skenario QA UI dan 10 panggilan berturut-turut MENUNGGU kuota/jaringan stabil)
- Perubahan nyata dan path file:
  - `lib/services/gemini_service.dart`: system+user prompt diperketat (tepat 3 karier berbeda dari katalog, urut skor, summary 2-3 kalimat, alasan minimal 2 kalimat berbasis data, skills minimal 2 item, week 1-4 minimal 2 aksi konkret, tanpa janji gaji/kerja); `responseSchema` membatasi tipe, enum katalog, jumlah 3 karier, roadmap tepat 4 item, skills/aksi minimal 2 item, skor 0-100; temperature 0.4/topP 0.9 (retry perbaikan 0.2); retry sekali dengan instruksi koreksi bila kontrak dilanggar.
  - `lib/utils/validators.dart`: tolak duplikat, karier luar katalog, jumlah bukan 3, skor di luar 0-100/semua 100, skills kosong/bukan daftar, roadmap bukan 4 minggu/urutan week salah/aksi kosong.
  - `lib/data/sample_result.dart`: tidak diubah; tetap menjadi fallback/mode demo dan lolos validasi (dibuktikan test).
  - `test/gemini_service_test.dart`, `test/validators_test.dart`: 26 test untuk happy path, markdown fence, JSON invalid, pelanggaran kontrak + retry, 429/401, safety block, MAX_TOKENS, konfigurasi kosong, panggilan ganda, timeout, fallback schema.
- Package, konfigurasi nonrahasia atau keputusan: Tidak ada package baru; memakai `package:http/testing.dart` (bawaan `http`). Fallback contoh tetap berlabel "Contoh hasil" di layar hasil; jalur B (Firebase AI Logic + App Check) belum dipakai (dicatat untuk APK distribusi).
- Uji oleh agent — perintah, hasil aktual (LULUS / GAGAL / BELUM DIUJI):
  - `flutter test test/validators_test.dart test/gemini_service_test.dart --concurrency=1 --no-pub` → LULUS 26/26.
  - `flutter analyze --no-pub` → hanya 15 info `deprecated_member_use` lama (tanpa error/warning baru).
  - `flutter test --concurrency=1` → 26 test AI LULUS + 1 GAGAL lama di widget test (pumpAndSettle).
  - Live `gemini-3.6-flash`: 3/3 sukses, lalu 8/8 sukses berturut-turut; panggilan ke-9 gagal kontrak roadmap setelah retry, lalu kuota 429. Hasil sukses selalu 3 karier dari katalog dengan roadmap 4 minggu; skor bervariasi (contoh 92/78/70).
- Uji manual oleh manusia — langkah, perangkat dan hasil, atau MENUNGGU: MENUNGGU (5 skenario PRD: teknis, kreatif, non-teknis, semua skill 1, semua skill 5; plus 10 panggilan stabil dan latensi <15 detik). Live service sudah memberi bukti awal, tetapi UI/HP belum.
- Kendala, tindakan perbaikan dan yang tersisa: 1/12 panggilan live melanggar kontrak roadmap setelah retry; schema sudah diperketat tetapi belum diverifikasi ulang karena kuota 429 dan jaringan IPv6 labil. Latensi live 14-20 detik (belum konsisten <15 detik). Widget test lama gagal; tidak diubah karena di luar scope AI.
- Gerbang blok dan butir To-Do yang diperbarui: Butir Should "Roadmap 4 minggu dibuat lebih konkret di prompt" dan "Fallback: tampilkan hasil contoh dengan label jelas" dicentang (fallback sudah ada, tervalidasi test, label tampil di `result_screen.dart`). Butir Must kualitas AI 10 panggilan & 5 skenario tetap terbuka.
- Tindakan berikut, lokasi mulai dan tanda berhasil: Setelah kuota/jaringan stabil, jalankan 5 skenario QA + 10 panggilan; mulai dari `lib/services/gemini_service.dart` (prompt/schema) bila perlu penyetelan. Berhasil bila semua skenario menghasilkan 3 karier relevan, skor bervariasi, alasan personal, roadmap konkret, dan tidak ada crash offline.
