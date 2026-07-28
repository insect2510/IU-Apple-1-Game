//
//  TOJ Game
//  GameStartView.swift
//
//  Created by Oliver Hartmann on 05.07.26.
//

import SwiftUI
import SpriteKit


struct GameStartView: View {
    
    // let score: Int
    let restartAction: () -> Void
    
    // game is not running
    // var isGaming: Bool = false
    
    
    // MARK: game start view
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let isLandscape = geometry.size.height < geometry.size.width
            
            
            ZStack {
                
                VStack(spacing: isLandscape ? 12 : 32) {
                    
                    // Display game name
                    
                    let titleSCale = isLandscape ? 1 : 1.5
                    
                    Text("TOJ")
                        .font(.system(.largeTitle, weight: .black))
                        .foregroundColor(Colors.primarycolor)
                        .scaleEffect(titleSCale)
                    
                    Text("Touch the object")
                        .font(.system(isLandscape ? .title3 : .title, weight: .medium))
                        .foregroundColor(Colors.primarycolor)
                        .textCase(.uppercase)
                    
                    // legend
                    
                    HStack
                    {
                        VStack (spacing: isLandscape ? 8 : 16)
                        {
                            HStack (spacing: 8) {
                                Circle()
                                    .fill(Color(GamingObject.Coin.fillcolor))
                                    .frame(width: isLandscape ? 16 : 24,
                                           height: isLandscape ? 16 : 24)
                                    .frame(width: 95,  alignment: .center)
                                
                                Text("+1 Point")
                                    .font(.system(isLandscape ? .caption2 : .title3, weight: .medium))
                                    .foregroundColor(Colors.primarycolor)
                                    .frame(width:95, alignment: .leading)
                            }
                            
                            HStack (spacing: 8) {
                                Rectangle()
                                    .fill(Color(GamingObject.Diamond.fillcolor))
                                    .frame(width: isLandscape ? 12 : 18,
                                           height: isLandscape ? 12 : 18)
                                    .rotationEffect(Angle(degrees: 45))
                                    .frame(width: 95,  alignment: .center)
                                  
                                
                                Text("+10 Points")
                                    .font(.system(isLandscape ? .caption2 : .title3, weight: .medium))
                                    .foregroundColor(Colors.primarycolor)
                                    .frame(width:95, alignment: .leading)
                            }
                            
                            HStack (spacing: 8) {
                                Image(systemName: "star.fill")
                                    .font(.system(isLandscape ? .caption2 : .title3, weight: .medium))
                                    .foregroundColor(Colors.primarycolor)
                                    .frame(width: 95,  alignment: .center)
                                
                                Text("Score")
                                    .font(.system(isLandscape ? .caption2 : .title3, weight: .medium))
                                    .foregroundColor(Colors.primarycolor)
                                    .frame(width:95, alignment: .leading)
                            }
                            
                            HStack(spacing: 8) {
                                
                                Image(systemName: "heart.fill")
                                    .font(.system(isLandscape ? .caption2 : .title3, weight: .medium))
                                    .foregroundColor(Colors.primarycolor)
                                    .frame(width: 95,  alignment: .center)
                                
                                Text("Lives")
                                    .font(.system(isLandscape ? .caption2 : .title3, weight: .medium))
                                    .foregroundColor(Colors.primarycolor)
                                    .frame(width:95, alignment: .leading)
                            }
                            
                            HStack (spacing: 8) {
                                
                                Image(systemName:  "bolt.fill")
                                    .font(.system(isLandscape ? .caption2 : .title3, weight: .medium))
                                    .foregroundColor(Colors.primarycolor)
                                    .frame(width: 95,  alignment: .center)
                                
                                Text("Level")
                                    .font(.system(isLandscape ? .caption2 : .title3, weight: .medium))
                                    .foregroundColor(Colors.primarycolor)
                                    .frame(width:95, alignment: .leading)
                            }
                            
                            HStack (spacing: 8) {
                                
                                
                                Text("01:00")
                                    .font(.system(isLandscape ? .caption2 : .title3, weight: .medium))
                                    .foregroundColor(Colors.primarycolor)
                                    .frame(width: 95,  alignment: .center)
                                
                                
                                Text("Time")
                                    .font(.system(isLandscape ? .caption2 : .title3, weight: .medium))
                                    .foregroundColor(Colors.primarycolor)
                                    .frame(width:95, alignment: .leading)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    // show start button
                    
                    Button {
                        restartAction()
                        
                    } label:  {
                        
                        Text("Start Game")
                            .textCase(.uppercase)
                            .font(.system(.title3, weight: .light))
                            .padding(.horizontal,  isLandscape ? 24 : 32)
                            .padding(.vertical,  isLandscape ? 8 : 18)
                            .background(
                                Capsule()
                                    .fill(.limegreen)
                            )
                            .foregroundColor(Colors.backgroundcolor)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        
    }
    
}
#Preview {
    GameStartView(
        restartAction: {}
    )
}
