# CareerPath AI — Materi Lengkap untuk PPT

Dokumen ini merancang isi slide presentasi (13 slide) dari aplikasi **CareerPath AI**, disusun dari `README.md`, `PRODUCT.md`, PRD, dan `PITCH-DEMO.md`. Naskah pitch 3 menit + demo tetap merujuk ke `PITCH-DEMO.md`.

**Aturan isi sebelum diekspor ke PowerPoint/Canva:**

- Jangan menaruh API key, isi `.env`, sandi, atau email akun demo di slide.
- Angka hanya yang terbukti (lihat `HASIL-KERJA.md`); placeholder `[...]` wajib diisi tim dengan data asli — jangan mengarang.
- Screenshot harus tangkapan layar asli; jika memakai data contoh, tampilkan label *“Contoh hasil (offline)”*.

---

## Slide 1 — Judul

- **CareerPath AI**
- Tagline: *Temukan karier cocok & rencana belajar 30 hari.*
- Nama tim + anggota: Aldi, Lutfi, Faji, Sabrina
- Ikon/logo aplikasi, warna latar konsisten dengan tema aplikasi

**Catatan pembicara:** buka dengan satu kalimat masalah (bukan daftar fitur).

---

## Slide 2 — Masalah

- Cerita singkat: mahasiswa sudah ikut tes karier, hasilnya hanya label (“tipe kreatif”) — lalu berhenti, tidak tahu langkah berikutnya.
- Survei mini tim: `[jumlah responden]` mahasiswa, `[x]%` bingung memilih karier, `[y]%` tidak punya rencana belajar.
- Insight: mahasiswa butuh **rekomendasi + langkah konkret**, bukan sekadar label kepribadian.

**Visual:** ilustrasi mahasiswa bingung / kutipan hasil survei.

---

## Slide 3 — Solusi

- Satu tangkapan layar asli layar hasil (3 kartu karier + skor + alasan).
- Tiga nilai utama:
  1. Rekomendasi **berdasarkan data jawaban** (bukan tebak-tebakan)
  2. **Skill gap** — skill yang sudah dimiliki vs perlu dilatih
  3. **Roadmap belajar 4 minggu / 30 hari** yang bisa langsung dikerjakan
- Janji inti: temukan arah dalam ~2 menit, dapat rencana belajar 30 hari.

---

## Slide 4 — Target Pengguna (Persona)

| Persona | Latar | Kebutuhan |
| --- | --- | --- |
| Rina, 20 th, semester 4 Sistem Informasi | Suka desain & logika, bingung antara web dev / UI-UX / data analyst | Tahu skill apa yang dipelajari 6 bulan ke depan |
| Dimas, 22 th, semester 7 Manajemen | Ingin masuk dunia digital tanpa latar teknis | Bidang yang cocok dengan kemampuan komunikasi + cara memulai |

- Target: mahasiswa semester 3–8 dan fresh graduate Indonesia, semua jurusan.

---

## Slide 5 — Fitur Utama

- **Auth email & kata sandi** (Firebase Auth) — sesi bertahan, tanpa Firebase tetap jalan mode lokal
- **Profil** — nama, jurusan, semester (validasi 1–14)
- **Asesmen minat** — 8 pertanyaan pilihan ganda + progress bar
- **Penilaian skill** — 6 slider nilai 1–5
- **Ringkasan & persetujuan** — tinjau jawaban, cegah submit ganda
- **Analisis AI (Gemini REST)** — JSON tervalidasi: tepat 3 karier dari 8 katalog, skor 0–100, alasan berbasis jawaban, skill gap, roadmap 4 minggu
- **Hasil & detail** — 3 kartu, disclaimer, skill dimiliki/kurang, roadmap
- **Career Journey** — pilih 1 fokus karier, checklist roadmap 30 hari, progres tersimpan
- **Riwayat** — buka hasil lama tanpa panggilan AI baru
- **Fallback** — hasil contoh offline berlabel jelas bila AI gagal

---

## Slide 6 — Cara Kerja (Arsitektur)

**Diagram:** Pengguna → Aplikasi Flutter → Firebase Auth/Firestore + Gemini (REST) → Hasil tervalidasi & tersimpan

Poin pendukung:

- Gemini dipaksa mengeluarkan JSON (`responseMimeType: application/json`); aplikasi **memvalidasi** struktur sebelum tampil: tepat 3 karier dari katalog 8, skor 0–100, roadmap 4 minggu.
- Rotasi model otomatis saat HTTP 404/429; fallback OpenAI; terakhir fallback contoh offline.
- Data: profil `users/{uid}`, hasil `users/{uid}/assessments/{id}` — aturan Firestore per-UID.
- Riwayat dibuka dari penyimpanan lokal/Firestore tanpa memanggil Gemini lagi.

---

## Slide 7 — Demo / Alur Pengguna

**Urutan alur (slide pengingat saat demo langsung di HP):**

