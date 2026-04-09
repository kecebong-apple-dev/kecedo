//
//  Statistics.swift
//  kecedo
//
//  Created by sherly dinata oey on 08/04/26.
//

import SwiftUI

struct Statistics: View {
    private let segments = StatisticSegment.mockData
    private let summaryItems = StatisticSegment.summaryData

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color.white,
                        Color(hex: "#FBF5F0"),
                        Color(hex: "#F6F7FB")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        overviewCard
                        countCards
                        progressCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 18)
                    .padding(.bottom, 32)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Color(hex: "#3B3B3B"))
                            .frame(width: 42, height: 42)
                            .background(.white.opacity(0.9), in: Circle())
                            .shadow(color: .black.opacity(0.06), radius: 16, y: 6)
                    }
                }
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var overviewCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Completed Task Overview")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Color(hex: "#222222"))

            DonutChartView(segments: segments)
                .frame(height: 235)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
        .background(.white.opacity(0.97), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 20, y: 10)
    }

    private var countCards: some View {
        HStack(spacing: 10) {
            ForEach(summaryItems) { segment in
                HStack(spacing: 8) {
                    Image(systemName: "square.grid.2x2")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(segment.color)

                    Text("\(segment.count)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color(hex: "#1F1F1F"))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(segment.tint, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }

    private var progressCard: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Nice Progress!")
                    .font(.system(size: 14, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(hex: "#F4F4F4"), in: Capsule())

                Text("You're on track!")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color(hex: "#202020"))

                Text("You completed 10 tasks today.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color(hex: "#4A4A4A"))

                Text("Keep focusing on what matters!")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.secondary.opacity(0.9))
            }

            Spacer(minLength: 0)

            
        }
        .padding(12)
        .background(.white.opacity(0.97), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 18, y: 10)
    }
}

private struct DonutChartView: View {
    let segments: [StatisticSegment]

    private let lineWidth: CGFloat = 69
    private let gapDegrees: Double = 5

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height) - 8

            ZStack {
                ForEach(Array(segments.enumerated()), id: \.element.id) { index, segment in
                    DonutArc(
                        startAngle: startAngle(for: index),
                        endAngle: endAngle(for: index),
                        lineWidth: lineWidth
                    )
                    .fill(
                        AngularGradient(
                            gradient: Gradient(colors: segment.gradient),
                            center: .center,
                            angle: .degrees(startAngle(for: index))
                        )
                    )
                }
            }
            .frame(width: size, height: size)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var total: Double {
        segments.map(\.value).reduce(0, +)
    }

    private func startAngle(for index: Int) -> Double {
        guard total > 0 else { return -90 }
        let cumulative = segments.prefix(index).map(\.value).reduce(0, +) / total
        return (cumulative * 360) - 90 + (gapDegrees / 2)
    }

    private func endAngle(for index: Int) -> Double {
        guard total > 0 else { return -90 }
        let cumulative = segments.prefix(index + 1).map(\.value).reduce(0, +) / total
        return (cumulative * 360) - 90 - (gapDegrees / 2)
    }
}

private struct StatisticSegment: Identifiable {
    let id = UUID()
    let value: Double
    let count: Int
    let tint: Color
    let gradient: [Color]

    static let mockData: [StatisticSegment] = [
        StatisticSegment(
            value: 0.12,
            count: 36,
            tint: Color(hex: "#E6FBEA"),
            gradient: [Color(hex: "#9AF0DA"), Color(hex: "#45D0AB")]
        ),
        StatisticSegment(
            value: 0.25,
            count: 36,
            tint: Color(hex: "#DBF0FF"),
            gradient: [Color(hex: "#B0CFD6"), Color(hex: "#4E98AE")]
        ),
        StatisticSegment(
            value: 0.38,
            count: 36,
            tint: Color(hex: "#FFE2E2"),
            gradient: [Color(hex: "#E57A28"), Color(hex: "#B84412")]
        ),
        StatisticSegment(
            value: 0.25,
            count: 36,
            tint: Color(hex: "#FFF5CF"),
            gradient: [Color(hex: "#E9DD54"), Color(hex: "#C1AF16")]
        )
    ]

    static let summaryData: [StatisticSegment] = [
        StatisticSegment(
            value: 0.12,
            count: 36,
            tint: Color(hex: "#E6FBEA"),
            gradient: [Color(hex: "#9AF0DA"), Color(hex: "#45D0AB")]
        ),
        StatisticSegment(
            value: 0.25,
            count: 36,
            tint: Color(hex: "#FFF5CF"),
            gradient: [Color(hex: "#E9DD54"), Color(hex: "#C1AF16")]
        ),
        StatisticSegment(
            value: 0.25,
            count: 36,
            tint: Color(hex: "#DBF0FF"),
            gradient: [Color(hex: "#B0CFD6"), Color(hex: "#4E98AE")]
        ),
        StatisticSegment(
            value: 0.38,
            count: 36,
            tint: Color(hex: "#FFE2E2"),
            gradient: [Color(hex: "#E57A28"), Color(hex: "#B84412")]
        )
    ]
}

private extension StatisticSegment {
    var color: Color {
        gradient.last ?? .clear
    }
}

private struct DonutArc: Shape {
    let startAngle: Double
    let endAngle: Double
    let lineWidth: CGFloat

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = (min(rect.width, rect.height) - lineWidth) / 2
        let outerRadius = radius + (lineWidth / 2)
        let innerRadius = radius - (lineWidth / 2)

        var path = Path()
        path.addArc(
            center: center,
            radius: outerRadius,
            startAngle: .degrees(startAngle),
            endAngle: .degrees(endAngle),
            clockwise: false
        )
        path.addArc(
            center: center,
            radius: innerRadius,
            startAngle: .degrees(endAngle),
            endAngle: .degrees(startAngle),
            clockwise: true
        )
        path.closeSubpath()
        return path
    }
}

#Preview {
    Statistics()
}
