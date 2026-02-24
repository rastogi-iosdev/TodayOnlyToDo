//
//  SettingsView.swift
//  TodayOnlyToDo
//
//  Created by Harshit Rastogi on 23/02/26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var manager: TaskViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Daily Reminder") {
                    DatePicker("EOD Notification", selection: $manager.reminderTime, displayedComponents: .hourAndMinute)
                }
                
                Section {
                    Text("Tasks are automatically hidden at 00:00 every night. This reminder helps you finish your 'Today' list before it resets.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Preferences")
            .toolbar {
                Button("Done") {
                    manager.remainderTimeChanged()
                    dismiss()
                }
            }
        }
    }
}
