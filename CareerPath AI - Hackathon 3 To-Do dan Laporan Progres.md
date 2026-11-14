# CareerPath AI - Hackathon 3: To-Do dan Laporan Progres

Nov 14, 2026 - @Habib

## 1. Cara Memakai Dokumen Ini

Dokumen ini adalah daftar kerja tim selama hackathon (asumsi 48 jam, 4 orang): centang tugas yang selesai, lalu setelah **setiap sesi kode** isi laporan progres di bagian 4 supaya seluruh tim selalu tahu apa yang sudah jadi. Acuan fitur ada di dokumen PRD, dan alasan keputusan ada di dokumen Brainstorming.

### 1.1 Tiga aturan utama

1. **Satu gerbang per blok.** Jangan pindah ke blok berikutnya sebelum gerbang blok sekarang lolos.
2. **Satu laporan per sesi kode.** Setiap kali selesai satu tugas kode dan sudah dijalankan, isi Laporan Selesai Kode (template di bagian 4) sebelum lanjut.
3. **Commit sebelum meminta AI mengubah banyak hal**, supaya bisa kembali jika hasilnya merusak aplikasi.

### 1.2 Pembagian peran (asumsi 4 orang)

| Peran | Tugas utama |
| --- | --- |
| A: Flutter UI | Semua layar dan widget |
| B: Data dan Firebase | Setup Firebase, Auth, Firestore, model, provider, data pertanyaan |
| C: AI | Prompt, `GeminiService`, uji kualitas hasil, fallback |
| D: Pitch dan QA | Slide, naskah demo, pengujian, video cadangan, log laporan |

Tim 3 orang: gabungkan D ke A atau C. Tim 2 orang: A+B dan C+D. Jika waktu Anda 24 jam, kerjakan hanya tugas bertanda **\[Must\]** dan gabungkan blok B dan C.

### 1.3 Prompt pembuka vibecoding (tempel di awal setiap sesi AI)

```text
Konteks proyek:
Saya dan tim (pemula Flutter) membuat aplikasi "CareerPath AI" untuk hackathon.
Pengguna masuk dengan email dan password (Firebase Auth), mengisi profil,
kuesioner minat, dan penilaian skill, lalu aplikasi memanggil Gemini API (REST via
package http) untuk menghasilkan 3 rekomendasi karier, skill gap, dan roadmap
30 hari dalam JSON. Hasil disimpan di Cloud Firestore (users/{uid}/assessments).

Tech stack: Flutter (Dart), provider, firebase_core, firebase_auth, cloud_firestore,
http, flutter_dotenv. Platform Android.

Struktur folder: lib/models, services, providers, data, screens, widgets, utils.

Aturan untuk jawabanmu:
- Jelaskan dengan bahasa sederhana karena saya pemula.
- Berikan kode lengkap per file beserta path file-nya.
- Jangan ubah file lain di luar yang saya minta.
- Beri tahu langkah menjalankan dan cara mengeceknya.
- Di akhir, tulis ringkasan file yang dibuat atau diubah dan apa yang perlu dites.
```

### 1.4 Aturan vibecoding singkat

- Satu tugas per prompt (misalnya "buat layar profil", bukan "buat semua layar").
- Jalankan setelah setiap perubahan. Jika ada error, tempel **seluruh** pesan error ke AI.
- Coba satu perbaikan saja per percobaan. Setelah 3 kali gagal, kembali ke commit terakhir yang berjalan.
- Jangan menempel API key atau isi `.env` ke chat AI.
- Setiap anggota harus bisa menjelaskan kode di layar yang dikerjakannya (juri bisa bertanya).

## 2. To-Do Pengembangan (48 Jam)

Pekerjaan dibagi menjadi 7 blok waktu dengan 10 titik laporan (L-01 sampai L-10); setiap titik laporan berarti kode sudah dijalankan dan Laporan Selesai Kode diisi di bagian 4. Tanda **\[Must\]**, **\[Should\]**, dan **\[Could\]** mengikuti prioritas di PRD.

