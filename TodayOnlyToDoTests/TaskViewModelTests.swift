//
//  TaskViewModelTests.swift
//  TodayOnlyToDo
//
//  Created by Harshit Rastogi on 25/02/26.
//

import XCTest
@testable import TodayOnlyToDo

final class TaskViewModelTests: XCTestCase {
    
    var viewModel: TaskViewModel!
    var mockPersistence: MockPersistence!
    var mockNotification: MockNotificationManager!
    
    override func setUp() {
        mockPersistence = MockPersistence()
        mockNotification = MockNotificationManager()
        
        viewModel = TaskViewModel(
            persistence: mockPersistence as! PersistenceProtocol,
            notificationManager: mockNotification as! NotificationProtocol
        )
    }
    
    func test_addTask_shouldAppendTask_andScheduleNotification() throws{
        viewModel.addTask(title: "Test Task", expiry: nil)
        
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(mockNotification.scheduledTasks.count, 1)
    }
    
    func test_toggleTask_shouldChangeCompletionState() throws {
        viewModel.addTask(title: "Task", expiry: nil)
        let task = viewModel.tasks[0]
        
        viewModel.toggleTask(task)
        
        XCTAssertTrue(viewModel.tasks[0].isCompleted)
    }
    
    func test_deleteTasksNotFromToday_shouldRemoveOldTasks() throws{
        let oldDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        
        let newTask = TodoTask(title: "New", expiryTime: nil)
        
        mockPersistence.storedTasks = [
            TodoTask(id: UUID(), title: "Old", isCompleted: false, createdAt: oldDate, expiryTime: nil),
            newTask
        ]
        
        viewModel.updateData()
        
        XCTAssertEqual(viewModel.tasks.count, 1)
    }
    
    func test_markExpiredTasksCompleted_shouldMarkTaskDone() throws {
        let pastDate = Date().addingTimeInterval(-60)
        
        let task = TodoTask(title: "Expired", expiryTime: pastDate)
        mockPersistence.storedTasks = [task]
        
        viewModel.updateData()
        
        XCTAssertTrue(viewModel.tasks[0].isCompleted)
    }
    
    func test_remainderTimeChanged_shouldReschedulePendingTasks() throws {
        viewModel.addTask(title: "Task", expiry: nil)
        
        viewModel.remainderTimeChanged()
        
        XCTAssertEqual(mockNotification.rescheduledTasks.count, 1)
    }
    
    func test_todayTasks_shouldReturnOnlyTodayTasks() throws {
        viewModel.addTask(title: "Today Task", expiry: nil)
        
        XCTAssertEqual(viewModel.todayTasks.count, 1)
    }
}
