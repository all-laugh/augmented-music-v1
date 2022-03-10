//
//  PitchCross.swift
//  Modes V1
//
//  Created by Xiao Quan on 3/9/22.
//

import AudioKit
import SoundpipeAudioKit
import Combine

class PitchCross: AudioMode, ObservableObject {
    var name: String = "Pitch Cross"
    var input: Node?
    var output: Node?
    var bypass: Bool = false
    var isActive: Bool = false
    
    var highPass: HighPassButterworthFilter!
    var lowPass: LowPassButterworthFilter!
    var pitchUp: PitchShifter!
    var pitchDown: PitchShifter!
//    var reverb: CostelloReverb!
    var outputMixer: Mixer!
    
    
    func setInput(to input: Node) {
        self.input = input
    }
    
    func activate() {
        if self.input == nil { return }
        highPass = HighPassButterworthFilter(input!, cutoffFrequency: 1500)
        pitchDown = PitchShifter(highPass,
                                 shift: -12,
                                 windowSize: 512,
                                 crossfade: 256)
        
        lowPass = LowPassButterworthFilter(input!, cutoffFrequency: 200)
        pitchUp = PitchShifter(lowPass,
                               shift: 12,
                               windowSize: 2048,
                               crossfade: 256)
        
        outputMixer = Mixer([pitchUp, pitchDown])
        
//        reverb = CostelloReverb(outputMixer,
//                                feedback: 0.1,
//                                cutoffFrequency: 10_000)
        
        self.output = outputMixer
        
        isActive = true
    }
    
    func deactivate() {
        output = nil
//        reverb = nil
        pitchUp = nil
        pitchDown = nil
        lowPass = nil
        highPass = nil
        input = nil
        
        isActive = false
    }
    
    
}
