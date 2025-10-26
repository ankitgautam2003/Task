import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/app_user.dart';

class AuthNotifier extends StateNotifier<AppUser?> {
  AuthNotifier() : super(null) {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      if (firebaseUser == null) {
        state = null;
      } else {
        state = AppUser.fromFirebase(firebaseUser.uid, firebaseUser.email ?? '');
      }
    });
  }

  Future<AppUser> signUp(String email, String password) async {
    final cred = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    final user = cred.user!;
    final appUser = AppUser.fromFirebase(user.uid, user.email ?? email);
    state = appUser;
    return appUser;
  }

  Future<AppUser> signIn(String email, String password) async {
    final cred = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    final user = cred.user!;
    final appUser = AppUser.fromFirebase(user.uid, user.email ?? email);
    state = appUser;
    return appUser;
  }

  Future<AppUser> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in aborted');
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final cred = await FirebaseAuth.instance.signInWithCredential(credential);
    final user = cred.user!;
    final appUser = AppUser.fromFirebase(user.uid, user.email ?? '');
    state = appUser;
    return appUser;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    state = null;
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AppUser?>(
  (ref) {
    return AuthNotifier();
  },
);

final authServiceProvider = Provider(
  (ref) => ref.watch(authNotifierProvider.notifier),
);

final currentUserProvider = Provider<AppUser?>(
  (ref) => ref.watch(authNotifierProvider),
);
