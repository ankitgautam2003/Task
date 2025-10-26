import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Added Firebase options
import 'core/constants/app_colors.dart';
import 'core/providers/auth_providers.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/signup_screen.dart';
import 'presentation/screens/tasks_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Firebase initialization added

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);

    if (user != null) {
      return TasksScreen(onLogout: () => _handleLogout(ref));
    }

    return const AuthScreen();
  }

  void _handleLogout(WidgetRef ref) {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    authNotifier.signOut();
  }
}

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _showLogin = true;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  void _handleSignUp(String email, String password) async {
    try {
      final authNotifier = ref.read(authNotifierProvider.notifier);
      await authNotifier.signUp(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _handleSignIn(String email, String password) async {
    try {
      final authNotifier = ref.read(authNotifierProvider.notifier);
      await authNotifier.signIn(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(
        onGetStarted: () {
          setState(() {
            _showSplash = false;
          });
        },
      );
    }

    return _showLogin
        ? LoginScreen(
            onLogin: _handleSignIn,
            onSignUp: () {
              setState(() {
                _showLogin = false;
              });
            },
          )
        : SignUpScreen(
            onSignUp: _handleSignUp,
            onLogin: () {
              setState(() {
                _showLogin = true;
              });
            },
          );
  }
}
