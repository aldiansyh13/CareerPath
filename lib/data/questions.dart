class InterestQuestion {
  final String id;
  final String text;
  final List<String> options;

  const InterestQuestion({
    required this.id,
    required this.text,
    required this.options,
  });
}

/// Pertanyaan umum lintas jurusan. Dipakai sebagai fallback bila jurusan
/// pengguna belum dikenali.
const List<InterestQuestion> kInterestQuestions = [
  InterestQuestion(
    id: 'q1',
    text: 'Aktivitas mana yang paling membuatmu bersemangat?',
    options: [
      'Menyelesaikan perhitungan dan laporan yang rapi',
      'Merancang tampilan atau konten yang menarik',
      'Menganalisis masalah dan mencari solusi logis',
      'Membantu orang lain belajar atau berkembang',
    ],
  ),
  InterestQuestion(
    id: 'q2',
    text: 'Saat mengerjakan tugas kelompok, peran apa yang sering kamu ambil?',
    options: [
      'Mengatur anggaran, data, dan detail pekerjaan',
      'Membuat desain atau presentasi visual',
      'Meneliti informasi dan menganalisis temuan',
      'Mengoordinasikan anggota dan waktu kerja',
    ],
  ),
  InterestQuestion(
    id: 'q3',
    text: 'Masalah seperti apa yang paling ingin kamu pecahkan?',
    options: [
      'Laporan atau pencatatan yang tidak akurat',
      'Pesan atau desain yang sulit dipahami',
      'Proses kerja yang lambat dan tidak efisien',
      'Orang yang kesulitan memahami sesuatu',
    ],
  ),
  InterestQuestion(
    id: 'q4',
    text: 'Kamu lebih suka bekerja dengan…',
    options: [
      'Angka, laporan, dan detail',
      'Ide visual, cerita, dan kreativitas',
      'Data, eksperimen, dan logika',
      'Orang, diskusi, dan presentasi',
    ],
  ),
  InterestQuestion(
    id: 'q5',
    text: 'Hasil kerja seperti apa yang paling ingin kamu tunjukkan?',
    options: [
      'Laporan atau analisis yang akurat',
      'Karya visual atau konten yang menarik',
      'Sistem atau proses yang lebih efisien',
      'Program atau pelatihan yang bermanfaat',
    ],
  ),
  InterestQuestion(
    id: 'q6',
    text: 'Kalau belajar hal baru, kamu paling tertarik pada topik…',
    options: [
      'Keuangan, administrasi, dan manajemen',
      'Desain, media, dan komunikasi',
      'Teknologi, sains, dan riset',
      'Pendidikan, sosial, dan perilaku manusia',
    ],
  ),
  InterestQuestion(
    id: 'q7',
    text: 'Lingkungan kerja mana yang terasa paling cocok?',
    options: [
      'Terstruktur, detail, dan berbasis angka',
      'Kreatif, dinamis, dan penuh ide',
      'Analitis dan berbasis pemecahan masalah',
      'Kolaboratif dan banyak berinteraksi dengan orang',
    ],
  ),
  InterestQuestion(
    id: 'q8',
    text: 'Dalam 6 bulan ke depan, pencapaian apa yang paling kamu inginkan?',
    options: [
      'Punya keahlian yang diakui di bidang keuangan/administrasi',
      'Punya portofolio karya atau konten',
      'Punya proyek riset atau teknis yang nyata',
      'Punya pengalaman mengajar atau membantu orang lain',
    ],
  ),
];

