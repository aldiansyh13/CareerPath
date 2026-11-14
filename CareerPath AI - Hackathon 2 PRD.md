# CareerPath AI - Hackathon 2: PRD

Nov 14, 2026 - @Habib

## 1. Ringkasan Produk dan Prioritas Fitur

Tujuan versi hackathon: dalam 48 jam menghasilkan aplikasi Android yang dapat menjalankan alur lengkap (login, asesmen, analisis Gemini, hasil, roadmap, riwayat tersimpan di Firebase) tanpa crash di depan juri.

### 1.1 Ringkasan

| Item | Isi |
| --- | --- |
| Nama | CareerPath AI |
| Pengguna | Mahasiswa semester 3–8 dan fresh graduate |
| Masalah | Bingung memilih karier dan tidak tahu skill apa yang harus dipelajari |
| Solusi | Asesmen 2 menit, lalu rekomendasi karier, skill gap, dan roadmap belajar 30 hari dari Gemini |
| Platform | Android (Flutter) |
| Backend | Firebase Authentication (email dan password) + Cloud Firestore |
| AI | Gemini API lewat HTTP (REST), output JSON terstruktur |

### 1.2 Metrik keberhasilan

| Tujuan | Metrik | Target |
| --- | --- | --- |
| Alur lengkap berjalan | Skenario demo selesai tanpa error | 3 dari 3 skenario |
| Respons cepat | Waktu dari tombol Analisis sampai hasil tampil | di bawah 15 detik |
| Hasil relevan | Penilaian penguji (skala 1–5) | rata-rata minimal 4 |
| Data tersimpan | Hasil muncul di riwayat setelah login ulang atau di HP lain | berhasil di 2 HP |

### 1.3 Persona

**Rina, 20 tahun, semester 4 Sistem Informasi.** Suka desain dan logika, bingung memilih antara web developer, UI/UX, atau data analyst. Ingin tahu skill apa yang harus dipelajari dalam 6 bulan ke depan.

**Dimas, 22 tahun, semester 7 Manajemen.** Ingin masuk dunia digital tetapi tidak punya latar teknis. Ingin tahu bidang yang cocok dengan kemampuan komunikasinya dan cara memulainya.

### 1.4 Prioritas fitur (MoSCoW)

| Prioritas | Fitur | Catatan |
| --- | --- | --- |
| Must | Daftar dan masuk dengan email dan password (Firebase Auth) | Tombol keluar juga wajib |
| Must | Profil singkat (nama, jurusan, semester), disimpan di Firestore | 3 field |
| Must | 8 pertanyaan minat (pilihan jawaban) | Satu layar bergulir, ada progress bar |
| Must | Penilaian 6 skill (slider 1–5) | Satu layar |
| Must | Panggilan Gemini dengan output JSON | Fungsi tunggal `analyzeCareer()` |
| Must | Layar hasil: 3 kartu karier dengan skor dan alasan | Inti demo |
| Must | Layar detail: skill dimiliki, skill kurang, roadmap 30 hari | Inti nilai tambah |
| Must | Simpan setiap hasil ke Firestore dan tampilkan riwayat | Bukti database server bekerja |
| Must | Loading dan penanganan error + tombol coba lagi | Mencegah layar kosong saat demo |
| Should | Mode demo (isi jawaban contoh otomatis) | Menghemat waktu presentasi |
| Should | Hasil contoh sebagai fallback jika Gemini gagal | Cadangan demo |
| Could | Login Google Sign-In | Butuh pengaturan SHA-1 |
| Could | Kartu hasil yang bisa dibagikan, grafik radar minat | Nilai tambah visual |
| Won't | Upload CV, chat bebas, iOS, web, backend khusus untuk menyembunyikan key | Masuk slide "rencana lanjutan" |

## 2. User Stories, Alur, dan Kebutuhan

Semua kebutuhan di bawah berstatus Must kecuali ditandai lain, dan tiap kebutuhan punya kriteria penerimaan yang bisa dicentang saat pengujian.

### 2.1 User stories

| ID | Sebagai mahasiswa, saya ingin... | Agar... |
| --- | --- | --- |
| US-01 | mendaftar dan masuk dengan email dan password | hasil saya tersimpan di akun saya |
| US-02 | mengisi profil singkat | AI mengenal latar belakang saya |
| US-03 | menjawab kuesioner minat | minat saya terbaca |
| US-04 | menilai skill saya dari 1 sampai 5 | kemampuan saya terbaca |
| US-05 | melihat 3 rekomendasi karier dengan skor dan alasan | saya paham mengapa bidang itu cocok |
| US-06 | melihat skill yang dimiliki, skill yang kurang, dan roadmap 30 hari | saya tahu langkah pertama |
| US-07 | membuka kembali hasil sebelumnya setelah login | saya bisa membandingkan dari waktu ke waktu |
| US-08 | mengulang asesmen | hasil diperbarui setelah saya belajar |

