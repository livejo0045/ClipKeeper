//
//  ContentView.swift
//  ClipKeeper
//
//  Created by Jonas Reveley on 07/03/2026.
//

import SwiftUI
import AppKit
import Combine

struct ClipItem: Identifiable {
    let id = UUID()
    let color: Color
    let content: String
    let timestamp: Date
}

struct ContentView: View {
    @State private var clips: [ClipItem] = []
    @State private var lastChangeCount: Int = NSPasteboard.general.changeCount

    let colors: [Color] = [.blue, .red, .green, .orange, .purple, .pink, .teal]
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    private func addClip(content: String) {
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

                            // Content
                            VStack(alignment: .leading, spacing: 4) {
                                Text(clip.content)
                                    .font(.system(size: 13))
                                    .lineLimit(2)
                                Text(clip.timestamp, style: .time)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            // Copy back button
                            Button {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(clip.content, forType: .string)
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
            if pb.changeCount != lastChangeCount {
                lastChangeCount = pb.changeCount
                if let copied = pb.string(forType: .string) {
                    addClip(content: copied)
                }
            }
        }
    }
}