const List<InterestQuestion> _itQuestions = [
  InterestQuestion(
    id: 'q1',
    text: 'Aktivitas mana yang paling membuatmu bersemangat?',
    options: [
      'Merancang tampilan yang mudah dipakai',
      'Membangun fitur dan logika aplikasi',
      'Menganalisis data untuk menemukan pola',
      'Menyusun strategi agar produk dikenal orang',
    ],
  ),
  InterestQuestion(
    id: 'q2',
    text: 'Saat mengerjakan tugas kelompok, peran apa yang sering kamu ambil?',
    options: [
      'Membuat desain atau presentasi visual',
      'Mengerjakan bagian teknis/implementasi',
      'Mengolah data dan membuat kesimpulan',
      'Mengatur rencana, prioritas, dan koordinasi',
    ],
  ),
  InterestQuestion(
    id: 'q3',
    text: 'Masalah seperti apa yang paling ingin kamu pecahkan?',
    options: [
      'Pengguna bingung memakai aplikasi',
      'Sistem lambat, error, atau sulit dikembangkan',
      'Keputusan tanpa dasar data yang jelas',
      'Produk sulit mencapai target pengguna/bisnis',
    ],
  ),
  InterestQuestion(
    id: 'q4',
    text: 'Kamu lebih suka bekerja dengan…',
    options: [
      'Warna, layout, dan pengalaman pengguna',
      'Kode, algoritma, dan arsitektur sistem',
      'Angka, tabel, dan grafik',
      'Orang, kebutuhan pasar, dan rencana kerja',
    ],
  ),
  InterestQuestion(
    id: 'q5',
    text: 'Hasil kerja seperti apa yang paling ingin kamu tunjukkan?',
    options: [
      'Prototipe/desain yang rapi dan intuitif',
      'Aplikasi atau fitur yang berjalan lancar',
      'Dashboard/insight dari data',
      'Rencana produk atau kampanye yang terukur',
    ],
  ),
  InterestQuestion(
    id: 'q6',
    text: 'Kalau belajar hal baru, kamu paling tertarik pada topik…',
    options: [
      'Prinsip desain, riset pengguna, dan Figma',
      'Bahasa pemrograman dan framework',
      'Statistik dasar, SQL, dan visualisasi data',
      'Pemasaran digital, manajemen produk, atau proses bisnis',
    ],
  ),
  InterestQuestion(
    id: 'q7',
    text: 'Lingkungan kerja mana yang terasa paling cocok?',
    options: [
      'Kolaborasi dekat dengan pengguna dan tim produk',
      'Fokus membangun dan memperbaiki sistem',
      'Fokus menggali fakta dari data',
      'Menjembatani kebutuhan bisnis dan tim teknis',
    ],
  ),
  InterestQuestion(
    id: 'q8',
    text: 'Dalam 6 bulan ke depan, pencapaian apa yang paling kamu inginkan?',
    options: [
      'Punya portofolio desain/prototipe yang kuat',
      'Punya proyek aplikasi yang bisa dipakai orang lain',
      'Bisa membuat analisis/data report yang berguna',
      'Bisa memimpin inisiatif produk atau pemasaran kecil',
    ],
  ),
];

const List<InterestQuestion> _accountingQuestions = [
  InterestQuestion(
    id: 'q1',
    text: 'Aktivitas mana yang paling membuatmu bersemangat?',
    options: [
      'Menyusun dan memeriksa laporan keuangan',
      'Menghitung pajak dan memastikan kepatuhan aturan',
      'Menganalisis anggaran dan kinerja keuangan',
      'Mengaudit proses dan menemukan kesalahan pencatatan',
    ],
  ),
  InterestQuestion(
    id: 'q2',
    text: 'Saat mengerjakan tugas kelompok, peran apa yang sering kamu ambil?',
    options: [
      'Mencatat pengeluaran dan membuat laporan keuangan',
      'Menghitung kebutuhan biaya dan anggaran',
      'Menganalisis data untuk mengambil keputusan',
      'Memeriksa ulang hasil kerja agar akurat',
    ],
  ),
  InterestQuestion(
    id: 'q3',
    text: 'Masalah seperti apa yang paling ingin kamu pecahkan?',
    options: [
      'Laporan tidak balance atau data tidak akurat',
      'Kesalahan pajak dan risiko sanksi',
      'Pengeluaran tidak terkendali',
      'Kecurangan atau ketidaksesuaian prosedur',
    ],
  ),
  InterestQuestion(
    id: 'q4',
    text: 'Kamu lebih suka bekerja dengan…',
    options: [
      'Jurnal, buku besar, dan laporan',
      'Angka, rumus, dan rekonsiliasi',
      'Data keuangan dan tren',
      'Dokumen, aturan, dan detail',
    ],
  ),
  InterestQuestion(
    id: 'q5',
    text: 'Hasil kerja seperti apa yang paling ingin kamu tunjukkan?',
    options: [
      'Laporan keuangan yang rapi dan tepat waktu',
      'Perhitungan pajak yang benar',
      'Analisis biaya dan rekomendasi efisiensi',
      'Temuan audit yang jelas',
    ],
  ),
  InterestQuestion(
    id: 'q6',
    text: 'Kalau belajar hal baru, kamu paling tertarik pada topik…',
    options: [
      'Akuntansi keuangan dan standar pelaporan',
      'Perpajakan dan regulasi',
      'Analisis keuangan dan investasi',
      'Audit dan pengendalian internal',
    ],
  ),
  InterestQuestion(
    id: 'q7',
    text: 'Lingkungan kerja mana yang terasa paling cocok?',
    options: [
      'Kantor dengan proses dan tenggat yang jelas',
      'Konsultan pajak atau akuntan publik',
      'Tim keuangan yang menganalisis angka',
      'Tim audit dengan ketelitian tinggi',
    ],
  ),
  InterestQuestion(
    id: 'q8',
    text: 'Dalam 6 bulan ke depan, pencapaian apa yang paling kamu inginkan?',
    options: [
      'Menguasai Excel dan software akuntansi',
      'Memahami perpajakan praktis',
      'Bisa membuat analisis laporan keuangan',
      'Punya pengalaman magang di bidang audit/akuntansi',
    ],
  ),
];

