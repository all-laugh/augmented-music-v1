//
//  ModeCarouselView.swift
//  Modes V1
//
//  Created by Xiao Quan on 11/11/21.
//

import SwiftUI

struct ModesCarouselView: View {
    
    @EnvironmentObject var audioManager: AudioManager
    @State var currentInput = AudioManager.sharedInstance.engine.inputDevice?.name ?? ""
    @State var isRunning = false
//    @State var selectedMode: ModeNames = .clouds
    @State var currentModeDisplayData: ModeViewData = modeDisplayData[0]
    
    var body: some View {
        HStack {
            List {
                Section(
                    header: Text("Audio Modes")
                        .font(.headline)
                        .bold()
                        .padding()
                ) {
                    ForEach(modeDisplayData) { data in
                        Button {
                            currentModeDisplayData = data
                        } label: {
                            Text(data.name.rawValue)
                        }
                    }
                }
                
                Section(header: Text("Input Selection")) {
                    
                    Menu(currentInput) {
                        ForEach(0 ..< audioManager.inputDeviceList.count) { deviceIndex in
                            Button {
                                audioManager.setInput(to: deviceIndex)
                                currentInput = audioManager.inputDeviceList[deviceIndex]
                            } label: {
                                Text(self.audioManager.inputDeviceList[deviceIndex])
                            }
                        }
                    }
                }
                
                Section(header: Text("Mic Volume: ")
                            .foregroundColor(.gray)) {
                    Slider(value: $audioManager.micGain, in: 0...20)
                        .padding()
                }
            }
            .frame(width: UIScreen.main.bounds.width / 4)
            
            GeometryReader { geometry in
                
                makeView(using: currentModeDisplayData, in: geometry.frame(in: .local) )
                    .centerInCurrentView()
                    
            }
        }
        .foregroundColor(.primary)
    }
    
    private func makeView(using modeData: ModeViewData, in frame: CGRect) -> some View {
        print(#function)
        print("📬 makeView for \(modeData.name)")
        let am = AudioManager.sharedInstance
        switch modeData.name {
        case .walk:
            am.setCurrentMode(to: .walk)
            return AnyView(GenericModeView(using: modeData, in: frame))
            
        case .clouds:
            am.setCurrentMode(to: .clouds)
            return AnyView(GenericModeView(using: modeData, in: frame))
            
        case .pitchCross:
            am.setCurrentMode(to: .pitchCross)
            return AnyView(GenericModeView(using: modeData, in: frame))
        
        case .duck:
            am.setCurrentMode(to: .duck) {
                let duckModel = am.currentMode as! Duck
                duckModel.startTap()
                print("Tap started")
            }
            return AnyView(DuckView(using: modeData, in: frame, model: am.currentMode)) 
        }
    }
}
