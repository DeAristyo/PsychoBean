//
//  ContentView.swift
//  JumpingBird
//
//  Created by Dimas Aristyo Rahadian on 24/05/23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @State private var isShowingGameView = false
    
    let scene = GameScene()
    
    var body: some View {
        NavigationView{
            ZStack{
                SpriteView(scene: scene).ignoresSafeArea()
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
