import 'major_groups.dart';

class SkillItem {
  final String id;
  final String label;
  final String hint;

  const SkillItem({required this.id, required this.label, required this.hint});
}

/// 6 skill yang dinilai 1–5.
const List<SkillItem> kSkillItems = [
  SkillItem(
      id: 'logic',
      label: 'Logika & Pemecahan Masalah',
      hint: 'Memecah masalah jadi langkah jelas'),
  SkillItem(
      id: 'design',
      label: 'Desain & Kreativitas Visual',
      hint: 'Membuat tampilan/ide visual yang rapi'),
  SkillItem(
      id: 'data',
      label: 'Analisis Data',
      hint: 'Membaca angka, pola, dan menarik kesimpulan'),
  SkillItem(
      id: 'communication',
      label: 'Komunikasi',
      hint: 'Menyampaikan ide lisan/tulisan dengan jelas'),
  SkillItem(
      id: 'organization',
      label: 'Ketelitian & Manajemen Tugas',
      hint: 'Mengatur informasi, waktu, dan detail pekerjaan'),
  SkillItem(
      id: 'leadership',
      label: 'Kepemimpinan & Kolaborasi',
      hint: 'Mengatur kerja tim dan mengambil inisiatif'),
];

const List<SkillItem> _itSkills = [
  SkillItem(
      id: 'it_problem_solving',
      label: 'Logika & Pemecahan Masalah',
      hint: 'Memecah masalah teknis menjadi langkah yang jelas'),
  SkillItem(
      id: 'it_coding',
      label: 'Pemrograman Dasar',
      hint: 'Menulis dan memahami kode program'),
  SkillItem(
      id: 'it_data',
      label: 'Analisis Data',
      hint: 'Mengolah data dan menemukan pola'),
  SkillItem(
      id: 'it_system',
      label: 'Perancangan Sistem',
      hint: 'Memahami kebutuhan dan alur sebuah sistem'),
  SkillItem(
      id: 'it_debugging',
      label: 'Pengujian & Debugging',
      hint: 'Menemukan penyebab kesalahan dan memperbaikinya'),
  SkillItem(
      id: 'it_collaboration',
      label: 'Kolaborasi Teknis',
      hint: 'Menjelaskan solusi dan bekerja dalam tim produk'),
];

const List<SkillItem> _accountingSkills = [
  SkillItem(
      id: 'accounting_records',
      label: 'Pencatatan Transaksi',
      hint: 'Mencatat jurnal dan transaksi secara akurat'),
  SkillItem(
      id: 'accounting_reports',
      label: 'Penyusunan Laporan Keuangan',
      hint: 'Menyusun neraca, laba rugi, dan arus kas'),
  SkillItem(
      id: 'accounting_reconciliation',
      label: 'Rekonsiliasi & Ketelitian Angka',
      hint: 'Mencocokkan saldo dan menemukan selisih'),
  SkillItem(
      id: 'accounting_tax',
      label: 'Perpajakan Dasar',
      hint: 'Memahami perhitungan dan dokumen pajak'),
  SkillItem(
      id: 'accounting_tools',
      label: 'Spreadsheet & Software Akuntansi',
      hint: 'Mengolah data keuangan dengan alat digital'),
  SkillItem(
      id: 'accounting_audit',
      label: 'Audit & Pengendalian Internal',
      hint: 'Memeriksa bukti dan kepatuhan proses'),
];

const List<SkillItem> _healthSkills = [
  SkillItem(
      id: 'health_patient_care',
      label: 'Perawatan Pasien',
      hint: 'Memberikan bantuan yang aman dan empatik'),
  SkillItem(
      id: 'health_observation',
      label: 'Observasi Klinis',
      hint: 'Mengamati gejala dan perubahan kondisi'),
  SkillItem(
      id: 'health_procedure',
      label: 'Prosedur Kesehatan',
      hint: 'Mengikuti prosedur klinis dan keselamatan'),
  SkillItem(
      id: 'health_records',
      label: 'Pencatatan Medis',
      hint: 'Mendokumentasikan informasi kesehatan dengan teliti'),
  SkillItem(
      id: 'health_education',
      label: 'Edukasi Kesehatan',
      hint: 'Menjelaskan informasi kesehatan dengan jelas'),
  SkillItem(
      id: 'health_teamwork',
      label: 'Kolaborasi Tim Medis',
      hint: 'Berkoordinasi dalam pelayanan kesehatan'),
];

const List<SkillItem> _lawSkills = [
  SkillItem(
      id: 'law_research',
      label: 'Riset Hukum',
      hint: 'Menemukan peraturan dan putusan yang relevan'),
  SkillItem(
      id: 'law_analysis',
      label: 'Analisis Kasus Hukum',
      hint: 'Menghubungkan fakta dengan aturan hukum'),
  SkillItem(
      id: 'law_drafting',
      label: 'Penyusunan Dokumen Hukum',
      hint: 'Menulis kontrak dan dokumen secara tepat'),
  SkillItem(
      id: 'law_argument',
      label: 'Argumentasi Hukum',
      hint: 'Menyampaikan alasan berbasis bukti dan aturan'),
  SkillItem(
      id: 'law_negotiation',
      label: 'Negosiasi & Mediasi',
      hint: 'Mencari penyelesaian sengketa yang adil'),
  SkillItem(
      id: 'law_detail',
      label: 'Ketelitian Fakta & Bukti',
      hint: 'Memeriksa kronologi dan dokumen secara cermat'),
];

