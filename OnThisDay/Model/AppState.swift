//
//  AppState.swift
//  OnThisDay
//
//  Created by Kenneth Chua on 11/6/26.
//

import Foundation

enum LoadState: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)
    
    static func == (lhs: LoadState, rhs: LoadState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.loaded, .loaded): return true
        case (.failed(let a), .failed(let b)): return a == b
        default: return false
        }
    }
}

@MainActor
final class AppState: ObservableObject {
    @Published var currentDay: Day?
    @Published var loadState: LoadState = .idle
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchDay(month: Int, day: Int) async {
        loadState = .loading
        
        guard let url = URL(string: "https://today.zenquotes.io/api/\(month)/\(day)")
        else {
            loadState = .failed("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let decoder = JSONDecoder()
            let decodedDay = try decoder.decode(Day.self, from: data)
            self.currentDay = decodedDay
            self.loadState = .loaded
        } catch {
            self.loadState = .failed(error.localizedDescription)
        }
    }
}


