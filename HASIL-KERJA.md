# Hasil kerja CareerPath AI

Satu log untuk seluruh sesi. Saat memulai, isi posisi terakhir dari keadaan repo aktual. Template kosong ini belum menyatakan fitur apa pun selesai.

## Posisi terakhir

| Yang perlu diketahui agent berikut | Isi saat checkpoint |
|---|---|
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
