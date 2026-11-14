# CareerPath AI — Paket Pitch & Demo (3 menit)

Dokumen kerja peran **D (Sabrina)**: slide maksimal 7, naskah 3 menit, skenario demo, rencana cadangan, jawaban juri, dan checklist pengumpulan. Isi yang bertanda `[...]` **wajib diisi tim dengan data asli** — jangan mengarang statistik.

- Aplikasi: Android Flutter, Firebase Auth/Firestore, Gemini REST (JSON).
- Akun demo: `[email akun demo]` / `[sandi — hanya di HP demo, jangan di slide/repo]`.
- Hasil uji & bug: lihat [`HASIL-KERJA.md`](HASIL-KERJA.md) bagian L-08/L-10.

## 0. Status pengisian (2026-11-14, peran D)

| Bagian | Status | Catatan |
| --- | --- | --- |
| 7 slide (isi) | SIAP di dokumen ini | Perlu diekspor ke PowerPoint/Canva; jangan menaruh key/`.env` di slide |
| Naskah 3 menit | SIAP (draf) | Latihan 2× dengan timer belum |
| Survei mini (angka masalah) | **BELUM** | Wajib diisi tim dengan data responden asli; jangan mengarang |
| Tangkapan layar asli | **BELUM** | Ambil Welcome, hasil 3 kartu, detail roadmap dari HP; percobaan render headless (golden test) menggantung di lingkungan QA sehingga dibatalkan |
| Akun demo + 1 riwayat | **BELUM** | Buat setelah Firebase/build beres |
| Video demo cadangan | **BELUM** | Rekam setelah APK rilis jalan |
| Hasil uji untuk Slide 6 | SEBAGIAN | 27/27 uji otomatis lulus; build rilis belum; 5 skenario AI live **dicoba, gagal karena kuota key (HTTP 429)** |

**Angka yang sudah terbukti (aman diklaim):** 27 uji otomatis lulus; `flutter analyze` 0 error/0 warning; katalog 8 karier/8 pertanyaan/6 skill; validasi kontrak JSON diuji; alur lokal end-to-end (profil → hasil → detail → riwayat → ulangi) diuji; endpoint Gemini terjangkau dari lingkungan QA.

