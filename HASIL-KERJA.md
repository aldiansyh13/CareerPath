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
