//
//  Calendar.swift
//  kecedo
//
//  Created by Benedecta Nadya Evangelie on 07/04/26.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @State private var currentMonth = Foundation.Calendar.current.date(
        from: Foundation.Calendar.current.dateComponents([.year, .month], from: .now)
    ) ?? .now
    @State private var isMonthPickerPresented = false
    @State private var selectedDate = Foundation.Calendar.current.startOfDay(for: .now)

    private var displayedMonth: CalendarMonth {
        CalendarMonth(date: currentMonth)
    }

    var body: some View {
        ZStack {
            Color(hex: "#F3F6F1")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                topNavigationBar
                    .padding(.top, 12)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 18) {
                        CalendarCard(
                            month: displayedMonth,
                            selectedDate: selectedDate,
                            onTapMonthLabel: { isMonthPickerPresented = true },
                            onSelectDay: { day in
                                if let date = displayedMonth.date(for: day) {
                                    selectedDate = date
                                }
                            },
                            onPreviousMonth: {
                                if let previousMonth = Foundation.Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) {
                                    updateCurrentMonth(to: previousMonth)
                                }
                            },
                            onNextMonth: {
                                if let nextMonth = Foundation.Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) {
                                    updateCurrentMonth(to: nextMonth)
                                }
                            }
                        )
                        
                        taskSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 14)
                    .padding(.bottom, 136)
                }
            }
        }
        .sheet(isPresented: $isMonthPickerPresented) {
            MonthYearPickerSheet(
                selectedMonth: currentMonth,
                onSelect: { newMonth in
                    updateCurrentMonth(to: newMonth)
                    isMonthPickerPresented = false
                }
            )
            .presentationDetents([.height(320)])
            .presentationCornerRadius(28)
            .presentationDragIndicator(.visible)
        }
    }

    private var topNavigationBar: some View {
        VStack(spacing: 12) {
            HStack {
                CircleIconButton(systemImage: "gearshape")
                Spacer()
                Text("Calendar")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.black)
                Spacer()
                CircleIconButton(systemImage: "plus")
            }
            .padding(.horizontal, 16)
        }
    }

    private var taskSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(selectedDateText)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(.black)
                .padding(.top, 2)

            ForEach(CalendarTaskItem.sampleItems) { item in
                TaskCard(item: item, selectedDate: selectedDate)
            }
        }
    }

    private var selectedDateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        return formatter.string(from: selectedDate)
    }

    private func updateCurrentMonth(to newMonth: Date) {
        let calendar = Foundation.Calendar.current
        let normalizedMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: newMonth)
        ) ?? newMonth

        currentMonth = normalizedMonth

        let selectedDay = calendar.component(.day, from: selectedDate)
        let dayRange = calendar.range(of: .day, in: .month, for: normalizedMonth) ?? 1..<29
        let clampedDay = min(selectedDay, dayRange.count)

        if let updatedSelectedDate = calendar.date(
            from: DateComponents(
                year: calendar.component(.year, from: normalizedMonth),
                month: calendar.component(.month, from: normalizedMonth),
                day: clampedDay
            )
        ) {
            selectedDate = calendar.startOfDay(for: updatedSelectedDate)
        }
    }
}

// MARK: - Supporting Components

private struct CalendarCard: View {
    let month: CalendarMonth
    let selectedDate: Date
    let onTapMonthLabel: () -> Void
    let onSelectDay: (Int) -> Void
    let onPreviousMonth: () -> Void
    let onNextMonth: () -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    private let weekSymbols = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]

    var body: some View {
        VStack(spacing: 18) {
            HStack {
                Button(action: onTapMonthLabel) {
                    HStack(spacing: 6) {
                        Text(month.title)
                            .font(.system(size: 19, weight: .semibold, design: .rounded))
                            .foregroundStyle(.black)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.blue)
                    }
                }
                .buttonStyle(.plain)

                Spacer()

                HStack(spacing: 22) {
                    Button(action: onPreviousMonth) {
                        Image(systemName: "chevron.left")
                    }
                    Button(action: onNextMonth) {
                        Image(systemName: "chevron.right")
                    }
                }
                .foregroundStyle(.blue)
                .font(.system(size: 19, weight: .semibold))
            }

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(weekSymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.black.opacity(0.22))
                        .frame(maxWidth: .infinity)
                }

                ForEach(month.cells) { cell in
                    if let day = cell.day {
                        CalendarDateCell(
                            day: day,
                            isSelected: month.isSelected(day: day, selectedDate: selectedDate),
                            onTap: { onSelectDay(day) }
                        )
                    } else {
                        Color.clear
                            .frame(height: 48)
                    }
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(Color(hex: "#F7F7F7"))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.95), lineWidth: 1)
        }
    }
}

