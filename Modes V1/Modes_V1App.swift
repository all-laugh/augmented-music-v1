//
//  Modes_V1App.swift
//  Modes V1
//
//  Created by Xiao Quan on 11/9/21.
//

import SwiftUI
import AVFoundation

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, options: [.allowBluetooth])
            try session.setActive(true)
        } catch {
            print("Error setting AVAudioSession Category", error.localizedDescription)
        }
        
        print("Simulator Directory: \(NSHomeDirectory())")
        
        return true
    }
}

@main
struct Modes_V1App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AudioManager.sharedInstance)
        }
    }
}
