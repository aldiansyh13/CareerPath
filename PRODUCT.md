# Product

<!-- impeccable:product-schema 1 -->

## Platform

android

## Users

Mahasiswa semester 3–8 dan fresh graduate Indonesia dari berbagai jurusan yang sedang menentukan arah karier, memahami kesenjangan skill, dan membutuhkan langkah belajar yang realistis untuk mulai bergerak.

## Product Purpose

CareerPath AI membantu pengguna menemukan arah karier melalui asesmen singkat, memahami alasan kecocokannya, lalu melanjutkan hasil tersebut sebagai roadmap belajar 30 hari yang dapat dikerjakan dan dipantau. Keberhasilan produk bukan hanya menghasilkan rekomendasi, tetapi membuat pengguna kembali untuk menyelesaikan langkah belajar dan melihat perkembangan skill.

## Positioning

CareerPath AI mengubah hasil asesmen berbasis AI menjadi perjalanan pengembangan diri yang berlanjut: rekomendasi karier, skill gap, roadmap mingguan, dan progres skill berada dalam satu alur yang saling terhubung.

## Operating Context

Pengguna memulai dengan profil, delapan pertanyaan minat, dan penilaian enam skill. AI menghasilkan tiga rekomendasi karier beserta alasan, skill yang sudah dimiliki, skill yang perlu dilatih, dan roadmap empat minggu. Setelah menerima hasil, pengguna kembali ke aplikasi untuk melanjutkan roadmap, menandai progres, dan memantau perkembangan skill. Riwayat asesmen digunakan untuk melihat perubahan dari waktu ke waktu.

## Capabilities and Constraints

- Flutter untuk Android 7.0 ke atas dengan Material 3.
- Firebase Authentication dan Cloud Firestore untuk akun, profil, hasil, dan sinkronisasi riwayat.
- Gemini melalui REST sebagai analisis utama, dengan fallback OpenAI dan hasil contoh offline yang diberi label jelas.
- Katalog rekomendasi dibatasi pada delapan bidang karier agar hasil stabil dan dapat diuji.
- Semua teks antarmuka menggunakan Bahasa Indonesia.
- Data minimum: nama panggilan, jurusan, semester, jawaban minat, nilai skill, hasil asesmen, dan progres belajar.
- Rekomendasi adalah saran awal, bukan keputusan atau jaminan karier.
- Target hackathon tetap membutuhkan alur demo yang stabil, penanganan error, dan dukungan layar ponsel kecil.
- Detail persistensi progres roadmap dan riwayat nilai skill akan ditetapkan dalam desain fitur.

## Brand Commitments

- Nama produk: CareerPath AI.
- Suara produk: suportif, jelas, praktis, tidak menggurui, dan tidak membuat janji berlebihan.
- Janji inti: menemukan arah dalam sekitar dua menit dan mendapatkan roadmap belajar 30 hari yang dapat dilakukan.

## Evidence on Hand

- PRD, brainstorming, pitch demo, dan laporan progres berada di root proyek.
- Implementasi Flutter sudah mencakup autentikasi, profil, asesmen, analisis AI, hasil, detail roadmap, fallback, dan riwayat.
- Sampel hasil tersedia di `lib/data/sample_result.dart` dan harus tetap diberi label sebagai contoh.
- Belum ada bukti pengguna nyata, testimoni, validasi konselor, atau data dampak; desain tidak boleh mengarangnya.

## Product Principles

1. Setiap rekomendasi harus berujung pada tindakan belajar yang jelas.
2. Progres yang kecil harus terlihat dan terasa berarti.
3. Pengguna harus selalu memahami alasan di balik rekomendasi dan perubahan skill.
4. Kegagalan jaringan atau AI tidak boleh memutus pengalaman utama.
5. Antarmuka harus terasa seperti pendamping karier, bukan formulir asesmen sekali pakai.

## Accessibility & Inclusion

Gunakan target sentuh minimal 48 dp, dukung skala teks sistem, kontras yang terbaca, navigasi Back Android, dan layout yang tetap berfungsi pada layar kecil. Bahasa dan jalur karier tidak boleh mengasumsikan latar teknis atau jurusan tertentu.
