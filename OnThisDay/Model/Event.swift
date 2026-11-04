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
