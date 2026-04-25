# hellocodex

`hellocodex` is a small SwiftUI iOS app created during our first Codex collaboration. It started as an empty local folder and became a runnable Xcode project with a tab-based interface and an animated mathematical visualization.

## What It Does

The app currently has three tabs:

- **Home**: the original welcome screen, showing `Hello, Codex`.
- **Math**: a black-background animated math scene built with SwiftUI `Canvas` and `TimelineView`, featuring colorful particles, butterfly-like parametric curves, coordinate axes, and formula text.
- **Mine**: a simple personal placeholder page.

## Tech Stack

- SwiftUI
- Xcode 26.4.1
- iOS Simulator target
- `Canvas` for custom drawing
- `TimelineView(.animation)` for continuous animation

## First Collaboration

This project records our first hands-on collaboration:

1. We named the project `hellocodex`.
2. We renamed the local project folder from `New project` to `hellocodex`.
3. We created a new iOS SwiftUI Xcode project from scratch.
4. We ran it successfully on an iPhone simulator.
5. We changed the app structure to use tabs.
6. We added `Home` and `Mine` pages.
7. We added a `Math` tab inspired by a reference image.
8. We replaced the static reference image with a real animated function visualization.
9. We removed unnecessary playback controls and kept the animation focused.
10. We uploaded the project to GitHub and added a conversation log.

## Running The App

Open the project in Xcode:

```sh
open hellocodex.xcodeproj
```

Then choose an iOS simulator and run the `hellocodex` scheme.

You can also build from the command line:

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -project hellocodex.xcodeproj   -scheme hellocodex   -configuration Debug   -destination 'generic/platform=iOS Simulator'   build
```

## Notes

`CONVERSATION.md` contains a summary of the project conversation and the decisions made while building it.
