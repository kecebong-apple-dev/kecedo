import json

filepath = "/Users/okyfaishal/project/kecedo/kecedo/Models/Localizable.xcstrings"

new_translations = {
    "All": {"id": "Semua", "zh-Hans": "全部"},
    "Week": {"id": "Minggu Ini", "zh-Hans": "本周"},
    "Period": {"id": "Periode", "zh-Hans": "期间"},
    "Today": {"id": "Hari Ini", "zh-Hans": "今天"}
}

with open(filepath, "r") as f:
    data = json.load(f)

for key, langs in new_translations.items():
    if key not in data["strings"]:
        data["strings"][key] = { "localizations": {} }
    
    val = data["strings"][key]
    if "localizations" not in val:
        val["localizations"] = {}
        
    for lang_code, trans in langs.items():
        val["localizations"][lang_code] = {
            "stringUnit": {
                "state": "translated",
                "value": trans
            }
        }

with open(filepath, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print("success")
