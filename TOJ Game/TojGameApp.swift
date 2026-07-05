//
//  TojGameApp.swift
//
//
//  Created by Oliver Hartmann on 25.06.26.
//

import SwiftUI
import SwiftData

@main
struct TojGame: App {
    
    var body: some Scene {
        WindowGroup {
            GamePlayView()
        }
                .modelContainer(for: Highscore.self)
       
    }
}
