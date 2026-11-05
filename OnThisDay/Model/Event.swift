//
//  Event.swift
//  OnThisDay
//
//  Created by Kenneth Chua on 11/4/26.
//

import Foundation

struct Event: Decodable {
    let id = UUID()
    let text: String
    let links: [Link]

    var year: String? {
        let components = text.components(separatedBy: "–")
        guard components.count >= 2 else { return nil }
        let potentialYear = components[0].trimmingCharacters(in: .whitespaces)
        
        if !potentialYear.isEmpty {
            return potentialYear
        }
        return nil
    }
    
    var description: String {
        let components = text.components(separatedBy: "–")
        
        // If there's no dash, just return the whole text
        guard components.count >= 2 else { return text }
        
        // Join the remaining components back together in case the description
        // itself contained a dash.
        let desc = components.dropFirst().joined(separator: "–")
        return desc.trimmingCharacters(in: .whitespaces)
    }
    
    private enum CodingKeys: String, CodingKey {
        case text, links
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.text = try container.decode(String.self, forKey: .text)

        var linksContainer = try container.nestedUnkeyedContainer(forKey: .links)
        var decoded: [Link] = []
        while !linksContainer.isAtEnd {
            do {
                let link = try linksContainer.decode(Link.self)
                if link.urlValue != nil {   // drop links whose URL string is invalid
                    decoded.append(link)
                }
            } catch {
                _ = try? linksContainer.decode(SkipElement.self)
            }
        }
        self.links = decoded
    }
}

private struct SkipElement: Decodable {
    init(from decoder: Decoder) throws {}
}
