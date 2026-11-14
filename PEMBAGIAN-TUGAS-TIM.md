# Pembagian Tugas Tim — CareerPath AI

Dokumen ini merangkum **fitur yang dibutuhkan** (berdasarkan `CareerPath AI - Hackathon 1 Brainstorming.md`, `CareerPath AI - Hackathon 2 PRD.md`, dan `CareerPath AI - Hackathon 3 To-Do dan Laporan Progres.md`) dan membaginya menjadi **4 tanggung jawab** untuk tim beranggotakan 4 orang.

- **Prioritas:** **Must** = wajib untuk MVP/demo (selesai & teruji). **Should** = sangat disarankan. **Could** = nilai tambah jika waktu aman (setelah gerbang Blok C/D stabil).
- **Aturan kerja:** satu tugas bermakna → jalankan/uji → catat di `HASIL-KERJA.md` & sinkronkan checklist di To-Do. Jangan commit/share `.env`, API key, token, atau sandi.
- **Koordinasi:** sepakati satu pemilik project Firebase & Gemini key; integrasi lintas bagian (UI ↔ data ↔ AI) dilakukan via kontrak data (format input/JSON hasil sesuai PRD).

---

## Ringkasan fitur yang dibutuhkan (acuan)

| Kode/Area | Fitur yang dibutuhkan | Prioritas | Kriteria ringkas |
|---|---|---|---|
| Auth | Daftar, masuk, keluar (Firebase Auth email/password), sesi bertahan | Must | Akun muncul di console, tutup-buka app tetap login, logout bersih |
| Profil | Profil singkat (nama, jurusan, semester) tersimpan & termuat ulang | Must | Tampil kembali setelah login/di perangkat lain (cloud) |
| Asesmen | 8 pertanyaan minat + 6 skill (1–5), progress, validasi wajib isi, kembali tidak menghapus jawaban | Must | Tombol lanjut/analisis aktif hanya saat lengkap |
| Analisis AI | Kirim data ke Gemini, terima & parse JSON valid | Must | Output sesuai format PRD, stabil diulang |
| Hasil | 3 kartu karier (judul, skor 0–100, alasan berbasis data) dari **8 karier katalog** | Must | Tepat 3, skor wajar (tidak semua 100), alasan relevan |
| Detail | Skill dimiliki, skill kurang, roadmap 30 hari (4 minggu, aksi konkret) | Must | Tampil lengkap & terbaca |
| Penyimpanan | Simpan hasil ke Firestore & tampilkan riwayat; buka hasil lama tanpa panggil Gemini | Must | Riwayat muncul/sinkron; bedakan gagal analisis vs gagal simpan |
| UX & Keandalan | Loading, error jelas + coba lagi, state kosong/gagal, navigasi welcome/contoh offline | Must | Tidak crash saat offline/error; fallback/contoh tersedia |
| Kepatuhan | Disclaimer “saran awal, bukan keputusan karier” di hasil; pemberitahuan penggunaan data; izin INTERNET | Must | Teks tampil; privasi minim |
| Demo/Polish | Mode demo (isi contoh otomatis), fallback hasil contoh jika Gemini gagal, ikon/nama/splash rapi | Should | Demo aman & cepat |
| Nilai tambah | Google Sign-In, share kartu hasil, grafik radar minat | Could | Hanya jika Must stabil & waktu cukup |
| Di luar MVP | Upload CV, chat bebas, iOS/web, backend sembunyikan key (produksi) | Won’t (hackathon) | Sebut rencana lanjutan |

**Katalog & data tetap:** 8 karier, 8 pertanyaan minat, 6 skill (lihat `lib/data/*` / PRD). **Format hasil:** `summary` + `careers[]` (`title`, `match_score`, `reason`, `skills_owned`, `skills_missing`, `roadmap[4]`).

---

## Orang 1 — Aldi (UI/UX, Layar & Navigasi)

**Fokus:** pengalaman pengguna, tampilan, dan alur antarmuka end-to-end sesuai PRD (peran mirip A: Flutter UI).

