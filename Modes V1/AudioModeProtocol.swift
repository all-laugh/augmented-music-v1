//
//  AudioModeProtocol.swift
//  Modes V1
//
//  Created by Xiao Quan on 11/10/21.
//

import Foundation
import AudioKit

protocol AudioMode {
    var name: String { get }
    var input: Node? { get set }
    var output: Node? { get set }
    var bypass: Bool { get set }
    var isActive: Bool { get set }
    
    func setInput(to input: Node)
    func activate()
    func deactivate()
}
