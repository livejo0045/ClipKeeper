//
//  ContentView.swift
//  ClipKeeper
//
//  Created by Jonas Reveley on 07/03/2026.
//

import SwiftUI

struct Box: Identifiable {
    let id = UUID()
    let color: Color
    let position: CGPoint
}

struct ContentView: View {
    @State private var boxes: [Box] = []
    
    let colors: [Color] = [.blue, .red, .green, .orange, .purple, .pink, .teal]
    
    var body: some View {
        ZStack {
            Color(.windowBackgroundColor)
                .ignoresSafeArea()
            
            ForEach(boxes) { box in
                RoundedRectangle(cornerRadius: 12)
                    .fill(box .color .opacity(0.85))
                    .frame(width: 100, height:  100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(.white.opacity(0.3), lineWidth: 1.5)
            }
        }
    }
}