private struct CalendarDateCell: View {
    let day: Int
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(day)")
                    .font(.system(size: 21, weight: .medium, design: .rounded))
                    .foregroundStyle(isSelected ? .blue : .black)
                    .frame(width: 42, height: 42)
                    .background(isSelected ? Color.blue.opacity(0.14) : Color.clear)
                    .clipShape(Circle())
                
                Circle()
                    .fill(isSelected ? Color.blue : Color.clear)
                    .frame(width: 7, height: 7)
            }
            .frame(maxWidth: .infinity, minHeight: 58)
        }
        .buttonStyle(.plain)
    }
}

private struct CircleIconButton: View {
    let systemImage: String

    var body: some View {
        Button(action: {}) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.black)
                .frame(width: 38, height: 38)
                .background(Color(hex: "#F2F4EF"))
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(Color.white.opacity(0.9), lineWidth: 1)
                }
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

private struct TaskCard: View {
    let item: CalendarTaskItem
    let selectedDate: Date

    var body: some View {
        HStack(spacing: 13) {
            TaskGridIcon(taskColor: item.color)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(.black)
                    .lineLimit(1)
                Text(item.subtitle(for: selectedDate))
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.black.opacity(0.38))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Circle()
                .stroke(Color.black.opacity(0.17), lineWidth: 1.6)
                .frame(width: 24, height: 24)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, minHeight: 66, alignment: .leading)
        .background(Color(hex: "#F8F8F8"))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

private struct TaskGridIcon: View {
    let taskColor: Color

    private let inactiveStroke = Color.black.opacity(0.10)
    private let squareSize: CGFloat = 11
    private let cornerRadius: CGFloat = 4
    private let spacing: CGFloat = 4

    var body: some View {
        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                gridSquare(color: color(for: .topLeft))
                gridSquare(color: color(for: .topRight))
            }

            HStack(spacing: spacing) {
                gridSquare(color: color(for: .bottomLeft))
                gridSquare(color: color(for: .bottomRight))
            }
        }
        .frame(width: 26, height: 26)
    }

    private func gridSquare(color: Color?) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(color ?? .clear)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(color ?? inactiveStroke, lineWidth: 1.7)
            }
            .frame(width: squareSize, height: squareSize)
    }

    private func color(for position: GridPosition) -> Color? {
        switch normalizedTaskColor {
        case .green:
            position == .topLeft ? .green : nil
        case .blue:
            position == .bottomLeft ? .blue : nil
        case .yellow:
            position == .bottomRight ? .yellow : nil
        case .orange:
            position == .bottomRight ? .orange : nil
        case .inactive:
            nil
        }
    }

    private var normalizedTaskColor: NormalizedTaskColor {
        if taskColor == .green {
            return .green
        }
        if taskColor == .blue {
            return .blue
        }
        if taskColor == .yellow {
            return .yellow
        }
        if taskColor == .orange || taskColor == .red {
            return .orange
        }

        return .inactive
    }

    private enum GridPosition {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }

    private enum NormalizedTaskColor {
        case green
        case blue
        case yellow
        case orange
        case inactive
    }
}

private struct CalendarTaskItem: Identifiable {
    let id = UUID()
    let title: String
    let time: String
    let color: Color

    func subtitle(for selectedDate: Date) -> String {
        let calendar = Foundation.Calendar.current
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"

        let parsedTime = timeFormatter.date(from: time) ?? .now
        let timeComponents = calendar.dateComponents([.hour, .minute], from: parsedTime)
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)

        let combinedDate = calendar.date(
            from: DateComponents(
                year: dateComponents.year,
                month: dateComponents.month,
                day: dateComponents.day,
                hour: timeComponents.hour,
                minute: timeComponents.minute
            )
        ) ?? selectedDate

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: combinedDate)
    }

    static let sampleItems: [CalendarTaskItem] = [
        CalendarTaskItem(
            title: "Finish project report",
            time: "3:00 AM",
            color: .blue
        ),
        CalendarTaskItem(
            title: "Schedule a meeting",
            time: "9:00 AM",
            color: .green
        ),
        CalendarTaskItem(
            title: "Clean the workspace",
            time: "8:00 PM",
            color: .blue
        ),
        CalendarTaskItem(
            title: "Backup important files",
            time: "9:00 PM",
            color: .yellow
        
        ),
    ]
}

