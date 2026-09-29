import 'package:flutter/material.dart';

class SafeAssetImage extends StatelessWidget {
  final String asset;
  final BoxFit fit;
  final FilterQuality filterQuality;

  const SafeAssetImage({
    super.key,
    required this.asset,
    this.fit = BoxFit.contain,
    this.filterQuality = FilterQuality.high,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: fit,
      filterQuality: filterQuality,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3F3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFFCACA)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.broken_image_outlined, size: 42, color: Colors.redAccent),
              const SizedBox(height: 10),
              const Text('Image asset could not be loaded', textAlign: TextAlign.center),
              const SizedBox(height: 6),
              SelectableText(asset, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
              const SizedBox(height: 6),
              const Text('Run: flutter clean  →  flutter pub get  →  flutter run', textAlign: TextAlign.center, style: TextStyle(fontSize: 11)),
            ],
          ),
        );
      },
    );
  }
}
