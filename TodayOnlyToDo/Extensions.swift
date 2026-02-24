//
//  Extensions.swift
//  TodayOnlyToDo
//
//  Created by Harshit Rastogi on 23/02/26.
//

import Foundation

extension Date {
    var timeString: String {
        self.formatted(date: .omitted, time: .shortened)
    }
}
