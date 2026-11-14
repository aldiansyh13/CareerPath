# Hasil kerja CareerPath AI

Satu log untuk seluruh sesi. Saat memulai, isi posisi terakhir dari keadaan repo aktual. Template kosong ini belum menyatakan fitur apa pun selesai.

## Posisi terakhir

| Yang perlu diketahui agent berikut | Isi saat checkpoint |
|---|---|
| Waktu dan penanggung jawab | 2026-11-14, Faji (agent, peran C: AI) |
| Blok, ID laporan, tugas aktif | L-05/L-08 SELESAI (parsial): jalur Gemini diperkuat (prompt + `responseSchema` dengan batas array + fallback tanpa schema, retry sekali saat kontrak JSON dilanggar, parsing/validasi aman, error Bahasa Indonesia, timeout, cegah panggilan ganda), fallback contoh tetap tersedia. 26 uji unit LULUS. Live: `gemini-3.6-flash` berhasil 11 panggilan nyata (3+8), lalu 1 kegagalan kontrak roadmap setelah retry dan kuota 429; 10 panggilan berturut-turut & 5 skenario QA UI belum terbukti. |
| Kondisi kode dan uji terakhir | `flutter pub get` LULUS. `flutter analyze --no-pub` → 15 info `deprecated_member_use` yang sudah ada sebelumnya (import `material.dart`; bukan error kode). `flutter test test/validators_test.dart test/gemini_service_test.dart --concurrency=1 --no-pub` → LULUS 26/26. `flutter test --concurrency=1` → 26 test AI LULUS + 1 GAGAL pada `test/widget_test.dart` (pumpAndSettle timeout; test lama, di luar scope AI, belum diperbaiki). Build/run perangkat BELUM DIUJI. |
| Pilihan integrasi Gemini | Jalur A (REST Gemini Developer API) diimplementasi: `lib/services/gemini_service.dart` membaca `.env` (`GEMINI_API_KEY`, `GEMINI_MODEL`), POST `generateContent`, `responseMimeType: application/json` + `responseSchema` (batas 3 karier/4 minggu/minimal 2 skills & aksi, fallback tanpa schema bila API menolak), retry sekali dengan instruksi perbaikan bila hasil melanggar kontrak, validasi 3 karier dari katalog/4 minggu/skor. Model live yang terbukti: `gemini-3.6-flash`. `.env` placeholder lokal (gitignored), `.env.example` ada. Jalur B (Firebase AI Logic + App Check) BELUM, dicatat untuk APK distribusi. |
| Hambatan / tindakan pemilik | Firebase Project + `flutterfire configure --project=<ID> --platforms=android` untuk menghasilkan `firebase_options.dart` & aktifkan Auth/Firestore+Rules masih menunggu. API key/model Gemini sudah tersedia dan live call terbukti, tetapi kuota/rate limit sempat 429 dan jaringan IPv6 lingkungan labil; 1 dari 12 panggilan live melanggar kontrak roadmap setelah retry. Perlu uji UI di emulator/HP (`flutter run`) dan ulang 10 panggilan saat kuota/jaringan stabil. |
| Tindakan berikut | Jalankan alur asesmen nyata di emulator/HP (L-05), ulangi 10 panggilan berturut-turut setelah kuota pulih untuk memverifikasi schema yang baru diperketat, lalu 5 skenario QA AI (L-08). Catat latensi; target <15 detik belum selalu tercapai (live 14-20 detik). Perbaikan `test/widget_test.dart` yang gagal adalah tugas Aldi/Lutfi (UI/Firebase), bukan scope AI. |
| Bukti selesai untuk tindakan berikut | `flutter analyze` tanpa error, 26 uji unit AI LULUS, 11 panggilan Gemini nyata mengembalikan 3 karier dari katalog + roadmap 4 minggu, fallback contoh berlabel, riwayat terbuka tanpa panggil Gemini ulang; bukti dicatat di HASIL-KERJA. |

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
