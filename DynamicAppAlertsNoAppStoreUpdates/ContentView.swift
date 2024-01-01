//
//  ContentView.swift
//  DynamicAppAlertsNoAppStoreUpdates
//
//  Created by test on 01.01.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var alertService = AlertService("https://ram4ik.github.io/AppAlert/messages.json")
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .alert(alertService.message.title, isPresented: $alertService.showMessage) {
                    Button(alertService.message.confirmLabel) {}
                } message: {
                    Text(alertService.message.text)
                }
        }
        .padding()
        .task {
            await alertService.showAlertIfNecessary()
        }
    }
}

#Preview {
    ContentView()
}
