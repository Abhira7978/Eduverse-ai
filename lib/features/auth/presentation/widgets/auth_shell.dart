import 'package:flutter/material.dart';

import '../../../../widgets/app_assets.dart';
import '../../../../widgets/safe_asset_image.dart';

class AuthShell extends StatelessWidget {
  final Widget child;
  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget topAction;

  const AuthShell({
    super.key,
    required this.child,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.topAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final desktop = width >= 1000;
            final tablet = width >= 650;

            return Stack(
              children: [
                const _GlowBackground(),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1280),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: desktop ? 48 : tablet ? 30 : 16,
                          vertical: 16,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const _Brand(),
                                const Spacer(),
                                topAction,
                              ],
                            ),
                            const SizedBox(height: 18),
                            desktop
                                ? _DesktopBody(
                                    eyebrow: eyebrow,
                                    title: title,
                                    subtitle: subtitle,
                                    child: child,
                                  )
                                : _MobileBody(
                                    eyebrow: eyebrow,
                                    title: title,
                                    subtitle: subtitle,
                                    showIllustration: tablet,
                                    child: child,
                                  ),
                          ],
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

class _DesktopBody extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget child;

  const _DesktopBody({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 650),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(flex: 5, child: _VisualPanel()),
          const SizedBox(width: 52),
          Expanded(
            flex: 5,
            child: _FormPanel(
              eyebrow: eyebrow,
              title: title,
              subtitle: subtitle,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileBody extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget child;
  final bool showIllustration;

  const _MobileBody({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.showIllustration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showIllustration) ...[
          const SizedBox(height: 4),
          const SizedBox(height: 210, child: _VisualPanel(compact: true)),
          const SizedBox(height: 6),
        ],
        _FormPanel(
          eyebrow: eyebrow,
          title: title,
          subtitle: subtitle,
          child: child,
        ),
      ],
    );
  }
}

class _FormPanel extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget child;

  const _FormPanel({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white.withValues(alpha: 0.94),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EEFF),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                eyebrow,
                style: const TextStyle(
                  color: Color(0xFF5146D8),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .7,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF0B2F63),
                fontSize: 34,
                fontWeight: FontWeight.w900,
                height: 1.08,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF6A7892),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            child,
          ],
        ),
      ),
    );
  }
}

class _VisualPanel extends StatelessWidget {
  final bool compact;

  const _VisualPanel({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEFF3FF), Color(0xFFFCEFF5)],
        ),
      ),
      padding: EdgeInsets.all(compact ? 10 : 24),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            right: 18,
            child: _FloatingBadge(
              icon: Icons.auto_awesome,
              label: 'AI',
              compact: compact,
            ),
          ),
          Center(
            child: SafeAssetImage(
              asset: AppAssets.hero,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool compact;

  const _FloatingBadge({
    required this.icon,
    required this.label,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            blurRadius: 20,
            color: Color(0x180D346A),
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 15 : 18, color: const Color(0xFFF12C68)),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF12366D),
              fontWeight: FontWeight.w900,
              fontSize: compact ? 10 : 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'EduVerse',
            style: TextStyle(
              color: Color(0xFF12366D),
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          TextSpan(
            text: ' AI',
            style: TextStyle(
              color: Color(0xFFF12C68),
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowBackground extends StatelessWidget {
  const _GlowBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -150,
            right: -120,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF8A7CFF).withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -180,
            left: -120,
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF4F83).withValues(alpha: 0.07),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
