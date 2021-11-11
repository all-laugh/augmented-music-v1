//
//  Modes_V1App.swift
//  Modes V1
//
//  Created by Xiao Quan on 11/9/21.
//

import SwiftUI

@main
struct Modes_V1App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AudioManager.sharedInstance)
        }
    }
}
