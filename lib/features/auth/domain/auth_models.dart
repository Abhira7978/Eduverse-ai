enum UserRole { student, parent, teacher, school, admin }

extension UserRoleLabel on UserRole {
  String get key => switch (this) {
        UserRole.student => 'student',
        UserRole.parent => 'parent',
        UserRole.teacher => 'teacher',
        UserRole.school => 'school',
        UserRole.admin => 'admin',
      };
}

class AuthProfile {
  final String displayName;
  final String identifier;
  final String? phone;
  final Map<String, String> details;

  const AuthProfile({
    required this.displayName,
    required this.identifier,
    this.phone,
    this.details = const {},
  });
}

class AuthUser {
  final String id;
  final String name;
  final String identifier;
  final UserRole role;
  final AuthProfile profile;

  const AuthUser({
    required this.id,
    required this.name,
    required this.identifier,
    required this.role,
    required this.profile,
  });
}

class AuthResult {
  final bool success;
  final String message;
  final AuthUser? user;

  const AuthResult({
    required this.success,
    required this.message,
    this.user,
  });
}
