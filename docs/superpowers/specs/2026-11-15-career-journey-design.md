# Career Journey — Design

## Intent and why

CareerPath AI saat ini berhasil membawa pengguna dari asesmen ke rekomendasi, tetapi pengalaman berhenti di layar hasil. Perubahan ini menjadikannya pendamping perjalanan karier: pengguna memilih satu fokus karier, melanjutkan roadmap 30 hari, menandai aksi yang selesai, dan memantau perubahan skill dari waktu ke waktu.

Pengguna utama tetap mahasiswa semester 3–8 dan fresh graduate Indonesia. Keberhasilan perubahan ini terlihat ketika pengguna yang sudah memiliki hasil asesmen membuka aplikasi dan langsung tahu satu langkah berikutnya, dapat menyelesaikannya, lalu melihat progres yang bertambah.

## Goals

- Mengubah beranda dari kartu ajakan asesmen menjadi pusat perjalanan karier aktif.
- Memungkinkan pengguna memilih satu rekomendasi sebagai fokus tanpa kehilangan dua rekomendasi lain.
- Membuat setiap aksi pada roadmap empat minggu dapat dicentang dan disimpan.
- Menampilkan progres keseluruhan, progres minggu berjalan, dan langkah berikutnya secara jelas.
- Memungkinkan pengguna memperbarui penilaian enam skill dan melihat perubahan dari nilai awal.
- Menjaga autentikasi, asesmen, AI, fallback contoh, riwayat, dan mode offline tetap berfungsi.
- Menjaga pengalaman aman di layar 320×568 logical pixels serta target sentuh minimal 48 dp.

## Non-goals

- Menghasilkan roadmap baru setiap kali satu aksi selesai.
- Chat mentor AI, notifikasi, upload bukti, komunitas, kursus berbayar, atau gamifikasi berhadiah.
- Mengubah katalog delapan karier atau kontrak JSON Gemini/OpenAI.
- Mengklaim progres skill objektif; nilai skill tetap merupakan penilaian diri pengguna.
- Menghapus atau memigrasikan riwayat asesmen lama secara destruktif.

## Anti-goals

- Jangan membuat beranda menjadi kumpulan grafik tanpa aksi utama.
- Jangan membuat pengalaman terasa seperti game skill-tree atau habit tracker generik.
- Jangan menyembunyikan bahwa hasil AI adalah saran awal, bukan keputusan final.
- Jangan memblokir progres lokal ketika Firebase atau internet tidak tersedia.
- Jangan membuat satu checklist yang selesai otomatis menaikkan level skill; perubahan level harus dikonfirmasi pengguna.

## Constraints and preserved behavior

- Flutter/Material 3 untuk Android 7.0+.
- Bahasa Indonesia, sistem Back Android, skala teks, dan safe area tetap dihormati.
- `CareerResult` dan `AssessmentRecord` lama tetap dapat dibaca tanpa perubahan format.
- Penyimpanan mengikuti pola local-first di `LocalStore` dan sinkron cloud bila pengguna masuk.
- Hasil contoh offline tetap berlabel jelas dan dapat dipakai untuk mencoba journey.
- Error cloud tidak menghapus progres lokal; UI memberi status sinkronisasi yang jujur.

## Approaches considered

### 1. Asesmen yang lebih cantik

Memperkuat layar hasil dan kartu karier tanpa state baru. Paling kecil risikonya, tetapi pengalaman tetap berakhir setelah rekomendasi sehingga tidak memenuhi tujuan “career path”.

### 2. Dashboard tracker

Menambah grafik, statistik, dan daftar aktivitas di beranda. Mudah dipindai, tetapi berisiko menjadi aplikasi produktivitas generik dan meletakkan visualisasi di atas tindakan.

### 3. Career Journey — selected

Satu jalur karier aktif menjadi pusat beranda; roadmap, langkah berikutnya, dan skill berkembang berada dalam satu cerita. Pendekatan ini dipilih karena paling langsung menjawab kebutuhan melanjutkan roadmap dan memantau skill.

