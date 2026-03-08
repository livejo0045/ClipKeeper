# ClipKeeper 📋

A lightweight, open-source macOS clipboard manager built with SwiftUI. Every time you copy something, ClipKeeper saves it — so you never lose a clip again.
---

## Features

- 🔍 **Automatic capture** — detects anything you copy, system-wide
- 🕐 **Timestamped history** — see exactly when each clip was copied
- 🎨 **Colour-coded clips** — each entry gets a unique colour tag at a glance
- 📋 **One-click re-copy** — tap the copy icon on any row to paste it back
- 🧹 **Clear All** — wipe your clipboard history in one tap

---

## Screenshots

> _Coming soon_

---

## Requirements

- macOS 13 (Ventura) or later
- Xcode 15 or later (to build from source)

---

## Installation

### Option A — Download (easiest)

1. Go to the [Releases](../../releases) page
2. Download the latest `ClipKeeper.zip`
3. Unzip and drag `ClipKeeper.app` to your **Applications** folder
4. Right-click → **Open** the first time (macOS will warn about an unidentified developer — this is normal for unsigned open source apps)

### Option B — Build from source

```bash
git clone https://github.com/YOURNAME/ClipKeeper.git
cd ClipKeeper
open ClipKeeper.xcodeproj
```

Then press **⌘R** in Xcode to build and run.

---

## How It Works

ClipKeeper runs a lightweight timer that polls `NSPasteboard` every 0.5 seconds. When it detects a change, it captures the copied text and adds it to the top of your list. No background daemons, no login items — just run the app and it watches while it's open.

---

## Contributing

Contributions are welcome! To get started:

1. Fork the repo
2. Create a branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m "Add your feature"`
4. Push: `git push origin feature/your-feature`
5. Open a Pull Request

Please open an issue first for major changes so we can discuss the approach.

---

## Roadmap
- [ ] Search/filter clips
- [ ] Menu bar icon with quick access popover
- [ ] Image clip support
- [ ] Pin important clips to the top
- [ ] Keyboard shortcut to open/focus the window
- [ ] 
---

## Author

Made by [Jonas Reveley](https://github.com/livejo0045) + With with Claude Ai for helping with debuging
