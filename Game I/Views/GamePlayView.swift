//
//  ContentView.swift
//  Gametest
//
//  Created by Oliver Hartmann on 25.06.26.
//

import SwiftUI
import SpriteKit

struct GamePlayView: View {

    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 300, height: 533)
        scene.scaleMode = .aspectFit
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}

#Preview {
    GamePlayView()
}
