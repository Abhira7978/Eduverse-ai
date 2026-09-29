import 'package:flutter/material.dart';

class HeroIllustration extends StatelessWidget {
  final double height;

  const HeroIllustration({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(38),
        child: Image.asset(
          'assets/images/eduverse_hero.png',
          width: double.infinity,
          height: height,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E4FF),
                borderRadius: BorderRadius.circular(38),
              ),
              child: const Icon(
                Icons.image_not_supported_outlined,
                size: 70,
                color: Color(0xFF5146D8),
              ),
            );
          },
        ),
      ),
    );
  }
}