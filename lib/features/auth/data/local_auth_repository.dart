import 'dart:async';
import '../domain/auth_models.dart';
import '../domain/auth_repository.dart';

/// Development repository. OTP is intentionally simulated as 123456.
/// Replace this repository with a Supabase/REST implementation later.
class LocalAuthRepository implements AuthRepository {
  final Map<String, _LocalAccount> _accounts = <String, _LocalAccount>{};
  final Map<String, _PendingSignup> _pending = <String, _PendingSignup>{};

  LocalAuthRepository() {
    _accounts['demo@eduverse.ai'] = const _LocalAccount(
      profile: AuthProfile(displayName: 'Aarav Sharma', identifier: 'demo@eduverse.ai', phone: '9999999999', details: {'class': '8', 'section': 'A', 'school': 'EduVerse Demo School', 'studentId': 'EVS-0001'}),
      password: 'Password123', role: UserRole.student,
    );
  }

  String _key(String value) => value.trim().toLowerCase();

  @override
  Future<AuthResult> signIn({required String identifier, required String password, required UserRole role}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final account = _accounts[_key(identifier)];
    if (account == null || account.password != password) return const AuthResult(success: false, message: 'invalid_credentials');
    if (account.role != role) return const AuthResult(success: false, message: 'role_mismatch');
    return AuthResult(success: true, message: 'signed_in', user: AuthUser(id: _key(identifier).hashCode.toString(), name: account.profile.displayName, identifier: account.profile.identifier, role: account.role, profile: account.profile));
  }

  @override
  Future<AuthResult> signUp({required AuthProfile profile, required String password, required UserRole role}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final key = _key(profile.identifier);
    if (_accounts.containsKey(key)) return const AuthResult(success: false, message: 'identifier_exists');
    _accounts[key] = _LocalAccount(profile: profile, password: password, role: role);
    return AuthResult(success: true, message: 'account_created', user: AuthUser(id: key.hashCode.toString(), name: profile.displayName, identifier: profile.identifier, role: role, profile: profile));
  }

  @override
  Future<AuthResult> requestSignupOtp({required String identifier, required UserRole role}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final key = _key(identifier);
    if (_accounts.containsKey(key)) return const AuthResult(success: false, message: 'identifier_exists');
    _pending[key] = _PendingSignup(role: role, otp: '123456', expiresAt: DateTime.now().add(const Duration(minutes: 5)));
    return const AuthResult(success: true, message: 'otp_sent');
  }

  @override
  Future<AuthResult> verifySignupOtp({required String identifier, required String otp}) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final key = _key(identifier);
    final pending = _pending[key];
    if (pending == null) return const AuthResult(success: false, message: 'otp_not_requested');
    if (DateTime.now().isAfter(pending.expiresAt)) {
      _pending.remove(key);
      return const AuthResult(success: false, message: 'otp_expired');
    }
    if (otp.trim() != pending.otp) return const AuthResult(success: false, message: 'invalid_otp');
    _pending.remove(key);
    return AuthResult(success: true, message: 'otp_verified', user: AuthUser(id: key.hashCode.toString(), name: '', identifier: key, role: pending.role, profile: AuthProfile(displayName: '', identifier: key)));
  }

  @override
  Future<AuthResult> sendPasswordReset({required String identifier}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return const AuthResult(success: true, message: 'reset_sent');
  }
}

class _LocalAccount {
  final AuthProfile profile;
  final String password;
  final UserRole role;
  const _LocalAccount({required this.profile, required this.password, required this.role});
}

class _PendingSignup {
  final UserRole role;
  final String otp;
  final DateTime expiresAt;
  const _PendingSignup({required this.role, required this.otp, required this.expiresAt});
}
