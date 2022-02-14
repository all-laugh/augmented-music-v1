//
//  ModeCarouselView.swift
//  Modes V1
//
//  Created by Xiao Quan on 11/11/21.
//

import SwiftUI

struct ModesCarouselView: View {
    
    @EnvironmentObject var audioManager: AudioManager
    @State var inputDeviceIndex: String = ""
    @State var isRunning = false
    @State var selectedMode: ModeNames = .clouds
    
    var body: some View {
        VStack {
            Text(selectedMode.rawValue)
                .fontWeight(.bold)
                .font(.largeTitle)
            
            // Carousel Pannel
            GeometryReader { geometry in
                let frame = geometry.frame(in: .global)
                
                TabView(selection: $selectedMode) {
                    ForEach (modeDisplays) { mode in
                        makeView(for: mode, in: frame)
                        .tag(mode.name)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
            }
            .frame(height: UIScreen.main.bounds.height / 2.2)
            
            // Input Selection
            Picker("Input Device", selection: $inputDeviceIndex) {
                ForEach(0 ..< audioManager.inputDeviceList.count) {
                    Text(self.audioManager.inputDeviceList[$0]).tag("\($0)")
                }
            }
            .padding(.bottom)
            .foregroundColor(.black)

            // Start/Stop
//            Button(action: {
//                // TODO: - How do we start and stop the filter?
//                self.isRunning ? audioManager.stop() : audioManager.start()
//                self.isRunning.toggle()
//            }, label: {
//                Image(systemName: isRunning ? "stop.fill" : "play.fill" )
//                    .resizable()
//                    .frame(width: 100, height: 100)
//            })
        }
        .onChange(of: inputDeviceIndex) { _ in
            print("=========Carousel -> inputDevice index changed to: \(inputDeviceIndex)")
            let deviceIndex = Int(inputDeviceIndex)
            audioManager.switchInput(number: deviceIndex)
        }
        .onChange(of: selectedMode) { _ in
            print("=========Carousel -> selected mode changed to \(selectedMode.rawValue)")
            audioManager.setCurrentMode(to: selectedMode)
            print("Current mode set to \(audioManager.currentMode!.name)")
        }
        .onAppear {
            print("=========Carousel -> Carousel Apearred!")
            audioManager.setCurrentMode(to: selectedMode)
        }
    }
}
