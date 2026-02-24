//
//  AddTaskIntent.swift
//  TodayOnlyToDo
//
//  Created by Harshit Rastogi on 23/02/26.
//

import AppIntents

struct AddTaskIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Add Task"
    static var description = IntentDescription("Add a new task for today")
    
    @Parameter(title: "Task Title")
    var title: String
    
    @Parameter(title: "Time")
    var time: Date?
    
    static var openAppWhenRun: Bool = false
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        
        var tasks = await TaskStorage.load()
        
        let newTask = TodoTask(
            title: title,
            isCompleted: false,
            createdAt: Date(),
            expiryTime: time
        )
        
        tasks.append(newTask)
        await TaskStorage.save(tasks)
        
        return .result(dialog: "Added \(title)")
    }
}
