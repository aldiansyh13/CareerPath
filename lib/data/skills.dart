class SkillItem {
  final String id;
  final String label;
  final String hint;

  const SkillItem({required this.id, required this.label, required this.hint});
}

/// 6 skill yang dinilai 1–5.
const List<SkillItem> kSkillItems = [
  SkillItem(id: 'logic', label: 'Logika & Pemecahan Masalah', hint: 'Memecah masalah jadi langkah jelas'),
  SkillItem(id: 'design', label: 'Desain & Kreativitas Visual', hint: 'Membuat tampilan/ide visual yang rapi'),
  SkillItem(id: 'data', label: 'Analisis Data', hint: 'Membaca angka, pola, dan menarik kesimpulan'),
  SkillItem(id: 'communication', label: 'Komunikasi', hint: 'Menyampaikan ide lisan/tulisan dengan jelas'),
  SkillItem(id: 'coding', label: 'Pemrograman Dasar', hint: 'Menulis atau memahami kode/program'),
  SkillItem(id: 'leadership', label: 'Kepemimpinan & Kolaborasi', hint: 'Mengatur kerja tim dan mengambil inisiatif'),
];
