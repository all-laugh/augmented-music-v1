//
//  ModeDisplayData.swift
//  Modes V1
//
//  Created by Xiao Quan on 11/11/21.
//

import Foundation

struct ModeDisplayData: Identifiable, Hashable {
    var id: Int
    var name: String
    var image: String
}

var modeDisplays = [
    ModeDisplayData(id: 0, name: "Up In The Clouds", image: "cloud"),
    ModeDisplayData(id: 1, name: "We Walk", image: "figure.walk")
]