## Visual direction

### Apprenticeship Logbook

Dunia visual mengambil disiplin buku kerja praktik dan paspor kompetensi, diterjemahkan melalui Material 3—bukan skeuomorfisme literal.

- Warna dasar: hijau tinta gelap, permukaan warm ivory, hijau sage, aksen kuning penanda, dan merah terakota hanya untuk perhatian.
- Bentuk: sudut sedang, garis tipis seperti lembar kerja, progress segment yang terasa seperti cap kompetensi.
- Tipografi: skala Material yang tegas; headline padat dan hangat, body sangat terbaca.
- Ikon: Material Symbols konsisten; tidak ada emoji dekoratif atau ilustrasi generik.
- Motion: checklist memberi perubahan tonal dan progress bergerak singkat; hormati reduced motion.
- Dark mode disiapkan lewat color roles, bukan membalik warna mentah.

Konsep awal dijalankan secara degraded karena layanan challenger tidak dapat dijangkau. Decision page juga tidak dapat dibuka karena browser host sesi tidak tersedia. Sesuai delegasi pengguna untuk memilih arah terbaik, arah roll dipakai dan build path ditetapkan code-first untuk sesi ini; keputusan ini belum disimpan sebagai default global proyek.

## Information architecture

Pada ponsel, aplikasi memakai `NavigationBar` dengan tiga destinasi setelah pengguna memiliki profil:

1. **Perjalanan** — jalur aktif, next action, progres roadmap, dan skill.
2. **Jelajahi** — asesmen baru, tiga rekomendasi terakhir, dan riwayat asesmen.
3. **Profil** — profil pengguna, status akun/sinkronisasi, masuk/keluar.

Flow onboarding dan asesmen tetap memakai navigasi layar penuh agar fokus. Pengguna tanpa profil tetap masuk melalui Welcome → Profile → Assessment. Pengguna lama tanpa journey melihat empty state di tab Perjalanan dan dapat memilih rekomendasi dari hasil terakhir atau memulai asesmen.

## Core screens and behavior

### 1. Perjalanan — active journey home

First viewport harus menjawab empat hal tanpa scroll: fokus karier, progres keseluruhan, minggu aktif, dan satu aksi berikutnya.

```text
Perjalananmu                         [avatar]
UI/UX Designer · 88% cocok
██████████░░  62% roadmap

MINGGU 3 · Validasi desain
Berikutnya: Uji prototipe ke 3 teman
[Tandai selesai]

Skill berkembang  +2 sejak mulai      [Lihat]
```

Di bawahnya:

- Empat segmen minggu dengan status selesai, aktif, dan terkunci secara visual tetapi tetap dapat dibuka.
- Daftar aksi minggu aktif; setiap baris adalah checkbox 48 dp dengan undo melalui snackbar.
- Ringkasan enam skill: nilai awal, nilai sekarang, dan delta. Hanya skill yang berubah memakai aksen.
- Aksi sekunder “Lihat roadmap lengkap” dan “Evaluasi skill”.

Jika semua aksi selesai, hero berubah menjadi completion state yang tenang: merayakan konsistensi, menawarkan evaluasi skill dan asesmen ulang, tanpa menjanjikan kesiapan kerja.

### 2. Pilih fokus karier

Di layar hasil, setiap kartu mendapat aksi `Jadikan fokus`. Satu journey aktif pada satu waktu. Memilih fokus baru tidak menghapus journey lama; journey lama disimpan sebagai arsip dan dapat diaktifkan kembali dari Jelajahi.

Untuk hasil baru, rekomendasi pertama tidak otomatis menjadi fokus. Pengguna membuat keputusan eksplisit. Untuk mode demo/contoh, journey tetap boleh dibuat dan selalu membawa label `Contoh`.

### 3. Roadmap detail

Detail karier berubah dari daftar statis menjadi roadmap interaktif:

