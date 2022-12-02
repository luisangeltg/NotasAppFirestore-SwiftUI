//
//  IphoneIpadFirebaseApp.swift
//  IphoneIpadFirebase
//
//  Created by Luis Angel Torres G on 28/11/22.
//


import SwiftUI
import UIKit

@main
struct IphoneIpadFirebaseApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        let login = FirebaseViewModel()
        WindowGroup {
            ContentView()
                .environmentObject(OrientationInfo())
                .environmentObject(login)
        }
    }
}
