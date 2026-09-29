import 'dart:async';
import '../widgets/app_assets.dart';
import '../widgets/safe_asset_image.dart';

import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../state/locale_controller.dart';
import '../widgets/language_selector.dart';
import '../widgets/primary_button.dart';
import '../features/auth/domain/auth_service.dart';
import '../features/auth/presentation/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final LocaleController localeController;
  final AuthService authService;

  const OnboardingScreen({
    super.key,
    required this.localeController,
    required this.authService,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();
  Timer? timer;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(seconds: 4),
      (_) => _automaticNext(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  void _automaticNext() {
    if (!pageController.hasClients) return;

    final next = (currentPage + 1) % 3;

    pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
    );
  }

  void _goTo(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  void _next() {
    if (currentPage < 2) {
      _goTo(currentPage + 1);
      return;
    }

    timer?.cancel();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          localeController: widget.localeController,
          authService: widget.authService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    final pages = [
      _OnboardingData(
        image: AppAssets.onboardingPersonalized,
        title: strings.personalized,
        description: strings.personalizedDesc,
      ),
      _OnboardingData(
        image: AppAssets.onboardingCareer,
        title: strings.career,
        description: strings.careerDesc,
      ),
      _OnboardingData(
        image: AppAssets.onboardingEmotional,
        title: strings.emotional,
        description: strings.emotionalDesc,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final desktop = width >= 900;

            return Column(
              children: [
                _Header(
                  controller: widget.localeController,
                  currentPage: currentPage,
                  onDotTap: _goTo,
                  compact: width < 430,
                ),
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      setState(() => currentPage = index);
                    },
                    itemBuilder: (_, index) {
                      return _OnboardingPage(
                        data: pages[index],
                        desktop: desktop,
                      );
                    },
                  ),
                ),
                _BottomBar(
                  currentPage: currentPage,
                  onDotTap: _goTo,
                  onSkip: () => _goTo(2),
                  onNext: _next,
                  nextText:
                      currentPage == 2 ? strings.getStarted : strings.next,
                  skipText: strings.skip,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final LocaleController controller;
  final int currentPage;
  final ValueChanged<int> onDotTap;
  final bool compact;

  const _Header({
    required this.controller,
    required this.currentPage,
    required this.onDotTap,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        compact ? 16 : 32,
        12,
        compact ? 16 : 32,
        4,
      ),
      child: Row(
        children: [
          const Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'EduVerse',
                    style: TextStyle(
                      color: Color(0xFF12366D),
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ' AI',
                    style: TextStyle(
                      color: Color(0xFFF12C68),
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          LanguageSelector(
            controller: controller,
            compact: compact,
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  final bool desktop;

  const _OnboardingPage({
    required this.data,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: desktop ? 45 : 16,
              vertical: 8,
            ),
            child: desktop
                ? _DesktopSlide(data: data)
                : _MobileSlide(data: data, width: width),
          ),
        ),
      ),
    );
  }
}

class _DesktopSlide extends StatelessWidget {
  final _OnboardingData data;

  const _DesktopSlide({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 560,
              minHeight: 300,
            ),
            child: AspectRatio(
              aspectRatio: 1.05,
              child: SafeAssetImage(asset: 
                data.image,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ),
        const SizedBox(width: 42),
        Expanded(
          flex: 4,
          child: _TextContent(data: data),
        ),
      ],
    );
  }
}

class _MobileSlide extends StatelessWidget {
  final _OnboardingData data;
  final double width;

  const _MobileSlide({
    required this.data,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final imageHeight = (width * .92).clamp(260.0, 520.0);

    return Column(
      children: [
        SizedBox(
          height: imageHeight,
          width: double.infinity,
          child: SafeAssetImage(asset: 
            data.image,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
        const SizedBox(height: 8),
        _TextContent(data: data),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _TextContent extends StatelessWidget {
  final _OnboardingData data;

  const _TextContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF0D346A),
              fontSize: 31,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 42,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFFF365E),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF587092),
              fontSize: 16,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int currentPage;
  final ValueChanged<int> onDotTap;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final String nextText;
  final String skipText;

  const _BottomBar({
    required this.currentPage,
    required this.onDotTap,
    required this.onSkip,
    required this.onNext,
    required this.nextText,
    required this.skipText,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final small = width < 430;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        small ? 12 : 28,
        5,
        small ? 12 : 28,
        14,
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: onSkip,
            child: Text(
              skipText,
              style: const TextStyle(
                color: Color(0xFF657895),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3,
              (index) => _Dot(
                active: index == currentPage,
                onTap: () => onDotTap(index),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: small ? 145 : 175,
            height: 56,
            child: PrimaryButton(
              label: nextText,
              onPressed: onNext,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;

  const _Dot({
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: active ? 28 : 13,
        height: 9,
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFFFF365E)
              : const Color(0xFFD9DDEF),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class _OnboardingData {
  final String image;
  final String title;
  final String description;

  const _OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}