const List<InterestQuestion> _businessQuestions = [
  InterestQuestion(
    id: 'q1',
    text: 'Aktivitas mana yang paling membuatmu bersemangat?',
    options: [
      'Menyusun strategi untuk mencapai target penjualan',
      'Mengelola tim dan membagi pekerjaan',
      'Meneliti kebutuhan pasar dan pelanggan',
      'Mengatur operasional agar berjalan efisien',
    ],
  ),
  InterestQuestion(
    id: 'q2',
    text: 'Saat mengerjakan tugas kelompok, peran apa yang sering kamu ambil?',
    options: [
      'Mengatur rencana dan pembagian tugas',
      'Bernegosiasi atau mencari sumber daya',
      'Menganalisis data penjualan atau pasar',
      'Memastikan pekerjaan selesai tepat waktu',
    ],
  ),
  InterestQuestion(
    id: 'q3',
    text: 'Masalah seperti apa yang paling ingin kamu pecahkan?',
    options: [
      'Target penjualan tidak tercapai',
      'Tim kurang terkoordinasi',
      'Keputusan bisnis tanpa data pasar',
      'Proses operasional lambat dan boros',
    ],
  ),
  InterestQuestion(
    id: 'q4',
    text: 'Kamu lebih suka bekerja dengan…',
    options: [
      'Orang, negosiasi, dan presentasi',
      'Angka penjualan, pasar, dan laporan',
      'Proses, jadwal, dan anggaran',
      'Ide produk atau kampanye baru',
    ],
  ),
  InterestQuestion(
    id: 'q5',
    text: 'Hasil kerja seperti apa yang paling ingin kamu tunjukkan?',
    options: [
      'Rencana bisnis yang jelas',
      'Peningkatan penjualan atau pelanggan',
      'Analisis pasar yang membantu keputusan',
      'Tim yang solid dan target tercapai',
    ],
  ),
  InterestQuestion(
    id: 'q6',
    text: 'Kalau belajar hal baru, kamu paling tertarik pada topik…',
    options: [
      'Manajemen, kepemimpinan, dan negosiasi',
      'Pemasaran dan perilaku konsumen',
      'Analisis bisnis dan keuangan',
      'Kewirausahaan dan inovasi',
    ],
  ),
  InterestQuestion(
    id: 'q7',
    text: 'Lingkungan kerja mana yang terasa paling cocok?',
    options: [
      'Dinamis dengan interaksi pelanggan dan mitra',
      'Terstruktur dengan target dan metrik',
      'Analitis dengan data pasar',
      'Kolaboratif dengan pengelolaan tim',
    ],
  ),
  InterestQuestion(
    id: 'q8',
    text: 'Dalam 6 bulan ke depan, pencapaian apa yang paling kamu inginkan?',
    options: [
      'Bisa memimpin proyek atau tim kecil',
      'Punya pengalaman menjual atau memasarkan produk',
      'Bisa membuat analisis pasar sederhana',
      'Punya ide usaha atau kampanye yang berjalan',
    ],
  ),
];

