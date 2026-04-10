# Instruksi Perbaikan Bug SettingsView

**Deskripsi Masalah:**
Saat pengguna mencoba mengubah bahasa kembali ke "English" melalui tampilan pengaturan (Settings), perubahan bahasa tersebut tidak berfungsi secara semestinya. UI menampilkan bahasa dengan teks yang salah ("EnRglish"), yang menyebabkan `appLanguage` menjadi *value* yang tidak valid dan aplikasi tidak bisa menerjemahkannya sesuai dengan `LocalizationManager` yang sudah tersedia.

**Lokasi File yang Harus Diperbaiki:**
File: `kecedo/Views/SettingsView.swift`

**Detail Temuan Logical Error:**
Pada bagian `Menu` *dropdown* pemilihan bahasa, terdapat *typo* pengisian nilai *state* di dalam *closure* *action* milik tombol "English".

**Tugas Anda:**
Tolong modifikasi dan perbaiki *typo/logical error* tersebut di dalam file `kecedo/Views/SettingsView.swift`.
Temukan kode pada baris di bawah ini:
`Button("English".localized(language)) { language = "EnRglish" }`

Lalu ubah kodenya menjadi seperti berikut (perbaiki "EnRglish" menjadi "English"):
`Button("English".localized(language)) { language = "English" }`

Pastikan tidak ada *typo* pada kata "English" dan verifikasi fungsionalitasnya agar saat menu ini dipilih, *state tracking* kembali berjalan secara normal.