| Blok | Jam | Fokus | Laporan |
| --- | --- | --- | --- |
| A | 0–3 | Persiapan alat dan keputusan | L-01 |
| B | 3–10 | UI statis, setup Firebase, GeminiService awal | L-02, L-03 |
| C | 10–20 | Auth, Firestore, integrasi Gemini, alur penuh | L-04 sampai L-07 |
| D | 20–28 | Stabilisasi dan istirahat bergiliran | L-08 |
| E | 28–38 | Fitur pembeda dan polish | L-09 |
| F | 38–44 | Build rilis, uji akhir, slide | L-10 |
| G | 44–48 | Latihan dan pengumpulan | (tidak ada kode baru) |

### Blok A (jam 0–3): Persiapan

- [ ] &#91;Must\] Semua anggota menjalankan `flutter doctor` dan aplikasi counter bawaan di HP atau emulator (yang belum bisa, pairing dengan yang sudah)
- [ ] &#91;Must\] Buat repo GitHub, branch `main` dan `dev`, undang semua anggota
- [ ] &#91;Must\] Buat API key Gemini, simpan di `.env` masing-masing (tidak di-commit), buat `.env.example`
- [ ] &#91;Must\] Uji prompt di Google AI Studio dengan data contoh sampai JSON-nya sesuai format PRD
- [ ] &#91;Must\] Putuskan 8 karier, 8 pertanyaan minat, 6 skill (isi `data/careers.dart`, `questions.dart`, `skills.dart`)
- [ ] &#91;Must\] `flutter create`, buat struktur folder sesuai PRD bagian 3.3, push ke `dev`
- [ ] &#91;Must\] Isi Laporan **L-01**

Gerbang A: semua anggota menjalankan proyek yang sama dan prompt sudah menghasilkan JSON benar di AI Studio.

### Blok B (jam 3–10): UI statis dan setup Firebase

- [ ] &#91;Must\] A: tema (warna, font), splash, layar Masuk/Daftar (tampilan saja), layar profil
- [ ] &#91;Must\] A: layar kuesioner minat, penilaian skill, ringkasan, loading
- [ ] &#91;Must\] A: layar hasil dan detail memakai data dummy dari `data/sample_result.dart`
- [ ] &#91;Must\] Isi Laporan **L-02** (UI statis)
- [ ] &#91;Must\] B: setup Firebase sesuai PRD bagian 3.2 (proyek, Auth Email/Password, Firestore, aturan keamanan, `flutterfire configure`); batas 90 menit
- [ ] &#91;Must\] B: `main.dart` memanggil `Firebase.initializeApp` dan aplikasi tetap berjalan
- [ ] &#91;Must\] B: undang semua anggota ke proyek Firebase
- [ ] &#91;Must\] Isi Laporan **L-03** (Firebase terpasang)
- [ ] &#91;Must\] C: tulis `GeminiService.analyzeCareer()` dan uji dari tombol sementara; cetak respons mentah ke konsol
- [ ] &#91;Should\] D: draf slide dan survei mini ke 10–20 teman (untuk angka di pitch)

Gerbang B: navigasi dari splash sampai detail berjalan dengan data dummy, Firebase terinisialisasi tanpa error, dan `GeminiService` mengembalikan JSON dari Gemini.

### Blok C (jam 10–20): Sambungkan Auth, Firestore, dan AI

