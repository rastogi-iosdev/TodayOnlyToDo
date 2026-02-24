//
//  NotificationManager.swift
//  TodayOnlyToDo
//
//  Created by Harshit Rastogi on 23/02/26.
//

import UserNotifications
import Combine

class NotificationManager: NotificationProtocol {
    @Published var reminderTime: Date = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date()
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }
    
    func scheduleEODReminder(tasksCount: Int) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["EOD_REMINDER"])
        
        guard tasksCount > 0 else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Finish your day"
        content.body = "You have \(tasksCount) tasks left. They'll reset at midnight!"
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: "EOD_REMINDER", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    func rescheduleNotification(for task: TodoTask){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
        
        scheduleTaskNotification(for: task)
    }
    
    func scheduleTaskNotification(for task: TodoTask) {
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = task.title
        content.sound = .default

        let triggerDate: Date

        if let expiry = task.expiryTime {
            triggerDate = expiry
        } else {
            triggerDate = reminderTime
        }

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: triggerDate
        )

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(
            identifier: task.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotification(for task: TodoTask) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
    }
    
    private func parseTime(_ time: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: time)
    }
}


