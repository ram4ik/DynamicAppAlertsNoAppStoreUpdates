//
//  AlertService.swift
//  DynamicAppAlertsNoAppStoreUpdates
//
//  Created by test on 01.01.2024.
//

import Foundation

@Observable
class AlertService {
    struct Message: Codable {
        var id: Int = 0
        var bundleId: String = ""
        var title: String = ""
        var text: String = ""
        var confirmLabel: String = ""
    }
    
    let jsonURL: String
    let bundleIdentifier = Bundle.main.bundleIdentifier!
    var message = Message()
    var showMessage = false
    
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
        if message.id > lastMessageId {
            showMessage.toggle()
        }
        lastMessageId = message.id
    }
}
