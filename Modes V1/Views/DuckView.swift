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
                .frame(width: frame.width - 100,
                        height: frame.height - 100,
                        alignment: .center)
                .padding(.bottom, 20)

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
            
            Text("When music is playing, your environment will \"duck\" to the beats")
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
