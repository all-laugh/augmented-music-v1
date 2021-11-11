//
//  ContentView.swift
//  Modes V1
//
//  Created by Xiao Quan on 11/9/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ModesCarouselView()
    }
}


struct ModesCarouselView: View {
    
    @State var selectedIndex: Int = 0
    
    var body: some View {
        VStack {
            Text("MODES")
                .fontWeight(.bold)
                .font(.largeTitle)
            
            GeometryReader { geometry in
                let frame = geometry.frame(in: .global)
                
                TabView(selection: $selectedIndex) {
                    ForEach (PLACEHOLDER) { mode in
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
            
            PageControl(numPages: PLACEHOLDER.count, currentPage: getCurModeIndex())

        }
    }
    
    func getCurModeIndex()->Int {
        let index = PLACEHOLDER.firstIndex { mode in
            mode.id == selectedIndex
        } ?? 0
//        print(index)
        return index
    }
}


struct Mode: Identifiable, Hashable {
    var id: Int
    var name: String
    var image: String
}

var PLACEHOLDER = [
    Mode(id: 0, name: "Up In The Clouds", image: "cloud"),
    Mode(id: 1, name: "We Walk", image: "figure.walk")
]

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.portrait)
    }
}
