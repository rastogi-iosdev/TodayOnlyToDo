//
//  TodayView.swift
//  TodayOnlyToDo
//
//  Created by Harshit Rastogi on 23/02/26.
//

import SwiftUI

struct TodayView: View {
    @StateObject var manager = TaskViewModel()
    @State private var showAddSheet = false
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HeaderView()
                
                List {
                    ForEach(manager.todayTasks) { task in
                        TaskRow(task: task) {
                            manager.toggleTask(task)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                
                Spacer()
                
                HStack {
                    Image(systemName: "line.3.horizontal.decrease").foregroundColor(.green)
                    Spacer()
                    Button { showAddSheet.toggle() } label: {
                        Image(systemName: "plus")
                            .font(.title.bold())
                            .foregroundColor(.black)
                            .padding()
                            .background(Circle().fill(Color.green.opacity(0.6)))
                    }
                    Spacer()
                    Button { showSettings.toggle() } label: {
                        Image(systemName: "gearshape").foregroundColor(.gray)
                    }
                    .sheet(isPresented: $showSettings) {
                        SettingsView(manager: manager)
                            .presentationDetents([.medium])
                    }
                }
                .padding(.horizontal, 30)
            }
            .onAppear{
                manager.updateData()
            }
            .sheet(isPresented: $showAddSheet) {
                AddTodoSheet(manager: manager)
                    .presentationDetents([.medium])
            }
        }
    }
}
