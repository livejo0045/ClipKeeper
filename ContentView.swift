//
//  ContentView.swift
//  ClipKeeper
//
//  Created by Jonas Reveley on 07/03/2026.
//

import SwiftUI
import AppKit
import Combine

enum ClipContent {
    case text(String)
    case image(NSImage)
}

struct ClipItem: Identifiable {
    let id = UUID()
    var color: Color
    var content: ClipContent
    let timestamp: Date
    
    // Convenience for display
    var isImage: Bool {
        if case .image = content { return true}
        return false
    }
    
    var textPreview: String {
        if case .text(let str) = content { return str }
        return "Image"
    }
}

struct ContentView: View {
    @State private var clips: [ClipItem] = []
    @State private var lastChangeCount: Int = NSPasteboard.general.changeCount

    let colors: [Color] = [.blue, .red, .green, .orange, .purple, .pink, .teal]
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    private func addClip(content: ClipContent) {
        let color = colors.randomElement() ?? .blue
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            clips.insert(ClipItem(color: color, content: content, timestamp: Date()), at: 0)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "doc.on.clipboard.fill")
                    .foregroundStyle(.secondary)
                Text("ClipKeeper")
                    .font(.headline)
                Spacer()
                if !clips.isEmpty {
                    Button(role: .destructive) {
                        withAnimation {
                            clips.removeAll()
                        }
                    } label: {
                        Text("Clear All")
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.red.opacity(0.8))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.bar)

            Divider()

            // List or empty state
            if clips.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "doc.on.clipboard")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    Text("Copy anything to add a clip")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            } else {
                List {
                    ForEach(clips) { clip in
                        HStack(spacing: 12) {
                            // Colour tag
                            RoundedRectangle(cornerRadius: 4)
                                .fill(clip.color)
                                .frame(width: 6)
                                .frame(maxHeight: .infinity)

                            // Content text or image
                            VStack(alignment: .leading, spacing: 4) {
                                Group {
                                    switch clip.content {
                                    case .text(let str):
                                        Text(str)
                                            .font(.system(size: 13))
                                            .lineLimit(2)
                                    case .image(let nsImage):
                                        Image(nsImage: nsImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxHeight: 60)
                                            .cornerRadius(6)
                                    }
                                }

                                HStack(spacing: 6) {
                                    Image(systemName: clip.isImage ? "photo" : "text.alignleft")
                                        .foregroundStyle(.secondary)
                                    Text(clip.timestamp, style: .time)
                                }
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            }

                            Spacer()

                            // Copy back button
                            Button {
                                NSPasteboard.general.clearContents()
                                switch clip.content {
                                case .text(let str):
                                    NSPasteboard.general.setString(str, forType: .string)
                                case .image(let img):
                                    NSPasteboard.general.writeObjects([img])
                                }
                            } label: {
                                Image(systemName: "doc.on.doc")
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                            .help("Copy to clipboard")
                        }
                        .padding(.vertical, 6)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                withAnimation {
                                    clips.removeAll { $0.id == clip.id }
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.inset)
            }
        }
        .frame(minWidth: 400, minHeight: 300)
        .onReceive(timer) { _ in
            let pb = NSPasteboard.general
            guard pb.changeCount != lastChangeCount else { return }
            lastChangeCount = pb.changeCount
            
            // Check for image first, then text
            if let image = NSImage(pasteboard: pb) {
                addClip(content: .image(image))
            } else if let text = pb.string(forType: .string) {
                addClip(content: .text(text))
            }
            
            if pb.changeCount != lastChangeCount {
                lastChangeCount = pb.changeCount
                if let copied = pb.string(forType: .string) {
                    addClip(content: .text(copied))
                }
            }
        }
    }
}