const List<InterestQuestion> _engineeringQuestions = [
  InterestQuestion(
    id: 'q1',
    text: 'Aktivitas mana yang paling membuatmu bersemangat?',
    options: [
      'Merancang bangunan, mesin, atau produk',
      'Memperbaiki masalah teknis',
      'Menguji dan memastikan sistem aman',
      'Mengatur proyek konstruksi atau produksi',
    ],
  ),
  InterestQuestion(
    id: 'q2',
    text: 'Saat mengerjakan tugas kelompok, peran apa yang sering kamu ambil?',
    options: [
      'Menggambar atau merancang solusi',
      'Menghitung kekuatan dan kebutuhan material',
      'Menguji hasil kerja',
      'Mengatur jadwal dan tim lapangan',
    ],
  ),
  InterestQuestion(
    id: 'q3',
    text: 'Masalah seperti apa yang paling ingin kamu pecahkan?',
    options: [
      'Struktur atau alat yang tidak aman',
      'Proses produksi yang tidak efisien',
      'Desain yang tidak sesuai kebutuhan',
      'Proyek yang melewati anggaran atau waktu',
    ],
  ),
  InterestQuestion(
    id: 'q4',
    text: 'Kamu lebih suka bekerja dengan…',
    options: [
      'Gambar teknik, model, dan material',
      'Rumus, perhitungan, dan material',
      'Alat, mesin, dan uji coba',
      'Jadwal, anggaran, dan koordinasi lapangan',
    ],
  ),
  InterestQuestion(
    id: 'q5',
    text: 'Hasil kerja seperti apa yang paling ingin kamu tunjukkan?',
    options: [
      'Desain atau prototipe yang berfungsi',
      'Perhitungan struktur yang aman',
      'Sistem atau proses yang efisien',
      'Proyek yang selesai tepat waktu',
    ],
  ),
  InterestQuestion(
    id: 'q6',
    text: 'Kalau belajar hal baru, kamu paling tertarik pada topik…',
    options: [
      'CAD, gambar teknik, dan material',
      'Fisika, mekanika, dan perhitungan',
      'Otomasi, mesin, dan teknologi',
      'Manajemen proyek konstruksi',
    ],
  ),
  InterestQuestion(
    id: 'q7',
    text: 'Lingkungan kerja mana yang terasa paling cocok?',
    options: [
      'Lapangan atau proyek dengan kerja praktis',
      'Kantor teknik dengan perhitungan detail',
      'Laboratorium atau pabrik dengan pengujian',
      'Tim proyek dengan koordinasi intensif',
    ],
  ),
  InterestQuestion(
    id: 'q8',
    text: 'Dalam 6 bulan ke depan, pencapaian apa yang paling kamu inginkan?',
    options: [
      'Bisa membuat desain atau prototipe sederhana',
      'Menguasai software teknik seperti CAD',
      'Punya pengalaman magang di proyek',
      'Bisa memimpin proyek kecil',
    ],
  ),
];

