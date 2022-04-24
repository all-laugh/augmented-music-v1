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

enum ModeNames: String, CaseIterable {
    case clouds = "Up In The Clouds"
//    case walk = "We Walk"
    case pitchCross = "Pitch Cross"
    case duck = "Duck"
}

var modeDisplayData = [
    ModeViewData(id: 0, name: .clouds, image: "cloud"),
//    ModeViewData(id: 1, name: .walk, image: "figure.walk"),
    ModeViewData(id: 2, name: .pitchCross, image: "arrow.up.arrow.down"),
    ModeViewData(id: 3, name: .duck, image: "rectangle.compress.vertical")
]

