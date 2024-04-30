//
//  ContentView.swift
//  Sandbox
//
//  Created by 日野森寛也 on 2024/04/30.
//

import SwiftUI
import Entity

public struct ContentView: View {
    let entity: Entity
    
    public init() {
        self.entity = .init(text: "Hoge", date: .now)
    }

    public var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(entity.text)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
