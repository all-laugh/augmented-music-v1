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
            
            PageControl(numPages: modeDisplays.count, currentPage: getCurModeIndex())
                .padding(.bottom, 20)
            
            Picker("Input Device", selection: $inputDevice) {
                ForEach(0 ..< audioManager.inputDeviceList.count) {
                    Text(self.audioManager.inputDeviceList[$0]).tag("\($0)")
                }
            }
            .padding(.bottom)
            Button(action: {
                self.audioManager.setCurrentMode(index: selectedIndex)
                self.isPlaying ? self.audioManager.stop() : self.audioManager.start()
                self.isPlaying.toggle()

            }, label: {
                Image(systemName: isPlaying ? "stop.fill" : "play.fill" )
            })
            .keyboardShortcut(.space, modifiers: [])

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
