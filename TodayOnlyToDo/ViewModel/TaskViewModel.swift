//
//  TaskViewModel.swift
//  TodayOnlyToDo
//
//  Created by Harshit Rastogi on 23/02/26.
//

import Foundation
import Combine
import WidgetKit

protocol PersistenceProtocol {
    func save(_ tasks: [TodoTask])
    func load() -> [TodoTask]
}

protocol NotificationProtocol {
    var reminderTime: Date { get set }
    func requestAuthorization()
    func scheduleTaskNotification(for task: TodoTask)
    func rescheduleNotification(for task: TodoTask)
    func cancelNotification(for task: TodoTask)
}

class TaskViewModel: ObservableObject {
    @Published private(set) var tasks: [TodoTask] = []
    
    private let persistence: PersistenceProtocol
    private var notificationManager: NotificationProtocol
    
    var todayTasks: [TodoTask] {
        tasks.filter { Calendar.current.isDateInToday($0.createdAt) }
    }
    var reminderTime: Date {
        get { notificationManager.reminderTime }
        set { notificationManager.reminderTime = newValue }
    }
    
    init(
        persistence: PersistenceProtocol = PersistenceManager(),
        notificationManager: NotificationProtocol = NotificationManager()
    ) {
        self.persistence = persistence
        self.notificationManager = notificationManager
        
        updateData()
    }
    func updateData(){
        load()
        markExpiredTasksCompleted()
        notificationManager.requestAuthorization()
        deleteTasksNotFromToday()
    }
    
    func addTask(title: String, expiry: Date?) {
        let task = TodoTask(title: title, expiryTime: expiry)
        tasks.append(task)
        
        notificationManager.scheduleTaskNotification(for: task)
        save()
    }
    func toggleTask(_ task: TodoTask) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isCompleted.toggle()
        save()
    }
    
    func remainderTimeChanged(){
        let remainingTasks = tasks.filter{ !$0.isCompleted }
        for task in remainingTasks{
            notificationManager.rescheduleNotification(for: task)
        }
    }
    
    func markExpiredTasksCompleted() {
        let now = Date()
        
        for i in tasks.indices {
            if let expiry = tasks[i].expiryTime,
               expiry <= now {
                tasks[i].isCompleted = true
            }
        }
    }
    
    func deleteTasksNotFromToday() {
        let today = Calendar.current
        
        tasks.removeAll { task in
            !today.isDateInToday(task.createdAt)
        }
        save()
    }
    
    private func save() {
        persistence.save(tasks)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func load() {
        tasks = persistence.load()
    }
}
