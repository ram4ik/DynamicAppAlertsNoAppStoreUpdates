//
//  DynamicAppAlertsNoAppStoreUpdatesApp.swift
//  DynamicAppAlertsNoAppStoreUpdates
//
//  Created by test on 01.01.2024.
//

import SwiftUI

@main
struct DynamicAppAlertsNoAppStoreUpdatesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    print(AlertService.appVersion)
                    print(AlertService.osVersion)
                    print(AlertService.cachesLocation.path())
                    print(AlertService.userDefaultsLocation.path())
                }
        }
    }
}
