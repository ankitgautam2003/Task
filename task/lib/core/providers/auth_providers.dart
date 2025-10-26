import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/app_user.dart';

class AuthNotifier extends StateNotifier<AppUser?> {
  AuthNotifier() : super(null);

  Future<AppUser> signUp(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final user = AppUser(id: 'mock_${email.hashCode}', email: email);
    state = user;
    return user;
  }

  Future<AppUser> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final user = AppUser(id: 'mock_${email.hashCode}', email: email);
    state = user;
    return user;
  }

  void signOut() {
    state = null;
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AppUser?>((
  ref,
) {
  return AuthNotifier();
});

final authServiceProvider = Provider(
  (ref) => ref.watch(authNotifierProvider.notifier),
);

final currentUserProvider = Provider<AppUser?>(
  (ref) => ref.watch(authNotifierProvider),
);
