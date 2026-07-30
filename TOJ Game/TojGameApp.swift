//
//  TojGameApp.swift
//
//
//  Created by Oliver Hartmann on 25.06.26.
//

import SwiftUI
import SwiftData

// declare startingpoint of the app

@main
struct TojGame: App {
    
    // main user interface for the app
    
    var body: some Scene {
        
        // in which the GameView() will be loaded
        
        WindowGroup {
            
            GameView()
        }
        
                // including data for highscore
        
                .modelContainer(for: Score.self)
       
    }
}
