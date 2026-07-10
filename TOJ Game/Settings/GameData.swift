//
//  GameData.swift
//  IU Apple I Game
//
//  Created by Oliver Hartmann on 05.07.26.
//

import SwiftUI
import Combine

class GameData: ObservableObject {
    
    @Published var score = 0
    @Published var lives = 3
    @Published var timeRemaining = 60
    @Published var level = 1
}
