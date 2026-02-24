//
//  TodayWidget.swift
//  TodayWidget
//
//  Created by Harshit Rastogi on 23/02/26.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), taskData: loadTasksFromShared())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), taskData: loadTasksFromShared())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let tasks = loadTasksFromShared()
        let entry = SimpleEntry(date: Date(), taskData: tasks)
        
        let nextMidnight = Calendar.current.nextDate(
            after: Date(),
            matching: DateComponents(hour: 0, minute: 0),
            matchingPolicy: .nextTime
        )!
        
        let timeline = Timeline(entries: [entry], policy: .after(nextMidnight))
        completion(timeline)
    }
    
    func loadTasksFromShared() -> [TodoTask] {
        guard let container = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.harsh.todaytodo"
        ) else { return [] }

        let url = container.appendingPathComponent("tasks.json")

        guard let data = try? Data(contentsOf: url),
              let tasks = try? JSONDecoder().decode([TodoTask].self, from: data)
        else { return [] }

        return tasks.filter {
            Calendar.current.isDateInToday($0.createdAt)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let taskData: [TodoTask]
}

struct TodayWidgetEntryView : View {
    var entry: Provider.Entry
    var progress: Double {
        guard !entry.taskData.isEmpty else { return 0 }
        let done = entry.taskData.filter { $0.isCompleted }.count
        return Double(done) / Double(entry.taskData.count)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
            
            VStack(alignment: .leading, spacing: 12) {
                VStack {
                    Text("Today")
                        .font(.headline.bold())
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        ForEach(entry.taskData) { task in
                            WidgetRow(task: task)
                        }
                        .listRowSeparator(.hidden)
                    }
                }
            }
            .padding()
        }
    }
}

struct TodayWidget: Widget {
    let kind: String = "TodayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                TodayWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TodayWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WidgetRow: View {
    let task: TodoTask
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 24))
                .foregroundColor(task.isCompleted ? .green : .gray.opacity(0.3))
            
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
