//
//  CompleteTaskIntent.swift
//  TodayOnlyToDo
//
//  Created by Harshit Rastogi on 23/02/26.
//

import AppIntents

struct CompleteTaskIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Complete Task"
    
    @Parameter(title: "Task Title")
    var title: String
    
    func perform() async throws -> some IntentResult & ProvidesDialog  {
        
        var tasks = TaskStorage.load()
        
        if let index = tasks.firstIndex(where: {
            $0.title.lowercased() == title.lowercased() &&
            Calendar.current.isDateInToday($0.createdAt)
        }) {
            tasks[index].isCompleted.toggle()
            TaskStorage.save(tasks)
            
            return .result(dialog: "\(title) updated")
        }
        
        return .result(dialog: "Task not found")
    }
}
