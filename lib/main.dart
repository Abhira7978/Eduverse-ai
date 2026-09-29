import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localization/app_strings.dart';
import 'screens/welcome_screen.dart';
import 'features/auth/data/local_auth_repository.dart';
import 'features/auth/domain/auth_service.dart';
import 'state/locale_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EduVerseApp());
}

class EduVerseApp extends StatefulWidget {
  final LocaleController? localeController;
  final AuthService? authService;

  const EduVerseApp({
    super.key,
    this.localeController,
    this.authService,
  });

  @override
  State<EduVerseApp> createState() => _EduVerseAppState();
}

class _EduVerseAppState extends State<EduVerseApp> {
  late final LocaleController localeController;
  late final AuthService authService;

  @override
  void initState() {
    super.initState();
    localeController = widget.localeController ?? LocaleController();
    authService = widget.authService ??
        AuthService(repository: LocalAuthRepository());
    localeController.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    localeController.removeListener(_onLocaleChanged);
    localeController.dispose();
    super.dispose();
  }

  void _onLocaleChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduVerse AI',
      locale: localeController.locale,
      supportedLocales: LocaleController.supportedLocales,
      localizationsDelegates: const [
        AppStringsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9F8FF),
      ),
      home: WelcomeScreen(
        localeController: localeController,
        authService: authService,
      ),
    );
  }
}