### Tanggung jawab utama
- [ ] **Welcome & navigasi awal (Must):** layar sambutan dengan *Masuk/Daftar*, *Mulai asesmen*, *Jelajahi contoh hasil (offline)*; arahkan sesi/profil sesuai alur.
- [ ] **Auth UI (Must):** layar Masuk/Daftar (form, validasi dasar, tampilkan pesan error ramah dari backend), tombol keluar di beranda/profil.
- [ ] **Profil UI (Must):** form nama, jurusan, semester + validasi & edit.
- [ ] **Asesmen minat (Must):** 8 pertanyaan pilihan, progress bar, semua wajib terisi, tombol lanjut aktif/nonaktif tepat.
- [ ] **Asesmen skill (Must):** 6 slider 1–5, indikator terisi, progress.
- [ ] **Ringkasan (Must):** tampilkan jawaban & profil, bisa kembali ubah, **pemberitahuan/persetujuan penggunaan data** sebelum kirim, cegah submit ganda.
- [ ] **Loading/Analisis (Must):** layar proses saat panggil AI/simpan.
- [ ] **Hasil & Detail (Must):** 3 kartu karier (judul, skor, alasan), detail (skill dimiliki/kurang, roadmap 4 minggu), label **contoh hasil/offline** bila relevan, **disclaimer** tampil jelas.
- [ ] **Beranda & Riwayat (Must):** daftar riwayat, state kosong, buka detail hasil lama, tombol ulangi asesmen (reset jawaban sesuai aturan).
- [ ] **State & aksesibilitas dasar (Must):** empty/loading/error/try-again konsisten, teks Indonesia jelas, layout aman di layar kecil (hindari overflow).
- [ ] **Polish (Should):** tema konsisten (buku kerja karier), splash/ikon/nama app rapi.

### Deliverable
- Layar & widget di `lib/screens/*`, `lib/widgets/*`, navigasi mulus, UI siap terhubung ke provider/service.
- Bukti uji manual alur UI (screenshot/catatan di `HASIL-KERJA.md`).

### Ketergantungan
- Kontrak data & fungsi dari **Lutfi** (auth/profil/riwayat) dan **Faji** (hasil analisis/fallback/error). Koordinasi field & state dengan tim.

---

## Orang 2 — Lutfi (Firebase, Auth, Data & Penyimpanan)

**Fokus:** autentikasi, profil, Firestore, riwayat, dan keandalan data (peran mirip B: Data & Firebase).

### Tanggung jawab utama
- [ ] **Setup & konfigurasi Firebase (Must):** hubungkan project `careerpath-e3adb` via `flutterfire configure --platforms=android`, pastikan `firebase_options.dart` & inisialisasi (`DefaultFirebaseOptions.currentPlatform`) benar.
- [ ] **Authentication (Must):** Email/Password aktif; implementasi daftar/masuk/keluar, pantau `authStateChanges`, sesi bertahan, pemetaan error ke pesan Indonesia (sandi salah, email terpakai, jaringan, dll).
- [ ] **Profil (Must):** simpan/muat profil (`name, major, semester`) ke `users/{uid}` (merge aman) dan sinkron dengan state lokal.
- [ ] **Penyimpanan hasil (Must):** simpan tiap asesmen ke `users/{uid}/assessments/{assessmentId}` (`createdAt` server, `input`, `result`, flag contoh bila ada); pastikan **analisis sukses tetap bisa ditampilkan** meski simpan gagal (laporkan error simpan terpisah).
- [ ] **Riwayat (Must):** ambil/tampilkan riwayat urut terbaru; buka hasil lama **tanpa** memanggil Gemini ulang; dukung fallback lokal bila cloud belum siap/error (sesuai desain app).
- [ ] **Keamanan data (Must):** pastikan **Firestore Rules** per-UID dipublish & diuji (A tidak bisa baca/tulis B), hindari mode test terbuka.
- [ ] **Kebersihan sesi (Must):** saat logout bersihkan state/profil/riwayat lokal yang tidak boleh bocor antar akun.
- [ ] **Dokumentasi konfigurasi (Must):** catat langkah non-rahasia, applicationId/Project ID yang dipakai, dan status verifikasi di `HASIL-KERJA.md`.

### Deliverable
- Layanan & integrasi di `lib/services/*` (auth/firestore/backend/local), wiring ke provider/UI, rules terverifikasi.
- Bukti: akun uji di Auth console, dokumen Firestore terbentuk, uji login ulang & (jika mungkin) dua perangkat.

### Ketergantungan
- UI dari **Aldi**; format `input/result` dari **Faji**. Butuh akses Console (pemilik project) untuk verifikasi.

---

## Orang 3 — Faji (Gemini AI, Prompt, Validasi & Fallback)

**Fokus:** kualitas analisis AI, kontrak JSON, dan ketahanan saat error (peran mirip C: AI).

