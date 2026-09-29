import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../state/locale_controller.dart';

class LanguageSelector extends StatelessWidget {
  final LocaleController controller;
  final bool compact;

  const LanguageSelector({
    super.key,
    required this.controller,
    this.compact = false,
  });

  static const names = <String, String>{
    'en': 'English',
    'hi': 'हिन्दी',
    'or': 'ଓଡ଼ିଆ',
    'bn': 'বাংলা',
    'te': 'తెలుగు',
    'ta': 'தமிழ்',
    'mr': 'मराठी',
  };

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return PopupMenuButton<String>(
      tooltip: 'Select language',
      offset: const Offset(0, 58),
      color: Colors.white,
      elevation: 12,
      constraints: const BoxConstraints(
        minWidth: 180,
        maxWidth: 230,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      onSelected: controller.setLanguage,
      itemBuilder: (context) {
        final selected = controller.locale.languageCode;

        return LocaleController.supportedLocales.map((locale) {
          final code = locale.languageCode;
          final isSelected = code == selected;

          return PopupMenuItem<String>(
            value: code,
            child: Row(
              children: [
                SizedBox(
                  width: 25,
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          color: Color(0xFF4054C7),
                          size: 20,
                        )
                      : null,
                ),
                const SizedBox(width: 7),
                Text(
                  names[code]!,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF2447A0)
                        : const Color(0xFF243B5A),
                    fontSize: 15,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 13 : 17,
          vertical: compact ? 9 : 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFFE4E6F4)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5D6AA5).withValues(alpha: 0.10),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language_rounded,
              color: const Color(0xFF3672A8),
              size: compact ? 20 : 22,
            ),
            const SizedBox(width: 8),
            Text(
              strings.language,
              style: TextStyle(
                color: const Color(0xFF174270),
                fontSize: compact ? 14 : 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF3975A8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}