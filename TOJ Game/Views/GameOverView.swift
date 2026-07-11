//
//  TOJ Game
//  GameOverView.swift
//
//  Created by Oliver Hartmann on 04.07.26.
//

import SwiftUI
import SpriteKit
import SwiftData
import AudioToolbox

struct GameOverView: View {
    
    @Query(sort: \Highscore.points, order: .reverse)
    
    private var highScore: [Highscore]
    
    //  @Environment(\.modelContext) var modelContext
    
    
    let score: Int
    let level: Int
    let isNewHighScore: Bool
    let restartAction: () -> Void
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let isLandscape = geometry.size.height < geometry.size.width
            
            ZStack {
                Color.darknight
                    .ignoresSafeArea()
                
                ScrollView {
                    
                    VStack(spacing: isLandscape ? 12 : 24) {
                        
                        // MARK: Game Over Header
                        
                        Text("GAME OVER")
                            .font (
                                isLandscape
                                ? .system(.title, weight: .thin)
                                : .system(.largeTitle, weight: .thin)
                            )
                        
                            .scaleEffect(1.5)
                            .tracking(5)
                            .foregroundColor(.warmwhite)
                            .textCase(.uppercase)
                        
                        HStack {
                            
                            VStack (spacing: 6) {
                                Text( "score:")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(.warmwhite.opacity(0.8))
                                
                                Text("\(score)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.warmwhite)
                            }
                            
                            // Spacer
                            
                            Rectangle()
                                .fill(.warmwhite.opacity(0.25))
                                .frame(width: 1, height: 50)
                            
                            VStack (spacing: 6) {
                                Text( "level:")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(.warmwhite.opacity(0.8))
                                
                                Text("\(level)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.warmwhite)
                            }
                        }
                        
                        .padding()
                        .textCase(.uppercase)
                        
                        
                        if isNewHighScore {
                            Text(GameText.higScore)
                                .font(.title2)
                                .fontWeight(.light)
                                .foregroundColor(.warmwhite)
                                .onAppear {
                                    
                                    AudioServicesPlaySystemSound(SystemSoundID(GameSound.highScore))
                                }
                            
                        } else {
                            
                            Text(GameText.fail)
                                .font(.title2)
                                .fontWeight(.light)
                                .foregroundColor(.warmwhite)
                                .onAppear {
                                    
                                    AudioServicesPlaySystemSound(SystemSoundID(GameSound.fail))
                                }
                            
                        }
                        
                        
                        // MARK: Highscore Card
                        
                        VStack(spacing: isLandscape ? 8: 16) {
                            
                            Text("TOP 5")
                                .textCase(.uppercase)
                                .font(
                                    isLandscape
                                    ? .system(.title2, weight: .bold)
                                    : .system(.title, weight: .black)
                                )
                            
                            
                                .foregroundColor(.black)
                            
                            // Header
                            
                            HStack {
                                
                                Text("#")
                                    .frame(width: 30, alignment: .leading)
                                
                                Text("Name")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                
                                Text("Score")
                                    .frame(width: 70, alignment: .trailing)
                                
                                
                                Text("Level")
                                    .frame(width: 50, alignment: .trailing)
                                
                            }
                            .font(.headline)
                            .foregroundColor(.lightnight)
                            
                            Divider()
                            
                            ForEach(
                                Array(highScore.prefix(5).enumerated()),
                                id: \.element
                                
                            ) { index, entry in
                                
                                VStack(spacing: 0) {
                                    HStack {
                                        
                                        Text("\(index + 1)")
                                            .font(.headline)
                                            .frame(
                                                width: 30,
                                                alignment: .leading
                                            )
                                        
                                        
                                        Text(entry.name)
                                            .frame(
                                                maxWidth: .infinity,
                                                alignment: .leading
                                            )
                                        
                                        
                                        Text("\(entry.points)")
                                            .frame(
                                                width: 70,
                                                alignment: .trailing
                                            )
                                        
                                        
                                        Text("\(entry.level)")
                                            .frame(
                                                width: 50,
                                                alignment: .trailing
                                            )
                                        
                                    }
                                    .font(.system(size: 18))
                                    .foregroundColor(.black)
                                    .padding(.vertical,  isLandscape ? 4 : 8)
                                    
                                    if index < 4 {
                                        Divider()
                                            .opacity(0.3)
                                    }
                                }
                            }
                        }
                        
                        .padding(24)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 24
                            )
                            .fill(.warmwhite)
                        )
                        .padding(.horizontal, 24)
                        
                        
                        //MARK: Restart Button
                        Button {
                            restartAction()
                            
                        } label:  {
                            
                            Text("Play Again")
                            
                                .textCase(.uppercase)
                                .font(.system(.title3, weight: .light))
                                .padding(.horizontal, 32)
                                .padding(.vertical, 18)
                                .background(
                                    Capsule()
                                        .fill(.darkcyan)
                                )
                                .foregroundColor(.warmwhite)
                        }
                        
                    }
                    .padding(.vertical, isLandscape ? 24 : 48)
                }
            }
        }
        
    }
}

//#Preview {
//    GameOverView(score: 331, level: 1, isHighScore: true)
// }