### Tanggung jawab utama
- [ ] **Konfigurasi Gemini (Must):** jalur **A (REST, demo tertutup)** — `.env` (`GEMINI_API_KEY`, `GEMINI_MODEL`), model Flash yang mendukung JSON & tersedia; pastikan pemanggilan `generateContent` sesuai (header, `responseMimeType: application/json`, timeout).
- [ ] **Prompt & kontrak output (Must):** system/user prompt menghasilkan **tepat 3 karier** dari **8 katalog**, alasan merujuk data pengguna, `match_score` 0–100 (tidak semua 100), **roadmap 4 minggu** dengan aksi konkret & realistis, Bahasa Indonesia, tanpa janji gaji/diterima kerja.
- [ ] **Parsing & validasi (Must):** parse JSON aman (`try/catch`), validasi struktur (summary, careers, skor, roadmap 1–4), tolak/handle respons tidak valid dengan pesan & opsi coba lagi.
- [ ] **Integrasi alur (Must):** sambungkan “Analisis dengan AI” ke input asesmen nyata, cegah klik ganda, tampilkan error yang dapat dipahami (key/model/kuota/jaringan/timeout).
- [ ] **Fallback & mode demo (Should):** sediakan/rapikan **contoh hasil** (`data/sample_result.dart`) saat Gemini gagal/belum dikonfigurasi; dukung alur demo cepat; beri label jelas “contoh/offline”.
- [ ] **Kualitas & uji AI (Must):** uji berulang (≥10 panggilan saat memungkinkan), cek konsistensi format, relevansi alasan, dan kepatuhan katalog; perbaiki prompt bila perlu.
- [ ] **Catatan integrasi (Should):** dokumentasikan keputusan jalur A vs kebutuhan jalur B (Firebase AI Logic + App Check) untuk distribusi APK di `HASIL-KERJA.md`.

### Deliverable
- `lib/services/gemini_service.dart`, validator/parser, data contoh/fallback yang konsisten dengan PRD.
- Bukti uji: contoh request/hasil teranonim (tanpa key/data sensitif), status sukses/gagal & perbaikan.

### Ketergantungan
- Input terstruktur dari **Aldi** (asesmen/profil) dan penyimpanan dari **Lutfi**. Butuh API key & model valid (pemilik).

---

## Orang 4 — Sabrina (QA, Dokumentasi, Pitch & Rilis)

**Fokus:** jaminan kualitas, bukti uji, keamanan dasar, dan kesiapan demo/pengumpulan (peran mirip D: Pitch & QA).

### Tanggung jawab utama
- [ ] **Rencana & eksekusi QA (Must):** jalankan **5 skenario uji** PRD (profil teknis, kreatif, non-teknis, semua skill 1, semua skill 5) dan checklist fungsional/AI/error di To-Do; catat hasil di `HASIL-KERJA.md`.
- [ ] **Uji Firebase & keamanan akses (Must):** verifikasi login/logout/sesi, data di Firestore, uji aturan (akun A vs B, bukan test mode), serta perilaku offline.
- [ ] **Keamanan & kebersihan repo (Must):** pastikan `.env` & rahasia tidak ter-commit/terbocor, izin `INTERNET` ada, tidak ada key di README/slide/video; koordinasi rotasi key jika pernah terekspos.
- [ ] **Bug log & triase (Must):** catat bug (Fatal/Besar/Kecil, langkah ulang, PIC, status) dan dorong perbaikan prioritas sebelum freeze.
- [ ] **Build & uji rilis (Must):** bantu `flutter build apk --release`, uji di ≥2 perangkat bila memungkinkan, cek perilaku mode rilis.
- [ ] **Dokumentasi (Must):** perbarui **README** (cara run, setup `.env`, setup Firebase/flutterfire, fitur, screenshot/tim) dan rapikan **`HASIL-KERJA.md`** / log L-xx sesuai progres tim.
- [ ] **Pitch & demo (Must):** siapkan slide (≤7) & naskah 3 menit, skenario demo (akun demo, data contoh, hotspot cadangan), video cadangan, dan jawaban Q&A juri.
- [ ] **Checklist pengumpulan (Must):** tautan repo/slide/video dapat diakses, aset final sesuai ketentuan lomba.

### Deliverable
- Laporan QA & bug log, README & materi demo siap pakai, bukti uji rilis/perangkat (jika ada).
- Koordinasi “code freeze” dan kesiapan presentasi.

### Ketergantungan
- Seluruh tim untuk perbaikan bug & bukti fitur; akses build/device & akun demo.

---

## Koordinasi lintas tim (disepakati bersama)

1. **Kontrak data:** samakan struktur `input` asesmen dan `result` JSON (PRD) agar UI, simpanan, dan AI kompatibel.
2. **Definition of Done bersama:** fitur Must teruji (alur login→asesmen→analisis→hasil→riwayat, fallback/error, rules aman) dan tercatat buktinya.
3. **Pembagian waktu kritis:** stabilkan Blok C (alur penuh) sebelum tambah fitur Could; utamakan perbaikan bug Fatal.
4. **Integrasi Gemini/Firebase:** satu keputusan jalur (A demo / rencana B distribusi) dicatat; kredensial hanya dikelola pemilik.

*Terakhir diperbarui: 2026-11-14 (dihasilkan dari dokumen PRD, Brainstorming, To-Do, Panduan, dan status repo saat ini).*
