import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rafiq/screens/home_screen.dart';
import 'package:rafiq/screens/get_started.dart';
import 'package:rafiq/widgets/intro.dart';
import 'package:rafiq/screens/splash.dart';
import 'package:rafiq/localization.dart';
import 'package:rafiq/config.dart';

extension Let<T> on T? {
  R? let<R>(R Function(T) fn) => this == null ? null : fn(this as T);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferencesWithCache prefs =
      await SharedPreferencesWithCache.create(
          cacheOptions: const SharedPreferencesWithCacheOptions());

  await init();
  Map<String, CountryWithPhoneCode> supportedRegions =
      await getAllSupportedRegions();

  bool languagePerApp = await Devicelocale.isLanguagePerAppSettingSupported;
  Locale? currentLocale = await Devicelocale.currentAsLocale;

  LocaleProvider? localeProvider(BuildContext context) {
    if (languagePerApp) {
      return SystemLocaleProvider();
    } else {
      return AppLocaleProvider(
          prefs.getString('locale').let(Locale.new) ?? currentLocale, prefs);
    }
  }

  var app = MultiProvider(
      providers: [ChangeNotifierProvider(create: localeProvider)],
      child: ConfigProvider(
          prefs: prefs,
          supportedRegions: supportedRegions,
          child: const RafiqApp()));
  runApp(app);
}

class RafiqApp extends StatelessWidget {
  const RafiqApp({super.key});

  ThemeData theme() {
    ColorScheme colorScheme = const ColorScheme.light(
        primary: Color(0xff071952),
        onPrimary: Colors.white,
        secondary: Color(0xff088395));

    InputDecorationTheme decorationTheme = InputDecorationTheme(
        floatingLabelStyle: TextStyle(color: colorScheme.secondary),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: colorScheme.secondary)));

    ThemeData theme = ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        inputDecorationTheme: decorationTheme,
        textSelectionTheme:
            TextSelectionThemeData(cursorColor: colorScheme.secondary),
        filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)))));

    return theme;
  }

  Widget defaultIntro() {
    return const Intro(infos: [
      IntroScreen(
        image: 'images/intros/1.svg.vec',
        title: 'Choose your courses easily',
        subtitle: 'Choose your courses easily and add it to favorite',
        nextButton: 'Next',
      ),
      IntroScreen(
        image: 'images/intros/2.svg.vec',
        title: 'Book your courses at any time',
        subtitle: 'Choose your courses easily and add it to favorite',
        nextButton: 'Next',
      ),
      IntroScreen(
        image: 'images/intros/3.svg.vec',
        title: 'Learn easily and anytime!',
        subtitle:
            'With video lessons, interactive tests, and certified certificates.',
        nextButton: 'Get Started',
      ),
    ], child: GetStarted());
  }

  Widget startScreen(BuildContext context) {
    ConfigProvider config = ConfigProvider.of(context);
    String? sessionToken = config.prefs.getString('sessionToken');
    if (sessionToken != null) {
      return const HomeScreen();
    }
    bool ignoreIntro = config.prefs.getBool('ignoreIntro') ?? false;
    if (ignoreIntro) {
      return const GetStarted();
    }
    return defaultIntro();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(next: startScreen(context)),
        locale: context.watch<LocaleProvider>().locale,
        theme: theme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales);
  }
}
