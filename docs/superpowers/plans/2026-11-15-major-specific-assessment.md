# Major-Specific Assessment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Membuat pertanyaan minat dan penilaian skill mengikuti jurusan yang dimasukkan pengguna untuk seluruh kelompok bidang yang didukung.

**Architecture:** Tambahkan satu resolver kelompok jurusan publik sebagai sumber kebenaran bagi pertanyaan dan skill. `questions.dart` dan `skills.dart` menyimpan konten masing-masing tanpa saling mengimpor. `AssessmentProvider` membersihkan jawaban ketika kelompok jurusan berubah serta memperkaya payload AI dengan label skill; layar membaca paket aktif melalui provider.

**Tech Stack:** Flutter 3.29, Dart 3.7, Provider, flutter_test.

**Spec:** `docs/superpowers/specs/2026-11-15-major-specific-assessment-design.md`

## Global Constraints

- Pertahankan alur navigasi dan kontrak hasil AI yang sudah ada.
- Jangan menambah dependency atau panggilan jaringan untuk memilih pertanyaan.
- Jurusan tidak dikenal wajib memakai fallback umum.
- Perubahan jurusan wajib menghapus jawaban minat dan skill lama.
- Jangan mengubah file pengguna yang tidak terkait.

## Review Focus

- Perbedaan kapital, spasi, dan nama seperti `Teknik Informatika` tetap masuk kelompok IT.
- Keyword spesifik seperti `Komputerisasi Akuntansi` tidak salah masuk IT.
- Nama jurusan kosong/tidak dikenal memakai fallback umum tanpa crash.
- Nilai skill dari jurusan lama tidak memenuhi kelengkapan jurusan baru.
- Payload AI membawa rating dan label skill yang sesuai dengan jurusan aktif.

---

### Task 1: Resolver bidang dan skill dinamis

**Files:**
- Create: `lib/data/major_groups.dart`
- Modify: `lib/data/questions.dart`
- Modify: `lib/data/skills.dart`
- Test: `test/qa_validators_test.dart`

**Interfaces:**
- Produces: enum `MajorGroup`, `MajorGroup majorGroupForMajor(String? major)`, `List<InterestQuestion> interestQuestionsForMajor(String? major)`, dan `List<SkillItem> skillItemsForMajor(String? major)`.

- [ ] **Step 1: Write failing resolver tests**

Tambahkan tes tabel untuk sembilan kelompok: Informatika, Akuntansi, Keperawatan, Hukum, Pendidikan, Psikologi, DKV, Teknik Sipil, dan Manajemen. Tegaskan masing-masing menghasilkan 8 pertanyaan, 6 skill unik, enum kelompok yang benar, serta konten bidang yang relevan. Tambahkan kasus `Komputerisasi Akuntansi`, kapital/spasi, kosong, dan jurusan tidak dikenal.

- [ ] **Step 2: Run tests and verify RED**

Run: `flutter test test/qa_validators_test.dart`

Expected: FAIL karena `majorGroupForMajor` dan `skillItemsForMajor` belum ada.

- [ ] **Step 3: Implement the catalog and resolver**

Buat enum `MajorGroup` dan resolver kata kunci dengan urutan spesifik lebih dulu di `major_groups.dart`. Ubah `questions.dart` agar memilih set berdasarkan enum tersebut, lalu definisikan enam `SkillItem` khusus untuk setiap kelompok dan enam skill fallback umum di `skills.dart`.

- [ ] **Step 4: Run tests and verify GREEN**

Run: `flutter test test/qa_validators_test.dart`

Expected: PASS.

### Task 2: State assessment dan payload AI

**Files:**
- Modify: `lib/providers/assessment_provider.dart`
- Test: `test/qa_local_store_provider_test.dart`

**Interfaces:**
- Consumes: `majorGroupForMajor` dan `skillItemsForMajor` dari Task 1.
- Produces: `AssessmentProvider.activeSkills`, state reset lintas jurusan, serta `buildInput()['skill_labels']` bertipe `Map<String, String>`.

- [ ] **Step 1: Write failing provider tests**

Tes bahwa mengganti Akuntansi ke Informatika membersihkan jawaban minat dan skill; menyimpan profil jurusan yang sama tidak membersihkan jawaban; `activeSkills` sesuai jurusan; dan `buildInput()` memuat rating plus label skill aktif.

- [ ] **Step 2: Run tests and verify RED**

Run: `flutter test test/qa_local_store_provider_test.dart`

Expected: FAIL pada reset skill, getter `activeSkills`, dan `skill_labels`.

- [ ] **Step 3: Implement provider behavior**

Gunakan ID hasil resolver untuk membandingkan kelompok jurusan. Bersihkan kedua map ketika kelompok berubah, expose `List<SkillItem> get activeSkills`, hitung kelengkapan dari ID aktif, dan tambahkan label aktif ke payload tanpa mengubah map rating `skills`.

- [ ] **Step 4: Run tests and verify GREEN**

Run: `flutter test test/qa_local_store_provider_test.dart`

Expected: PASS.

### Task 3: Layar skill dan ringkasan dinamis

**Files:**
- Modify: `lib/screens/skill_screen.dart`
- Modify: `lib/screens/summary_screen.dart`
- Modify: `test/small_screen_test.dart`
- Modify: `test/qa_flow_test.dart`

**Interfaces:**
- Consumes: `AssessmentProvider.activeSkills` dan state kelengkapan dari Task 2.
- Produces: UI yang menampilkan enam skill sesuai jurusan pada penilaian dan ringkasan.

- [ ] **Step 1: Write failing widget tests**

Pump alur dengan profil Akuntansi dan tegaskan label skill Akuntansi terlihat sementara `Pemrograman Dasar` tidak terlihat. Ulangi satu kasus IT untuk memastikan skill IT tetap muncul. Pada ringkasan, tegaskan label dan rating berasal dari daftar aktif.

- [ ] **Step 2: Run tests and verify RED**

Run: `flutter test test/small_screen_test.dart test/qa_flow_test.dart`

Expected: FAIL karena kedua layar masih memakai `kSkillItems` statis.

- [ ] **Step 3: Update both screens**

Ganti pembacaan `kSkillItems` dengan `provider.activeSkills`; hitung progress, tombol lanjut, label, dan ringkasan dari daftar aktif yang sama.

- [ ] **Step 4: Run focused tests and verify GREEN**

Run: `flutter test test/small_screen_test.dart test/qa_flow_test.dart`

Expected: PASS.

### Task 4: Verification gate

**Files:**
- Verify all changed production and test files.

**Interfaces:**
- Consumes: hasil Task 1–3.
- Produces: bukti analisis statis dan regresi penuh.

- [ ] **Step 1: Format changed Dart files**

Run: `dart format lib/data/major_groups.dart lib/data/questions.dart lib/data/skills.dart lib/providers/assessment_provider.dart lib/screens/skill_screen.dart lib/screens/summary_screen.dart test/qa_validators_test.dart test/qa_local_store_provider_test.dart test/small_screen_test.dart test/qa_flow_test.dart`

- [ ] **Step 2: Run static analysis**

Run: `flutter analyze`

Expected: `No issues found!`

- [ ] **Step 3: Run the full suite**

Run: `flutter test`

Expected: seluruh tes lulus tanpa exception.

- [ ] **Step 4: Review diff scope**

Pastikan diff hanya mencakup katalog/resolver, provider, dua layar, tes terkait, spec, dan plan.
