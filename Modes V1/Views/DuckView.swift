//
//  DuckView.swift
//  Modes V1
//
//  Created by Xiao Quan on 2/20/22.
//

import SwiftUI

struct DuckView: View {
    var modeViewData: ModeViewData
    let frame: CGRect
    @ObservedObject var duckModel: Duck
    @State var musicProgressWidth : CGFloat = 0
    
    init (using modeViewData: ModeViewData, in frame: CGRect = UIScreen.main.bounds, model: AudioMode? = nil) {
        self.modeViewData = modeViewData
        self.frame = frame
        self.duckModel = model! as! Duck
    }
    
    var body: some View {
        VStack {
            Image(systemName: modeViewData.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: frame.width / 3,
                        height: frame.height / 3,
                        alignment: .center)
                .padding(20)

            Text(modeViewData.name.rawValue)
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Button {
                duckModel.playButtonPressed()
            } label: {
                Image(systemName: duckModel.isMusicPlaying ? "stop.circle" : "play.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            .padding()
            
            Text("When music is playing, your environment will \"duck\" to the beats")
                .foregroundColor(.gray)
                .padding()
            
            HStack {
                Text("Mic Volume: ")
                    .foregroundColor(.gray)
                Slider(value: duckModel.isMusicPlaying ? $duckModel.defaultGainWhenActive : $duckModel.micGain, in: 0...2.0)
                    .padding()
            }
            
            HStack {
                Text(duckModel.currentPlayTimeText)
                    
                Slider(value: $duckModel.playPercentage, in: 0.0...1.0) { isUpdating in
                    duckModel.updatePlayhead(isUpdating)
                }
                .padding()
                
                Text(duckModel.trackDuration ?? "")
            }
            .foregroundColor(.gray)
        }
    }
}

struct DuckView_Previews: PreviewProvider {
    static var previews: some View {
        DuckView(using: .init(id: 0,
                              name: .duck,
                              image: "rectangle.compress.vertical"))
    }
        
}
