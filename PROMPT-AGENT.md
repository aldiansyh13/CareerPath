# Prompt implementasi CareerPath AI

Letakkan dokumen ini, empat dokumen acuan, PANDUAN-FIREBASE-GEMINI.md dan HASIL-KERJA.md di repo yang dapat dibaca dan ditulis agent. Gunakan instruksi pertama untuk sesi awal dan instruksi kedua setelah berganti sesi.

## Prompt sesi pertama — salin seluruh blok

```text
Bangun aplikasi Android CareerPath AI di workspace ini. Tulis kode Flutter/Dart yang dapat dijalankan. Bekerjalah langsung di repo, uji hasil melalui alur pengguna, dan simpan progres ke disk selama bekerja.

Baca empat dokumen ini sebelum implementasi. Cari berdasarkan nama jika berada dalam subfolder.
1. “CareerPath AI - Hackathon 1 Brainstorming.md” menjelaskan pengguna, tujuan demo, dan batas lingkup.
2. “CareerPath AI - Hackathon 2 PRD.md” menentukan fitur Must, kontrak JSON, model Firebase dan kriteria penerimaan.
3. “CareerPath AI - Hackathon 3 To-Do dan Laporan Progres.md” adalah daftar tugas resmi, gerbang A–G dan indeks L-01 sampai L-10.
4. “CareerPath-AI-UI-UX.md” menentukan copy Indonesia, tema buku kerja karier, navigasi, welcome lengkap, aksesibilitas serta status kosong, loading dan gagal.

Baca juga PANDUAN-FIREBASE-GEMINI.md saat mengerjakan integrasi. Baca HASIL-KERJA.md untuk mengetahui posisi terakhir. Periksa isi repo dan perubahan lokal sebelum membuat apa pun. Jika Flutter sudah ada, gunakan proyek itu. Jika belum ada, buat proyek Android tanpa menimpa dokumen. Ambil satu tugas yang dependensinya siap, implementasikan, uji, catat, kemudian lanjutkan. Utamakan fitur Must dan ikuti gerbang To-Do. Kerjakan bagian independen dalam blok aktif selama menunggu tindakan pemilik akun.

Alur yang harus berfungsi
• Sesi baru membuka welcome. Ada Masuk, Mulai asesmen dan Jelajahi contoh hasil offline. Terapkan contoh minat → karier → tugas pertama beserta copy dan aksi dari spesifikasi UI/UX. Sesi aktif menuju profil atau beranda sesuai kelengkapan profil.
• Daftar/masuk email dan kata sandi, profil, delapan pertanyaan minat, enam nilai skill 1–5, lalu ringkasan yang dapat diedit. Hanya kirim setelah lengkap, dengan pemberitahuan penggunaan data.
• Gemini menghasilkan tepat tiga karier berbeda dari katalog delapan karier. Validasi skor, alasan berdasarkan jawaban, skill yang dimiliki dan perlu dilatih, serta empat minggu tindakan konkret. Tampilkan disclaimer persis seperti PRD.
• Simpan hasil pribadi pada users/{uid}/assessments/{assessmentId}. Retry simpan memakai ID semula. Riwayat dapat dibuka tanpa permintaan Gemini baru. Bersihkan state akun ketika logout. Bedakan gagal analisis dari gagal menyimpan.
• Gunakan provider, Firebase Auth, Firestore dan GeminiService.analyzeCareer(). Untuk demo tertutup ikuti jalur REST PRD pada panduan. Jika pemilik memilih Firebase AI Logic untuk APK distribusi, catat keputusan sekali di HASIL-KERJA dan ganti hanya transport Gemini. Jangan jalankan kedua integrasi. Selama cloud belum siap gunakan fixture berlabel “Contoh hasil”; verifikasi layanan asli tetap berstatus tertunda.
• Gunakan pertanyaan, skill dan katalog yang sudah tersedia. Jika belum ada, siapkan draf lengkap 8/8/6 sesuai tujuan mahasiswa lintas jurusan dan catat pilihan kontennya untuk ditinjau. Batasi tampilan ke scope MVP dan spesifikasi welcome. Ikuti token desain, perilaku tombol kembali dan urutan fokus dokumen UI/UX.

Protokol pencatatan wajib
1. Pakai SATU file kumulatif HASIL-KERJA.md untuk semua pekerjaan. To-Do tetap jadi checklist dan indeks. Jangan buat file laporan baru per sesi, fitur, atau ID. Pertahankan catatan sebelumnya.
2. Sebelum mengedit kode, perbarui “Posisi terakhir” dan tambahkan entri SEDANG dengan ID L terkait, tugas spesifik, dan kriteria selesai. Sesudah satu perubahan bermakna atau satu uji, tulis checkpoint langsung ke file. Jangan menunggu akhir percakapan.
3. Catat apa yang benar-benar dibuat, path, konfigurasi nonrahasia, perintah uji, hasil nyata, bug, kebutuhan uji manusia, status gerbang, dan satu tindakan berikut yang bisa langsung dijalankan. Jika belum diuji, tulis BELUM DIUJI. Bedakan uji otomatis agent dan uji manual manusia dengan perangkat serta waktunya. Contoh laporan L-04 di dokumen To-Do bukan bukti hasil.
4. Perbarui butir To-Do yang tepat dan indeks §4.4 dengan tautan ke bagian L terkait di HASIL-KERJA.md. Centang hanya bila kriteria butir terbukti. Saat gerbang membutuhkan uji HP atau akun cloud dan aksesnya belum tersedia, catat siapa perlu melakukan apa serta tanda berhasilnya.
5. Untuk setiap aksi akun Google, beri pemilik satu instruksi konkret dari panduan. Jangan minta isi key, token, sandi atau service-account JSON. Jangan cetak isi .env, respons berisi data pengguna, atau credential. Aktivasi billing dan publikasi APK dilakukan hanya atas keputusan pemilik.
6. Jika sesi terputus mendadak, sesi baru harus bisa mencocokkan entri SEDANG dengan file aktual, melengkapi catatan dan melanjutkan tanpa mengulangi fitur. Jangan reset perubahan lokal. Bila sesi akan berakhir, tulis checkpoint lebih dulu.

Mulai sekarang: inventaris repo, temukan butir pertama yang belum terbukti selesai, catat di “Posisi terakhir”, lalu kerjakan. Di akhir respons, laporkan singkat hasil teruji, hambatan nyata dan langkah berikut.
```

## Prompt lanjutan — tempel setelah limit atau pindah agent

```text
Lanjutkan CareerPath AI dari repo ini. Mulai dengan membaca “CareerPath AI - Hackathon 3 To-Do dan Laporan Progres.md” dan “HASIL-KERJA.md”. Cocokkan Posisi terakhir, entri terbaru, perubahan repo dan bukti uji. Jika sesi terputus di tengah tugas, verifikasi perubahan yang sudah ada sebelum menulis ulang. Ambil tindakan berikut yang tertulis, atau butir pertama yang dependensinya siap jika catatan itu sudah selesai. Baca bagian PRD, UI/UX atau panduan setup yang relevan saat diperlukan. Implementasikan dan uji langsung. Setelah setiap perubahan bermakna, perbarui HASIL-KERJA.md yang sama dan sinkronkan checklist To-Do. Catat hasil manual yang masih menunggu manusia secara terpisah. Lanjutkan sampai target tercapai atau ada hambatan konkret.
```
