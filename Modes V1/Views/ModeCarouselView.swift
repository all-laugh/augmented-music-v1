//
//  ModeCarouselView.swift
//  Modes V1
//
//  Created by Xiao Quan on 11/11/21.
//

import SwiftUI

struct ModesCarouselView: View {
    
    @EnvironmentObject var audioManager: AudioManager
    @State var inputDevice: String = ""
    @State var isPlaying = false
    @State var selectedIndex: Int = 0
    
    var body: some View {
        VStack {
            Text("MODES")
                .fontWeight(.bold)
                .font(.largeTitle)
            
            // Carousel Pannel
            GeometryReader { geometry in
                let frame = geometry.frame(in: .global)
                
                TabView(selection: $selectedIndex) {
                    ForEach (modeDisplays) { mode in
                        VStack {
                            Image(systemName: mode.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: frame.width - 100,
                                        height: frame.height - 100,
                                        alignment: .center)
                                .padding(.bottom, 20)

                            Text(mode.name)
                                .font(.body)
                                .fontWeight(.bold)
                        }
                        .tag(mode.id)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
            }
                .frame(height: UIScreen.main.bounds.height / 2.2)
            
            // Page Control
            PageControl(numPages: modeDisplays.count, currentPage: getCurModeIndex())
                .padding(.bottom, 20)
            
            // Input Selection
            Picker("Input Device", selection: $inputDevice) {
                ForEach(0 ..< audioManager.inputDeviceList.count) {
                    Text(self.audioManager.inputDeviceList[$0]).tag("\($0)")
                }
            }
            .padding(.bottom)
            .foregroundColor(.black)

            Button(action: {
                // TODO: - How do we start and stop the filter?
                self.isPlaying ? audioManager.stop() : audioManager.start()
                
                self.isPlaying.toggle()
            }, label: {
                Image(systemName: isPlaying ? "stop.fill" : "play.fill" )
            })
            .keyboardShortcut(.space, modifiers: [])

        }
        .onChange(of: inputDevice) { _ in
            print("inputDevice Changed")
            let index = Int(inputDevice)
            audioManager.switchInput(number: index)
        }
        .onChange(of: selectedIndex) { _ in
            print("selected Index changed to \(selectedIndex)")

            audioManager.engine.stop()
            print("Engine stopped")
//
//            for node in audioManager.engine.mainMixerNode!.connections {
//                audioManager.engine.avEngine.detach(node.avAudioNode)
//            }
//
//            audioManager.engine.avEngine.detach(audioManager.engine.output!.avAudioNode)
//            print("detached current engine output from engine")
//
//            audioManager.engine.mainMixerNode?.removeAllInputs()
//            print("removed all inputs from engine main mixer node")
//
//            audioManager.currentMode!.input = nil
//            print("current mode input cleared")
//            audioManager.currentMode = nil
//            print("Current Mode set to nil")
//            audioManager.mic = nil
//            print("Set mic to nil")
//
//            audioManager.engine.output = nil
            
            audioManager.setCurrentMode(index: selectedIndex)
            print("Current mode set to \(audioManager.currentMode!.name)")
            audioManager.engine.rebuildGraph()
            print("Rebuilt engine audio graph")
        }
        .onAppear {
            print("Carousel Apearred!")
            audioManager.setCurrentMode(index: selectedIndex)
        }
    }
        
    
    private func getCurModeIndex()->Int {
        let index = modeDisplays.firstIndex { mode in
            mode.id == selectedIndex
        } ?? 0
//        print(index)
        
        return index
    }
}
