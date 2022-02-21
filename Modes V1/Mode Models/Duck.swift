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

/*
 Test side chain compressor.
 
 The input comes from the music, after being lowpassed at 120Hz.
 
 This will be done via an amplitude tap on the lowpass filter node.
 
 Within the amplitude tap callback:
    - We need the the environmental sound to behave, such that, the higher the amplitude we get
    here, the lower the volume needs to be, with the reaction/fade time adjustable, for the time
    being.
    - This means that we'll need to know the range for both levels. How much does drums typically
    sound like after being lowpassed. And how much attenuation we need to have a good ducking effect?
 
    - Don't need to worry about the 'tail' time for now.
 
 Not sure if this will fuck up the threading. But,
 we can set a variable that keeps track of the current amplitude, put a didSet on it and update the
 volume coming out of the reverb attached to the mics. This should work.
 
 Once we activate the filter and started the engine in the audio manager,
 
 // TODO: - Add a completion closure to the function in AudioManager that starts the filter/engine.
 
 This gives us the option to start the tap after the engine is started.
    
 */

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
    
    // Effect Chain on Mic
    var reverb: CostelloReverb?
    
    // Player Chain on Music
    var audioPlayer: AudioPlayer?
    var lowpass: LowPassButterworthFilter?
    var amplitudeTap: AmplitudeTap!
    
    // Mixer
    var mixer = Mixer()
    
    // Controls
    @Published var isMusicPlaying = false
    
    func playButtonPressed() {
        isMusicPlaying ? stopMusic() : playMusic()
    }
    
    func setInput(to input: Node) {
        self.input = input
    }
    
    func activate() {
        if input == nil { return }
        reverb = CostelloReverb(self.input!)
        
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
        print(amplitude)
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
    
    
}
