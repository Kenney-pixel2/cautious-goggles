//
//  EventView.swift
//  OnThisDay
//
//  Created by Kenneth Chua on 11/10/26.
//

import SwiftUI

struct EventView: View {
    var event: Event
    
    // State to control the popover
    @State private var showingAllLinks = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 1. Year & Description
            if let year = event.year {
                Text(year).font(.headline).foregroundStyle(.secondary)
            }
            Text(event.description)
                .font(.body)
                .lineLimit(4)
            
            // 2. Links
            if !event.links.isEmpty {
                Divider().padding(.vertical, 4)
                
                HStack(spacing: 12) {
                    // Show only the first 2 links on the card
                    ForEach(event.links.prefix(2)) { link in
                        if let url = link.urlValue {
                            SwiftUI.Link(link.text, destination: url)
                                .font(.caption)
                        }
                    }
                    
                    // If there are more than 2 links, show the "More" button
                    if event.links.count > 2 {
                        Button("More...") {
                            showingAllLinks = true
                        }
                        .buttonStyle(.link)
                        .font(.caption)
                        .popover(isPresented: $showingAllLinks) {
                            // This is the content of the popover
                            VStack(alignment: .leading, spacing: 8) {
                                Text("All Links").font(.headline).padding(.bottom, 4)
                                ForEach(event.links) { link in
                                    if let url = link.urlValue {
                                        SwiftUI.Link(link.text, destination: url)
                                            .font(.body)
                                    }
                                }
                            }
                            .padding()
                            .frame(minWidth: 200, alignment: .leading)
                        }
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(NSColor.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
// MARK: - Previews

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        // This preview shows how the cards look in a grid layout!
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 280))], spacing: 16) {
                // We loop 3 times to create multiple cards for the preview
                ForEach(0..<3, id: \.self) { _ in
                    EventView(event: Event.sampleEvent)
                }
            }
            .padding()
        }
        .frame(width: 600, height: 400)
        .background(Color(NSColor.windowBackgroundColor)) // Gives a nice backdrop behind the cards
    }
}
