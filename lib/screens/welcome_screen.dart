import 'package:flutter/material.dart';
import '../widgets/app_assets.dart';
import '../widgets/safe_asset_image.dart';

import '../localization/app_strings.dart';
import '../state/locale_controller.dart';
import '../widgets/language_selector.dart';
import '../widgets/primary_button.dart';
import 'onboarding_screen.dart';
import '../features/auth/domain/auth_service.dart';

class WelcomeScreen extends StatefulWidget {
  final LocaleController localeController;
  final AuthService authService;

  const WelcomeScreen({
    super.key,
    required this.localeController,
    required this.authService,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> fade;
  late final Animation<double> scale;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    fade = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

    scale = Tween<double>(
      begin: .96,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutBack,
      ),
    );

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final desktop = width >= 1000;
            final tablet = width >= 600;

            return Stack(
              children: [
                const _Background(),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1280),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: desktop
                              ? 52
                              : tablet
                                  ? 36
                                  : 18,
                          vertical: 14,
                        ),
                        child: FadeTransition(
                          opacity: fade,
                          child: ScaleTransition(
                            scale: scale,
                            child: desktop
                                ? _DesktopContent(
                                    strings: strings,
                                    controller: widget.localeController,
                                    authService: widget.authService,
                                  )
                                : _MobileContent(
                                    strings: strings,
                                    controller: widget.localeController,
                                    authService: widget.authService,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MobileContent extends StatelessWidget {
  final AppStrings strings;
  final LocaleController controller;
  final AuthService authService;

  const _MobileContent({
    required this.strings,
    required this.controller,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final small = width < 360;

    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: LanguageSelector(
            controller: controller,
            compact: small,
          ),
        ),
        const SizedBox(height: 18),
        _Badge(text: strings.badge),
        const SizedBox(height: 14),
        AspectRatio(
          aspectRatio: 1.25,
          child: SafeAssetImage(asset: 
            AppAssets.hero,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
        const SizedBox(height: 10),
        _Title(strings: strings, small: small),
        const SizedBox(height: 16),
        _Tagline(text: strings.tagline, small: small),
        const SizedBox(height: 16),
        _Description(text: strings.description),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            label: strings.getStarted,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OnboardingScreen(
                  localeController: controller,
                  authService: authService,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        _Terms(text: strings.terms),
        const SizedBox(height: 14),
      ],
    );
  }
}

class _DesktopContent extends StatelessWidget {
  final AppStrings strings;
  final LocaleController controller;
  final AuthService authService;

  const _DesktopContent({
    required this.strings,
    required this.controller,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 680),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Badge(text: strings.badge),
                const SizedBox(height: 18),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 520),
                  child: AspectRatio(
                    aspectRatio: 1.2,
                    child: SafeAssetImage(asset: 
                      AppAssets.hero,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: LanguageSelector(controller: controller),
                ),
                const SizedBox(height: 45),
                _Title(strings: strings, desktop: true),
                const SizedBox(height: 20),
                _Tagline(text: strings.tagline, desktop: true),
                const SizedBox(height: 20),
                _Description(text: strings.description, desktop: true),
                const SizedBox(height: 30),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: PrimaryButton(
                    label: strings.getStarted,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OnboardingScreen(
                          localeController: controller,
                          authService: authService,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _Terms(text: strings.terms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;

  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EEFF),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE1D8FF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome,
            color: Color(0xFF5146D8),
            size: 18,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF4141B8),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final AppStrings strings;
  final bool small;
  final bool desktop;

  const _Title({
    required this.strings,
    this.small = false,
    this.desktop = false,
  });

  @override
  Widget build(BuildContext context) {
    final welcomeSize = desktop ? 48.0 : (small ? 31.0 : 39.0);
    final brandSize = desktop ? 57.0 : (small ? 40.0 : 48.0);

    return Column(
      crossAxisAlignment:
          desktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          strings.welcome,
          textAlign: desktop ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF06356B),
            fontSize: welcomeSize,
            fontWeight: FontWeight.w800,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 3),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'EduVerse',
                style: TextStyle(
                  color: const Color(0xFF1745A1),
                  fontSize: brandSize,
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(
                text: ' AI',
                style: TextStyle(
                  color: const Color(0xFFF12C68),
                  fontSize: brandSize,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          textAlign: desktop ? TextAlign.left : TextAlign.center,
        ),
      ],
    );
  }
}

class _Tagline extends StatelessWidget {
  final String text;
  final bool small;
  final bool desktop;

  const _Tagline({
    required this.text,
    this.small = false,
    this.desktop = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 540),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F0FF),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFF123F78),
          fontSize: desktop ? 21 : (small ? 17 : 20),
          fontWeight: FontWeight.w700,
          height: 1.35,
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final String text;
  final bool desktop;

  const _Description({
    required this.text,
    this.desktop = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: desktop ? TextAlign.left : TextAlign.center,
      style: TextStyle(
        color: const Color(0xFF53688B),
        fontSize: desktop ? 17 : 15,
        height: 1.55,
      ),
    );
  }
}

class _Terms extends StatelessWidget {
  final String text;

  const _Terms({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color(0xFF53688B),
        fontSize: 12.5,
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -90,
            child: _Glow(
              size: 280,
              color: const Color(0xFFDCD7FF),
            ),
          ),
          Positioned(
            top: 160,
            right: -100,
            child: _Glow(
              size: 250,
              color: const Color(0xFFE8D8FF),
            ),
          ),
          Positioned(
            bottom: -130,
            left: -90,
            child: _Glow(
              size: 300,
              color: const Color(0xFFDCE8FF),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -90,
            child: _Glow(
              size: 300,
              color: const Color(0xFFF0DFFF),
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final double size;
  final Color color;

  const _Glow({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.25),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.22),
            blurRadius: 90,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}