private struct MonthYearPickerSheet: View {
    let selectedMonth: Date
    let onSelect: (Date) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var monthIndex: Int
    @State private var year: Int

    private let months = CalendarMonth.monthSymbols
    private let yearRange = Array(2020...2035)

    init(selectedMonth: Date, onSelect: @escaping (Date) -> Void) {
        self.selectedMonth = selectedMonth
        self.onSelect = onSelect

        let calendar = Foundation.Calendar.current
        let components = calendar.dateComponents([.month, .year], from: selectedMonth)
        _monthIndex = State(initialValue: max((components.month ?? 1) - 1, 0))
        _year = State(initialValue: components.year ?? 2025)
    }

    var body: some View {
        VStack(spacing: 18) {
            HStack {
                Text("Select Month")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.black)
                Spacer()
                Button("Done") {
                    let date = Foundation.Calendar.current.date(
                        from: DateComponents(year: year, month: monthIndex + 1, day: 1)
                    ) ?? selectedMonth
                    onSelect(date)
                    dismiss()
                }
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(.blue)
            }

            HStack(spacing: 0) {
                Picker("Month", selection: $monthIndex) {
                    ForEach(Array(months.enumerated()), id: \.offset) { index, month in
                        Text(month).tag(index)
                    }
                }
                .pickerStyle(.wheel)

                Picker("Year", selection: $year) {
                    ForEach(yearRange, id: \.self) { year in
                        Text(verbatim: String(year)).tag(year)
                    }
                }
                .pickerStyle(.wheel)
            }
            .frame(height: 180)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 12)
        .background(Color(hex: "#F7F7F7"))
    }
}

private struct CalendarMonth {
    struct Cell: Identifiable {
        let id = UUID()
        let day: Int?
    }

    let year: Int
    let month: Int

    static var current: CalendarMonth {
        let components = Foundation.Calendar.current.dateComponents([.year, .month], from: .now)
        return CalendarMonth(year: components.year ?? 2025, month: components.month ?? 1)
    }

    static var monthSymbols: [String] {
        let formatter = DateFormatter()
        return formatter.monthSymbols
    }

    init(year: Int, month: Int) {
        self.year = year
        self.month = month
    }

    init(date: Date) {
        let components = Foundation.Calendar.current.dateComponents([.year, .month], from: date)
        self.year = components.year ?? 2025
        self.month = components.month ?? 1
    }

    var title: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: firstDate)
    }

    var cells: [Cell] {
        let calendar = Foundation.Calendar.current
        let firstWeekdayIndex = calendar.component(.weekday, from: firstDate) - 1
        let dayRange = calendar.range(of: .day, in: .month, for: firstDate) ?? 1..<31

        let leadingCells = Array(repeating: Cell(day: nil), count: firstWeekdayIndex)
        let dayCells = dayRange.map { Cell(day: $0) }

        return leadingCells + dayCells
    }

    func offset(by value: Int) -> CalendarMonth {
        let calendar = Foundation.Calendar.current
        guard
            let offsetDate = calendar.date(byAdding: .month, value: value, to: firstDate)
        else {
            return self
        }

        let components = calendar.dateComponents([.year, .month], from: offsetDate)
        return CalendarMonth(year: components.year ?? year, month: components.month ?? month)
    }

    func date(for day: Int) -> Date? {
        Foundation.Calendar.current.date(
            from: DateComponents(year: year, month: month, day: day)
        )
        .map { Foundation.Calendar.current.startOfDay(for: $0) }
    }

    func isSelected(day: Int, selectedDate: Date) -> Bool {
        guard let cellDate = date(for: day) else {
            return false
        }

        return Foundation.Calendar.current.isDate(cellDate, inSameDayAs: selectedDate)
    }

    private var firstDate: Date {
        let calendar = Foundation.Calendar.current
        return calendar.date(from: DateComponents(year: year, month: month, day: 1)) ?? .now
    }
}

#Preview {
    ContentView(initialTab: .calendar)
        .modelContainer(for: TaskModel.self, inMemory: true)
}
