//
//  OpenTodayIntent.swift
//  TodayOnlyToDo
//
//  Created by Harshit Rastogi on 23/02/26.
//

import AppIntents

struct OpenTodayIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Open Today Tasks"
    static var openAppWhenRun = true
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
