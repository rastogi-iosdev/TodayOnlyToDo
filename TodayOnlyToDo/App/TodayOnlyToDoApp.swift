//
//  TodayOnlyToDoApp.swift
//  TodayOnlyToDo
//
//  Created by Harshit Rastogi on 23/02/26.
//

import SwiftUI

@main
struct TodayOnlyToDoApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var manager = TaskViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .active:
                print("App is active")
                manager.updateData()
            case .inactive:
                print("App is inactive")
            case .background:
                print("App is in background")
            @unknown default:
                break    
            }
        }
    }
}