- Header berisi judul karier, skor kecocokan, progres, serta label sumber hasil.
- Empat blok minggu memakai vertical stepper Material yang sederhana.
- Setiap aksi dapat dicentang; penyimpanan terjadi optimistis ke lokal lalu cloud.
- Alasan, skill dimiliki, dan skill yang perlu dilatih tetap tersedia setelah roadmap, bukan hilang.
- Disclaimer tetap tampil.

### 4. Skill check-in

Layar khusus menampilkan enam skill asesmen dengan skala 1–5, nilai awal, nilai sekarang, dan deskripsi setiap level. Pengguna harus menekan `Simpan perkembangan`; slider tidak menyimpan otomatis. Setelah simpan, aplikasi menampilkan ringkasan perubahan dan tanggal check-in.

Data bersifat self-assessment dan global per pengguna, bukan terpisah per journey. Dengan demikian, pindah fokus karier tidak mereset perkembangan enam skill. Copy harus mengatakan “penilaianmu”, bukan “kemampuan terbukti”. Bila semua nilai sama, penyimpanan tetap valid dan dicatat sebagai check-in tanpa perubahan.

### 5. Jelajahi

- Aksi utama `Mulai asesmen baru`.
- `Hasil terbaru` menampilkan tiga rekomendasi dengan status fokus bila relevan.
- `Perjalanan tersimpan` menampilkan journey aktif dan arsip.
- `Riwayat asesmen` tetap dapat dibuka tanpa memanggil AI.

### 6. Profil

- Data nama, jurusan, semester.
- Status akun: lokal atau tersinkron.
- Aksi masuk/daftar, edit profil, dan keluar.
- Keluar mengikuti perilaku sekarang; copy harus menjelaskan konsekuensi data perangkat sebelum aksi bila implementasi tetap membersihkan cache lokal.

## Data design

Tambahkan model baru tanpa mengubah `CareerResult`:

```text
CareerJourney
  id
  assessmentId
  careerTitle
  matchScore
  isSample
  startedAt
  updatedAt
  completedActionIds[]
  sourceCareerSnapshot {reason, skillsOwned[], skillsMissing[], roadmap[]}

UserCareerState
  activeJourneyId
  activeJourneyChangedAt

UserSkillProgress
  baselineSkills {skillId: 1..5}
  currentSkills {skillId: 1..5}
  checkIns[] {createdAt, ratings}
```

ID aksi stabil diturunkan dari `week` dan indeks aksi (`w{week}-a{index}`), bukan dari teks, agar perubahan copy tidak menghilangkan checklist. Journey menyimpan snapshot lengkap satu `CareerRecommendation`, termasuk reason, skills owned/missing, dan seluruh roadmap/action text. Dengan begitu journey tetap dapat dibuka dan diselesaikan bila source assessment hilang.

Local storage memakai key yang dipisah per UID seperti profil dan riwayat. Cloud memakai `users/{uid}/journeys/{journeyId}`, sedangkan `activeJourneyId` dan skill progress berada pada state pengguna yang terpisah. Source assessment tetap berada di koleksi `assessments`.

Aturan merge menggunakan `updatedAt` terbaru per journey ID. `activeJourneyId` memiliki timestamp perubahan tersendiri; aktivasi terbaru menang lintas perangkat sehingga invariant satu journey aktif tetap terjaga. Jika cloud gagal, state lokal tetap menjadi sumber UI dan status “Belum tersinkron” ditampilkan. Tidak ada migrasi paksa: pengguna dengan data lama melihat empty state dan dapat membuat journey dari riwayat yang sudah ada.

Skill progress bersifat global per pengguna. Baseline pertama berasal dari asesmen yang membuat journey pertama; asesmen atau journey berikutnya tidak menimpa baseline. Nilai terbaru hanya berubah melalui skill check-in eksplisit. UI journey dapat menyorot skill yang relevan dari snapshot rekomendasi, tetapi delta selalu dihitung dari skill profile global.