const List<SkillItem> _educationSkills = [
  SkillItem(
      id: 'education_teaching',
      label: 'Mengajar & Menjelaskan',
      hint: 'Menyampaikan materi agar mudah dipahami'),
  SkillItem(
      id: 'education_planning',
      label: 'Perencanaan Pembelajaran',
      hint: 'Menyusun tujuan dan kegiatan belajar'),
  SkillItem(
      id: 'education_materials',
      label: 'Pengembangan Media Belajar',
      hint: 'Membuat materi yang menarik dan relevan'),
  SkillItem(
      id: 'education_assessment',
      label: 'Evaluasi Pembelajaran',
      hint: 'Menilai pemahaman dan memberi umpan balik'),
  SkillItem(
      id: 'education_guidance',
      label: 'Bimbingan Siswa',
      hint: 'Mendampingi kebutuhan belajar siswa'),
  SkillItem(
      id: 'education_classroom',
      label: 'Manajemen Kelas',
      hint: 'Membangun kelas yang tertib dan aktif'),
];

const List<SkillItem> _psychologySkills = [
  SkillItem(
      id: 'psychology_listening',
      label: 'Mendengar Aktif',
      hint: 'Memahami pengalaman orang tanpa menghakimi'),
  SkillItem(
      id: 'psychology_observation',
      label: 'Observasi Perilaku',
      hint: 'Mengenali pola perilaku dan konteksnya'),
  SkillItem(
      id: 'psychology_counseling',
      label: 'Konseling Dasar',
      hint: 'Membangun percakapan bantuan yang empatik'),
  SkillItem(
      id: 'psychology_research',
      label: 'Riset Sosial',
      hint: 'Mengumpulkan dan menafsirkan data perilaku'),
  SkillItem(
      id: 'psychology_assessment',
      label: 'Asesmen Psikologis Dasar',
      hint: 'Memahami tujuan dan etika asesmen'),
  SkillItem(
      id: 'psychology_facilitation',
      label: 'Fasilitasi Kelompok',
      hint: 'Membantu kelompok berdiskusi secara sehat'),
];

const List<SkillItem> _communicationSkills = [
  SkillItem(
      id: 'communication_writing',
      label: 'Penulisan & Storytelling',
      hint: 'Menyusun pesan dan cerita yang kuat'),
  SkillItem(
      id: 'communication_visual',
      label: 'Komunikasi Visual',
      hint: 'Menyampaikan pesan melalui desain visual'),
  SkillItem(
      id: 'communication_content',
      label: 'Produksi Konten',
      hint: 'Membuat konten foto, video, atau digital'),
  SkillItem(
      id: 'communication_public',
      label: 'Public Speaking',
      hint: 'Menyampaikan gagasan di depan audiens'),
  SkillItem(
      id: 'communication_campaign',
      label: 'Strategi Media & Kampanye',
      hint: 'Merancang pesan untuk target audiens'),
  SkillItem(
      id: 'communication_audience',
      label: 'Riset Audiens',
      hint: 'Memahami kebutuhan dan respons audiens'),
];

const List<SkillItem> _engineeringSkills = [
  SkillItem(
      id: 'engineering_drawing',
      label: 'Gambar Teknik & CAD',
      hint: 'Membaca dan membuat rancangan teknis'),
  SkillItem(
      id: 'engineering_calculation',
      label: 'Perhitungan Teknik',
      hint: 'Menggunakan matematika dan fisika terapan'),
  SkillItem(
      id: 'engineering_design',
      label: 'Perancangan Solusi Teknik',
      hint: 'Merancang solusi yang aman dan fungsional'),
  SkillItem(
      id: 'engineering_testing',
      label: 'Pengujian & Keselamatan',
      hint: 'Menguji hasil dan mengenali risiko'),
  SkillItem(
      id: 'engineering_tools',
      label: 'Penggunaan Alat & Material',
      hint: 'Memilih alat dan material sesuai kebutuhan'),
  SkillItem(
      id: 'engineering_project',
      label: 'Manajemen Proyek Teknik',
      hint: 'Mengatur waktu, biaya, dan pekerjaan lapangan'),
];

const List<SkillItem> _businessSkills = [
  SkillItem(
      id: 'business_analysis',
      label: 'Analisis Bisnis',
      hint: 'Membaca data untuk mendukung keputusan bisnis'),
  SkillItem(
      id: 'business_marketing',
      label: 'Pemasaran & Riset Pasar',
      hint: 'Memahami pelanggan dan peluang pasar'),
  SkillItem(
      id: 'business_finance',
      label: 'Perencanaan Keuangan',
      hint: 'Menyusun anggaran dan menilai biaya'),
  SkillItem(
      id: 'business_operations',
      label: 'Manajemen Operasional',
      hint: 'Membuat proses kerja lebih efisien'),
  SkillItem(
      id: 'business_negotiation',
      label: 'Negosiasi & Penjualan',
      hint: 'Membangun kesepakatan dan relasi pelanggan'),
  SkillItem(
      id: 'business_leadership',
      label: 'Kepemimpinan Tim',
      hint: 'Mengatur prioritas dan menggerakkan tim'),
];

List<SkillItem> skillItemsForMajor(String? major) {
  switch (majorGroupForMajor(major)) {
    case MajorGroup.it:
      return _itSkills;
    case MajorGroup.accounting:
      return _accountingSkills;
    case MajorGroup.health:
      return _healthSkills;
    case MajorGroup.law:
      return _lawSkills;
    case MajorGroup.education:
      return _educationSkills;
    case MajorGroup.psychology:
      return _psychologySkills;
    case MajorGroup.communication:
      return _communicationSkills;
    case MajorGroup.engineering:
      return _engineeringSkills;
    case MajorGroup.business:
      return _businessSkills;
    case MajorGroup.general:
      return kSkillItems;
  }
}
