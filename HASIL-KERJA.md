# Hasil kerja CareerPath AI

Satu log untuk seluruh sesi. Saat memulai, isi posisi terakhir dari keadaan repo aktual. Template kosong ini belum menyatakan fitur apa pun selesai.

## Posisi terakhir

| Yang perlu diketahui agent berikut | Isi saat checkpoint |
|---|---|
| Waktu dan penanggung jawab | 2026-11-14, Lutfi / Orang 2 (agent) — pengerjaan tugas data & Firebase sesuai pembagian, tanpa mengubah UI/AI milik anggota lain |
| Blok, ID laporan, tugas aktif | L-03/L-04/L-07 (kode, parsial): Firebase init via `firebase_options.dart`, `AuthService`, sesi `authStateChanges`, profil & riwayat Firestore + fallback lokal, logout bersih, salinan `firestore.rules`. Verifikasi console/perangkat masih MENUNGGU. |
| Kondisi kode dan uji terakhir | `firebase_options.dart` terdeteksi di repo. `flutter analyze` penuh: 15 info `deprecated_member_use` (lint env), tanpa error/warning. `flutter test test/data_layer_test.dart` **LULUS** (3 tes: serialisasi profil, validasi sample result 3 karier/4 minggu, round-trip record). `flutter test` penuh & `test/widget_test.dart` **timeout/hang** di environment ini (butuh verifikasi manual/device). `flutter run`/build APK & verifikasi Firebase Console BELUM DIUJI. |
| Pilihan integrasi Gemini | Tidak diubah (tetap jalur A REST di `gemini_service.dart`, milik Orang 3). `.env` berisi key/model lokal (jangan commit). |
| Hambatan / tindakan pemilik | Butuh verifikasi di Firebase Console & perangkat: pastikan Email/Password aktif, Rules `firestore.rules` dipublish, lalu uji daftar/masuk/sesi, simpan profil, simpan asesmen, riwayat cloud, dan isolasi data antar akun. Tanpa uji nyata butir To-Do L-03/L-04/L-06/L-07 belum bisa dicentang. |
| Tindakan berikut | Jalankan `flutter run`, lakukan uji L-04 (auth) & L-06/L-07 (profil/riwayat Firestore) sesuai To-Do/QA; perbaiki jika ada `permission-denied`/config; catat bukti di HASIL-KERJA dan sinkronkan checklist. |
| Bukti selesai untuk tindakan berikut | Akun uji muncul di Authentication, dokumen `users/{uid}` & `users/{uid}/assessments` terbentuk, login ulang/perangkat lain menampilkan riwayat sama, akun B ditolak akses data A, logout mengosongkan state lokal. |

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

## L-03

- Waktu, nama/peran, branch/commit bila tersedia: 2026-11-14, Lutfi (Orang 2 — Data & Firebase), repo non-git
- Tugas, tujuan dan kriteria selesai: Konfigurasi & inisialisasi Firebase sisi aplikasi (pakai `firebase_options.dart`), siapkan salinan Rules; kriteria: app init Firebase dengan opsi platform, rules per-UID tersedia di repo.
- Status: SELESAI (kode/artefak repo) — verifikasi console/device MENUNGGU
- Perubahan nyata dan path file: `lib/main.dart` (init `DefaultFirebaseOptions.currentPlatform`, entry gate reaktif `authStateChanges` + pemuatan profil per sesi), `lib/firebase_options.dart` (ada di repo, hasil konfigurasi), `firestore.rules` (salinan aturan `users/{uid}` & `assessments/{assessmentId}`).
- Package, konfigurasi nonrahasia atau keputusan: Project ID `careerpath-e3adb`, applicationId Android `com.example.flutter_application_1`; fallback lokal tetap jika init gagal. Rules wajib dipublish di Console (tidak otomatis dari repo).
- Uji oleh agent — perintah, hasil aktual (LULUS / GAGAL / BELUM DIUJI): `flutter analyze` (penuh & file terkait) → tanpa error/warning (info lint env saja). `flutter test test/data_layer_test.dart` → LULUS (3 tes). `flutter test` penuh → TIMEOUT di environment ini.
- Uji manual oleh manusia — langkah, perangkat dan hasil, atau MENUNGGU: MENUNGGU (cek app terhubung project benar, tidak error init di `flutter run`).
- Kendala, tindakan perbaikan dan yang tersisa: Agent tidak dapat memverifikasi Console/Rules publish; perlu uji perangkat.
- Gerbang blok dan butir To-Do yang diperbarui: Mendukung Blok B/L-03 (inisialisasi & artefak config) — belum dicentang tanpa bukti uji.
- Tindakan berikut, lokasi mulai dan tanda berhasil: Jalankan `flutter run` dari root; berhasil bila app start tanpa crash init dan siap auth bila provider aktif.