const List<InterestQuestion> _healthQuestions = [
  InterestQuestion(
    id: 'q1',
    text: 'Aktivitas mana yang paling membuatmu bersemangat?',
    options: [
      'Merawat dan membantu pasien',
      'Menganalisis gejala atau penyakit',
      'Mengedukasi orang tentang hidup sehat',
      'Meneliti masalah kesehatan',
    ],
  ),
  InterestQuestion(
    id: 'q2',
    text: 'Saat mengerjakan tugas kelompok, peran apa yang sering kamu ambil?',
    options: [
      'Memeriksa dan mencatat kondisi pasien',
      'Menyusun rencana perawatan',
      'Mengedukasi anggota atau tim',
      'Memastikan prosedur kesehatan dijalankan',
    ],
  ),
  InterestQuestion(
    id: 'q3',
    text: 'Masalah seperti apa yang paling ingin kamu pecahkan?',
    options: [
      'Pasien tidak mendapat penanganan yang tepat',
      'Penyakit menyebar karena kurang edukasi',
      'Prosedur layanan kesehatan tidak aman',
      'Data kesehatan tidak akurat',
    ],
  ),
  InterestQuestion(
    id: 'q4',
    text: 'Kamu lebih suka bekerja dengan…',
    options: [
      'Pasien dan keluarganya',
      'Gejala, rekam medis, dan diagnosis',
      'Obat, alat, dan prosedur',
      'Data kesehatan dan penelitian',
    ],
  ),
  InterestQuestion(
    id: 'q5',
    text: 'Hasil kerja seperti apa yang paling ingin kamu tunjukkan?',
    options: [
      'Pasien merasa terbantu dan membaik',
      'Diagnosis atau rencana perawatan yang tepat',
      'Program edukasi kesehatan',
      'Temuan riset yang berguna',
    ],
  ),
  InterestQuestion(
    id: 'q6',
    text: 'Kalau belajar hal baru, kamu paling tertarik pada topik…',
    options: [
      'Anatomi, fisiologi, dan penyakit',
      'Farmakologi dan perawatan',
      'Kesehatan masyarakat dan gizi',
      'Riset kesehatan dan statistik',
    ],
  ),
  InterestQuestion(
    id: 'q7',
    text: 'Lingkungan kerja mana yang terasa paling cocok?',
    options: [
      'Rumah sakit atau klinik dengan pasien',
      'Laboratorium dengan pemeriksaan',
      'Komunitas dengan edukasi kesehatan',
      'Tim medis yang cepat tanggap',
    ],
  ),
  InterestQuestion(
    id: 'q8',
    text: 'Dalam 6 bulan ke depan, pencapaian apa yang paling kamu inginkan?',
    options: [
      'Bisa membantu perawatan pasien',
      'Memahami prosedur klinis dasar',
      'Bisa membuat program edukasi kesehatan',
      'Punya pengalaman magang di fasilitas kesehatan',
    ],
  ),
];

const List<InterestQuestion> _lawQuestions = [
  InterestQuestion(
    id: 'q1',
    text: 'Aktivitas mana yang paling membuatmu bersemangat?',
    options: [
      'Menganalisis kasus dan aturan hukum',
      'Menyusun kontrak atau dokumen hukum',
      'Membela atau mewakili kepentingan orang lain',
      'Menyelesaikan sengketa lewat mediasi',
    ],
  ),
  InterestQuestion(
    id: 'q2',
    text: 'Saat mengerjakan tugas kelompok, peran apa yang sering kamu ambil?',
    options: [
      'Mencari dasar hukum dan referensi',
      'Menyusun argumen',
      'Menyusun dokumen atau kesepakatan',
      'Mencatat dan memverifikasi fakta',
    ],
  ),
  InterestQuestion(
    id: 'q3',
    text: 'Masalah seperti apa yang paling ingin kamu pecahkan?',
    options: [
      'Aturan yang tidak jelas atau tumpang tindih',
      'Hak pihak yang lemah tidak terlindungi',
      'Kontrak yang menimbulkan risiko',
      'Sengketa yang sulit diselesaikan',
    ],
  ),
  InterestQuestion(
    id: 'q4',
    text: 'Kamu lebih suka bekerja dengan…',
    options: [
      'Peraturan, putusan, dan dokumen',
      'Argumen, debat, dan negosiasi',
      'Fakta, bukti, dan kronologi',
      'Orang yang punya masalah hukum',
    ],
  ),
  InterestQuestion(
    id: 'q5',
    text: 'Hasil kerja seperti apa yang paling ingin kamu tunjukkan?',
    options: [
      'Analisis hukum yang kuat',
      'Kontrak atau dokumen yang aman',
      'Penyelesaian sengketa yang adil',
      'Klien yang memahami hak dan kewajibannya',
    ],
  ),
  InterestQuestion(
    id: 'q6',
    text: 'Kalau belajar hal baru, kamu paling tertarik pada topik…',
    options: [
      'Hukum perdata dan pidana',
      'Hukum bisnis dan kontrak',
      'Hukum tata negara dan kebijakan',
      'Mediasi dan advokasi',
    ],
  ),
  InterestQuestion(
    id: 'q7',
    text: 'Lingkungan kerja mana yang terasa paling cocok?',
    options: [
      'Kantor hukum dengan banyak dokumen',
      'Pengadilan dengan argumen',
      'Perusahaan dengan kontrak dan bisnis',
      'Lembaga bantuan hukum dengan masyarakat',
    ],
  ),
  InterestQuestion(
    id: 'q8',
    text: 'Dalam 6 bulan ke depan, pencapaian apa yang paling kamu inginkan?',
    options: [
      'Bisa menyusun dokumen hukum sederhana',
      'Memahami proses peradilan',
      'Punya pengalaman magang di kantor hukum',
      'Bisa membantu mediasi atau advokasi',
    ],
  ),
];