Welcome → Masuk (akun demo) → Profil → Mulai Asesmen → 8 pertanyaan minat → 6 slider skill → Ringkasan + persetujuan → Analisis → 3 kartu hasil → Detail roadmap → Riwayat

- Target waktu analisis: < 15 detik (kondisi normal).
- Tunjukkan progress bar, skor yang bervariasi, dan alasan yang merujuk jawaban.
- Jika AI gagal: tekan **“Gunakan contoh hasil (tanpa AI)”** dan katakan terus terang itu contoh.

---

## Slide 8 — Fitur Unggulan: Career Journey (30 Hari)

- Pilih **satu** rekomendasi karier sebagai fokus.
- Checklist roadmap 30 hari dari Beranda: minggu aktif + langkah berikutnya.
- Progres disimpan lokal → bertahan setelah aplikasi dibuka ulang.
- Mengubah hasil asesmen sekali pakai menjadi **perjalanan belajar berkelanjutan** (prinsip produk: setiap rekomendasi berujung tindakan belajar yang jelas).

**Visual:** screenshot layar detail roadmap + checklist minggu aktif.

---

## Slide 9 — Teknologi

| Lapisan | Pilihan |
| --- | --- |
| Framework | Flutter (Dart), Material 3, Android 7.0+ |
| State management | Provider |
| Auth & database | Firebase Authentication + Cloud Firestore |
| Penyimpanan lokal | shared_preferences (mode lokal & cache riwayat) |
| AI utama | Gemini API (REST, JSON terstruktur, rotasi model) |
| AI cadangan | OpenAI Responses API (Structured Outputs, `store: false`) |
| Bahasa antarmuka | Bahasa Indonesia |

---

## Slide 10 — Status Pengembangan & Hasil Uji

**Angka yang terbukti (aman diklaim):**

- `flutter test` → **27/27 uji lulus** (widget, validasi kontrak JSON, local store, alur end-to-end lokal)
- `flutter analyze` → **0 error, 0 warning**
- Katalog: **8 karier / 8 pertanyaan / 6 skill**
- Endpoint Gemini terjangkau dari lingkungan QA
- Alur lokal end-to-end teruji: profil → hasil → detail → riwayat → ulangi

**Jujur — belum/belum tuntas:**

- Build rilis `google-services.json` belum tersedia → APK rilis terhambat
- 5 skenario AI live **0/5** — terkendala HTTP 429 kuota key (didahului 503/timeout)
- Belum ada uji 2 HP & verifikasi aturan Firestore dua akun (butuh akses cloud)

---

## Slide 11 — Keterbatasan & Mitigasi (jujur)

- Rekomendasi adalah **saran awal, bukan keputusan/jaminan karier** (disclaimer tampil di aplikasi).
- Output dibatasi 8 katalog + validasi JSON → mencegah AI “mengarang” karier liar.
- API key masih di sisi klien untuk **demo tertutup**; belum ada backend produksi/App Check.
- Analisis butuh internet + kuota API; tersedia fallback hasil contoh offline berlabel.
- Belum ada bukti pengguna nyata/testimoni — klaim hanya pada yang teruji.

---

## Slide 12 — Rencana Lanjutan (Roadmap Produk)

1. **Keamanan:** backend aman (Cloud Functions / Firebase AI Logic) + App Check untuk APK publik
2. **Akun:** Google Sign-In, verifikasi email
3. **Fitur:** analisis CV, rekomendasi kursus/sumber belajar, pelacakan progres skill, grafik minat
4. **Konsultasi:** chat karier berkonteks hasil asesmen
5. **Validasi & kemitraan:** uji bersama konselor karier kampus, kemitraan career center
6. **Ekspansi:** iOS, notifikasi, kartu hasil bisa dibagikan

---

## Slide 13 — Penutup

- Ulangi satu kalimat nilai: *“CareerPath AI mengubah kebingungan karier menjadi rencana 30 hari yang bisa dikerjakan hari ini.”*
- Nama tim + kontak/GitHub
- “Terima kasih — sesi tanya jawab”

---

## Lampiran A — Naskah 3 Menit & Demo

Gunakan bagian 2–3 di [`PITCH-DEMO.md`](PITCH-DEMO.md) (naskah per 3 pembicara + skenario 11 langkah demo). Peran: 1 operator HP, 1 narator, 2 penjawab teknis.

## Lampiran B — Checklist Pra-Ekspor

- [ ] Slide ≤ jumlah yang diizinkan panitia; periksa bebas API key/`.env`/sandi
- [ ] Placeholder `[n]`, `[x]%`, `[y]%` diisi data survei asli atau slide masalah disederhanakan
- [ ] Screenshot asli: Welcome, 3 kartu hasil, detail roadmap, Career Journey
- [ ] Semua klaim angka cocok dengan `HASIL-KERJA.md`
- [ ] Latihan pitch 2× dengan timer; siapkan Plan B (fallback, hotspot, HP cadangan)