### 2.2 Alur pengguna

1. Splash screen, lalu cek status login.
2. Belum login: layar Masuk atau Daftar. Sudah login: langsung ke Beranda.
3. Pertama kali masuk: isi profil (nama, jurusan, semester), disimpan ke Firestore.
4. Beranda: tombol "Mulai Asesmen" dan daftar riwayat hasil.
5. Kuesioner minat (8 pertanyaan), lalu penilaian skill (6 skill).
6. Ringkasan jawaban, lalu tombol "Analisis dengan AI" (atau mode demo).
7. Layar loading selama Gemini memproses.
8. Layar hasil dengan 3 kartu karier; hasil otomatis disimpan ke Firestore.
9. Layar detail karier: alasan, skill dimiliki, skill kurang, roadmap 30 hari.
10. Kembali ke Beranda; riwayat menampilkan hasil baru.

### 2.3 Kebutuhan fungsional

| Kode | Kebutuhan | Kriteria penerimaan |
| --- | --- | --- |
| FR-01 | Daftar, masuk, dan keluar dengan Firebase Auth | Akun baru terlihat di konsol Firebase; setelah keluar, pengguna kembali ke layar Masuk |
| FR-02 | Sesi login bertahan | Setelah aplikasi ditutup dan dibuka, pengguna tetap login |
| FR-03 | Profil disimpan di Firestore | Data profil tampil kembali setelah login di HP lain |
| FR-04 | Kuesioner 8 pertanyaan dan 6 skill | Tombol lanjut aktif setelah semua terisi |
| FR-05 | Kirim data asesmen ke Gemini dan terima JSON valid | 10 panggilan berturut-turut berhasil di-parse |
| FR-06 | Tampilkan 3 kartu karier dengan skor 0–100 dan ringkasan alasan | Setiap kartu memuat judul, skor, alasan |
| FR-07 | Detail karier memuat skill dimiliki, skill kurang, dan roadmap 4 tahap (minggu 1–4) | Semua bagian tampil tanpa teks terpotong |
| FR-08 | Simpan hasil ke Firestore dan tampilkan riwayat | Hasil lama bisa dibuka tanpa memanggil Gemini lagi |
| FR-09 | Penanganan error | Tanpa internet atau API gagal: pesan jelas dan tombol coba lagi (atau hasil contoh) |
| FR-10 (Should) | Mode demo dan hasil contoh fallback | Berfungsi tanpa internet |
| FR-11 | Disclaimer di halaman hasil | Teks "saran awal, bukan keputusan karier" tampil |

### 2.4 Kebutuhan non-fungsional

- **Performa:** hasil tampil di bawah 15 detik pada koneksi normal.
- **Keamanan:** API key Gemini hanya di `.env` dan tidak masuk repository; aturan Firestore membatasi akses ke data milik pengguna sendiri (bagian 3.5).
- **Privasi:** beri tahu pengguna bahwa jawaban dikirim ke layanan AI dan disimpan di akun mereka; jangan kumpulkan data yang tidak perlu (cukup nama panggilan, jurusan, semester).
- **Kegunaan:** semua teks Bahasa Indonesia, tombol mudah dijangkau, teks terbaca di layar kecil.
- **Kompatibilitas:** Android 7.0 ke atas.

## 3. Spesifikasi Teknis

Aplikasi Flutter memakai Firebase Auth untuk login, Firestore untuk profil dan riwayat hasil, dan Gemini lewat HTTP untuk analisis; kode di bagian ini adalah kerangka awal yang bisa diminta diperbaiki ke AI coding assistant Anda.

### 3.1 Tech stack

| Kebutuhan | Pilihan | Keterangan |
| --- | --- | --- |
| Framework | Flutter (Dart), versi stable terbaru | Satu kode untuk Android dan iOS |
| State management | `provider` | Paling mudah untuk pemula |
| Login | `firebase_auth` | Email dan password |
| Database server | `cloud_firestore` | Dokumen JSON, cocok dengan output Gemini |
| Inisialisasi Firebase | `firebase_core` + FlutterFire CLI | Menghasilkan `firebase_options.dart` otomatis |
| Panggilan Gemini | `http` | REST ke Gemini API |
| API key | `flutter_dotenv` | File `.env`, tidak di-commit |
| Version control | Git + GitHub | Branch per fitur |