const List<InterestQuestion> _educationQuestions = [
  InterestQuestion(
    id: 'q1',
    text: 'Aktivitas mana yang paling membuatmu bersemangat?',
    options: [
      'Mengajar dan menjelaskan materi',
      'Merancang materi atau kegiatan belajar',
      'Membimbing siswa yang kesulitan',
      'Mengelola kelas',
    ],
  ),
  InterestQuestion(
    id: 'q2',
    text: 'Saat mengerjakan tugas kelompok, peran apa yang sering kamu ambil?',
    options: [
      'Menjelaskan materi',
      'Menyusun rencana belajar',
      'Membantu teman yang kesulitan',
      'Mengatur waktu dan tugas',
    ],
  ),
  InterestQuestion(
    id: 'q3',
    text: 'Masalah seperti apa yang paling ingin kamu pecahkan?',
    options: [
      'Siswa sulit memahami materi',
      'Materi belajar membosankan',
      'Siswa kehilangan motivasi',
      'Kelas tidak kondusif',
    ],
  ),
  InterestQuestion(
    id: 'q4',
    text: 'Kamu lebih suka bekerja dengan…',
    options: [
      'Anak atau siswa dan proses belajar',
      'Materi, buku, dan media ajar',
      'Metode dan evaluasi belajar',
      'Jadwal dan kegiatan kelas',
    ],
  ),
  InterestQuestion(
    id: 'q5',
    text: 'Hasil kerja seperti apa yang paling ingin kamu tunjukkan?',
    options: [
      'Siswa memahami materi',
      'Materi atau kegiatan belajar yang menarik',
      'Siswa lebih percaya diri',
      'Kelas yang aktif dan tertib',
    ],
  ),
  InterestQuestion(
    id: 'q6',
    text: 'Kalau belajar hal baru, kamu paling tertarik pada topik…',
    options: [
      'Psikologi pendidikan dan pedagogi',
      'Desain materi dan media belajar',
      'Kurikulum dan asesmen',
      'Kepemimpinan dan manajemen kelas',
    ],
  ),
  InterestQuestion(
    id: 'q7',
    text: 'Lingkungan kerja mana yang terasa paling cocok?',
    options: [
      'Sekolah atau kelas dengan siswa',
      'Ruang belajar dengan materi ajar',
      'Komunitas pendidikan',
      'Kegiatan ekstrakurikuler',
    ],
  ),
  InterestQuestion(
    id: 'q8',
    text: 'Dalam 6 bulan ke depan, pencapaian apa yang paling kamu inginkan?',
    options: [
      'Bisa mengajar atau membimbing',
      'Punya pengalaman mengajar',
      'Bisa membuat media belajar',
      'Bisa mengelola program belajar',
    ],
  ),
];

