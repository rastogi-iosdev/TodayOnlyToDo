//
//  TodoTask.swift
//  TodayOnlyToDo
//
//  Created by Harshit Rastogi on 23/02/26.
//

import Foundation

struct TodoTask: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var createdAt: Date = Date()
    var expiryTime: Date?
}
