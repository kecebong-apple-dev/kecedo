import json

filepath = "/Users/okyfaishal/project/kecedo/kecedo/Models/Localizable.xcstrings"

translations = {
    "Are you sure you want to apply these changes?": "您确定要应用这些更改吗？",
    "Are you sure you want to delete this task? This action is irreversible.": "您确定要删除此任务吗？此操作不可逆转。",
    "Calendar": "日历",
    "Camera": "相机",
    "Cancel": "取消",
    "Choose Image Source": "选择图像来源",
    "Confirm": "确认",
    "Confirm Action": "确认操作",
    "Confirm Changes": "确认更改",
    "Date Filter": "日期筛选",
    "Delete": "删除",
    "Delete Task": "删除任务",
    "Description": "描述",
    "Discard": "放弃",
    "Discard Changes": "放弃更改",
    "Done": "完成",
    "End Date": "结束日期",
    "English": "英语",
    "Filter": "筛选",
    "Font Size": "字体大小",
    "Header": "标头",
    "Indonesian": "印尼语",
    "Chinese": "中文",
    "Keep Editing": "继续编辑",
    "Language": "语言",
    "Light Mode": "亮色模式",
    "Matrix": "矩阵",
    "Matrix Area": "矩阵区域",
    "Month": "月",
    "New Task": "新任务",
    "Photo Library": "照片库",
    "Scan": "扫描",
    "Select Month": "选择月份",
    "Settings": "设置",
    "Show Completed": "显示已完成",
    "Start Date": "开始日期",
    "Statistics": "统计",
    "Task Detail": "任务详情",
    "Tidak ada tugas di tanggal ini.": "此日期没有任务。",
    "Title": "标题",
    "Today": "今天",
    "Year": "年",
    "You have unsaved changes. Are you sure you want to discard them?": "您有未保存的更改。确定要放弃吗？"
}

with open(filepath, "r") as f:
    data = json.load(f)

# Ensure "Chinese" key exists first if it was not auto-detected
if "Chinese" not in data["strings"]:
    data["strings"]["Chinese"] = { "localizations": {} }

for key, val in data["strings"].items():
    if key in translations:
        if "localizations" not in val:
            val["localizations"] = {}
        val["localizations"]["zh-Hans"] = {
            "stringUnit": {
                "state": "translated",
                "value": translations[key]
            }
        }

with open(filepath, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print("success")