const List<InterestQuestion> _psychologyQuestions = [
  InterestQuestion(
    id: 'q1',
    text: 'Aktivitas mana yang paling membuatmu bersemangat?',
    options: [
      'Mendengarkan masalah orang lain',
      'Meneliti perilaku manusia',
      'Membantu menyelesaikan konflik',
      'Merancang program sosial',
    ],
  ),
  InterestQuestion(
    id: 'q2',
    text: 'Saat mengerjakan tugas kelompok, peran apa yang sering kamu ambil?',
    options: [
      'Mendengarkan dan menenangkan',
      'Mengamati perilaku dan tanggapan',
      'Menganalisis penyebab masalah',
      'Mengoordinasikan kegiatan sosial',
    ],
  ),
  InterestQuestion(
    id: 'q3',
    text: 'Masalah seperti apa yang paling ingin kamu pecahkan?',
    options: [
      'Orang merasa tidak didengar',
      'Konflik dalam kelompok',
      'Masalah sosial yang tidak tertangani',
      'Keputusan yang mengabaikan kondisi manusia',
    ],
  ),
  InterestQuestion(
    id: 'q4',
    text: 'Kamu lebih suka bekerja dengan…',
    options: [
      'Orang dan emosinya',
      'Data dan riset perilaku',
      'Diskusi dan mediasi',
      'Program dan kegiatan sosial',
    ],
  ),
  InterestQuestion(
    id: 'q5',
    text: 'Hasil kerja seperti apa yang paling ingin kamu tunjukkan?',
    options: [
      'Orang merasa lebih baik',
      'Temuan tentang perilaku manusia',
      'Kelompok yang lebih harmonis',
      'Program sosial yang berjalan',
    ],
  ),
  InterestQuestion(
    id: 'q6',
    text: 'Kalau belajar hal baru, kamu paling tertarik pada topik…',
    options: [
      'Psikologi dan konseling',
      'Riset sosial dan statistik',
      'Komunikasi dan mediasi',
      'Kebijakan dan pemberdayaan masyarakat',
    ],
  ),
  InterestQuestion(
    id: 'q7',
    text: 'Lingkungan kerja mana yang terasa paling cocok?',
    options: [
      'Ruang konseling dengan klien',
      'Lembaga riset atau survei',
      'Organisasi dengan kerja tim',
      'Komunitas atau masyarakat',
    ],
  ),
  InterestQuestion(
    id: 'q8',
    text: 'Dalam 6 bulan ke depan, pencapaian apa yang paling kamu inginkan?',
    options: [
      'Bisa menjadi pendengar atau konselor dasar',
      'Punya pengalaman riset sosial',
      'Bisa memfasilitasi kelompok',
      'Bisa menjalankan program sosial',
    ],
  ),
];

const List<InterestQuestion> _communicationQuestions = [
  InterestQuestion(
    id: 'q1',
    text: 'Aktivitas mana yang paling membuatmu bersemangat?',
    options: [
      'Membuat desain visual',
      'Menulis cerita atau naskah',
      'Membuat video atau foto',
      'Mengelola media sosial dan kampanye',
    ],
  ),
  InterestQuestion(
    id: 'q2',
    text: 'Saat mengerjakan tugas kelompok, peran apa yang sering kamu ambil?',
    options: [
      'Membuat desain atau presentasi',
      'Menulis laporan atau naskah',
      'Mendokumentasikan kegiatan',
      'Mengatur publikasi atau konten',
    ],
  ),
  InterestQuestion(
    id: 'q3',
    text: 'Masalah seperti apa yang paling ingin kamu pecahkan?',
    options: [
      'Pesan yang tidak tersampaikan',
      'Desain atau konten yang membosankan',
      'Informasi yang salah dipahami',
      'Kampanye yang tidak menarik audiens',
    ],
  ),
  InterestQuestion(
    id: 'q4',
    text: 'Kamu lebih suka bekerja dengan…',
    options: [
      'Warna, layout, dan visual',
      'Kata, cerita, dan narasi',
      'Kamera, video, dan editing',
      'Media sosial dan tren',
    ],
  ),
  InterestQuestion(
    id: 'q5',
    text: 'Hasil kerja seperti apa yang paling ingin kamu tunjukkan?',
    options: [
      'Desain atau karya visual yang menarik',
      'Tulisan atau naskah yang jelas',
      'Video atau konten yang diminati',
      'Kampanye yang menjangkau audiens',
    ],
  ),
  InterestQuestion(
    id: 'q6',
    text: 'Kalau belajar hal baru, kamu paling tertarik pada topik…',
    options: [
      'Desain grafis dan tools kreatif',
      'Penulisan kreatif dan jurnalistik',
      'Fotografi dan videografi',
      'Pemasaran digital dan media sosial',
    ],
  ),
  InterestQuestion(
    id: 'q7',
    text: 'Lingkungan kerja mana yang terasa paling cocok?',
    options: [
      'Studio kreatif dengan proyek visual',
      'Redaksi atau media dengan tulisan',
      'Produksi konten dengan kamera',
      'Agensi dengan kampanye klien',
    ],
  ),
  InterestQuestion(
    id: 'q8',
    text: 'Dalam 6 bulan ke depan, pencapaian apa yang paling kamu inginkan?',
    options: [
      'Punya portofolio desain',
      'Punya kumpulan tulisan atau naskah',
      'Punya karya video atau foto',
      'Bisa menjalankan kampanye media sosial',
    ],
  ),
];

