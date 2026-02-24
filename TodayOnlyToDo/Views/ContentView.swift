//
//  ContentView.swift
//  TodayOnlyToDo
//
//  Created by Harshit Rastogi on 23/02/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TodayView(manager: TaskViewModel())
    }
}

#Preview {
    ContentView()
}
