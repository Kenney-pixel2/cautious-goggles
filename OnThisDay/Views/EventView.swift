//
//  EventView.swift
//  OnThisDay
//
//  Created by Kenneth Chua on 11/10/26.
//

import SwiftUI

struct EventView: View {
    var event: Event
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            if let year = event.year {
                Text(year)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            
            Text(event.description)
                .font(.body)
                .lineLimit(4)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(NSColor.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x:0, y: 2)
        .padding(.vertical, 4)
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        // A preview of how the grid will look!
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 250))], spacing: 16) {
                ForEach(0..<4) { _ in
                    EventView(event: Event.sampleEvent)
                }
            }
            .padding()
        }
        .frame(width: 600, height: 400)
    }
}