class _MajorQuestionSet {
  final String id;
  final List<String> keywords;
  final List<InterestQuestion> questions;

  const _MajorQuestionSet(this.id, this.keywords, this.questions);
}

/// Urutan pengecekan penting: jurusan yang lebih spesifik diperiksa lebih dulu.
const List<_MajorQuestionSet> _majorQuestionSets = [
  _MajorQuestionSet(
      'it',
      [
        'informatika',
        'ilmu komputer',
        'sistem informasi',
        'teknologi informasi',
        'teknologi komputer',
        'rekayasa perangkat lunak',
        'software',
        'data science',
        'sains data',
        'kecerdasan artifisial',
        'keamanan siber',
        'cyber',
        'multimedia',
        'animasi',
        'game',
      ],
      _itQuestions),
  _MajorQuestionSet(
      'accounting',
      [
        'akuntansi',
        'akuntan',
        'perpajakan',
        'pajak',
        'komputerisasi akuntansi',
      ],
      _accountingQuestions),
  _MajorQuestionSet(
      'health',
      [
        'kedokteran',
        'keperawatan',
        'kebidanan',
        'farmasi',
        'gizi',
        'kesehatan',
        'fisioterapi',
        'radiologi',
        'analis kesehatan',
      ],
      _healthQuestions),
  _MajorQuestionSet(
      'law',
      [
        'hukum',
        'kenotariatan',
        'notaris',
      ],
      _lawQuestions),
  _MajorQuestionSet(
      'education',
      [
        'pendidikan',
        'keguruan',
        'pgsd',
        'paud',
        'bimbingan konseling',
      ],
      _educationQuestions),
  _MajorQuestionSet(
      'psychology',
      [
        'psikologi',
        'sosiologi',
        'antropologi',
        'ilmu sosial',
        'kesejahteraan sosial',
        'pekerja sosial',
      ],
      _psychologyQuestions),
  _MajorQuestionSet(
      'communication',
      [
        'komunikasi',
        'humas',
        'public relation',
        'jurnalistik',
        'penyiaran',
        'desain komunikasi visual',
        'dkv',
        'desain',
        'seni',
        'sastra',
        'bahasa',
        'film',
        'fotografi',
        'periklanan',
      ],
      _communicationQuestions),
  _MajorQuestionSet(
      'engineering',
      [
        'teknik',
        'mesin',
        'sipil',
        'elektro',
        'industri',
        'arsitektur',
        'kimia',
        'pertambangan',
        'geologi',
        'lingkungan',
      ],
      _engineeringQuestions),
  _MajorQuestionSet(
      'business',
      [
        'manajemen',
        'bisnis',
        'ekonomi',
        'administrasi',
        'kewirausahaan',
        'perbankan',
        'keuangan',
        'pemasaran',
        'marketing',
        'logistik',
        'supply chain',
        'pariwisata',
      ],
      _businessQuestions),
];

/// Mengembalikan 8 pertanyaan minat yang paling relevan dengan jurusan.
/// Bila jurusan belum dikenali, dipakai pertanyaan umum lintas jurusan.
List<InterestQuestion> interestQuestionsForMajor(String? major) {
  final normalized = (major ?? '').trim().toLowerCase();
  if (normalized.isEmpty) return kInterestQuestions;
  for (final entry in _majorQuestionSets) {
    for (final keyword in entry.keywords) {
      if (normalized.contains(keyword)) return entry.questions;
    }
  }
  return kInterestQuestions;
}
