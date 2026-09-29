import 'auth_models.dart';
import 'auth_repository.dart';

class AuthService {
  final AuthRepository repository;
  const AuthService({required this.repository});

  Future<AuthResult> signIn({required String identifier, required String password, required UserRole role}) => repository.signIn(identifier: identifier, password: password, role: role);
  Future<AuthResult> signUp({required AuthProfile profile, required String password, required UserRole role}) => repository.signUp(profile: profile, password: password, role: role);
  Future<AuthResult> requestSignupOtp({required String identifier, required UserRole role}) => repository.requestSignupOtp(identifier: identifier, role: role);
  Future<AuthResult> verifySignupOtp({required String identifier, required String otp}) => repository.verifySignupOtp(identifier: identifier, otp: otp);
  Future<AuthResult> forgotPassword({required String identifier}) => repository.sendPasswordReset(identifier: identifier);
}