Catatan: nama dan versi package bisa berubah. Pasang dengan `flutter pub add <nama>` agar mendapat versi yang cocok, dan cek halaman package di pub.dev jika AI menyarankan nama yang berbeda.

### 3.2 Setup Firebase (target 60–90 menit, satu orang)

1. Buka console.firebase.google.com, buat proyek baru (Google Analytics boleh dimatikan).
2. Di **Authentication**, klik Get started, aktifkan provider **Email/Password**.
3. Di **Firestore Database**, buat database. Pilih mode produksi, lalu langsung tempel aturan keamanan di bagian 3.5.
4. Di komputer, pasang Firebase CLI (membutuhkan Node.js): `npm install -g firebase-tools`, lalu `firebase login`.
5. Pasang FlutterFire CLI: `dart pub global activate flutterfire_cli`.
6. Di folder proyek Flutter jalankan `flutterfire configure`, pilih proyek Firebase Anda dan platform Android. Perintah ini membuat `lib/firebase_options.dart` dan menghubungkan aplikasi Android ke proyek.
7. Tambah package: `flutter pub add firebase_core firebase_auth cloud_firestore http provider flutter_dotenv`.
8. Undang anggota tim di konsol Firebase (Project settings, Users and permissions) agar semua bisa melihat data.
9. Jika build Android gagal karena `minSdkVersion`, naikkan nilainya di `android/app/build.gradle` (atau `build.gradle.kts`) sesuai pesan error.

Jika setup belum berhasil setelah 90 menit, hentikan: pakai penyimpanan lokal dulu dan lanjutkan hal lain.

### 3.3 Struktur folder

```text
careerpath_ai/
  .env                  # GEMINI_API_KEY (JANGAN di-commit)
  .env.example
  .gitignore            # harus memuat .env
  lib/
    main.dart
    firebase_options.dart   # dihasilkan flutterfire configure
    models/
      user_profile.dart
      career_result.dart
    services/
      auth_service.dart
      firestore_service.dart
      gemini_service.dart
    providers/
      assessment_provider.dart
    data/
      questions.dart
      skills.dart
      careers.dart          # daftar 8 karier
      sample_result.dart    # hasil contoh untuk fallback
    screens/
      splash_screen.dart
      auth_screen.dart
      profile_screen.dart
      home_screen.dart
      interest_screen.dart
      skill_screen.dart
      loading_screen.dart
      result_screen.dart
      career_detail_screen.dart
    widgets/
      career_card.dart
      skill_slider.dart
      progress_header.dart
    utils/
      constants.dart
```

### 3.4 Model data Firestore

```text
users/{uid}
  name, major, semester, createdAt
  assessments/{assessmentId}
    createdAt        (timestamp server)
    input            { interests: {...}, skills: {...} }
    result           { summary, careers: [ {title, match_score, reason,
                       skills_owned[], skills_missing[], roadmap[]} ] }
```

Format `result` sama dengan JSON keluaran Gemini:

```json
{
  "summary": "Ringkasan 2-3 kalimat tentang potensi pengguna",
  "careers": [
    {
      "title": "UI/UX Designer",
      "match_score": 88,
      "reason": "Alasan singkat yang merujuk data pengguna",
      "skills_owned": ["Desain visual", "Komunikasi"],
      "skills_missing": ["User research", "Prototyping Figma"],
      "roadmap": [
        {"week": 1, "title": "Dasar UX", "actions": ["Pelajari prinsip UX", "Tiru 3 aplikasi populer"]}
      ]
    }
  ]
}
```

### 3.5 Aturan keamanan Firestore

Tempel di tab Rules pada konsol Firestore dan klik Publish. Aturan ini hanya mengizinkan pengguna yang login membaca dan menulis datanya sendiri:

