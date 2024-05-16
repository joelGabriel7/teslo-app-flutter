

class User {

  final String id;
  final String email;
  final String fullName;
  final String token;
  final List<String> role;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.token,
  });

  bool get isAdmin => role.contains('admin');

}