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
    @Published var micGain: AUValue = 10.0 {
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
    var playheadTimer: Timer?
    @Published var playPercentage: Double = 0.0 {
        willSet {
            if let player = audioPlayer {
                currentPlayTimeText = formatTime(playPercentage * player.duration)
            }
        }
    }
    @Published var currentPlayTimeText: String = "00:00"
    @Published var trackDuration: String?
    
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
        reverb = CostelloReverb(input!)
        micFader = Fader(reverb!, gain: micGain)
        
        
        let audioFileUrl = Bundle.main.resourceURL?.appendingPathComponent("andata.mp3")
        let audioFile = try? AVAudioFile(forReading: audioFileUrl!)
        trackDuration = formatTime(audioFile?.duration ?? 0.0)
        audioPlayer = AudioPlayer(file: audioFile!)
        lowpass = LowPassButterworthFilter(audioPlayer!, cutoffFrequency: 120)
        let silence = Fader(lowpass!, gain: 0)
        
        mixer.addInput(audioPlayer!)
        mixer.addInput(micFader!)
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
        
        if let player = audioPlayer {
            player.play()
            isMusicPlaying = true
            startPlayheadUpdate()
        }
        
    }
    
    func stopMusic() {
        stopPlayheadUpdate()
        audioPlayer?.stop()
        isMusicPlaying = false
    }
    
    private func startPlayheadUpdate() {
        if let player = audioPlayer {
            playheadTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.playPercentage = player.getCurrentTime() / player.duration
                self.currentPlayTimeText = self.formatTime(player.getCurrentTime())
            }
        }
    }
    
    private func formatTime(_ time: Double) -> String {
        
        let time = Int(time)
        
        let minutes = time / 60
        let seconds = time % 60
        
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    private func stopPlayheadUpdate() {
        playheadTimer?.invalidate()
    }
    
    func updatePlayhead(_ isUpdating: Bool) {
        
        if let player = audioPlayer {
            let targetTime = player.duration * playPercentage
            player.seek(time: targetTime)
        }
        
        if isUpdating {
            stopPlayheadUpdate()
        } else {
            startPlayheadUpdate()
        }
    }
    
    
    var micGainDefault: Float = 12.0
    var lastAmplitude: Float = 0.0
    let threshold: Float = 0.2
    let conversionRatio: Float = 8 / 0.7
    let maxAttenuation: Float = 8
    
    func handler(amplitude: Float) {
        
        /*
         .90 seems to be a baseline for kicks.
         
         we want to use this to ramp the micFader
         */
        
        if !audioPlayer!.isPlaying { return }
        
        let conversionRatio: Float = maxAttenuation / (0.9 - threshold)
         
        if amplitude > threshold {
            
            if amplitude < lastAmplitude {
                micGain += 0.5
            } else {
                let gainReduction = (amplitude - threshold) * conversionRatio
                
                if gainReduction > 3.0 {
                    micGain -= 3.0
                } else {
                    micGain = micGainDefault - gainReduction
                }
            }
        } else {
            micGain = micGainDefault
        }
        
        lastAmplitude = amplitude
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
