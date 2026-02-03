# Bolt Flutter Builder

This Flutter app is a UI prototype for a real-time builder that can orchestrate Expo/React projects with a live preview, bring-your-own API configuration, E2B preview sessions, and an embedded terminal. The current implementation focuses on layout, state handling, and interaction hooks so it can be wired to real services later.

## Getting Started

```bash
flutter pub get
flutter run
```

## Feature Highlights

- Framework selection (Expo or React)
- Bring-your-own API configuration panel
- E2B session toggle and preview placeholders
- Terminal panel with command input
- Activity log to reflect build steps and AI actions

## Next Steps

- Wire terminal input to an actual shell or E2B workspace
- Connect preview area to an iframe/webview
- Integrate AI pipeline for code generation + file streaming
