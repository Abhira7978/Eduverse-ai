import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../state/locale_controller.dart';
import '../../../../widgets/language_selector.dart';
import '../../../student_onboarding/student_onboarding_flow.dart';
import '../../domain/auth_models.dart';
import '../../domain/auth_service.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_shell.dart';
import 'auth_success_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final LocaleController localeController;
  final AuthService authService;
  final AuthProfile profile;
  final String password;
  final UserRole role;

  const OtpVerificationScreen({super.key, required this.localeController, required this.authService, required this.profile, required this.password, required this.role});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  int _seconds = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() { _timer?.cancel(); _controller.dispose(); super.dispose(); }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 45);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_seconds <= 1) { timer.cancel(); setState(() => _seconds = 0); } else { setState(() => _seconds--); }
    });
  }

  Future<void> _verify() async {
    if (_controller.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter the 6-digit OTP.')));
      return;
    }
    setState(() => _loading = true);
    final result = await widget.authService.verifySignupOtp(identifier: widget.profile.identifier, otp: _controller.text.trim());
    if (!mounted) return;
    setState(() => _loading = false);
    if (!result.success) {
      final message = switch (result.message) { 'invalid_otp' => 'That OTP is incorrect. Try again.', 'otp_expired' => 'This OTP expired. Please request a new one.', _ => 'Please request a new OTP.' };
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
      return;
    }
    if (widget.role == UserRole.student) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StudentOnboardingFlow(localeController: widget.localeController, authService: widget.authService, signupProfile: widget.profile, password: widget.password)));
    } else {
      final profile = widget.profile;
      final created = await widget.authService.signUp(profile: profile, password: widget.password, role: widget.role);
      if (!mounted) return;
      if (!created.success) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not create the account. Please try again.'))); return; }
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => AuthSuccessScreen(user: created.user!, localeController: widget.localeController)));
    }
  }

  Future<void> _resend() async {
    if (_seconds > 0) return;
    final result = await widget.authService.requestSignupOtp(identifier: widget.profile.identifier, role: widget.role);
    if (!mounted) return;
    if (result.success) { _startTimer(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A new OTP has been sent.'))); }
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      eyebrow: 'SECURITY • OTP VERIFICATION',
      title: 'Verify your account.',
      subtitle: 'Enter the one-time code sent to ${widget.profile.identifier}. This extra step helps keep student and family accounts secure.',
      topAction: LanguageSelector(controller: widget.localeController, compact: true),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFF5F7FF), borderRadius: BorderRadius.circular(18)), child: const Row(children: [Icon(Icons.mark_email_read_rounded, color: Color(0xFF5B55E8)), SizedBox(width: 12), Expanded(child: Text('Development mode: use OTP 123456. Production will connect this step to email/SMS.', style: TextStyle(color: Color(0xFF475467), fontSize: 13, height: 1.4)))])),
        const SizedBox(height: 22),
        TextField(controller: _controller, autofocus: true, maxLength: 6, keyboardType: TextInputType.number, textAlign: TextAlign.center, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: 10, color: Color(0xFF0B2F63)), decoration: InputDecoration(counterText: '', hintText: '••••••', filled: true, fillColor: const Color(0xFFF8F9FC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none))),
        const SizedBox(height: 18),
        AuthButton(label: 'Verify & Continue', onPressed: _verify, loading: _loading),
        const SizedBox(height: 14),
        Center(child: TextButton(onPressed: _seconds == 0 ? _resend : null, child: Text(_seconds == 0 ? 'Resend OTP' : 'Resend OTP in ${_seconds}s'))),
      ]),
    );
  }
}
