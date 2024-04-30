//
//  ContentView.swift
//  Sandbox
//
//  Created by 日野森寛也 on 2024/04/30.
//

import SwiftUI

public struct ContentView: View {
    public init() { }

    public var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
