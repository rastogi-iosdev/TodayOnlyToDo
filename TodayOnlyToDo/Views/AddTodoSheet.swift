//
//  AddTodoSheet.swift
//  TodayOnlyToDo
//
//  Created by Harshit Rastogi on 23/02/26.
//

import SwiftUI

struct AddTodoSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var manager: TaskViewModel
    @State private var taskTitle = ""
    @State private var selectedTime: Date? = nil
    
    private var bindingForTime: Binding<Date> {
        Binding<Date>(
            get: {
                selectedTime ?? Date()
            },
            set: { newValue in
                selectedTime = newValue
            }
        )
    }
    
    var body: some View {
        VStack(spacing: 25) {
            Capsule().frame(width: 40, height: 5).foregroundColor(.gray.opacity(0.3))
                .padding(.bottom, 25)
            
            Text("NEW INTENT").font(.caption.bold()).foregroundColor(.green)
            Text("TODAY ONLY - RESETS AT 00:00").font(.caption2)
            
            TextField("Finish the report", text: $taskTitle)
                .font(.title2)
                .multilineTextAlignment(.center)
            
            DatePicker(
                "Select Time",
                selection: bindingForTime,
                displayedComponents: .hourAndMinute
            )
            
            Button {
                manager.addTask(title: taskTitle, expiry: selectedTime)
                dismiss()
            } label: {
                HStack {
                    Text("Add to Timeline")
                    Image(systemName: "bolt.fill")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green.opacity(0.8))
                .foregroundColor(.black)
                .cornerRadius(15)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
