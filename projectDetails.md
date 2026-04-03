# Rafiq — Project Details

This document describes the **Rafiq** Flutter application: purpose, architecture, modules, dependencies, assets, and configuration. The package name on pub.dev is `rafiq` (see `pubspec.yaml`).

---

## 1. Overview

**Rafiq** is a cross-platform **educational / e-learning style** mobile app built with **Flutter**. It provides:

- Onboarding intros, authentication entry (sign in / sign up), and a main shell with tabbed navigation  
- Course discovery, categories, details, booking flow, and media (video)  
- User profile, favorites, and “my courses”  
- A **Gemini-powered chat assistant** with **local SQLite** persistence for sessions and messages  
- **Localization** (generated `AppLocalizations` + JSON language files) and **locale** handling via **Provider** and **SharedPreferences**  
- **Material Design 3** theming with a custom primary/secondary palette  

**Display names:** iOS bundle display name **Rafiq**; Android application ID **`systems.rafiq.app`**.

---

## 2. Technical Stack

| Area | Choice |
|------|--------|
| Framework | Flutter (Dart SDK `^3.5.3`) |
| UI | Material 3 (`ThemeData`, `NavigationBar`, `PageView`, etc.) |
| State / DI | **Provider** (`MultiProvider`, `ChangeNotifierProvider`, `context.watch` / `context.read`) |
| Local storage | **SharedPreferences** (cached API), **sqflite** (chat DB) |
| Phone input | **flutter_libphonenumber** (initialized at startup with `init()`) |
| Device locale | **devicelocale** (per-app language support detection + current locale) |
| AI chat | **flutter_gemini** (wraps Google Gemini; see also `google_generative_ai` in dependencies) |
| Images | **flutter_svg** + **vector_graphics** (`.svg.vec` assets) |
| Video | **video_player** (splash + course-related screens) |
| Validation | **email_validator** |
| OTP UI | **pin_code_fields** |
| i18n codegen | **flutter_localizations** + **intl** + `l10n.yaml` → generated files under `lib/l10n/` |
| Language names | **language_code** (native language names in the profile language picker) |
| Path utilities | **path** (join paths for SQLite file location) |
| Linting | **flutter_lints** (`analysis_options.yaml`) |

**Declared but lightly or indirectly used**

- **flutter_bloc**: imported in `profile_screen.dart` (e.g. for `context.read` patterns alongside Provider); no full BLoC/Cubit feature module is defined in the current tree.  
- **circle_nav_bar**: listed in `pubspec.yaml`; no direct usage found under `lib/` (candidate for removal if confirmed unused).  
- **google_generative_ai**: direct usage is via **flutter_gemini** in the chatbot screen; this package may be pulled for compatibility or future use.

---

## 3. Project Structure (`lib/`)

### 3.1 Entry & global configuration

| File | Role |
|------|------|
| `main.dart` | `main()`: `WidgetsFlutterBinding`, **SharedPreferencesWithCache**, `flutter_libphonenumber` `init()`, **Devicelocale** probes, builds `MultiProvider` + `ConfigProvider` + `RafiqApp`. Defines app **theme** (colors, inputs, filled buttons), **intro** pages, and **start screen** logic (session vs intro vs get started). |
| `config.dart` | `ConfigProvider` (**InheritedWidget**): exposes `SharedPreferencesWithCache` and map of **supported phone regions** to descendants. |
| `localization.dart` | `LocaleProvider` (**ChangeNotifier**): `SystemLocaleProvider` vs `AppLocaleProvider` (persists `locale` string in prefs). |

### 3.2 Screens (`lib/screens/`)

| Screen | Purpose |
|--------|---------|
| `splash.dart` | Full-screen **video** splash (`images/lodosplash.mp4`), then navigates to the next route from `main`. |
| `get_started.dart` | Welcome hub: sign up, sign in, “Continue with Google” (routes to login). |
| `sign_in.dart` | Email/password login form, forgot password link, navigation to home on action. |
| `sign_up.dart` | Registration UI with date picker and password fields. |
| `forget_password.dart` | Forgot password flow entry (SVG illustration). |
| `otp_verification.dart` | OTP entry (uses pin-style fields via project widgets). |
| `reset_password.dart` | Password reset UI. |
| `home_screen.dart` | Main shell: **PageView** (4 tabs) + **FAB** → **RafiqChatbotScreen**; bottom **NavigationBar** with notch. |
| `home_page.dart` | Home feed style UI (courses, favorites toggles, navigation to categories/details). |
| `academic_category.dart` | Academic level / category browsing. |
| `popular_courses.dart` | Popular courses listing. |
| `course_details.dart` | Course detail with **video_player** (network sample URL in code), imagery, links to booking/video. |
| `booking_screen.dart` | Multi-step **PageView** booking: payment method (**RadioGroup**), payment info, confirmation. |
| `video_screen.dart` | Dedicated video playback screen. |
| `my_courses.dart` | User’s enrolled or saved courses area. |
| `favorites_screen.dart` | Favorites list. |
| `profile_screen.dart` | Profile hub: avatar, edit profile, settings tiles, **language bottom sheet** (`AppLocalizations` + `LanguageCodes`), logout. |
| `my_profile.dart` | Profile detail view. |
| `edit_profile_screen.dart` | Edit profile form. |
| `notifications_screen.dart` | Notifications UI. |
| `messages_screen.dart` | Messages UI. |
| `chat_screen.dart` | Chat UI (non-Gemini flow). |
| `instructor_profile.dart` | Instructor profile presentation. |
| `interests_page.dart` | User interests selection. |
| `language_selection.dart` | Language list with **RadioGroup** for selection. |
| `rafiq_chatbot_screen.dart` | **Gemini** chat: **sqflite** tables `sessions` / `messages`, custom bubble UI, session history dialog. |