```text
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      match /assessments/{assessmentId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

Jangan memakai mode "test" yang membuka database untuk semua orang, terutama setelah repo dipublikasikan.

### 3.6 Kode kerangka

`lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
```

`lib/services/auth_service.dart`:

```dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Stream<User?> get authChanges => _auth.authStateChanges();

  Future<void> register(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
```

`lib/services/firestore_service.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<void> saveProfile(Map<String, dynamic> profile) async {
    await _db.collection('users').doc(_uid).set(
      {...profile, 'createdAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final doc = await _db.collection('users').doc(_uid).get();
    return doc.data();
  }

  Future<void> saveAssessment(
      Map<String, dynamic> input, Map<String, dynamic> result) async {
    await _db.collection('users').doc(_uid).collection('assessments').add({
      'createdAt': FieldValue.serverTimestamp(),
      'input': input,
      'result': result,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> historyStream() {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('assessments')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
```

`lib/services/gemini_service.dart`:

```dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  // Ganti dengan nama model Flash terbaru dari Google AI Studio
  static const String _model = 'NAMA_MODEL_FLASH_TERBARU';

  static const String _systemPrompt = '''
Kamu adalah konselor karier untuk mahasiswa Indonesia.
Analisis profil, minat, dan skill pengguna, lalu beri 3 rekomendasi karier.
Aturan:
- Jawab dalam Bahasa Indonesia.
- Hanya pilih dari daftar karier yang diberikan.
- match_score berupa angka 0-100 dan tidak semua boleh 100.
- Alasan harus merujuk pada data pengguna, bukan klaim umum.
- Roadmap 4 tahap (week 1 sampai 4), realistis untuk mahasiswa.
- Jangan menjanjikan gaji atau jaminan diterima kerja.
- Keluarkan HANYA JSON valid sesuai format yang diminta.
''';

  Future<Map<String, dynamic>> analyzeCareer(
      Map<String, dynamic> userData, List<String> careerList) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key belum diatur di file .env');
    }

    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent');

    final prompt = '''
Daftar karier yang boleh dipilih: ${careerList.join(', ')}

Data pengguna:
${jsonEncode(userData)}

Format JSON yang diminta:
{"summary": string, "careers": [{"title": string, "match_score": number,
"reason": string, "skills_owned": [string], "skills_missing": [string],
"roadmap": [{"week": number, "title": string, "actions": [string]}]}]}
''';

    final body = {
      'systemInstruction': {
        'parts': [{'text': _systemPrompt}]
      },
      'contents': [
        {
          'role': 'user',
          'parts': [{'text': prompt}]
        }
      ],
      'generationConfig': {
        'responseMimeType': 'application/json',
        'temperature': 0.4,
      },
    };

    final response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'x-goog-api-key': apiKey,
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 40));

    if (response.statusCode != 200) {
      throw Exception('Gemini error ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final text = data['candidates'][0]['content']['parts'][0]['text'] as String;
    return jsonDecode(text) as Map<String, dynamic>;
  }
}
```

### 3.7 Konfigurasi Android dan keamanan key

Tambahkan di `android/app/src/main/AndroidManifest.xml`, di dalam `<manifest>` dan di luar `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

`.env`, `.gitignore`, dan `pubspec.yaml`:

```text
# .env
GEMINI_API_KEY=isi_key_kamu_di_sini

# .gitignore (tambahkan)
.env
```

```yaml
flutter:
  assets:
    - .env
```

Key Gemini yang dibungkus di dalam aplikasi masih bisa diekstrak dari APK. Untuk hackathon ini dapat diterima, tetapi sebutkan di pitch bahwa versi produksi memindahkan panggilan Gemini ke backend (misalnya Cloud Functions). Berkas `firebase_options.dart` berisi pengenal proyek, bukan rahasia kuat, dan keamanan datanya ditentukan oleh aturan Firestore di bagian 3.5.

## 4. Kriteria Selesai dan Rencana Lanjutan

### 4.1 Definition of done

- [ ] Daftar, masuk, keluar, dan sesi login bertahan berfungsi di APK rilis
- [ ] Profil dan riwayat hasil tersimpan di Firestore dan muncul kembali di HP kedua
- [ ] 3 skenario demo dengan profil berbeda menghasilkan hasil masuk akal dan format benar
- [ ] Tidak ada crash saat internet mati; hasil contoh atau pesan error muncul
- [ ] Aturan Firestore sudah dipublikasikan dan dites (pengguna A tidak bisa membaca data pengguna B)
- [ ] Tidak ada API key di repository, README, slide, atau video demo
- [ ] APK terpasang di minimal 2 HP, salah satunya HP demo
- [ ] Pitch dan demo sudah dilatih minimal 2 kali dengan waktu 3 menit

### 4.2 Di luar cakupan hackathon

Upload CV, chat bebas dengan AI, versi iOS dan web, notifikasi, fitur sosial, dan backend khusus untuk menyembunyikan API key Gemini.

### 4.3 Rencana setelah hackathon

- Pindahkan panggilan Gemini ke backend (Cloud Functions) agar API key aman dan kuota bisa dikontrol.
- Tambah Google Sign-In dan verifikasi email.
- Tambah chat konsultasi karier dengan konteks hasil asesmen.
- Tambah analisis CV dan rekomendasi kursus atau sumber belajar.
- Validasi hasil dengan konselor karier kampus dan ukur dampak ke pengguna.
