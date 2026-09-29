import 'auth_models.dart';

abstract interface class AuthRepository {
  Future<AuthResult> signIn({required String identifier, required String password, required UserRole role});
  Future<AuthResult> signUp({required AuthProfile profile, required String password, required UserRole role});
  Future<AuthResult> requestSignupOtp({required String identifier, required UserRole role});
  Future<AuthResult> verifySignupOtp({required String identifier, required String otp});
  Future<AuthResult> sendPasswordReset({required String identifier});
}
