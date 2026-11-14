# Tangkapan layar untuk README & slide

Folder ini disiapkan untuk bukti visual asli aplikasi. Jangan memakai tangkapan layar yang menampilkan API key, isi `.env`, email pribadi, atau data pengguna nyata.

## Daftar minimal (peran D)

| Nama file | Layar | Dipakai di |
| --- | --- | --- |
| `01-welcome.png` | Welcome (Masuk/Daftar, Mulai asesmen, contoh offline) | README, Slide 3/5 |
| `02-hasil-3-kartu.png` | Hasil 3 kartu + skor + alasan + disclaimer | README, Slide 3 |
| `03-detail-roadmap.png` | Detail: skill dimiliki/kurang + roadmap 4 minggu | README, Slide 3 |
| `04-riwayat.png` | Beranda dengan riwayat hasil | Slide 5 |

## Cara mengambil

1. Jalankan APK debug/rilis di HP atau emulator.
2. Selesaikan alur: profil → 8 minat → 6 skill → ringkasan + persetujuan → analisis.
3. Ambil tangkapan layar (PowerShell: `adb exec-out screencap -p > 01-welcome.png`) atau tombol screenshot HP.
4. Periksa: tidak ada key/`.env`/email pribadi; label **Contoh hasil (offline)** terlihat bila memakai fallback.
5. Simpan dengan nama di atas, lalu tautkan ke README dan slide.

Status 2026-11-14: **BELUM ADA** — menunggu APK/perangkat. Jangan mengisi slide dengan tangkapan layar palsu.
