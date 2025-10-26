class AppUser {
  final String id;
  final String email;
  final String? displayName;

  AppUser({
    required this.id,
    required this.email,
    this.displayName,
  });

  factory AppUser.fromFirebase(String id, String email) {
    return AppUser(
      id: id,
      email: email,
    );
  }
}

