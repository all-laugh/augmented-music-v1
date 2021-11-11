//
//  ContentView.swift
//  Modes V1
//
//  Created by Xiao Quan on 11/9/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        ModesCarouselView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.portrait)
    }
}