- [ ] &#91;Must\] B: `AuthService` (daftar, masuk, keluar) dan layar Masuk/Daftar terhubung; pantau `authStateChanges` agar sesi bertahan
- [ ] &#91;Must\] B: pesan error Auth dalam Bahasa Indonesia (email salah, sandi lemah, akun sudah ada)
- [ ] &#91;Must\] Isi Laporan **L-04** (login berfungsi, akun muncul di konsol Firebase)
- [ ] &#91;Must\] C: parse JSON ke model `CareerResult` dengan `try/catch`
- [ ] &#91;Must\] B: `AssessmentProvider` menampung jawaban selama pengisian; validasi semua wajib diisi
- [ ] &#91;Must\] C: tombol "Analisis dengan AI" mengirim data asli ke Gemini; cegah klik ganda
- [ ] &#91;Must\] Isi Laporan **L-05** (Gemini terhubung ke alur asli)
- [ ] &#91;Must\] A+C: layar loading, layar hasil, dan detail menampilkan data asli; tampilkan error dengan tombol coba lagi
- [ ] &#91;Must\] B: `FirestoreService.saveProfile()` dan simpan profil saat pertama login
- [ ] &#91;Must\] Isi Laporan **L-06** (alur lengkap berjalan dari login sampai hasil)
- [ ] &#91;Must\] B: `saveAssessment()` setelah hasil tampil, `historyStream()` di Beranda, buka hasil lama tanpa memanggil Gemini
- [ ] &#91;Must\] Isi Laporan **L-07** (riwayat tersimpan di Firestore)

Gerbang C: alur penuh berjalan di APK debug: daftar, profil, asesmen, hasil dari Gemini, hasil tersimpan, riwayat terbuka. Mulai blok berikutnya hanya setelah ini lolos.

### Blok D (jam 20–28): Stabilisasi dan istirahat

- [ ] Bagi shift istirahat minimal 4–5 jam per orang (anggota yang kurang tidur membuat bug dan salah demo)
- [ ] &#91;Must\] D: jalankan 5 skenario uji dan checklist QA di bagian 3, catat bug di tabel bug — **PARSIAL**: uji otomatis & bug log selesai; endpoint Gemini kini terjangkau tetapi kuota key habis (HTTP 429), jadi 5 skenario live & uji HP **MENUNGGU** kuota/cloud ([L-08](HASIL-KERJA.md#l-08)).
- [ ] &#91;Must\] C: perbaiki prompt berdasarkan hasil uji (kualitas alasan, format JSON, konsistensi skor)
- [ ] &#91;Must\] A: perbaiki bug UI yang paling terlihat (overflow, teks terpotong, tombol tidak aktif)
- [ ] &#91;Must\] B: uji aturan Firestore (pengguna A tidak bisa membaca data pengguna B)
- [ ] &#91;Must\] Isi Laporan **L-08** (hasil stabilisasi dan daftar bug yang tersisa)

Gerbang D: 5 skenario uji menghasilkan hasil masuk akal dan tidak crash.

### Blok E (jam 28–38): Fitur pembeda dan polish

- [ ] &#91;Should\] Mode demo: tombol yang mengisi jawaban contoh otomatis
- [ ] &#91;Should\] Fallback: jika Gemini gagal, tampilkan hasil contoh dengan label jelas
- [ ] &#91;Should\] Roadmap 4 minggu dibuat lebih konkret di prompt
- [ ] &#91;Could\] Google Sign-In (hanya jika SHA-1 sudah dipahami dan blok D bersih)
- [ ] &#91;Could\] Grafik radar minat atau kartu hasil yang bisa dibagikan
- [ ] &#91;Must\] Ikon dan nama aplikasi, splash, disclaimer di halaman hasil
- [x] &#91;Must\] Hapus `print`, jalankan `flutter analyze` — **LULUS**: tidak ada `print` di `lib/`; 0 error, 0 warning; sisa info hanya 16 deprecation `material.dart` dan `avoid_print` di alat QA `tool/`. Bukti: [L-08](HASIL-KERJA.md#l-08).
- [ ] &#91;Must\] Isi Laporan **L-09**

Gerbang E: aplikasi terlihat rapi dan ada minimal satu hal "wow" yang bisa ditunjukkan.

### Blok F (jam 38–44): Build rilis dan uji akhir

