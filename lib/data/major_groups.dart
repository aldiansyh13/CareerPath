enum MajorGroup {
  general,
  it,
  accounting,
  health,
  law,
  education,
  psychology,
  communication,
  engineering,
  business,
}

class _MajorGroupKeywords {
  final MajorGroup group;
  final List<String> keywords;

  const _MajorGroupKeywords(this.group, this.keywords);
}

/// Urutan penting: bidang spesifik diperiksa sebelum istilah yang lebih umum.
const List<_MajorGroupKeywords> _majorGroups = [
  _MajorGroupKeywords(MajorGroup.accounting, [
    'komputerisasi akuntansi',
    'sistem informasi akuntansi',
    'akuntansi',
    'akuntan',
    'perpajakan',
    'pajak',
  ]),
  _MajorGroupKeywords(MajorGroup.it, [
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
  ]),
  _MajorGroupKeywords(MajorGroup.health, [
    'kedokteran',
    'keperawatan',
    'kebidanan',
    'farmasi',
    'gizi',
    'kesehatan',
    'fisioterapi',
    'radiologi',
    'analis kesehatan',
  ]),
  _MajorGroupKeywords(MajorGroup.law, [
    'hukum',
    'kenotariatan',
    'notaris',
  ]),
  _MajorGroupKeywords(MajorGroup.education, [
    'pendidikan',
    'keguruan',
    'pgsd',
    'paud',
    'bimbingan konseling',
  ]),
  _MajorGroupKeywords(MajorGroup.psychology, [
    'psikologi',
    'sosiologi',
    'antropologi',
    'ilmu sosial',
    'kesejahteraan sosial',
    'pekerja sosial',
  ]),
  _MajorGroupKeywords(MajorGroup.communication, [
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
  ]),
  _MajorGroupKeywords(MajorGroup.engineering, [
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
  ]),
  _MajorGroupKeywords(MajorGroup.business, [
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
  ]),
];

MajorGroup majorGroupForMajor(String? major) {
  final normalized = (major ?? '').trim().toLowerCase();
  if (normalized.isEmpty) return MajorGroup.general;
  for (final entry in _majorGroups) {
    if (entry.keywords.any(normalized.contains)) return entry.group;
  }
  return MajorGroup.general;
}
