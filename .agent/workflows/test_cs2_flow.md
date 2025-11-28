---
description: Testing Flow CS Layer 2
---

1. Login sebagai CS Layer 2
   - Gunakan user sample yang sudah digenerate
   - Role: `cs2`

2. Buka Halaman Orders
   - Tab "Orders" di bottom navigation
   - Seharusnya hanya melihat pesanan dengan status `MENUNGGU_DIPROSES_CS2`

3. Proses Pesanan
   - Tap salah satu pesanan untuk melihat detail
   - Scroll ke bawah, cari tombol "Update Status Pesanan"
   - Tap tombol tersebut
   - Pilih status baru (misal: `SEDANG_DIPROSES`)
   - Konfirmasi

4. Verifikasi Update
   - Status pesanan berubah di halaman detail
   - Jika kembali ke list, pesanan mungkin hilang dari list jika filter hanya menampilkan `MENUNGGU_DIPROSES_CS2` (sesuai requirement)
   - Namun, untuk memudahkan testing, filter CS2 saat ini di-set untuk menampilkan `MENUNGGU_DIPROSES_CS2`. Jika status berubah jadi `SEDANG_DIPROSES`, order tersebut akan hilang dari list CS2.

   *Note: Jika ingin melihat semua order untuk debugging, bisa login sebagai Customer.*
