//
//  ModeDisplayData.swift
//  Modes V1
//
//  Created by Xiao Quan on 11/11/21.
//

import Foundation
import SwiftUI

struct ModeViewData: Identifiable, Hashable {
    var id: Int
    var name: ModeNames
    var image: String
}

var modeDisplays = [
    ModeViewData(id: 0, name: .clouds, image: "cloud"),
    ModeViewData(id: 1, name: .walk, image: "figure.walk")
]

enum ModeNames: String, CaseIterable {
    case clouds = "Up In The Clouds"
    case walk = "We Walk"
}

func makeView(for mode: ModeViewData, in frame: CGRect) -> some View {
    switch mode.name {
    case .walk:
        return GenericModeView(for: mode, in: frame)
        
    case .clouds:
        return GenericModeView(for: mode, in: frame)
    }
}
