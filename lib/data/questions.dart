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

/// 8 pertanyaan minat (pilihan ganda) untuk asesmen ~2 menit.
const List<InterestQuestion> kInterestQuestions = [
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
