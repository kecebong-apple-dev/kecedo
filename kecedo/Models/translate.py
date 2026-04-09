import json

filepath = "/Users/okyfaishal/project/kecedo/kecedo/Models/Localizable.xcstrings"

translations = {
    "Are you sure you want to apply these changes?": "Apakah Anda yakin ingin menerapkan perubahan ini?",
    "Are you sure you want to delete this task? This action is irreversible.": "Apakah Anda yakin ingin menghapus tugas ini? Tindakan ini tidak dapat dibatalkan.",
    "Calendar": "Kalender",
    "Camera": "Kamera",
    "Cancel": "Batal",
    "Choose Image Source": "Pilih Sumber Gambar",
    "Confirm": "Konfirmasi",
    "Confirm Action": "Konfirmasi Aksi",
    "Confirm Changes": "Konfirmasi Perubahan",
    "Date Filter": "Filter Tanggal",
    "Delete": "Hapus",
    "Delete Task": "Hapus Tugas",
    "Description": "Deskripsi",
    "Discard": "Buang",
    "Discard Changes": "Buang Perubahan",
    "Done": "Selesai",
    "End Date": "Waktu Selesai",
    "English": "Bahasa Inggris",
    "Filter": "Saring",
    "Font Size": "Ukuran Font",
    "Header": "Header",
    "Indonesian": "Bahasa Indonesia",
    "Keep Editing": "Lanjut Mengedit",
    "Language": "Bahasa",
    "Light Mode": "Mode Terang",
    "Matrix": "Matriks",
    "Matrix Area": "Area Matriks",
    "Month": "Bulan",
    "New Task": "Tugas Baru",
    "Photo Library": "Galeri Foto",
    "Scan": "Pindai",
    "Select Month": "Pilih Bulan",
    "Settings": "Pengaturan",
    "Show Completed": "Tampilkan yang Selesai",
    "Start Date": "Waktu Mulai",
    "Statistics": "Statistik",
    "Task Detail": "Detail Tugas",
    "Tidak ada tugas di tanggal ini.": "Tidak ada tugas di tanggal ini.",
    "Title": "Judul",
    "Today": "Hari Ini",
    "Year": "Tahun",
    "You have unsaved changes. Are you sure you want to discard them?": "Anda punya perubahan yang belum disimpan. Yakin ingin membuangnya?"
}

with open(filepath, "r") as f:
    data = json.load(f)

for key, val in data["strings"].items():
    if key in translations:
        if "localizations" not in val:
            val["localizations"] = {}
        val["localizations"]["id"] = {
            "stringUnit": {
                "state": "translated",
                "value": translations[key]
            }
        }

with open(filepath, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print("success")
