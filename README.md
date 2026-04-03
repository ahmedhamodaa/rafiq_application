# Rafiq

**Rafiq** is a Flutter application for browsing courses, managing favorites and profile, booking, and chatting with a **Google Gemini**–powered assistant. The app uses **Material Design 3**, **Provider** for locale state, **SharedPreferences** for session and preferences, and **SQLite** for chat history.

---

## Requirements

- [Flutter](https://docs.flutter.dev/get-started/install) (stable channel recommended)  
- Dart SDK **^3.5.3** (as specified in `pubspec.yaml`)  
- Xcode (for iOS) / Android Studio or SDK (for Android)

---

## Getting started

Clone the repository and install dependencies:

```bash
cd rafiq_application
flutter pub get
```

Generate localizations (if needed):

```bash
flutter gen-l10n
```

Run the app:

```bash
flutter run
```

Run static analysis:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

---

## Project documentation

For a full breakdown of screens, widgets, packages, assets, data flow, and configuration, see **[projectDetails.md](./projectDetails.md)**.

---

## Configuration

- **Gemini**: The chat feature uses **flutter_gemini**. Configure your API key securely for production (avoid committing secrets). See the notes in `projectDetails.md`.  
- **Android**: Application ID **`systems.rafiq.app`**.  
- **iOS**: Display name **Rafiq**.

---

## Tech stack (short)

| Topic | Technology |
|--------|------------|
| UI | Flutter, Material 3 |
| State | Provider |
| Preferences | shared_preferences |
| Chat DB | sqflite |
| AI | flutter_gemini |
| Phone | flutter_libphonenumber |
| i18n | flutter_localizations, intl, generated `AppLocalizations` |
| Media | video_player, flutter_svg, vector_graphics |

---

## License

Private project (`publish_to: 'none'` in `pubspec.yaml`). Add a license file if you plan to distribute the source.
