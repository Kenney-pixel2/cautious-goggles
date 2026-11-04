//
//  Day.swift
//  OnThisDay
//
//  Created by Kenneth Chua on 10/23/26.
//

import Foundation

struct Day: Decodable {
    let date: String
    let data: [String: [Event]]
    
    var events: [Event] {
        data[EventType.events.rawValue] ?? []
    }
    
    var deaths: [Event] {
        data[EventType.deaths.rawValue] ?? []
    }
    
    var births: [Event] {
        data[EventType.births.rawValue] ?? []
    }
    
    var displayDate: String {
        date.replacingOccurrences(of: "_", with: " ")
    }
}

enum EventType: String {
    case events = "Events"
    case births = "Births"
    case deaths = "Deaths"
}
