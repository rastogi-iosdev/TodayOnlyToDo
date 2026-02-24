//
//  TaskStorage.swift
//  TodayOnlyToDo
//
//  Created by Harshit Rastogi on 23/02/26.
//

import Foundation
import WidgetKit

struct TaskStorage {
    
    static var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("tasks.json")
    }
    
    static func load() -> [TodoTask] {
        guard let data = try? Data(contentsOf: fileURL),
              let tasks = try? JSONDecoder().decode([TodoTask].self, from: data)
        else { return [] }
        
        return tasks
    }
    
    static func save(_ tasks: [TodoTask]) {
        if let data = try? JSONEncoder().encode(tasks) {
            try? data.write(to: fileURL)
        }
        
        WidgetCenter.shared.reloadAllTimelines()
    }
}
