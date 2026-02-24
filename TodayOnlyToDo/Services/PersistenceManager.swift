//
//  PersistenceManager.swift
//  TodayOnlyToDo
//
//  Created by Harshit Rastogi on 24/02/26.
//

import Foundation

final class PersistenceManager: PersistenceProtocol {
    
    private let fileURL: URL = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("tasks.json")
    }()
    
    // this code is for accessing data through AppGroup, I don't have Apple Developer account for Appgroup.
    /*
     private let fileURL: URL = {
         guard let container = FileManager.default.containerURL(
             forSecurityApplicationGroupIdentifier: "group.com.harsh.todaytodo"
         ) else {
             fatalError("App Group not configured properly")
         }
         
         return container.appendingPathComponent("tasks.json")
     }()
     */
    
    func save(_ tasks: [TodoTask]) {
        if let data = try? JSONEncoder().encode(tasks) {
            try? data.write(to: fileURL)
        }
    }
    
    func load() -> [TodoTask] {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([TodoTask].self, from: data) else {
            return []
        }
        return decoded
    }
}

