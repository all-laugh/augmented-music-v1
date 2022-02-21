//
//  GenericModeView.swift
//  Modes V1
//
//  Created by Xiao Quan on 2/13/22.
//

import SwiftUI

struct GenericModeView: View {
    
    var modeViewData: ModeViewData
    let frame: CGRect
    
    init (using modeViewData: ModeViewData, in frame: CGRect = UIScreen.main.bounds) {
        self.modeViewData = modeViewData
        self.frame = frame
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
        }
    }
}

struct GenericModeView_Previews: PreviewProvider {
    static var previews: some View {
        GenericModeView(using: .init(id: 0,
                                   name: .clouds,
                                   image: "cloud"))
    }
}
