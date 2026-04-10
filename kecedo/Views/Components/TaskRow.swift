//
//  TaskRow.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 09/04/26.
//

import Foundation
import SwiftUI

struct TaskRow: View {
    let task: TaskModel
    let iconMode: Priority
    let onToggle: () -> Void
    var onTap: (() -> Void)? = nil
    
    // Status deadline logic
    private var statusInfo: (text: String, color: Color, icon: String?) {
        let dateString = DateFormatter.matrixTime.string(from: task.endDate)

        if task.isDone {
            return (dateString, .gray, nil)
        }
        
        let timeInterval = task.endDate.timeIntervalSinceNow
        
        if timeInterval < 0 {
            return ("Overdue - \(dateString)", .red, "exclamationmark.circle.fill")
        } else if timeInterval < 86400 { 
            let hours = Int(timeInterval / 3600)
            let hourText = hours > 0 ? "Due in \(hours) \(hours == 1 ? "hour" : "hours")" : "Due in less than an hour"
            return ("\(hourText) - \(dateString)", .orange, "alarm.fill")
        } else {
            return (dateString, .gray, nil)
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            MatrixGridBadge(priority: iconMode)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(task.isDone ? .gray : .primary)
                    .strikethrough(task.isDone, color: .gray)
                    .lineLimit(1)
                
                let status = statusInfo
                HStack(spacing: 4) {
                    if let icon = status.icon {
                        Image(systemName: icon)
                    }
                    Text(status.text)
                }
                .font(.system(size: 13, weight: status.icon != nil ? .medium : .regular))
                .foregroundColor(status.color)
            }
            
            Spacer(minLength: 12)
            
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .stroke(task.isDone ? Color.clear : Color.gray.opacity(0.4), lineWidth: 1.5)
                        .frame(width: 28, height: 28)
                    
                    if task.isDone {
                        Circle()
                            .fill(task.priority.color.primary)
                            .frame(width: 28, height: 28)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 5, y: 2)
        .contentShape(Rectangle())
        .onTapGesture { onTap?() }
    }
}