Journey tamu tetap milik perangkat dan tidak otomatis diunggah saat login. Journey akun memakai cache bernama UID dan tidak boleh terlihat ketika pengguna telah logout. Logout menghapus cache journey akun pada perangkat untuk menjaga privasi perangkat bersama; data cloud tetap tersedia ketika pengguna login kembali. Riwayat asesmen lama mempertahankan perilaku yang sudah ada dan tidak ikut diubah dalam scope ini.

## State and edge cases

- **No profile:** onboarding lama tetap digunakan.
- **Profile, no assessment:** empty state dengan aksi mulai asesmen.
- **Assessment, no journey:** tawarkan tiga rekomendasi terbaru untuk dipilih.
- **Journey data references missing assessment:** tampilkan snapshot minimum dan aksi `Pulihkan dari hasil lain`; jangan crash.
- **Active week:** minggu aktif adalah minggu paling awal yang masih memiliki aksi belum selesai, bukan tujuh hari kalender sejak journey dibuat. Minggu berikutnya tetap dapat dibuka; tidak ada hard lock. Bila semua aksi selesai, journey masuk completion state.
- **Offline:** checklist dan check-in tersimpan lokal; banner sinkronisasi ringkas, bukan dialog.
- **Cloud conflict:** versi `updatedAt` terbaru menang per journey; checklist disimpan sebagai union jika timestamp sama untuk menghindari kehilangan centang.
- **Sample result:** seluruh journey diberi label `Contoh`; tidak dicampur menjadi bukti progres nyata.
- **Long text / large font:** judul membungkus, tombol tidak memakai teks satu baris paksa, cards tidak memakai tinggi tetap.
- **Sign out:** tidak boleh diam-diam menghapus journey akun dari cloud. Perilaku pembersihan cache lokal harus teruji dan copy konsekuensi harus jelas.

## Copy principles

- Aksi dulu: “Lanjutkan minggu 2”, “Tandai selesai”, “Evaluasi skill”.
- Hindari klaim: gunakan “progres roadmap” dan “penilaian skill”, bukan “kesiapan kerja”.
- Rayakan konsistensi secara spesifik: “3 dari 4 aksi minggu ini selesai”.
- Error menjelaskan apa yang tetap aman: “Tersimpan di perangkat. Sinkronisasi akan dicoba lagi.”

## Testing and acceptance

- Widget test untuk empty state, journey aktif, checklist, snackbar undo, dan completion state.
- Unit test serialization, action ID stability, progress calculation, merge, dan local-store isolation per UID.
- Flow test: hasil → pilih fokus → centang aksi → restart app → progres tetap ada.
- Flow test: skill check-in → delta tampil → restart app → nilai tetap ada.
- Regression: seluruh tes auth, asesmen, AI fallback, hasil, riwayat, dan layar kecil tetap lulus.
- `flutter analyze` tanpa error/warning baru.
- Screenshot emulator Android untuk phone compact; cek light, dark, dan font scale 1.3 dalam maksimal dua pass.

## Builder-owned implementation choices

- Pemisahan widget dan file selama nama domain tetap jelas.
- Mekanisme retry sinkronisasi selama local-first dan status jujur dipertahankan.
- Detail motion dan tonal elevation dalam batas Material 3 dan reduced motion.
- Urutan implementasi internal, dengan syarat model/persistensi diuji sebelum UI bergantung padanya.

## Builder review decisions

Reviewer implementasi meminta kepastian mengenai kepemilikan skill, aturan minggu aktif, snapshot recovery, konflik active journey, dan batas data tamu/akun. Keputusan yang mengikat:

- Skill progress global per pengguna dan bertahan saat fokus karier berganti.
- Minggu aktif ditentukan oleh aksi paling awal yang belum selesai.
- Snapshot journey menyimpan seluruh `CareerRecommendation` yang dibutuhkan untuk tetap interaktif.
- `activeJourneyId` bertimestamp adalah sumber kebenaran tunggal lintas perangkat.
- Data tamu tidak otomatis digabung ke akun; cache journey akun dihapus dari perangkat saat logout, sementara data cloud tetap ada.
