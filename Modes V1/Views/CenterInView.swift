//
//  CenterInView.swift
//  Modes V1
//
//  Created by Xiao Quan on 2/21/22.
//

import SwiftUI

struct CenterInView: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            
            VStack {
                Spacer()
                
                content
                
                Spacer()
            }
            Spacer()
        }
    }
    
}


extension View {
    func centerInCurrentView() -> some View {
        modifier(CenterInView())
    }
}
