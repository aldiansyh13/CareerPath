# Hasil kerja CareerPath AI

Satu log untuk seluruh sesi. Saat memulai, isi posisi terakhir dari keadaan repo aktual. Template kosong ini belum menyatakan fitur apa pun selesai.

## Posisi terakhir

| Yang perlu diketahui agent berikut | Isi saat checkpoint |
|---|---|
| Waktu dan penanggung jawab | 2026-11-14, Iceman (agent) |
| Blok, ID laporan, tugas aktif | L-01/L-02 (parsial): struktur MVP & data dibuat, alur UI end-to-end + Gemini REST + fallback contoh diimplementasi. Lanjut ke verifikasi manual/build & integrasi cloud oleh pemilik. |
| Kondisi kode dan uji terakhir | `flutter pub get` LULUS. `flutter analyze` selesai dengan 15 info `deprecated_member_use` (saran ganti `material.dart`→`material_ui` dari lint env; bukan error kode). Tidak ada error/warning lain. `flutter test` BELUM DIJALANKAN (test widget diganti, butuh verifikasi). Build/run perangkat BELUM DIUJI. |
| Pilihan integrasi Gemini | Jalur A (REST Gemini Developer API) diimplementasi: `lib/services/gemini_service.dart` membaca `.env` (`GEMINI_API_KEY`, `GEMINI_MODEL`), POST `generateContent`, `responseMimeType: application/json`, validasi 3 karier dari katalog/4 minggu/skor. `.env` placeholder dibuat lokal (gitignored), `.env.example` ditambahkan. Jalur B (Firebase AI Logic + App Check) BELUM, dicatat untuk APK distribusi. |
| Hambatan / tindakan pemilik | Butuh akun/konsol: (1) Firebase Project + `flutterfire configure --project=<ID> --platforms=android` untuk menghasilkan `firebase_options.dart` & aktifkan Auth/Firestore+Rules, (2) AI Studio: buat API key proyek & pilih model Flash JSON, isi `.env`, (3) uji di emulator/HP (`flutter run`). Tanpa ini app berjalan mode lokal + contoh hasil; analisis AI & sinkron cloud tidak aktif. |
| Tindakan berikut | Pemilik lakukan setup Firebase/Gemini (lihat panduan). Agent/lanjutan: ganti init Firebase ke `DefaultFirebaseOptions.currentPlatform` setelah `firebase_options.dart` ada, jalankan uji manual L-04..L-07, perbaiki bug UI/flow yang ditemukan, dan centang To-Do berbasis bukti. |
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
