//
//  TaskRow.swift
//  TodayOnlyToDo
//
//  Created by Harshit Rastogi on 23/02/26.
//

import SwiftUI

struct TaskRow: View {
    let task: TodoTask
    var onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(task.isCompleted ? .green : .gray.opacity(0.3))
            }
            .buttonStyle(.plain)
            
            Text(task.title)
                .font(.body)
                .strikethrough(task.isCompleted)
                .foregroundColor(task.isCompleted ? .gray.opacity(0.5) : .primary)
            
            Spacer()
            
            if let time = task.expiryTime {
                Text(time.timeString)
                    .font(.caption2.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(task.isCompleted ? Color.gray.opacity(0.1) : Color.orange.opacity(0.1))
                    .foregroundColor(task.isCompleted ? .gray : .orange)
                    .cornerRadius(4)
            }
        }
        .padding(.vertical, 8)
    }
}
