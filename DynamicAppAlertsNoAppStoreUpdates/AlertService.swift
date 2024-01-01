//
//  AlertService.swift
//  DynamicAppAlertsNoAppStoreUpdates
//
//  Created by test on 01.01.2024.
//

import Foundation
import SwiftUI

@Observable
class AlertService {
    struct Message: Codable {
        struct Link: Codable {
            let title: String
            let url: String
        }
        var id: Int = 0
        var bundleId: String = ""
        var title: String = ""
        var text: String = ""
        var confirmLabel: String = ""
        var appVersions: [String]?
        var osVersions: [String]?
        var link: Link?
    }
    
    let jsonURL: String
    let bundleIdentifier = Bundle.main.bundleIdentifier!
    var message = Message()
    var showMessage = false
    static var appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    static var osVersion = UIDevice.current.systemVersion
    
    var lastMessageId: Int {
        get {
            UserDefaults.standard.integer(forKey: "lastMessageId")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "lastMessageId")
        }
    }
    
    init(_ jsonURL: String) {
        self.jsonURL = jsonURL
    }
    
    func fetchMessage() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: jsonURL)!)
            if let message = try JSONDecoder().decode([Message].self, from: data).first(where: {$0.bundleId == bundleIdentifier}) {
                self.message = message
            }
        } catch {
            print("Could not decode")
        }
    }
    
    func showAlertIfNecessary() async {
        await fetchMessage()
        guard message.id > lastMessageId else { return }
        if let osVersions = message.osVersions {
            guard osVersions.contains(Self.osVersion) else { return }
        }
        if let appVersions = message.appVersions {
            guard appVersions.contains(Self.appVersion) else { return }
        }
        
        showMessage.toggle()
        lastMessageId = message.id
    }
    
    struct AlertModifier: ViewModifier {
        @Bindable var alertService: AlertService
        func body(content: Content) -> some View {
            content
                .alert(alertService.message.title, isPresented: $alertService.showMessage) {
                Button(alertService.message.confirmLabel) {}
                if let link = alertService.message.link {
                    Link(link.title, destination: URL(string: link.url)!)
                }
            } message: {
                Text(alertService.message.text)
            }
        }
    }
}

extension View {
    func messageAlert(_ alertService: AlertService) -> some View {
        modifier(AlertService.AlertModifier(alertService: alertService))
    }
}
