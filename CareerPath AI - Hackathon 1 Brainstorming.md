# CareerPath AI - Hackathon 1: Brainstorming

Nov 14, 2026 - @Habib

## 1. Masalah, Pitch, dan Penilaian Juri

CareerPath AI untuk hackathon dipersempit menjadi satu alur yang stabil saat demo: mahasiswa masuk, mengisi asesmen singkat (sekitar 2 menit), lalu Gemini menghasilkan peta karier dan roadmap belajar 30 hari yang tersimpan di akunnya lewat Firebase. Dokumen ini mengasumsikan waktu 48 jam dan tim 3–4 orang pemula Flutter; jika waktu Anda berbeda, geser blok waktu di dokumen To-Do.

### Masalah

- Banyak mahasiswa tidak tahu bidang kerja yang cocok dengan minat dan kemampuannya.
- Informasi skill yang dibutuhkan industri tersebar dan sulit dirangkum sendiri.
- Mahasiswa tahu jurusannya, tetapi tidak tahu skill tambahan apa yang perlu dipelajari agar siap kerja.
- Konselor karier kampus jumlahnya terbatas dan tidak selalu tersedia kapan saja.

### Pitch satu kalimat

"CareerPath AI membantu mahasiswa menemukan karier yang cocok dalam 2 menit dan langsung memberi rencana belajar 30 hari untuk skill yang masih kurang."

### Target pengguna

Mahasiswa semester 3–8 dan fresh graduate dari jurusan apa pun. Untuk hackathon, katalog karier dibatasi 8 bidang agar hasil AI konsisten dan mudah diuji.

### Yang biasanya dinilai juri

| Kriteria umum | Cara CareerPath AI memenuhinya |
| --- | --- |
| Masalah nyata dan relevan | Kebingungan karier mahasiswa; siapkan 1–2 angka dari survei mini ke 10–20 teman |
| Inovasi / penggunaan AI | Gemini menghasilkan analisis personal dengan alasan, skill gap, dan roadmap dalam JSON terstruktur |
| Kelayakan teknis | Aplikasi Flutter yang benar-benar berjalan di HP, dengan login dan data tersimpan di Firebase |
| Dampak dan potensi | Bisa dipakai kampus, career center, dan bootcamp |
| Presentasi dan demo | Demo langsung 3 menit dengan cadangan rekaman layar |

Kriteria tiap hackathon berbeda. Cek buku panduan lomba Anda dan sesuaikan bobotnya.

### Titik pembeda yang ditonjolkan (pilih 2)

1. **Hasil personal dengan alasan transparan.** Setiap rekomendasi menjelaskan data pengguna mana yang mendasarinya.
2. **Roadmap 30 hari yang bisa dikerjakan.** Bukan hanya "pelajari Python", tetapi minggu 1 sampai minggu 4 dengan tugas konkret.
3. *(Opsional jika waktu sisa)* **Skor kecocokan dan radar minat** yang visual, mudah ditunjukkan ke juri.

## 2. Ide Fitur dan Pemotongan Scope

Firebase sekarang masuk ke MVP hackathon (login dan penyimpanan riwayat), sehingga yang dipotong adalah fitur yang memakan waktu tetapi tidak menambah nilai demo.

### Daftar ide dan keputusannya

| Fitur | Keputusan | Alasan |
| --- | --- | --- |
| Profil singkat + kuesioner 8 pertanyaan + 6 skill | Masuk | Input inti untuk Gemini |
| Rekomendasi 3 karier dengan skor dan alasan | Masuk | Inti demo |
| Skill gap + roadmap 30 hari | Masuk | Nilai tambah utama |
| Login email dan password (Firebase Auth) | Masuk | Sederhana dan membuat aplikasi terasa nyata |
| Simpan riwayat hasil di Firestore | Masuk | Membuktikan data tersimpan di server |
| Mode demo (isi jawaban contoh otomatis) | Masuk | Menghemat waktu presentasi |
| Hasil contoh tersimpan sebagai fallback | Masuk | Cadangan jika API gagal |
| Login Google Sign-In | Opsional | Butuh pengaturan SHA-1 yang sering membuat pemula tersangkut |
| Kartu hasil yang bisa dibagikan | Opsional | Nilai tambah visual |
| Grafik radar minat | Opsional | Nilai tambah visual |
| Upload CV | Ditunda | Rawan gagal saat demo |
| Chat bebas dengan AI | Ditunda | Hasil sulit diprediksi di depan juri |
| Versi iOS dan web | Ditunda | Tidak ada waktu menguji |
| Backend untuk menyembunyikan API key | Ditunda | Disebut sebagai rencana produksi |

