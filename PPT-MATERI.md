# CareerPath AI — Materi Lengkap untuk PPT (Versi Tanpa Firebase)

Dokumen ini merancang isi slide presentasi (13 slide) dari aplikasi **CareerPath AI** — **dalam mode lokal: tanpa login, tanpa Firebase Auth/Firestore**. Data disimpan di perangkat (`shared_preferences`). Naskah pitch 3 menit + demo tetap merujuk ke `PITCH-DEMO.md` (bagian yang menyebut akun demo/login **dihapus saat presentasi**).

**Aturan isi sebelum diekspor ke PowerPoint/Canva:**

- Jangan menaruh API key, isi `.env`, atau sandi di slide.
- **Jangan menyebut login, akun, Firebase Auth, Firestore, atau sinkronisasi cloud** — aplikasi dipresentasikan sebagai mode lokal penuh.
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

- **Langsung pakai tanpa login** — buka aplikasi → mulai asesmen; tanpa registrasi, tanpa data akun di server
- **Profil** — nama, jurusan, semester (validasi 1–14), disimpan di perangkat
- **Asesmen minat** — 8 pertanyaan pilihan ganda + progress bar
- **Penilaian skill** — 6 slider nilai 1–5
- **Ringkasan & persetujuan** — tinjau jawaban, cegah submit ganda
- **Analisis AI (Gemini REST)** — JSON tervalidasi: tepat 3 karier dari 8 katalog, skor 0–100, alasan berbasis jawaban, skill gap, roadmap 4 minggu
- **Hasil & detail** — 3 kartu, disclaimer, skill dimiliki/kurang, roadmap
- **Career Journey** — pilih 1 fokus karier, checklist roadmap 30 hari, progres tersimpan
- **Riwayat di perangkat** — buka hasil lama tanpa panggilan AI baru
- **Fallback** — hasil contoh offline berlabel jelas bila AI gagal

---

## Slide 6 — Cara Kerja (Arsitektur)

**Diagram:** Pengguna → Aplikasi Flutter → Penyimpanan lokal (`shared_preferences`) + Gemini (REST) → Hasil tervalidasi & tersimpan di perangkat

Poin pendukung:

- Gemini dipaksa mengeluarkan JSON (`responseMimeType: application/json`); aplikasi **memvalidasi** struktur sebelum tampil: tepat 3 karier dari katalog 8, skor 0–100, roadmap 4 minggu.
- Rotasi model otomatis saat HTTP 404/429; fallback OpenAI; terakhir fallback contoh offline.
- Profil, jawaban, hasil, riwayat, dan progres journey **hanya tersimpan di perangkat** — tidak ada server yang menampung data pengguna.
- Riwayat dibuka dari penyimpanan lokal tanpa memanggil Gemini lagi; aplikasi tetap berguna tanpa internet (hasil contoh + riwayat).

---

## Slide 7 — Demo / Alur Pengguna

**Urutan alur (slide pengingat saat demo langsung di HP):**

Welcome → **Mulai asesmen** (tanpa login) → Profil → 8 pertanyaan minat → 6 slider skill → Ringkasan + persetujuan → Analisis → 3 kartu hasil → Detail roadmap → Riwayat

- Target waktu analisis: < 15 detik (kondisi normal).
- Tunjukkan progress bar, skor yang bervariasi, dan alasan yang merujuk jawaban.
- Jika AI gagal: tekan **“Gunakan contoh hasil (tanpa AI)”** dan katakan terus terang itu contoh.
- Tunjukkan riwayat terbuka kembali setelah aplikasi ditutup → bukti data bertahan di perangkat.

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
| Penyimpanan lokal | `shared_preferences` — profil, riwayat, progres journey |
| AI utama | Gemini API (REST, JSON terstruktur, rotasi model) |
| AI cadangan | OpenAI Responses API (Structured Outputs, `store: false`) |
| Bahasa antarmuka | Bahasa Indonesia |
| Kebutuhan | Internet saat analisis; riwayat & fallback tetap jalan offline |

**Sudut pandang positif untuk dijual:** arsitektur lokal-first = sederhana, cepat, hemat infrastruktur, dan **privasi by design** (data tidak meninggalkan perangkat).

---

## Slide 10 — Status Pengembangan & Hasil Uji

**Angka yang terbukti (aman diklaim):**

- `flutter test` → **27/27 uji lulus** (widget, validasi kontrak JSON, local store, alur end-to-end lokal)
- `flutter analyze` → **0 error, 0 warning**
- Katalog: **8 karier / 8 pertanyaan / 6 skill**
- Endpoint Gemini terjangkau dari lingkungan QA
- Alur lokal end-to-end teruji: profil → hasil → detail → riwayat → ulangi

**Jujur — belum/belum tuntas:**