### 3.3 Widgets (`lib/widgets/`)

| Widget | Role |
|--------|------|
| `intro.dart` | Paged onboarding (**PageView**) driven by `IntroScreen` data from `main.dart`. |
| `password_field.dart` | Shared password field(s). |
| `phonenumber_field.dart` | Phone input using libphonenumber context. |
| `label_button.dart` | Text button styling helper. |
| `read_more_description.dart` | Expandable description text. |
| `resend_code_widget.dart` | OTP resend UI. |
| `interest.dart` | Interest chip / selection UI. |
| `video.dart` | Reusable video widget wrapper. |

### 3.4 Localization (`lib/l10n/`)

- **`l10n.yaml`**: `arb-dir: lib/l10n`, template `app_en.arb`, output `app_localizations.dart`.  
- **ARB files**: `app_en.arb`, `app_ar.arb` (e.g. `chooseLanguage` for the profile language label).  
- **Generated**: `app_localizations.dart`, `app_localizations_en.dart`, `app_localizations_ar.dart` — import in app code as `package:rafiq/l10n/app_localizations.dart`.  
- **JSON**: `assets/lang/ar.json`, `assets/lang/en.json` for additional string resources if loaded elsewhere.

`pubspec.yaml` sets `flutter: generate: true` so codegen runs with Flutter tooling.

---

## 4. User Flows & Persistence

### 4.1 App entry (`main.dart` → `SplashScreen`)

1. Splash plays **lodosplash.mp4**.  
2. `startScreen(context)` reads **`ConfigProvider`** prefs:  
   - If **`sessionToken`** is set → **`HomeScreen`**.  
   - Else if **`ignoreIntro`** is true → **`GetStarted`**.  
   - Else → **onboarding `Intro`** → **`GetStarted`**.

### 4.2 SharedPreferences keys (observed in code)

| Key | Usage |
|-----|--------|
| `sessionToken` | Treat user as logged in when present. |
| `ignoreIntro` | Skip intro carousel. |
| `locale` | Saved language code (`AppLocaleProvider`). |

### 4.3 Chat database (sqflite)

- File: `chat_database.db` under the app documents databases path (via `getDatabasesPath()` + **`path`** `join`).  
- Tables: **`sessions`** (id, name, createdAt), **`messages`** (id, userId, text, createdAt, sessionId, FK to sessions).  
- Used exclusively in **`rafiq_chatbot_screen.dart`**.

---

## 5. Dependencies (`pubspec.yaml` — direct)

**Runtime (`dependencies`)**

- `flutter` (SDK)  
- `flutter_localizations` (SDK)  
- `cupertino_icons`  
- `circle_nav_bar`  
- `devicelocale`  
- `email_validator`  
- `flutter_bloc`  
- `flutter_gemini`  
- `flutter_libphonenumber`  
- `flutter_svg`  
- `google_generative_ai`  
- `intl`  
- `language_code`  
- `path`  
- `pin_code_fields`  
- `provider`  
- `shared_preferences`  
- `sqflite`  
- `vector_graphics`  
- `video_player`  

**Development (`dev_dependencies`)**

- `flutter_test` (SDK)  
- `flutter_lints`  

**Version:** `1.0.0+1`  

---

## 6. Assets (summary)

Assets are declared under `flutter: assets:` in `pubspec.yaml`.

- **Vector (`.svg.vec`)**: intros, login illustrations, buttons (robot, notification, message), social logos, course “Completed” badge.  
- **Raster images**: course category thumbnails (kids, prep, primary, secondary, university, technology topics), UI/course hero images, **profile_picture.jpg**.  
- **Payment**: Instapay, Visa/Mastercard, wallet.  
- **Social**: LinkedIn, Instagram, Facebook, Behance icons.  
- **Video**: `images/lodosplash.mp4`.  
- **JSON**: `assets/lang/ar.json`, `assets/lang/en.json`.

---

## 7. Theming

Defined in `RafiqApp.theme()`:

- **ColorScheme.light** with primary **`#071952`**, secondary **`#088395`**.  
- **Material 3** enabled (`useMaterial3: true`).  
- Custom **InputDecorationTheme** (outlined rounded fields, focused border uses secondary).  
- **FilledButton** minimum width and rounded shape.

---

## 8. Security & Configuration Notes

- **Gemini API key**: The chatbot screen initializes **flutter_gemini** with an API key in source code. For production, move the key to **secure storage**, **build-time secrets**, or a **backend proxy**; rotate any key that was committed to a repository.  
- **Network**: Course detail sample uses a **network** `VideoPlayerController`; ensure **cleartext / HTTPS** rules on Android/iOS if you use HTTP URLs.  
- **Release signing**: Android `build.gradle` release build still uses **debug signing** (TODO in template comments).

---

## 9. Android / iOS specifics

- **Android**: `applicationId` / namespace **`systems.rafiq.app`**; `resConfigs "en", "ar"`.  
- **iOS**: Display name **Rafiq**; standard portrait + landscape orientations configured in `Info.plist`.

---

## 10. How to regenerate localization

From the project root:

```bash
flutter gen-l10n
```

Ensure `l10n.yaml` and ARB files stay in sync with `AppLocalizations` usage.

---

## 11. Analyzer / quality

The project uses **`package:flutter_lints/flutter.yaml`** via `analysis_options.yaml`. Run:

```bash
flutter analyze
```

---

*This file reflects the repository layout and dependencies as of the last update. Remove unused packages (e.g. `circle_nav_bar` if still unused) after verification.*
