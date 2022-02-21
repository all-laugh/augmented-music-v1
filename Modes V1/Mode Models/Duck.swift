//
//  Duck.swift
//  Modes V1
//
//  Created by Xiao Quan on 2/19/22.
//

import Foundation
import AudioKit
import AudioKitEX
import SoundpipeAudioKit
import AVFAudio
import SwiftUI

class Duck: AudioMode, ObservableObject {

    var name: String = "Duck"
    var input: Node?
    var output: Node?
    @Published var bypass: Bool = false {
        didSet {
            bypass ? reverb?.bypass() : reverb?.play()
        }
    }
    var isActive: Bool = false
    var effectParams = ReverbData()
    
    // Effect Chain on Mic
    @Published var micGain: AUValue = 1.0 {
        willSet {
            micFader?.gain = newValue
        }
    }
    var micFader: Fader?
    var reverb: CostelloReverb?
    
    // Player Chain on Music
    var audioPlayer: AudioPlayer?
    var lowpass: LowPassButterworthFilter?
    var amplitudeTap: AmplitudeTap!
    
    // Mixer
    var mixer = Mixer()
    
    // Controls
    @Published var isMusicPlaying = false
    
    
    // MARK: - Mode Controls
    
    func playButtonPressed() {
        isMusicPlaying ? stopMusic() : playMusic()
    }
    
    func setInput(to input: Node) {
        self.input = input
    }
    
    func activate() {
        if input == nil { return }
        micFader = Fader(input!, gain: micGain)
        reverb = CostelloReverb(micFader!)
        
        let audioFileUrl = Bundle.main.resourceURL?.appendingPathComponent("andata.mp3")
        let audioFile = try? AVAudioFile(forReading: audioFileUrl!)
        audioPlayer = AudioPlayer(file: audioFile!)
        lowpass = LowPassButterworthFilter(audioPlayer!, cutoffFrequency: 120)
        let silence = Fader(lowpass!, gain: 0)
        
        mixer.addInput(audioPlayer!)
        mixer.addInput(reverb!)
        mixer.addInput(silence)
        output = mixer
        
        amplitudeTap = AmplitudeTap(lowpass!,
                                    bufferSize: 1024,
                                    stereoMode: .center,
                                    analysisMode: .peak,
                                    handler: self.handler)
        
        setData()
        isActive = true
        
    }
    
    func playMusic() {
        audioPlayer?.play()
        isMusicPlaying = true
    }
    
    func stopMusic() {
        audioPlayer?.stop()
        isMusicPlaying = false
    }
    
    func handler(amplitude: Float) {
        
        /*
         .90 seems to be a baseline for kicks.
         
         we want to use this to ramp the micFader
         */
        
//        let currentMicGain = micGain
        
        

    }
    
    func startTap() {
        guard amplitudeTap != nil else {
            print("Amplitude Tap Not Setup")
            return
        }
        
        amplitudeTap.start()
    }
    
    func deactivate() {
        amplitudeTap.stop()
        lowpass = nil
        audioPlayer = nil
        
        isActive = false
    }
    
    private func setData() {
        reverb!.$feedback.ramp(to: effectParams.reverbFeedback, duration: effectParams.rampDuration)
        reverb!.$cutoffFrequency.ramp(to: effectParams.reverbLowpassCutoff, duration: effectParams.rampDuration)
//        reverb!.$balance.ramp(to: effectParams.reverbBalance, duration: effectParams.rampDuration)
    }
    

}


struct ReverbData {
    var rampDuration: AUValue = 0.02
    // Reverb
    var reverbFeedback: AUValue = 0.95
    var reverbLowpassCutoff: AUValue = 10_000.0
}
