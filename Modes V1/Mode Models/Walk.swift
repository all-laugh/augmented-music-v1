//
//  Walk.swift
//  Modes V1
//
//  Created by Xiao Quan on 11/10/21.
//

import AudioKit
import SoundpipeAudioKit
import SwiftUI

// MARK: - Data

struct WalkData {
    var rampDuration: AUValue = 0.02
    // Delay
    var delayTime: AUValue = 0.2
    var delayFeedback: AUValue = 0.5
    var delayLowPassCutoff: AUValue = 5_000
    var delayDryWetMix: AUValue = 1
    // Reverb
    var reverbFeedback: AUValue = 0.7
    var reverbLowpassCutoff: AUValue = 8_000.0
    var reverbBalance: AUValue = 1
}

// MARK: - Filter Model

class Walk: AudioMode, ObservableObject {
    var name: String = "We Walk"
    var input: Node?
    var output: Node?
    var delay: Delay?
    var reverb: CostelloReverb?
    var dryWetMixer: DryWetMixer?
    var data: WalkData = WalkData()
    var isActive = false
    
    @Published var bypass: Bool = false {
        didSet {
            bypass ? reverb!.bypass() : reverb!.play()
            bypass ? delay!.bypass() : delay!.play()
        }
    }
    
    func setInput(to input: Node) {
        self.input = input
    }
    
    func activate() {
        if input == nil { return }
        delay = Delay(input!, time: 0.4)
        reverb = CostelloReverb(delay!)
        dryWetMixer = DryWetMixer(self.input!, reverb!)
        output = dryWetMixer!
        setData()
        isActive = true
    }
    
    func deactivate() {
        if !isActive { return }
        output = nil
        dryWetMixer = nil
        reverb = nil
        delay = nil
        isActive = false
        
        input = nil
        output = nil
    }
    
    private func setData() {
        delay!.$time.ramp(to: data.delayTime, duration: data.rampDuration)
        delay!.$feedback.ramp(to: data.delayFeedback, duration: data.rampDuration)
        delay!.$lowPassCutoff.ramp(to: data.delayLowPassCutoff, duration: data.rampDuration)
        delay!.$dryWetMix.ramp(to: data.rampDuration, duration: data.rampDuration)
        reverb!.$feedback.ramp(to: data.reverbFeedback, duration: data.rampDuration)
        reverb!.$cutoffFrequency.ramp(to: data.reverbLowpassCutoff, duration: data.rampDuration)
        dryWetMixer!.balance = data.reverbBalance
    }
}
