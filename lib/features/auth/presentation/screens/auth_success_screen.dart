import 'package:flutter/material.dart';

import '../../../../state/locale_controller.dart';
import '../../../../widgets/language_selector.dart';
import '../../domain/auth_models.dart';

class AuthSuccessScreen extends StatelessWidget {
  final AuthUser user;
  final LocaleController localeController;

  const AuthSuccessScreen({
    super.key,
    required this.user,
    required this.localeController,
  });

  @override
  Widget build(BuildContext context) {
    final role = switch (user.role) {
      UserRole.student => 'Student',
      UserRole.parent => 'Parent',
      UserRole.teacher => 'Teacher',
      UserRole.school => 'School',
      UserRole.admin => 'Admin',
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                    child: Padding(
                      padding: EdgeInsets.all(width < 500 ? 24 : 42),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text.rich(TextSpan(children: [
                                TextSpan(text: 'EduVerse', style: TextStyle(color: Color(0xFF12366D), fontSize: 24, fontWeight: FontWeight.w900)),
                                TextSpan(text: ' AI', style: TextStyle(color: Color(0xFFF12C68), fontSize: 24, fontWeight: FontWeight.w900)),
                              ])),
                              const Spacer(),
                              LanguageSelector(controller: localeController, compact: true),
                            ],
                          ),
                          const SizedBox(height: 45),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [Color(0xFF5146D8), Color(0xFFF12C68)]),
                            ),
                            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 48),
                          ),
                          const SizedBox(height: 22),
                          const Text('You’re in!', style: TextStyle(color: Color(0xFF0B2F63), fontSize: 36, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 10),
                          Text(
                            'Welcome ${user.name}. Your ${role.toLowerCase()} experience is ready for the next dashboard module.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFF68778F), fontSize: 15, height: 1.55),
                          ),
                          const SizedBox(height: 28),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F6FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.verified_user_outlined, color: Color(0xFF5146D8)),
                                const SizedBox(width: 12),
                                Expanded(child: Text(user.identifier, style: const TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w800))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.arrow_back_rounded),
                              label: const Text('Back'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF5146D8),
                                side: const BorderSide(color: Color(0xFFCBC9F4)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text('Dashboard/AuthWrapper can replace this screen later without changing the auth module.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF98A2B3), fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
