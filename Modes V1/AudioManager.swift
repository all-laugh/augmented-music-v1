//
//  AudioManager.swift
//  Modes V1
//
//  Created by Xiao Quan on 11/10/21.
//

import Foundation
import SwiftUI
import AudioKit
import AudioKitEX

class AudioManager: ObservableObject {
    
    public static var sharedInstance = AudioManager()
    
    var engine: AudioEngine!
    var mic: AudioEngine.InputNode?
    let inputDevices = Settings.session.availableInputs
    var inputDeviceList = [String]()
    
    var currentMode: AudioMode?
    var currentModeName: String {
        currentMode?.name ?? "Up In The Clouds"
    }
    
    private init() {
        prepareEngine()
    }
    
    func prepareEngine() {
        engine = AudioEngine()
        
        if let input = engine.input {
            mic = input
        } else {
            mic = nil
            engine.output = Mixer()
        }
        
        if let existingInputs = inputDevices {
            for device in existingInputs {
                self.inputDeviceList.append(device.portName)
            }
        }
    }
    
    func setInput(to: Int?) {
        stop()
        if let inputs = Settings.session.availableInputs {
            let newInput = inputs[to ?? 0]
            do {
                try Settings.session.setPreferredInput(newInput)
                try Settings.session.setActive(true)
            } catch let err {
                Log(err)
            }
        }
        prepareEngine()
        setCurrentMode(to: .init(rawValue: currentModeName)!)
        start()
    }
    
    private func setEngineOutput(to output: Node) {
        engine.output = output
    }

    func start(completion: (() -> Void)? = nil) {
        do {
            try engine.start()
        } catch let err {
            Log(err)
            
        }
        print("Current Route: \(Settings.session.currentRoute)")
        print("Engine Started")
        
        if let completion = completion {
            completion()
        }
    }

    func stop() {
        engine.stop()
        print("Engine Stopped")
    }
    
    // Connect mic to filter, then engine output to filter output
    func setCurrentMode(to mode: ModeNames, completion: (() -> Void)? = nil) {
        print("Headphones plugged: ", Settings.headPhonesPlugged)
        print("Available Outputs: ", Settings.session.currentRoute.outputs)
        stop()
        prepareEngine()
        let newMode = constructAudioMode(for: mode)
       
        // Connext mic to filter
        newMode.setInput(to: Fader(mic!, gain: 1))
        
        // Activate Filter
        newMode.activate()
        
        // Connect engine output to filter output
        if let modeOutput = newMode.output {
            setEngineOutput(to: modeOutput)
            print("Engine output set to \(newMode.name)")
        } else {
            print("Error Constructing Audio Mode")
        }
        self.currentMode = newMode
        start(completion: completion)
    }

    private func constructAudioMode(for mode: ModeNames) -> AudioMode {
        switch mode {
        case .clouds:
            print("Made a Cloud mode")
            return Cloud()
        case .walk:
            print("Made a Walk mode")
            return Walk()
            
        case .duck:
            print("Made a Duck mode")
            return Duck()
//        default:
//            print("Made a Cloud mode")
//            return Cloud()
        }
    }
}