### Ide "wow" murah

- Animasi loading bertema ("Menganalisis potensi kamu...") agar tunggu 5–10 detik terasa disengaja.
- Satu angka headline di hasil, misalnya "Kecocokan 88% untuk UI/UX Designer".
- Mode demo satu tombol agar presentasi cepat dan aman.
- Riwayat hasil yang sinkron: login di HP kedua dan hasil lama muncul (bukti nyata Firebase bekerja).

### Keputusan yang harus selesai di jam pertama

- [ ] Nama aplikasi dan tagline final
- [ ] 8 karier yang didukung
- [ ] 8 pertanyaan minat dan 6 skill yang dinilai
- [ ] Siapa pemilik proyek Firebase (satu orang membuat, lainnya diundang sebagai anggota)
- [ ] Model Gemini yang dipakai dan siapa yang membuat API key
- [ ] Pembagian peran tim

## 3. Keputusan Teknologi dan Risiko

Keputusan tim: Flutter untuk aplikasi, Gemini untuk analisis, dan Firebase (Auth + Firestore) untuk login dan database server. Supabase dipertimbangkan, tetapi Firebase dipilih karena paling cocok untuk tim pemula yang mengandalkan vibecoding.

### Mengapa Firebase, bukan Supabase

| Aspek | Firebase (dipilih) | Supabase |
| --- | --- | --- |
| Dukungan Flutter | Paling matang, contoh dan tutorial sangat banyak, kode dari AI jarang salah | Bagus, tetapi contoh lebih sedikit |
| Bentuk data | Firestore (dokumen JSON), cocok dengan hasil Gemini yang berbentuk JSON bersarang | PostgreSQL (tabel), perlu desain tabel dan paham SQL |
| Login | Email/password siap pakai, setup cepat | Juga mudah, tetapi aturan akses (RLS) sering jadi jebakan pemula |
| Setup | Sekitar 30–60 menit dengan FlutterFire CLI | Sekitar 30–60 menit |
| Cocok jika | Tim pemula, data berbentuk dokumen | Tim mahir SQL, butuh data relasional |

Catatan: batas free tier dan fitur tiap layanan bisa berubah, jadi cek halaman harga resmi sebelum mulai.

### Arsitektur singkat

Aplikasi Flutter memakai Firebase Auth untuk login dan Firestore untuk menyimpan profil serta riwayat hasil. Saat pengguna menekan "Analisis", aplikasi memanggil Gemini lewat HTTP, menerima JSON, menampilkan hasilnya, lalu menyimpan hasil ke Firestore. Detail teknis ada di dokumen PRD.

### Risiko dan antisipasi

| Risiko | Dampak | Antisipasi |
| --- | --- | --- |
| Setup Firebase memakan waktu lebih lama dari rencana | Waktu kerja inti tersita | Satu orang (peran Data) memegang Firebase dan dibatasi 90 menit; jika gagal, pakai penyimpanan lokal dan tandai Firebase sebagai rencana lanjutan |
| Kuota Gemini habis atau terkena batas permintaan | Aplikasi gagal saat demo | Batasi percobaan, simpan hasil contoh untuk fallback |
| JSON dari Gemini tidak valid | Aplikasi crash atau layar kosong | `responseMimeType` JSON, `try/catch`, tombol coba lagi |
| Hasil AI tidak relevan | Juri menilai kurang meyakinkan | Batasi daftar karier, minta alasan merujuk data pengguna |
| API key atau berkas konfigurasi bocor | Kuota dipakai orang lain | `.env` di `.gitignore`, jangan tempel ke chat AI, buat key baru jika terlanjur bocor |
| Aturan keamanan Firestore terlalu longgar | Data pengguna terbuka | Aturan hanya mengizinkan pengguna membaca dan menulis dokumennya sendiri (ada di PRD) |
| Konflik Git | Kode hilang atau tertimpa | Branch per fitur, satu file satu pemilik |
| Scope membesar | Tidak selesai tepat waktu | Pegang daftar "Masuk" di bagian 2, fitur opsional hanya setelah gerbang blok C lolos |
