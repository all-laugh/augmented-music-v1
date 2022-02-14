//
//  ModeDisplayData.swift
//  Modes V1
//
//  Created by Xiao Quan on 11/11/21.
//

import Foundation

struct ModeDisplayData: Identifiable, Hashable {
    var id: Int
    var name: ModeNames
    var image: String
}

var modeDisplays = [
    ModeDisplayData(id: 0, name: .clouds, image: "cloud"),
    ModeDisplayData(id: 1, name: .walk, image: "figure.walk")
]

enum ModeNames: String, CaseIterable {
    case clouds = "Up In The Clouds"
    case walk = "We Walk"
}
