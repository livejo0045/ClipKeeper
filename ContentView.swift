//
//  ContentView.swift
//  ClipKeeper
//
//  Created by Jonas Reveley on 07/03/2026.
//

import SwiftUI

struct Box: Identifiable, Equatable {
    let id = UUID()
    let color: Color
    let position: CGPoint
}

struct ContentView: View {
    @State private var boxes: [Box] = []
    
    let colors: [Color] = [.blue, .red, .green, .orange, .purple, .pink, .teal]
    
    private func addBox() {
        let size = CGSize(width: 100, height: 100)
        // Use the main screen size as a simple placement area; clamp so boxes stay within view bounds.
        let screen = NSScreen.main?.frame.size ?? CGSize(width: 800, height: 600)
        let margin: CGFloat = 60
        let maxX = max(margin, screen.width - margin)
        let maxY = max(margin, screen.height - margin)
        let position = CGPoint(x: .random(in: margin...maxX), y: .random(in: margin...maxY))
        let color = colors.randomElement() ?? .blue
        let newBox = Box(color: color, position: position)
        boxes.append(newBox)
    }
    
    var body: some View {
        ZStack {
            Color(.windowBackgroundColor)
                .ignoresSafeArea()
            
            ForEach(boxes) { box in
                RoundedRectangle(cornerRadius: 12)
                    .fill(box.color.opacity(0.85))
                    .frame(width: 100, height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 1.5)
                    )
                    .shadow(color: box.color.opacity(0.4), radius: 8, x: 0, y: 4)
                    .position(box.position)
                    .transition(.scale(scale: 0.5).combined(with: .opacity))
            }
            
            if boxes.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "square.dashed")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    Text("Press ⌘C to add a box")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(minWidth: 500, minHeight: 400)
        .animation(.spring(response: 0.35, dampingFraction: 0.7, blendDuration: 0.2), value: boxes) // ← ⌘c triggers this
        // Attach the action via a hidden button trick below
        .background(
            Button("\u{2318}") { addBox() }
                .keyboardShortcut("C", modifiers: [.command])
                .opacity(0) // hidden button trick
            
        )
    }
}
