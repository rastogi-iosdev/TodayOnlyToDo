//
//  MockClasses.swift
//  TodayOnlyToDo
//
//  Created by Harshit Rastogi on 25/02/26.
//

import Foundation

final class MockPersistence: PersistenceProtocol {
    var storedTasks: [TodoTask] = []
    
    func save(_ tasks: [TodoTask]) {
        storedTasks = tasks
    }
    
    func load() -> [TodoTask] {
        storedTasks
    }
}

final class MockNotificationManager: NotificationProtocol {
    var reminderTime: Date = Date()
    
    var scheduledTasks: [TodoTask] = []
    var rescheduledTasks: [TodoTask] = []
    var cancelledTasks: [TodoTask] = []
    
    func requestAuthorization() {}
    
    func scheduleTaskNotification(for task: TodoTask) {
        scheduledTasks.append(task)
    }
    
    func rescheduleNotification(for task: TodoTask) {
        rescheduledTasks.append(task)
    }
    
    func cancelNotification(for task: TodoTask) {
        cancelledTasks.append(task)
    }
}