**Jangan diklaim sebelum ada bukti:** “akurat”, “5 skenario AI lulus”, “APK rilis siap”, “sudah diuji 2 HP”. Uji live 2026-11-14 berakhir **0/5** (503/timeout, lalu HTTP 429 kuota habis) — lihat [`HASIL-KERJA.md`](HASIL-KERJA.md#l-08).

---

## 1. Tujuh slide

### Slide 1 — Judul
- **CareerPath AI**
- *Temukan karier cocok & rencana belajar 30 hari.*
- Nama tim + anggota: Aldi, Lutfi, Faji, Sabrina.
- Catatan pembicara: sebut satu kalimat masalah yang dijawab (bukan daftar fitur).

### Slide 2 — Masalah
- Cerita singkat satu mahasiswa: bingung memilih karier, tes karier berhenti di “tipe kepribadian”, tidak tahu langkah berikutnya.
- Angka survei mini tim: `[jumlah responden]` mahasiswa, `[x]%` merasa bingung memilih karier, `[y]%` tidak punya rencana belajar.
- Insight: mahasiswa butuh **rekomendasi + langkah konkret**, bukan label.

### Slide 3 — Solusi
- Satu tangkapan layar asli layar hasil (3 kartu karier + skor + alasan).
- Tiga nilai: rekomendasi **dari data jawaban**, **skill gap**, **roadmap 4 minggu**.
- Catatan: tampilkan label “Contoh hasil (offline)” bila screenshot memakai data contoh.

### Slide 4 — Cara kerja
Diagram sederhana: **Pengguna → Aplikasi Flutter → Firebase Auth/Firestore + Gemini → Hasil tersimpan**.
- Asesmen 8 minat + 6 skill (1–5).
- Gemini dipaksa menjawab JSON; aplikasi memvalidasi 3 karier dari 8 katalog, skor 0–100, roadmap 4 minggu.
- Riwayat dibuka tanpa memanggil Gemini lagi; ada fallback contoh jika AI gagal.

### Slide 5 — Demo
- Slide pengingat alur: Welcome → Masuk (akun demo) → Mulai asesmen → 8 minat → 6 skill → Ringkasan + persetujuan → Analisis → 3 kartu → Detail roadmap → Riwayat.
- Demo dilakukan langsung di HP; slide ini hanya jangkar bila proyektor lambat.

### Slide 6 — Hasil uji & keterbatasan jujur
- Isi dari `HASIL-KERJA.md` (per 2026-11-14): **27/27 uji otomatis lulus**; `flutter analyze` **0 error/0 warning**; **build rilis belum** (`google-services.json` belum tersedia); **5 skenario AI live belum lulus** — endpoint Gemini kini terjangkau, tetapi panggilan berakhir HTTP **429 kuota key habis** (didahului 503/timeout).
- Keterbatasan: saran awal bukan keputusan final; key demo masih di sisi klien untuk demo tertutup; belum ada backend produksi/App Check; analisis butuh internet dan kuota key yang cukup.
- Jangan mengklaim “akurat” — klaim “konsisten format, alasan transparan, diuji dengan skenario”. Bila angka 5 skenario belum teruji saat presentasi, katakan jujur “pengujian live terkendala kuota key; format & validasi sudah diuji otomatis, dan hasil contoh tersedia offline”.

### Slide 7 — Rencana lanjutan & penutup
- Backend aman/Firebase AI Logic + App Check untuk APK publik.
- Google Sign-In, analisis CV, rekomendasi kursus, pelacakan progres, kemitraan career center kampus.
- Penutup: *“CareerPath AI mengubah kebingungan karier menjadi rencana 30 hari yang bisa dikerjakan hari ini.”*

---

## 2. Naskah 3 menit

| Waktu | Pembicara | Naskah (ringkas, boleh diadaptasi) |
| --- | --- | --- |
| 0:00–0:30 | Pembicara 1 (Sabrina) | “Bayangkan seorang mahasiswa semester 4. Ia sudah mencoba tes karier, hasilnya ‘tipe kreatif’ — lalu bingung: langkah berikutnya apa? Survei mini kami ke `[n]` mahasiswa menunjukkan `[x]%` merasakan hal yang sama. Masalahnya bukan kurang tes, tapi tidak ada rencana tindakan.” |
| 0:30–1:00 | Pembicara 1 | “CareerPath AI menjawab itu. Mahasiswa mengisi 8 pertanyaan minat dan 6 skill, lalu Gemini memberi tiga karier paling cocok, alasan berbasis jawaban, skill yang perlu dilatih, dan roadmap 30 hari. Semua tersimpan sehingga bisa dibuka lagi tanpa memanggil AI.” |
| 1:00–2:15 | Pembicara 2 (Aldi) + operator | “Saya tunjukkan. Masuk dengan akun demo → Mulai asesmen → jawab 8 pertanyaan dan 6 slider → ringkasan, centang persetujuan → Analisis. Ini tiga kartu hasil: UI/UX Designer 88, Frontend Developer 79, Product Manager 72 — skornya bervariasi, alasannya menyebut jawaban saya. Buka detail: skill yang sudah dimiliki, yang perlu dilatih, dan roadmap Minggu 1–4. Kembali, hasil ini ada di riwayat dan bisa dibuka tanpa internet.” |
| 2:15–2:45 | Pembicara 1 | “Di balik layar: Flutter, Firebase Auth dan Firestore per pengguna, serta Gemini yang dipaksa mengeluarkan JSON. Aplikasi memvalidasi tepat tiga karier dari delapan katalog, skor 0–100, dan roadmap empat minggu — jadi output tidak liar. Ada disclaimer: ini saran awal, bukan keputusan karier.” |
| 2:45–3:00 | Pembicara 1 | “Langkah berikutnya: backend aman, App Check, dan kemitraan career center kampus. CareerPath AI mengubah kebingungan karier menjadi rencana 30 hari yang bisa dikerjakan hari ini. Terima kasih.” |

**Pembagian peran saat demo:** 1 orang mengoperasikan HP, 1 orang menarasikan, 2 orang menjawab pertanyaan teknis (Firebase/AI) saat Q&A. Tulis nama di kartu catatan.

> Catatan skrip: angka **UI/UX Designer 88, Frontend Developer 79, Product Manager 72** berasal dari `data/sample_result.dart`. Saat demo AI asli, sebut skor yang benar-benar muncul; saat memakai fallback, sebut terus terang “ini hasil contoh”.

---

## 3. Skenario demo (urutan klik)

1. Buka aplikasi → layar **Welcome** (jangan menunggu lama di splash).
2. Tayangkan **Jelajahi contoh hasil (offline)** ±10 detik sebagai jaring pengaman, lalu kembali.
3. **Masuk / Daftar** dengan akun demo yang sudah punya riwayat.
4. Dari Beranda: **Mulai / Ulangi Asesmen** → isi profil (sudah terisi) → lanjut.
5. Jawab 8 pertanyaan minat; tunjukkan progress bar bergerak.
6. Geser 6 slider skill; tunjukkan angka terisi.
7. **Lihat ringkasan** → centang persetujuan data → **Analisis dengan AI**.
8. Tunggu hasil (target < 15 detik). Tunjukkan 3 kartu, skor berbeda, label/disclaimer.
9. Buka satu kartu → skill dimiliki/kurang + roadmap 4 minggu.
10. Kembali → Beranda → buka item **Riwayat** (tanpa memanggil Gemini).
11. Tutup dengan slide rencana lanjutan.

**Kalimat jujur bila memakai fallback:** “Koneksi venue sedang kurang stabil, jadi saya tampilkan hasil contoh yang tersedia offline — formatnya sama dengan hasil AI.”

---

## 4. Rencana cadangan (Plan B)

| Risiko | Tindakan |
| --- | --- |
| Gemini lambat/gagal/kuota (termasuk **HTTP 429**) | Tekan **Gunakan contoh hasil (tanpa AI)**; katakan terus terang itu contoh. Jika 429 muncul saat gladi, minta pemilik mengganti key/menambah kuota sebelum demo. |
| Internet venue mati | Pindah ke hotspot cadangan yang sudah diuji. |
| Login bermasalah | Pakai HP cadangan yang sudah login dengan akun demo. |
| Aplikasi crash | Buka HP cadangan atau putar video demo cadangan. |
| Waktu dipotong | Lewati teknis, tetap tampilkan hasil + roadmap + penutup. |
| Proyektor bermasalah | Narasikan sambil memegang HP; slide hanya pendukung. |

**Sebelum berangkat:** rekam video demo (layar + suara) memakai urutan bagian 3, simpan di HP dan laptop, dan unggah ke drive tim.

---

## 5. Jawaban pertanyaan juri

| Pertanyaan | Poin jawaban |
| --- | --- |
| Seberapa akurat rekomendasinya? | Ini saran awal, bukan keputusan. Output dibatasi 8 katalog, divalidasi struktur/skor/roadmap, dan diuji dengan 5 skenario. Validasi bersama konselor karier adalah rencana lanjutan. |
| Bedanya dengan tes karier biasa? | Tes biasa berhenti di label; kami memberi skill gap dan roadmap 4 minggu yang bisa langsung dikerjakan. |
| Keamanan data pengguna? | Auth Firebase, data per-UID di `users/{uid}`, aturan Firestore membatasi akses ke pemilik data; hanya jawaban asesmen yang dikirim ke Gemini. Untuk produksi, panggilan Gemini dipindah ke backend. |
| Mengapa Firebase? | Dukungan Flutter matang, dokumen JSON cocok dengan output Gemini, Auth + Firestore mempercepat MVP. |
| Bagaimana jika AI salah/mengarang? | Pilihan dibatasi 8 karier, output wajib JSON dan divalidasi; alasan harus merujuk jawaban; ada disclaimer. Respons tidak valid ditolak dan pengguna bisa coba lagi. |
| Apa yang belum selesai? | Build rilis perlu `google-services.json` + keputusan jalur B (AI Logic/App Check); kuota API key Gemini sedang habis (HTTP 429) sehingga uji live harus diulang; verifikasi 2 perangkat dan aturan Firestore dua akun masih menunggu akses cloud. |
| Bagaimana keberlanjutan? | Kemitraan career center kampus/bootcamp, versi premium untuk konsultasi dan pelacakan progres, analisis CV. |
| Apa langkah berikutnya? | Backend aman, App Check, Google Sign-In, analisis CV, rekomendasi kursus. |

---

## 6. Checklist pra-demo

- [ ] APK rilis terpasang di HP demo dan satu HP cadangan.
- [ ] Akun demo dibuat dan sudah punya minimal satu hasil di riwayat.
- [ ] Mode demo/hasil contoh berfungsi tanpa internet.
- [ ] Video demo cadangan tersimpan di HP dan laptop.
- [ ] Hotspot cadangan diuji dan terhubung ke HP demo.
- [ ] Baterai penuh, mode jangan ganggu aktif, kecerahan maksimal, notifikasi mati.
- [ ] Latihan pitch 3 menit minimal 2 kali dengan pengukur waktu.
- [ ] Jelas siapa mengoperasikan HP, siapa bicara, siapa menjawab teknis.
- [ ] Slide ≤ 7 dan tidak memuat API key/isi `.env`.

## 7. Checklist pengumpulan

- [ ] Repo GitHub rapi, README lengkap, tidak ada API key atau `.env`.
- [ ] Slide dan video demo diunggah sesuai ketentuan lomba.
- [ ] Semua tautan dibuka dari akun lain (bukan akun pribadi tim).
- [ ] APK final atau instruksi build tersedia bila diminta panitia.
- [x] Log laporan/L-xx dan bug log terisi di `HASIL-KERJA.md` sebagai bukti proses — **L-08/L-10 terisi** (2026-11-14).
- [ ] Screenshot asli (Welcome, hasil 3 kartu, detail roadmap) ditambahkan ke README/`docs/screenshots/`.

---

## 8. Data yang masih harus diisi tim (blokir pitch)

Isi hanya dengan bukti nyata; jangan mengarang angka.

- [ ] Jumlah responden survei mini + `x%` bingung karier + `y%` tanpa rencana belajar (Slide 2 & naskah).
- [ ] Akun demo (email) + 1 hasil di riwayat; sandi hanya di HP demo.
- [ ] Screenshot asli: Welcome, 3 kartu hasil, detail roadmap (Slide 3 & README).
- [ ] Status APK rilis + hasil uji 2 HP (Slide 6) — saat ini **TERHAMBAT**.
- [ ] Hasil 5 skenario AI live (Slide 6) — saat ini **0/5** karena HTTP 429 kuota key; jalankan `dart run tool/qa_live_gemini.dart` setelah kuota/key diperbarui dari jaringan yang bisa mengakses Gemini.
- [ ] Video demo cadangan (urutan bagian 3) tersimpan di HP + laptop.
- [ ] Slide diekspor ke file presentasi (≤7) dan diperiksa bebas key/`.env`.
- [ ] Latihan pitch 2× dengan timer; tentukan operator HP, pembicara, penjawab teknis.
- [ ] Latihan Plan B: fallback contoh, hotspot, HP cadangan.

**Definition of Done pitch:** semua checkbox di atas tercentang, semua tautan bisa dibuka dari akun lain, dan tidak ada klaim yang tidak didukung bukti di `HASIL-KERJA.md`.
