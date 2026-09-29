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
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final LocaleController localeController;
  final AuthService authService;
  final UserRole initialRole;

  const ForgotPasswordScreen({
    super.key,
    required this.localeController,
    required this.authService,
    this.initialRole = UserRole.student,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  UserRole _role = UserRole.student;
  bool _loading = false;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _role = widget.initialRole;
  }

  @override
  void dispose() {
    _identifier.dispose();
    super.dispose();
  }

  String _label() => switch (_role) {
        UserRole.student => 'Student email / Student ID',
        UserRole.parent => 'Parent email / Mobile number',
        UserRole.teacher => 'Teacher email / Employee ID',
        UserRole.school => 'School email / School code',
        UserRole.admin => 'Admin email / Admin ID',
      };

  String _hint() => switch (_role) {
        UserRole.student => 'student@school.com or EVS-1024',
        UserRole.parent => 'parent@email.com or mobile number',
        UserRole.teacher => 'teacher@school.com or EMP-1024',
        UserRole.school => 'school@email.com or SCHOOL-1024',
        UserRole.admin => 'admin@eduverse.ai or ADM-1024',
      };

  Future<void> _send() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    await widget.authService.forgotPassword(identifier: _identifier.text);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = AuthStrings.of(context);
    return AuthShell(
      eyebrow: 'RECOVER • ${_role.key.toUpperCase()}',
      title: 'Reset your EduVerse access.',
      subtitle: 'Choose your account type and enter the identifier connected to your school or EduVerse account.',
      topAction: Row(mainAxisSize: MainAxisSize.min, children: [
        TextButton(onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen(localeController: widget.localeController, authService: widget.authService))), child: Text(s.forgotTop)),
        LanguageSelector(controller: widget.localeController, compact: true),
      ]),
      child: _sent
          ? _SuccessCard(s: s)
          : Form(
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
                  label: _label(),
                  hint: _hint(),
                  icon: Icons.alternate_email_rounded,
                  validator: (v) => (v?.trim().isEmpty ?? true) ? s.fillRequired : null,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _send(),
                ),
                const SizedBox(height: 20),
                AuthButton(label: s.sendReset, onPressed: _send, loading: _loading),
                const SizedBox(height: 14),
                Center(child: AuthLink(prefix: '', action: s.backToLogin, onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen(localeController: widget.localeController, authService: widget.authService))))),
              ]),
            ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  final AuthStrings s;
  const _SuccessCard({required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFFF0FAF6), borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFFCBEBDD))),
      child: Column(children: [
        const CircleAvatar(radius: 30, backgroundColor: Color(0xFF218A67), child: Icon(Icons.mark_email_read_rounded, color: Colors.white, size: 30)),
        const SizedBox(height: 16),
        Text('Check your inbox', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF123B31))),
        const SizedBox(height: 8),
        Text(s.resetSent, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF55756B), height: 1.5)),
      ]),
    );
  }
}
