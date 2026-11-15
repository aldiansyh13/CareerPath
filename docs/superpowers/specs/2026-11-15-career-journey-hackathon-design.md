# Career Journey Hackathon Slice — Design

## Intent

CareerPath AI harus menunjukkan kepada juri bahwa hasil AI tidak berhenti sebagai rekomendasi. Pengguna memilih satu karier sebagai fokus, melihat langkah belajar berikutnya, mencentang roadmap 30 hari, dan menemukan progres itu kembali saat aplikasi dibuka ulang.

## Demo promise

1. Selesaikan asesmen dan terima tiga rekomendasi.
2. Tekan `Jadikan fokus` pada satu karier.
3. Kembali ke beranda yang menampilkan jalur aktif, progress, dan aksi berikutnya.
4. Tandai satu aksi roadmap selesai dan lihat progress bertambah.
5. Buka ulang aplikasi dan progress tetap tersimpan.

## Goals

- Satu active career journey pada satu waktu.
- Checklist untuk seluruh aksi roadmap empat minggu.
- Progress keseluruhan, minggu aktif, dan next action terlihat di beranda.
- Penyimpanan lokal yang stabil dan terisolasi antara mode tamu dan UID akun.
- Detail karier tetap memuat alasan, skill dimiliki, skill gap, roadmap, dan disclaimer.
- Alur autentikasi, asesmen, AI, fallback contoh, dan riwayat lama tidak rusak.

## Deliberately deferred

- Skill check-in atau perubahan rating 1–5 dan grafik skill.
- Banyak journey, archive, atau riwayat ganti fokus.
- Sinkronisasi progress journey ke Firestore.
- Bottom navigation baru, notifikasi, gamifikasi, upload bukti, atau AI mentor.

## UX

### Hasil rekomendasi

Setiap `CareerCard` mendapat aksi `Jadikan fokus`. Journey baru menggantikan journey lokal sebelumnya; hasil asesmen lama tidak dihapus. Setelah tersimpan, aplikasi membuka Beranda dan menampilkan snackbar `Roadmap <karier> dijadikan fokusmu`.

### Beranda

Tanpa journey, perilaku sekarang dipertahankan. Dengan journey, first viewport menampilkan jalur aktif, match score, jumlah langkah selesai, progress bar, minggu aktif, next action, `Tandai selesai`, dan `Buka roadmap`. Kartu asesmen ulang dan riwayat lama tetap tersedia di bawahnya.

### Detail roadmap

Empat minggu tampil sebagai daftar cards. Setiap action memakai checkbox minimum 48 dp. Toggle disimpan langsung dan snackbar menyediakan `Urungkan`. Minggu aktif adalah minggu pertama yang masih memiliki aksi belum selesai; minggu lain tetap dapat dicentang. Jika selesai semua, copy menjadi `Roadmap 30 hari selesai` dan menawarkan asesmen ulang tanpa klaim siap kerja.

### Skill monitoring in this slice

Skill belum dinilai ulang. Produk hanya menampilkan `Skill yang sudah kamu miliki` dan `Skill yang perlu dilatih` dari hasil AI. Progress yang ditampilkan adalah progress roadmap, bukan kenaikan skill.

## Visual direction

Gunakan Apprenticeship Logbook secara ringan di atas Material 3: hijau tinta sebagai primary, warm ivory background, amber highlight; label uppercase kecil untuk `JALUR AKTIF` dan `MINGGU N`; progress jelas tanpa grafik dekoratif; cards datar dengan border tonal; Material icons konsisten; tanpa aset raster baru.

## Data model

```text
CareerJourney
  assessmentId
  careerSnapshot (CareerRecommendation JSON lengkap)
  isSample
  startedAt
  updatedAt
  completedActionIds[]
```

Hanya satu journey disimpan per storage namespace. Action ID stabil memakai `w{week}-a{index}`. Snapshot lengkap membuat roadmap tetap tersedia tanpa assessment sumber. Local key: tamu `active_career_journey`, akun `active_career_journey_<uid>`. Journey tamu tidak otomatis dicampur dengan journey akun. Firestore tidak masuk slice ini.

## Acceptance

- `Jadikan fokus` membuat journey dari rekomendasi terpilih.
- Beranda menampilkan judul, match score, progress, active week, dan next action.
- Toggle mengubah progress dan tersimpan setelah restart.
- Undo mengembalikan action.
- Hasil contoh membawa label `Contoh`.
- Journey tamu dan UID berbeda tidak berbagi storage.
- Existing tests tetap lulus; layar 320×568 tidak overflow.
- `flutter analyze --no-pub` tidak menghasilkan issue baru.