- [x] &#91;Must\] Pastikan izin `INTERNET` ada di `AndroidManifest.xml` utama — **LULUS** (diperiksa 2026-11-14, [L-08](HASIL-KERJA.md#l-08)).
- [ ] &#91;Must\] `flutter build apk --release`, install ke minimal 2 HP — **TERHAMBAT**: build gagal karena `google-services.json` tidak ada + cache Kotlin; APK belum dihasilkan ([L-10](HASIL-KERJA.md#l-10)).
- [ ] &#91;Must\] Jalankan seluruh checklist QA di bagian 3 pada APK rilis
- [ ] &#91;Must\] D: selesaikan slide (maksimal 7), naskah demo, dan rekam video demo cadangan
- [ ] &#91;Must\] Code freeze setelah jam 44: tidak ada fitur baru, hanya perbaikan bug fatal
- [ ] &#91;Must\] Isi Laporan **L-10** (kondisi akhir aplikasi)

Gerbang F: APK rilis berjalan di HP demo dan video cadangan tersimpan di 2 tempat.

### Blok G (jam 44–48): Latihan dan pengumpulan

- [ ] &#91;Must\] Latihan pitch 3 menit minimal 2 kali dengan pewaktu
- [ ] &#91;Must\] Siapkan jawaban untuk pertanyaan juri (bagian 5)
- [ ] &#91;Must\] README di repo: cara menjalankan, cara membuat `.env`, fitur, tangkapan layar, tim
- [ ] &#91;Must\] Kumpulkan sesuai ketentuan lomba dan cek ulang bahwa semua tautan bisa dibuka
- [ ] &#91;Must\] HP demo: baterai penuh, notifikasi mati, hotspot cadangan siap

## 3. To-Do Pengecekan (QA)

Centang daftar ini di blok D, lalu ulangi seluruhnya di blok F pada APK rilis (bukan mode debug), karena beberapa masalah seperti izin internet hanya muncul di versi rilis.

### 3.1 Lima skenario uji wajib

| No | Skenario | Hasil yang diharapkan |
| --- | --- | --- |
| 1 | Profil teknis (Informatika, skill logika dan analisis tinggi) | Karier teknis di urutan atas, alasan menyebut skill tersebut |
| 2 | Profil kreatif (DKV, skill desain dan komunikasi tinggi) | Karier kreatif di urutan atas |
| 3 | Profil non-teknis (Manajemen, skill komunikasi dan kepemimpinan tinggi) | Karier bisnis atau manajemen di urutan atas |
| 4 | Semua skill dinilai 1 | Hasil tetap tampil dan masuk akal, roadmap fokus pada dasar |
| 5 | Semua skill dinilai 5 | Skor tidak semua 100, hasil tetap bervariasi |