- 5 skenario AI live **0/5** — terkendala HTTP 429 kuota key (didahului 503/timeout)
- Build rilis APK belum final
- Belum ada uji lintas perangkat (pindah HP = data tidak ikut, karena memang lokal)

---

## Slide 11 — Keterbatasan & Mitigasi (jujur)

- Rekomendasi adalah **saran awal, bukan keputusan/jaminan karier** (disclaimer tampil di aplikasi).
- Output dibatasi 8 katalog + validasi JSON → mencegah AI “mengarang” karier liar.
- **Data hanya di perangkat:** hapus aplikasi = data ikut hilang; tidak ada cadangan cloud (sengaja untuk privasi MVP).
- Analisis butuh internet + kuota API; tersedia fallback hasil contoh offline berlabel.
- API key masih di sisi klien untuk demo; untuk rilis publik key dipindah ke backend.
- Belum ada bukti pengguna nyata/testimoni — klaim hanya pada yang teruji.

---

## Slide 12 — Rencana Lanjutan (Roadmap Produk)

1. **Keamanan rilis:** pindahkan panggilan AI ke backend agar API key aman
2. **Opsi akun & sinkronisasi (opsional):** login + cadangan cloud untuk pengguna yang mau, tetap ada mode lokal
3. **Fitur:** analisis CV, rekomendasi kursus/sumber belajar, grafik minat, kartu hasil bisa dibagikan
4. **Konsultasi:** chat karier berkonteks hasil asesmen
5. **Validasi & kemitraan:** uji bersama konselor karier kampus, kemitraan career center
6. **Ekspansi:** iOS, notifikasi, ekspor/impor riwayat antar perangkat

---

## Slide 13 — Penutup

- Ulangi satu kalimat nilai: *“CareerPath AI mengubah kebingungan karier menjadi rencana 30 hari yang bisa dikerjakan hari ini.”*
- Nama tim + kontak/GitHub
- “Terima kasih — sesi tanya jawab”

---

## Lampiran A — Jawaban Q&A yang Sering Muncul (tanpa Firebase)

| Pertanyaan | Poin jawaban |
| --- | --- |
| Kenapa tidak pakai login/database cloud? | Fokus MVP pada kualitas rekomendasi & roadmap. Mode lokal = tanpa gesekan registrasi, privasi by design, dan tidak butuh infrastruktur. Cloud bisa ditambahkan belakangan tanpa mengubah alur inti. |
| Kalau ganti HP, data hilang? | Ya, data memang hanya di perangkat (jujur). Rencana lanjutan: ekspor/impor atau opsi sinkronisasi. |
| Seberapa akurat rekomendasinya? | Saran awal, bukan keputusan. Output dibatasi 8 katalog, divalidasi struktur/skor/roadmap, diuji 27/27 otomatis. Validasi konselor = rencana lanjutan. |
| Bedanya dengan tes karier biasa? | Tes berhenti di label; kami beri skill gap + roadmap 4 minggu yang bisa langsung dikerjakan. |
| Bagaimana jika AI salah/mengarang? | Pilihan dibatasi 8 karier, output wajib JSON dan divalidasi, alasan merujuk jawaban, ada disclaimer; respons tidak valid ditolak. |
| Privasi data pengguna? | Jawaban asesmen hanya diproses untuk analisis dan **disimpan di perangkat**; tidak ada server penyimpan data pengguna. |
| Apa yang belum selesai? | Uji AI live terkendala kuota key (429); build rilis belum final; uji lintas perangkat tidak relevan untuk mode lokal. |
| Bagaimana keberlanjutan? | Kemitraan career center kampus, versi premium (konsultasi, pelacakan progres), analisis CV. |

## Lampiran B — Naskah 3 Menit & Demo

Merujuk bagian 2–3 [`PITCH-DEMO.md`](PITCH-DEMO.md) dengan **penyesuaian**: hapus langkah “Masuk dengan akun demo” — mulai langsung dari Welcome → Mulai asesmen. Peran: 1 operator HP, 1 narator, 2 penjawab teknis.

## Lampiran C — Checklist Pra-Ekspor

- [ ] Slide ≤ jumlah yang diizinkan panitia; periksa bebas API key/`.env`/sandi
- [ ] Tidak ada penyebutan login/akun/Firebase/Firestore di slide mana pun
- [ ] Placeholder `[n]`, `[x]%`, `[y]%` diisi data survei asli atau slide masalah disederhanakan
- [ ] Screenshot asli: Welcome, 3 kartu hasil, detail roadmap, Career Journey, riwayat
- [ ] Semua klaim angka cocok dengan `HASIL-KERJA.md`
- [ ] Latihan pitch 2× dengan timer; siapkan Plan B (fallback contoh, hotspot, HP cadangan)
