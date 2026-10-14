# Smart Kids Learning

A cheerful, offline-first Android educational app for young children, built
with Flutter and Material 3.

## Features

- Home screen with entry points: Learn, Quiz, Progress, Settings
- Learn: lesson list (alphabet, numbers, colors, shapes)
- Quiz: interactive multiple-choice quiz with score persistence
- Progress: per-lesson progress stored locally
- Settings: language (English / Bengali) and theme (light / dark / system)
- Fully offline

## Tech

- Flutter + Dart (null-safe)
- Material 3
- Provider for state management
- SharedPreferences for persistence
- Flutter gen-l10n for localization (en, bn)

## Build

APK is built automatically via GitHub Actions on every push to main.
Download the artifact from the Actions tab.