//
//  Link.swift
//  OnThisDay
//
//  Created by Kenneth Chua on 11/4/26.
//

import Foundation

struct Link: Identifiable, Decodable {
    let id: UUID
    let text: String
    let url: String
    
    var urlValue: URL? {
        URL(string: url)
    }
    
    private enum CodingKeys: String, CodingKey {
        case text, url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.url = try container.decode(String.self, forKey: .url)
        self.id = UUID() // Generate ID dynamically
    }
}
