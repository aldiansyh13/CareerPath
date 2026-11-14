/// Hasil contoh (fallback/offline) sesuai format PRD.
/// Digunakan untuk mode "Jelajahi contoh hasil" dan cadangan saat Gemini gagal.
const Map<String, dynamic> kSampleResult = {
  'summary':
      'Berdasarkan minat pada desain, pengalaman pengguna, dan kemampuan komunikasi yang baik, kamu memiliki potensi kuat di bidang yang menggabungkan kreativitas dan pemahaman pengguna. Skill teknis dasar dapat dilatih bertahap dalam 30 hari ke depan.',
  'careers': [
    {
      'title': 'UI/UX Designer',
      'match_score': 88,
      'reason':
          'Jawabanmu menunjukkan ketertarikan pada tampilan yang mudah dipakai dan peran membuat desain visual. Skill desain dan komunikasi yang kamu nilai tinggi mendukung pekerjaan riset pengguna dan pembuatan prototipe.',
      'skills_owned': ['Desain visual', 'Komunikasi', 'Empati pengguna'],
      'skills_missing': [
        'User research terstruktur',
        'Prototyping Figma',
        'Usability testing'
      ],
      'roadmap': [
        {
          'week': 1,
          'title': 'Dasar UX',
          'actions': [
            'Pelajari prinsip dasar UX (hierarki, kontras, konsistensi)',
            'Amati dan catat alur 3 aplikasi populer yang kamu pakai'
          ]
        },
        {
          'week': 2,
          'title': 'Riset & Persona',
          'actions': [
            'Wawancara singkat 2 teman tentang pengalaman memakai satu aplikasi',
            'Buat 1 user persona sederhana dari hasil wawancara'
          ]
        },
        {
          'week': 3,
          'title': 'Prototyping',
          'actions': [
            'Pelajari dasar Figma (frame, komponen, auto layout)',
            'Buat wireframe dan prototipe 2 layar untuk ide sederhana'
          ]
        },
        {
          'week': 4,
          'title': 'Uji & Portofolio',
          'actions': [
            'Minta 2 orang mencoba prototipe dan catat masukan',
            'Rapikan hasil menjadi 1 studi kasus mini untuk portofolio'
          ]
        }
      ]
    },
    {
      'title': 'Frontend Developer',
      'match_score': 79,
      'reason':
          'Minatmu pada pembuatan fitur yang terlihat oleh pengguna dan kemauan belajar hal teknis selaras dengan peran frontend. Dengan latihan logika dan pemrograman dasar, kamu bisa mulai membangun antarmuka aplikasi.',
      'skills_owned': ['Kreativitas visual', 'Ketelitian', 'Kemauan belajar'],
      'skills_missing': [
        'HTML/CSS/JavaScript atau Flutter widget',
        'Git dasar',
        'Debugging'
      ],
      'roadmap': [
        {
          'week': 1,
          'title': 'Dasar Web/UI',
          'actions': [
            'Pelajari struktur dasar HTML dan styling CSS',
            'Buat 1 halaman profil sederhana'
          ]
        },
        {
          'week': 2,
          'title': 'Interaktivitas',
          'actions': [
            'Pelajari dasar JavaScript (variabel, fungsi, event)',
            'Tambahkan interaksi sederhana pada halaman minggu 1'
          ]
        },
        {
          'week': 3,
          'title': 'Komponen & Layout',
          'actions': [
            'Pelajari konsep komponen/layout (atau widget Flutter)',
            'Bangun ulang halaman menjadi beberapa komponen rapi'
          ]
        },
        {
          'week': 4,
          'title': 'Proyek Mini',
          'actions': [
            'Buat mini project 1 fitur (mis. daftar tugas)',
            'Publikasikan kode ke GitHub sebagai portofolio awal'
          ]
        }
      ]
    },
    {
      'title': 'Product Manager',
      'match_score': 72,
      'reason':
          'Kamu menunjukkan minat mengatur rencana dan memahami kebutuhan pengguna/bisnis. Kemampuan komunikasi dan kolaborasi menjadi modal untuk menjembatani tim dan menyusun prioritas.',
      'skills_owned': ['Komunikasi', 'Kolaborasi', 'Orientasi tujuan'],
      'skills_missing': [
        'Prioritisasi (impact/effort)',
        'Penulisan requirement',
        'Metrik produk dasar'
      ],
      'roadmap': [
        {
          'week': 1,
          'title': 'Pahami Produk',
          'actions': [
            'Pilih 1 aplikasi dan tulis masalah utama yang diselesaikannya',
            'Identifikasi 3 fitur inti dan nilai bagi pengguna'
          ]
        },
        {
          'week': 2,
          'title': 'Kebutuhan Pengguna',
          'actions': [
            'Tulis 3 user story sederhana (sebagai…, saya ingin…, agar…)',
            'Tentukan kriteria sukses untuk tiap story'
          ]
        },
        {
          'week': 3,
          'title': 'Prioritas',
          'actions': [
            'Pelajari matriks impact vs effort',
            'Urutkan backlog kecil dari ide-ide produk pilihamu'
          ]
        },
        {
          'week': 4,
          'title': 'Komunikasi Rencana',
          'actions': [
            'Buat roadmap 1 bulan versi sederhana (mingguan)',
            'Presentasikan rencana ke teman/mentor untuk masukan'
          ]
        }
      ]
    }
  ]
};

/// Input contoh (untuk mode demo / jelajah contoh).
const Map<String, dynamic> kSampleInput = {
  'profile': {
    'name': 'Contoh Pengguna',
    'major': 'Sistem Informasi',
    'semester': 4
  },
  'interests': {
    'q1': 'Merancang tampilan yang mudah dipakai',
    'q2': 'Membuat desain atau presentasi visual',
    'q3': 'Pengguna bingung memakai aplikasi',
    'q4': 'Warna, layout, dan pengalaman pengguna',
    'q5': 'Prototipe/desain yang rapi dan intuitif',
    'q6': 'Prinsip desain, riset pengguna, dan Figma',
    'q7': 'Kolaborasi dekat dengan pengguna dan tim produk',
    'q8': 'Punya portofolio desain/prototipe yang kuat',
  },
  'skills': {
    'logic': 3,
    'design': 4,
    'data': 2,
    'communication': 4,
    'coding': 2,
    'leadership': 3,
  }
};