## L-04

- Waktu, nama/peran, branch/commit bila tersedia: 2026-11-14, Lutfi (Orang 2 — Data & Firebase), repo non-git
- Tugas, tujuan dan kriteria selesai: Auth email/password (daftar/masuk/keluar), sesi bertahan, pesan error Indonesia, dan pembersihan state saat logout/pergantian akun; kriteria: alur auth via service, UI menampilkan error ramah, state tidak bocor.
- Status: SELESAI (implementasi kode) — verifikasi akun console & perangkat MENUNGGU
- Perubahan nyata dan path file: `lib/services/auth_service.dart` (baru: register/login/logout, `authChanges`, pemetaan error termasuk `operation-not-allowed`, `too-many-requests`, dll.), `lib/screens/auth_screen.dart` (pakai `AuthService`), `lib/main.dart` (gate berbasis `authStateChanges`), `lib/services/app_backend.dart` & `lib/screens/home_screen.dart` (logout membersihkan profil/riwayat lokal + reset assessment provider).
- Package, konfigurasi nonrahasia atau keputusan: Tetap Firebase Auth; tidak mengubah layout/UI selain wiring yang diperlukan (ranah Orang 1).
- Uji oleh agent — perintah, hasil aktual (LULUS / GAGAL / BELUM DIUJI): `flutter analyze` → tanpa error/warning (LULUS statis). `flutter test test/data_layer_test.dart` → LULUS. Uji alur auth nyata & Firebase Console BELUM DIUJI.
- Uji manual oleh manusia — langkah, perangkat dan hasil, atau MENUNGGU: MENUNGGU (daftar/masuk/salah sandi/email terpakai, tutup-buka app, logout → akun muncul di Authentication).
- Kendala, tindakan perbaikan dan yang tersisa: Jika `operation-not-allowed`, aktifkan Email/Password di Console. Uji jaringan/error nyata belum dilakukan.
- Gerbang blok dan butir To-Do yang diperbarui: Mendukung L-04 Blok C — belum dicentang tanpa bukti.
- Tindakan berikut, lokasi mulai dan tanda berhasil: Uji dari layar Masuk/Daftar; berhasil bila kredensial valid masuk, error tampil Indonesia, sesi bertahan, logout kembali ke welcome tanpa data akun lain.

## L-07

- Waktu, nama/peran, branch/commit bila tersedia: 2026-11-14, Lutfi (Orang 2 — Data & Firebase), repo non-git
- Tugas, tujuan dan kriteria selesai: Simpan profil & hasil asesmen ke Firestore, muat riwayat cloud (fallback lokal), buka hasil lama tanpa panggil Gemini; pisahkan kegagalan simpan dari kegagalan analisis; kriteria: path `users/{uid}` & `assessments` sesuai PRD, riwayat terurut.
- Status: SELESAI (implementasi kode) — verifikasi data & rules MENUNGGU
- Perubahan nyata dan path file: `lib/services/app_backend.dart` (simpan profil merge+timestamp, simpan assessment ke subkoleksi lalu rethrow agar UI lapor gagal simpan; `getHistory` dari Firestore urut desc dengan fallback lokal & parsing timestamp aman), integrasi dipakai oleh `lib/screens/profile_screen.dart`, `lib/screens/analyzing_screen.dart`, `lib/screens/home_screen.dart` (tanpa ubah UX inti).
- Package, konfigurasi nonrahasia atau keputusan: Firestore collection `users/{uid}/assessments` dengan `createdAt` server, `input`, `result`, `isSample`. Riwayat cloud mengembalikan list kosong jika belum ada dokumen (bukan salah jatuh ke lokal pengguna lain).
- Uji oleh agent — perintah, hasil aktual (LULUS / GAGAL / BELUM DIUJI): `flutter analyze` → tanpa error/warning (LULUS statis). `flutter test test/data_layer_test.dart` (serialisasi/validasi/round-trip) → LULUS. Uji tulis/baca Firestore & Rules nyata BELUM DIUJI.
- Uji manual oleh manusia — langkah, perangkat dan hasil, atau MENUNGGU: MENUNGGU (profil & assessment muncul di console, riwayat tampil, buka item tanpa analisis ulang, uji aturan A vs B).
- Kendala, tindakan perbaikan dan yang tersisa: `permission-denied` bila rules belum publish/salah path; butuh verifikasi dua akun/perangkat.
- Gerbang blok dan butir To-Do yang diperbarui: Mendukung L-06/L-07 Blok C — belum dicentang tanpa bukti.
- Tindakan berikut, lokasi mulai dan tanda berhasil: Setelah login, simpan profil & selesaikan asesmen; berhasil bila dokumen muncul di Firestore dan riwayat home memuat dari cloud.

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
