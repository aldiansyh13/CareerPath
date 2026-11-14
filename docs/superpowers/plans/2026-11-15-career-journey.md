# Career Journey Hackathon Slice Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Menambahkan satu career journey aktif dengan checklist roadmap persisten sehingga demo membuktikan pengguna dapat melanjutkan hasil AI.

**Architecture:** Model `CareerJourney` menyimpan snapshot satu rekomendasi dan completion IDs. `LocalStore` memisahkan journey tamu/UID, sedangkan `JourneyProvider` menjadi state UI. Home dan detail roadmap membaca provider; ResultScreen membuat fokus secara eksplisit.

**Tech Stack:** Flutter, Dart, Material 3, Provider, SharedPreferences.

**Spec:** `docs/superpowers/specs/2026-11-15-career-journey-hackathon-design.md`

## Global Constraints

- Jangan mengubah kontrak `CareerResult`, Gemini, OpenAI, Firebase assessment, atau riwayat lama.
- Hanya satu local active journey per namespace; tidak ada Firestore journey sync.
- Target sentuh minimum 48 dp, Bahasa Indonesia, dan layar 320×568 tetap aman.
- Progress berarti penyelesaian roadmap, bukan bukti kenaikan skill.
- Hasil sample harus tetap berlabel `Contoh`.

## Review Focus

- Snapshot lengkap harus membuat journey mandiri dari assessment sumber — Task 1.
- Action ID harus stabil dan progress tidak membagi nol — Task 1.
- Data tamu dan UID harus terisolasi — Task 2.
- Toggle, undo, dan restart harus mempertahankan completion — Task 2 dan Task 3.
- Existing result/history/assessment flow tidak boleh rusak — Task 4.

---

### Task 1: Journey model

**Files:**
- Create: `lib/models/career_journey.dart`
- Test: `test/career_journey_test.dart`

**Interfaces:**
- Produces: `CareerJourney.fromRecommendation(...)`, `actionId(week,index)`, `progress`, `activeWeek`, `nextAction`, `toggleAction(...)`, JSON round-trip.

- [x] Write failing tests for snapshot, IDs, progress, active week, next action, completion, and JSON round-trip.
- [x] Run `flutter test test/career_journey_test.dart --concurrency=1 --no-pub`; observed RED because model was missing.
- [x] Implement the immutable model with primitive JSON.
- [x] Run the same command; PASS (6 tests).

### Task 2: Persistence and provider

**Files:**
- Modify: `lib/services/local_store.dart`
- Create: `lib/providers/journey_provider.dart`
- Test: `test/journey_store_provider_test.dart`

**Interfaces:**
- Produces: `LocalStore.getJourney/saveJourney/clearJourney`; `JourneyProvider.load/startJourney/toggleAction/undoToggle` and `activeJourney`.

- [x] Write failing tests for empty load, guest/UID isolation, start, toggle, undo, provider reload, and account-store switching.
- [x] Run `flutter test test/journey_store_provider_test.dart --concurrency=1 --no-pub`; observed RED.
- [x] Implement local persistence and provider with optimistic save.
- [x] Run the same command; PASS (6 tests).

### Task 3: Result-to-journey and interactive roadmap

**Files:**
- Modify: `lib/main.dart`
- Modify: `lib/widgets/career_card.dart`
- Modify: `lib/screens/result_screen.dart`
- Modify: `lib/screens/career_detail_screen.dart`
- Test: `test/journey_flow_test.dart`

**Interfaces:**
- Consumes: Task 2 provider.
- Produces: app-level provider, `Jadikan fokus`, sample label, interactive checklist, undo.

- [x] Write failing widget flow for result → focus → saved journey and detail checklist → undo.
- [x] Run `flutter test test/journey_flow_test.dart --concurrency=1 --no-pub`; observed RED.
- [x] Wire provider and implement focus CTA plus roadmap interaction.
- [x] Run the same command; PASS (2 tests).

### Task 4: Journey-first home and visual polish

**Files:**
- Modify: `lib/screens/home_screen.dart`
- Modify: `lib/utils/constants.dart`
- Modify: `lib/utils/app_theme.dart`
- Modify: `test/small_screen_test.dart`

**Interfaces:**
- Consumes: Task 2 provider and Task 3 navigation.
- Produces: active journey hero and existing home content below it.

- [x] Write failing widget assertions for journey title, match score, progress, active week, next action, and compact layout.
- [x] Run focused tests with `--concurrency=1 --no-pub`; observed RED.
- [x] Implement lightweight Apprenticeship Logbook theme and journey-first hero without new navigation.
- [x] Run focused tests; PASS.
- [x] Run `flutter test --concurrency=1 --no-pub`; PASS (112 tests).

### Task 5: Verification and report

**Files:**
- Modify: `README.md`
- Modify: `HASIL-KERJA.md`
- Modify: this plan to mark truthful completion.

- [x] Run `dart format lib test`.
- [x] Run `flutter analyze --no-pub`; `No issues found`.
- [x] Run `flutter test --concurrency=1 --no-pub`; PASS (112 tests).
- [x] Append Indonesian report: delivered flow, files, data decisions, test results, deferred ideas, and pending device QA.
- [x] Run `git -c safe.directory=D:/CODE/mobile/CareerPath diff --check` and review status without touching unrelated user changes; no whitespace errors.
