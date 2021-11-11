//
//  AudioManager.swift
//  Modes V1
//
//  Created by Xiao Quan on 11/10/21.
//

import Foundation
import SwiftUI
import AudioKit

class AudioManager: ObservableObject {
    
    public static var sharedInstance = AudioManager()
    
    var engine = AudioEngine()
    var mic: AudioEngine.InputNode?
    let inputDevices = Settings.session.availableInputs
    var inputDeviceList = [String]()
    
    private var currentMode: AudioMode?
    
    private init() {
        if let input = engine.input {
            mic = input
//            engine.output = Mixer(input)
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
    
    func switchInput(number: Int?) {
        stop()
        if let inputs = Settings.session.availableInputs {
            let newInput = inputs[number ?? 0]
            do {
                try Settings.session.setPreferredInput(newInput)
                try Settings.session.setActive(true)
            } catch let err {
                Log(err)
            }
        }
    }
    
    private func setEngineOutput(to output: Node) {
        engine.output = output
    }

    func start() {
        do { try engine.start() } catch let err { Log(err) }
        print("Engine Started")
    }

    func stop() {
        engine.stop()
    }
    
    func setCurrentMode(index: Int) {
        self.currentMode = constructAudioMode(index)
        // Connext mic to filter
        self.currentMode!.setInput(to: Mixer(mic!))
        // Activate Filter
        self.currentMode!.activate()
        // Connect engine output to filter output
        if let modeOutput = self.currentMode?.output {
            setEngineOutput(to: modeOutput)
            print("Engine output set to \(currentMode!.name)")
        } else {
            print("Error Constructing Audio Mode")
        }
    }

    private func constructAudioMode(_ index: Int) -> AudioMode {
        switch index {
        case 0:
            print("Made a Cloud mode")
            return Cloud()
        case 1:
            print("Made a Walk mode")
            return Walk()
        default:
            print("Made a Cloud mode")
            return Cloud()
        }
    }
}


