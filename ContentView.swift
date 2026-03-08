//
//  ContentView.swift
//  ClipKeeper
//
//  Created by Jonas Reveley on 07/03/2026.
//

import SwiftUI
import AppKit
import Combine

struct Box: Identifiable, Equatable {
    let id = UUID()
    let color: Color
    let position: CGPoint
    let content: String // stores what was copied
}

struct ContentView: View {
    @State private var boxes: [Box] = []
    @State private var lastChangeCount: Int = NSPasteboard.general.changeCount
    
    let colors: [Color] = [.blue, .red, .green, .orange, .purple, .pink, .teal]
    
    // Timer that polls the clipboard every 0.5s
    let timer = Timer.publish(every: 0.5, on: .main, in: .common) .autoconnect()
    
    private func addBox(content: String) {
        let size = CGSize(width: 100, height: 100)
        // Use the main screen size as a simple placement area; clamp so boxes stay within view bounds.
        let screen = NSScreen.main?.frame.size ?? CGSize(width: 800, height: 600)
        let margin: CGFloat = 60
        let maxX = max(margin, screen.width - margin)
        let maxY = max(margin, screen.height - margin)
        let position = CGPoint(x: .random(in: margin...maxX), y: .random(in: margin...maxY))
        let color = colors.randomElement() ?? .blue
        withAnimation(.spring(response: 0.35, dampingfraction: 0.7)) {
            boxes.append(Box(color: color, position: position, content: content))
        }
        let newBox = Box(color: color, position: position, content: content)
        boxes.append(newBox)
    }
    
    var body: some View {
        ZStack {
            Color(.windowBackgroundColor).ignoresSafeArea()
            
            ForEach(boxes) { box in
                RoundedRectangle(cornerRadius: 12)
                    .fill(box.color.opacity(0.85))
                    .frame(width: 100, height: 100)
                    .overlay(
                        VStack {
                            Text(box.content)
                                .font(.system(size: 10))
                                .foregroundStyle(.white)
                                .lineLimit(4)
                                .padding(6)
                        }
                    )
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
                    Image(systemName: "doc.on.clipboard")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    Text("Copy anything to add a clip")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(minWidth: 500, minHeight: 400)
        // Poll clipboard every 0.5s
        .onReceive(timer) { _ in
            let pb = NSPasteboard.general
            if pb.changeCount != lastChangeCount {
                lastChangeCount = pb.changeCount
                if let copied = pb.string(forType: .string) {
                    addBox(content: copied)
                }
            }
        }
    }
}