> Status 2026-11-14 (D): kelima skenario sudah disiapkan sebagai input sintetis di `tool/qa_live_gemini.dart`. Uji live sudah **dicoba ulang** setelah jaringan pulih (endpoint discovery HTTP 200) dan menghasilkan **0/5**: dua skenario HTTP 503, tiga timeout, lalu probe langsung menerima **HTTP 429 kuota habis**. Jadi hambatannya sekarang **kuota/limit API key**, bukan jaringan atau kode. Ganti key/tambah kuota lalu jalankan ulang dari HP/jaringan demo, lalu catat hasil di [L-08](HASIL-KERJA.md#l-08). Jangan centang sebelum ada hasil nyata.

### 3.2 Pengecekan login dan Firebase

- [ ] Daftar dengan email baru berhasil dan akun muncul di Authentication pada konsol Firebase
- [ ] Masuk dengan sandi salah menampilkan pesan Bahasa Indonesia, bukan crash
- [ ] Daftar dengan email yang sudah dipakai menampilkan pesan yang jelas
- [ ] Tutup aplikasi sepenuhnya lalu buka lagi: pengguna tetap login
- [ ] Keluar mengembalikan ke layar Masuk dan riwayat pengguna lain tidak tampil
- [ ] Profil dan hasil muncul di dokumen `users/{uid}` pada konsol Firestore
- [ ] Login di HP kedua: riwayat yang sama muncul
- [ ] Aturan Firestore: pengguna A tidak bisa membaca atau menulis data pengguna B (uji dengan dua akun)
- [ ] Aturan Firestore bukan mode test (tidak ada `allow read, write: if true`)

### 3.3 Pengecekan fungsional

- [ ] Aplikasi terbuka sampai layar Masuk tanpa error
- [ ] Tombol lanjut tidak aktif sampai semua field wajib terisi
- [ ] Semua 8 pertanyaan minat dan 6 skill bisa dijawab, progress bar bergerak
- [ ] Tombol kembali tidak menghapus jawaban yang sudah diisi
- [ ] Tombol "Analisis dengan AI" memunculkan layar loading
- [x] Hasil menampilkan 3 kartu dengan skor 0–100 yang masuk akal — **LULUS** uji widget lokal ([L-08](HASIL-KERJA.md#l-08)).
- [x] Layar detail menampilkan alasan, skill dimiliki, skill kurang, dan roadmap 4 minggu — **LULUS** uji widget lokal ([L-08](HASIL-KERJA.md#l-08)).
- [x] Hasil baru muncul di riwayat dan bisa dibuka tanpa memanggil Gemini lagi — **LULUS untuk mode lokal**; sinkron cloud **MENUNGGU** Firebase ([L-08](HASIL-KERJA.md#l-08)).
- [x] Tombol "Ulangi asesmen" mengosongkan jawaban lama — **LULUS** uji widget lokal ([L-08](HASIL-KERJA.md#l-08)).

### 3.4 Pengecekan AI

- [ ] JSON dari Gemini valid pada 10 panggilan berturut-turut tanpa gagal parse
- [ ] Karier yang direkomendasikan hanya dari daftar 8 karier
- [ ] Alasan menyebut data pengguna (jurusan, skill, minat), bukan kalimat umum
- [ ] Bahasa Indonesia konsisten
- [ ] Tidak ada klaim berlebihan (gaji atau jaminan diterima kerja)
- [ ] Waktu respons di bawah 15 detik pada koneksi yang akan dipakai saat demo
- [ ] Jika field kosong atau tidak lengkap, UI tidak crash

> Status 2026-11-14 (D): kontrak JSON & penolakan respons tidak valid sudah diuji otomatis (LULUS). Pengecekan live di tabel ini **BELUM** bisa dicentang: panggilan `generateContent` berakhir **HTTP 429 kuota habis** (didahului 503/timeout), jadi kualitas alasan, konsistensi Bahasa, dan waktu respons <15 dtk belum terbukti. Lihat [L-08](HASIL-KERJA.md#l-08).

### 3.5 Pengecekan error dan ketahanan

- [ ] Matikan internet lalu tekan Analisis: muncul pesan jelas dan tombol coba lagi (atau hasil contoh)
- [ ] Matikan internet saat login: pesan jelas, bukan layar putih
- [ ] API key Gemini dikosongkan sementara: muncul pesan, bukan crash
- [ ] Tekan tombol Analisis dua kali cepat: tidak mengirim dua permintaan
- [ ] Pindah aplikasi lalu kembali saat loading: aplikasi tidak crash
- [ ] Layar kecil (5 inci) dan layar besar: tidak ada teks terpotong atau overflow garis kuning-hitam

### 3.6 Pengecekan keamanan dan repo

- [x] `.env` ada di `.gitignore` dan tidak ada di riwayat commit (`git log -- .env`) — **LULUS** (`git check-ignore` cocok, `git ls-files -- .env` & log kosong; [L-08](HASIL-KERJA.md#l-08)).
- [x] Tidak ada API key Gemini di kode, README, slide, atau video demo — **LULUS** (pola key tidak ditemukan; `firebase_options.dart` hanya client key Firebase, bukan Gemini; [L-08](HASIL-KERJA.md#l-08)).
- [x] Jika key pernah ter-commit: buat key baru dan hapus yang lama di AI Studio — **TIDAK BERLAKU**: `.env` tidak pernah masuk riwayat commit.
- [x] Izin `INTERNET` ada di `AndroidManifest.xml` utama — **LULUS** ([L-08](HASIL-KERJA.md#l-08)).
- [x] README menjelaskan cara membuat `.env` dan cara menghubungkan proyek Firebase — **LULUS** ([README](README.md#konfigurasi-env-gemini)); tangkapan layar masih kosong.

### 3.7 Kesiapan demo

- [ ] APK rilis terpasang di HP demo dan satu HP cadangan
- [ ] Akun demo sudah dibuat dan sudah punya satu hasil di riwayat
- [ ] HP demo: baterai penuh, mode jangan ganggu aktif, kecerahan maksimal
- [ ] Hotspot cadangan sudah dites dan terhubung ke HP demo
- [ ] Video demo cadangan tersimpan di HP dan laptop
- [ ] Mode demo atau hasil contoh berfungsi tanpa internet
- [ ] Jelas siapa yang mengoperasikan HP, siapa yang bicara, dan siapa menjawab pertanyaan teknis

### 3.8 Format pencatatan bug

| No | Deskripsi singkat | Langkah mengulang | Tingkat (Fatal/Besar/Kecil) | Penanggung jawab | Status |
| --- | --- | --- | --- | --- | --- |
| 1 |  |  |  |  |  |

Aturan: bug Fatal (crash, layar kosong, alur terhenti) diperbaiki dulu; bug Kecil diabaikan jika sudah melewati jam 38.

## 4. Laporan Selesai Kode

Setiap kali satu tugas kode selesai dan sudah dijalankan, anggota yang mengerjakannya meminta AI menulis laporan singkat memakai prompt di bawah, lalu menempelkan hasilnya ke log di bagian 4.4. Laporan ini memberi tim gambaran jelas tentang apa yang sudah jadi, apa yang belum, dan dasar untuk README serta bahan presentasi.

### 4.1 Template laporan

```text
LAPORAN L-xx: <judul singkat>
Tanggal/jam   : <hari dan jam>
Penanggung jawab: <nama> (peran A/B/C/D)
Branch/commit : <nama branch dan pesan commit terakhir>

1. Tujuan tugas
   <apa yang ingin dicapai dalam 1-2 kalimat>

2. Yang sudah dikerjakan
   - <fitur atau perubahan 1>
   - <fitur atau perubahan 2>

3. File yang dibuat atau diubah
   - lib/... : <apa yang dilakukan file ini>

4. Package atau konfigurasi yang ditambah
   - <nama package / pengaturan Firebase / izin Android>

5. Cara menguji dan hasilnya
   - Langkah: <cara menjalankan dan mengecek>
   - Hasil  : LULUS / GAGAL sebagian / GAGAL (jelaskan)

6. Masalah yang ditemui dan solusinya
   - <error atau kendala, cara mengatasi>

7. Yang belum selesai atau utang teknis
   - <hal yang ditunda, bug yang diketahui>

8. Langkah berikutnya
   - <tugas selanjutnya dan siapa yang mengerjakan>

9. Status gerbang blok: BELUM / LOLOS
```

### 4.2 Prompt untuk meminta AI membuat laporan

Tempel ke percobaan AI yang sama (yang tahu kode apa saja yang baru dibuat), setelah Anda menjalankan aplikasinya:

```text
Saya baru selesai mengerjakan tugas: <tulis tugas, misalnya "AuthService dan layar Masuk/Daftar">.

Buatkan Laporan Selesai Kode dengan template berikut, dalam Bahasa Indonesia yang ringkas.
Isi hanya berdasarkan kode dan perubahan yang benar-benar kita buat di percakapan ini.
Jangan mengarang hasil uji: bagian "Cara menguji dan hasilnya" biarkan saya yang isi
atau tulis "belum diuji" jika tidak ada informasinya.
Jangan menyertakan API key atau isi file .env.

[tempel template dari bagian 4.1]
```

Catatan: hasil uji (LULUS atau GAGAL) harus diisi manusia setelah benar-benar menjalankan aplikasi. AI hanya bisa merangkum kode yang ia tulis, bukan memastikan kode itu berjalan.

### 4.3 Contoh laporan terisi

```text
LAPORAN L-04: Login dan daftar dengan Firebase Auth
Tanggal/jam   : Sabtu, jam 14.00
Penanggung jawab: Dina (B: Data dan Firebase)
Branch/commit : feature/auth - "feat: auth service dan layar masuk/daftar"

1. Tujuan tugas
   Pengguna bisa mendaftar, masuk, dan keluar, dan sesi tetap tersimpan.

2. Yang sudah dikerjakan
   - AuthService (register, login, logout, authChanges)
   - Layar Masuk/Daftar terhubung ke AuthService
   - Pesan error Bahasa Indonesia untuk sandi salah dan email terpakai

3. File yang dibuat atau diubah
   - lib/services/auth_service.dart : pembungkus FirebaseAuth
   - lib/screens/auth_screen.dart   : form dan penanganan error
   - lib/main.dart                  : StreamBuilder untuk memilih layar awal

4. Package atau konfigurasi yang ditambah
   - firebase_auth, provider Email/Password diaktifkan di konsol

5. Cara menguji dan hasilnya
   - Langkah: daftar akun baru, tutup aplikasi, buka lagi, lalu keluar
   - Hasil  : LULUS

6. Masalah yang ditemui dan solusinya
   - Build gagal karena minSdkVersion; dinaikkan di android/app/build.gradle

7. Yang belum selesai atau utang teknis
   - Belum ada fitur lupa sandi (ditunda, tidak masuk MVP)

8. Langkah berikutnya
   - Parse JSON Gemini ke model CareerResult (Citra, peran C)

9. Status gerbang blok: BELUM (Blok C masih berjalan)
```

Contoh ini hanya ilustrasi format; nama dan isinya bukan hasil kerja sungguhan.

### 4.4 Log laporan

Isi kolom status dan tempel ringkasan laporan (atau tautan ke berkas laporan di repo, misalnya folder `reports/`).

| ID | Setelah tugas | Penanggung jawab | Waktu | Hasil uji | Ringkasan atau tautan |
| --- | --- | --- | --- | --- | --- |
| L-01 | Persiapan alat, repo, dan prompt di AI Studio |  |  |  |  |
| L-02 | UI statis semua layar dengan data dummy |  |  |  |  |
| L-03 | Firebase terpasang dan terinisialisasi |  |  |  |  |
| L-04 | Login, daftar, keluar, sesi bertahan |  |  |  |  |
| L-05 | Gemini terhubung ke alur asli |  |  |  |  |
| L-06 | Alur lengkap dari login sampai hasil |  |  |  |  |
| L-07 | Riwayat tersimpan di Firestore |  |  |  |  |
| L-08 | Stabilisasi dan perbaikan bug | Sabrina (D) | 2026-11-14 | LULUS parsial: 0 error/0 warning, 27/27 uji otomatis; AI live 0/5 karena HTTP 429 (kuota key) & cloud MENUNGGU | [L-08](HASIL-KERJA.md#l-08) |
| L-09 | Fitur pembeda dan polish |  |  |  |  |
| L-10 | Build rilis dan kondisi akhir | Sabrina (D) | 2026-11-14 | TERHAMBAT: `google-services.json` tidak ada; APK belum dihasilkan | [L-10](HASIL-KERJA.md#l-10) |

### 4.5 Kegunaan laporan

- **Selama lomba:** menjaga semua anggota tahu status terbaru, terutama saat bergantian istirahat.
- **Saat bug muncul:** bisa melacak kapan dan di tugas mana sesuatu berubah.
- **Setelah lomba:** bahan langsung untuk README, bagian "cara kerja" di slide, dan jawaban pertanyaan juri tentang proses pengembangan.

## 5. Pitch, Rencana Cadangan, dan Pengumpulan

Pitch yang kuat bercerita tentang satu orang nyata, menunjukkan produk berjalan, lalu menutup dengan dampak; demo langsung selalu dibarengi rencana cadangan.

### 5.1 Struktur pitch 3 menit

| Waktu | Isi | Pembicara |
| --- | --- | --- |
| 0:00–0:30 | Masalah: cerita singkat satu mahasiswa yang bingung memilih karier, plus 1–2 angka dari survei mini | Pembicara 1 |
| 0:30–1:00 | Solusi: CareerPath AI dalam satu kalimat dan cara kerja singkat (login, asesmen, Gemini, hasil tersimpan) | Pembicara 1 |
| 1:00–2:15 | Demo langsung: masuk dengan akun demo, asesmen (mode demo), analisis, hasil, detail roadmap, riwayat | Pembicara 2 mengoperasikan, Pembicara 1 menarasikan |
| 2:15–2:45 | Teknis ringkas: Flutter, Gemini JSON terstruktur, Firebase Auth dan Firestore, alasan transparan | Pembicara 1 |
| 2:45–3:00 | Penutup: rencana lanjutan dan satu kalimat dampak | Pembicara 1 |

### 5.2 Rencana cadangan (Plan B)

1. Gemini lambat atau gagal: tekan hasil contoh dan katakan jujur bahwa itu hasil contoh karena koneksi venue kurang stabil.
2. Internet venue mati: pindah ke hotspot.
3. Login bermasalah: pakai akun demo yang sudah masuk sebelumnya di HP cadangan.
4. Aplikasi crash: buka HP cadangan, atau putar video demo cadangan.
5. Waktu dipotong: lewati penjelasan teknis, tetap tampilkan demo dan penutup.

### 5.3 Pertanyaan juri yang mungkin muncul

| Pertanyaan | Poin jawaban |
| --- | --- |
| Seberapa akurat rekomendasinya? | Hasil adalah saran awal, bukan keputusan. Diuji dengan 5 skenario dan survei pengguna; ke depan divalidasi dengan konselor karier |
| Mengapa tidak memakai tes karier yang sudah ada? | Tes biasa berhenti di hasil; kami menambah skill gap dan roadmap 4 minggu yang personal |
| Bagaimana keamanan data pengguna? | Login Firebase, aturan Firestore membatasi akses ke data milik sendiri, hanya jawaban asesmen yang dikirim ke Gemini; produksi memindahkan panggilan Gemini ke backend |
| Mengapa Firebase? | Dukungan Flutter paling matang dan data berbentuk dokumen JSON cocok dengan output Gemini |
| Bagaimana jika AI salah atau mengarang? | Pilihan karier dibatasi daftar tetap, output dipaksa JSON, ada disclaimer, alasan transparan |
| Bagaimana keberlanjutannya? | Kemitraan dengan career center kampus dan bootcamp, versi premium untuk konsultasi dan pelacakan progres (sebutkan sebagai rencana) |
| Apa langkah berikutnya? | Backend aman, Google Sign-In, chat konsultasi, analisis CV, rekomendasi kursus |

### 5.4 Isi slide (maksimal 7)

1. Judul, tagline, nama tim
2. Masalah (cerita dan angka survei)
3. Solusi (satu tangkapan layar hasil)
4. Cara kerja (diagram sederhana: Pengguna, Aplikasi Flutter, Firebase, Gemini, Hasil)
5. Demo (slide pengingat, demo berjalan di HP)
6. Hasil uji dan keterbatasan jujur
7. Rencana lanjutan dan penutup

Gunakan data survei dan hasil uji tim sendiri; jangan mengarang statistik.

### 5.5 Checklist pengumpulan

- [ ] Repo GitHub rapi, README lengkap, tidak ada API key
- [ ] Slide dan video demo terunggah sesuai ketentuan lomba
- [ ] Semua tautan sudah dibuka dari akun lain (bukan akun pribadi tim)
- [ ] APK final atau instruksi build tersedia jika diminta panitia
- [ ] Folder `reports/` atau log laporan di bagian 4.4 terisi sebagai bukti proses pengembangan
