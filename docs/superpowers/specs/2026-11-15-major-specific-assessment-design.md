# Desain Asesmen Dinamis Berdasarkan Jurusan

## Tujuan

Pertanyaan minat dan penilaian skill harus mengikuti jurusan yang diketik pengguna, sehingga seluruh asesmen menilai jalur karier yang relevan dengan bidang studinya.

## Perilaku

- Teks jurusan dinormalisasi dan dicocokkan melalui kata kunci ke kelompok bidang.
- Kelompok yang didukung: IT, Akuntansi, Kesehatan, Hukum, Pendidikan, Psikologi/Sosial, Komunikasi/Kreatif, Teknik, serta Bisnis/Ekonomi.
- Setiap kelompok memiliki 8 pertanyaan minat dan 6 skill khusus bidang.
- Jurusan yang belum dikenali memakai paket umum lintas jurusan; aplikasi tidak menebak bidang yang tidak didukung.
- Saat pengguna mengubah jurusan, jawaban minat dan nilai skill lama dihapus agar data dari dua bidang tidak tercampur.
- Ringkasan menampilkan pertanyaan dan label skill dari kelompok jurusan aktif.
- Payload AI tetap memuat rating berdasarkan ID, ditambah label skill agar Gemini/OpenAI memahami makna nilai tersebut.

## Struktur

- Satu resolver jurusan menjadi sumber kebenaran untuk pertanyaan minat dan daftar skill.
- Data skill tidak lagi berupa satu konstanta global untuk semua pengguna.
- Layar skill dan ringkasan meminta daftar skill melalui jurusan pada `AssessmentProvider`.
- ID skill dibuat stabil dan spesifik per kelompok supaya nilai dari bidang lain tidak dianggap valid.

## Pendekatan

1. **Paket khusus per kelompok jurusan — dipilih.** Stabil, dapat diuji, dan konsisten tanpa bergantung pada jaringan.
2. Gabungan skill umum dan khusus. Ditolak karena pengguna menginginkan asesmen yang benar-benar mengikuti bidang.
3. Pertanyaan dibuat AI. Ditolak karena tidak stabil, bergantung pada API, dan sulit divalidasi.

## Pengujian

- Akuntansi mendapatkan pertanyaan dan skill Akuntansi, tanpa skill Pemrograman.
- Informatika mendapatkan pertanyaan dan skill IT.
- Jurusan lain yang mewakili delapan kelompok tersisa mendapatkan paketnya masing-masing.
- Jurusan tidak dikenal mendapatkan fallback umum.
- Mengubah jurusan membersihkan jawaban minat dan skill lama.
- Ringkasan dan payload AI memakai label skill kelompok jurusan aktif.

## Batasan

Versi ini memakai kelompok bidang dan kata kunci lokal, bukan membuat konten baru untuk setiap kemungkinan nama jurusan. Sinonim baru dapat ditambahkan ke katalog tanpa mengubah alur layar.
