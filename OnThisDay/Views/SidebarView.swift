//
//  SidebarView.swift
//  OnThisDay
//
//  Created by Kenneth Chua on 11/8/26.
//

import SwiftUI

struct SidebarView: View {
    @Binding var selection: EventType?
    
    var body: some View {
        List(selection: $selection) {
            Section("TODAY") {
                ForEach(EventType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }
        }
        .listStyle(.sidebar)
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(selection: .constant(nil))
            .frame(width: 200)
    }
}
