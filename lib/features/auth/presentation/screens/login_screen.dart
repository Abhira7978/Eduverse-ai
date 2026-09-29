import 'package:flutter/material.dart';

import '../../../../state/locale_controller.dart';
import '../../../../widgets/language_selector.dart';
import '../../domain/auth_models.dart';
import '../../domain/auth_service.dart';
import '../auth_strings.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_link.dart';
import '../widgets/auth_shell.dart';
import '../widgets/role_selector.dart';
import 'auth_success_screen.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  final LocaleController localeController;
  final AuthService authService;

  const LoginScreen({super.key, required this.localeController, required this.authService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  UserRole _role = UserRole.student;
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  String _label(AuthStrings s) => switch (_role) {
        UserRole.student => 'Student email / Student ID',
        UserRole.parent => 'Parent email / Mobile number',
        UserRole.teacher => 'Teacher email / Employee ID',
        UserRole.school => 'School email / School code',
        UserRole.admin => 'Admin email / Admin ID',
      };

  String _hint() => switch (_role) {
        UserRole.student => 'student@school.com or EVS-1024',
        UserRole.parent => 'parent@email.com or 10-digit mobile',
        UserRole.teacher => 'teacher@school.com or EMP-1024',
        UserRole.school => 'school@email.com or SCHOOL-1024',
        UserRole.admin => 'admin@eduverse.ai or ADM-1024',
      };

  Future<void> _signIn() async {
    final s = AuthStrings.of(context);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    final result = await widget.authService.signIn(
      identifier: _identifier.text,
      password: _password.text,
      role: _role,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (!result.success) {
      final message = result.message == 'role_mismatch' ? s.roleMismatch : s.invalidCredentials;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
      return;
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => AuthSuccessScreen(user: result.user!, localeController: widget.localeController),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final s = AuthStrings.of(context);
    return AuthShell(
      eyebrow: 'SECURE ACCESS • ${_role.key.toUpperCase()}',
      title: 'Welcome back to EduVerse.',
      subtitle: 'Sign in to your ${_role.key} space and continue your personalized EduVerse experience.',
      topAction: Row(mainAxisSize: MainAxisSize.min, children: [
        TextButton(
          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => SignupScreen(localeController: widget.localeController, authService: widget.authService),
          )),
          child: Text(s.signupTop),
        ),
        LanguageSelector(controller: widget.localeController, compact: true),
      ]),
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.role, style: const TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w800, fontSize: 13)),
          const SizedBox(height: 10),
          RoleSelector(
            selected: _role,
            onChanged: (r) => setState(() => _role = r),
            labels: {UserRole.student: s.student, UserRole.parent: s.parent, UserRole.teacher: s.teacher, UserRole.school: s.school, UserRole.admin: s.admin},
          ),
          const SizedBox(height: 18),
          AuthField(
            controller: _identifier,
            label: _label(s),
            hint: _hint(),
            icon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (v) => (v?.trim().isEmpty ?? true) ? s.fillRequired : null,
          ),
          const SizedBox(height: 14),
          AuthField(
            controller: _password,
            label: s.password,
            hint: s.passwordHint,
            icon: Icons.lock_outline_rounded,
            obscureText: _obscure,
            onVisibilityTap: () => setState(() => _obscure = !_obscure),
            textInputAction: TextInputAction.done,
            validator: (v) => (v?.length ?? 0) < 8 ? s.weakPassword : null,
            onSubmitted: (_) => _signIn(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ForgotPasswordScreen(localeController: widget.localeController, authService: widget.authService, initialRole: _role),
              )),
              child: Text(s.forgotPassword),
            ),
          ),
          AuthButton(label: s.signIn, onPressed: _signIn, loading: _loading),
          const SizedBox(height: 14),
          Center(child: AuthLink(prefix: s.newHere, action: s.createAccount, onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => SignupScreen(localeController: widget.localeController, authService: widget.authService),
          )))),
          const SizedBox(height: 8),
          Center(child: Text('Demo: demo@eduverse.ai / Password123', style: const TextStyle(fontSize: 11, color: Color(0xFF98A2B3)))),
        ]),
      ),
    );
  }
}
