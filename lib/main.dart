import 'package:client_side/core/providers/current_user_notifier.dart';
import 'package:client_side/core/theme/theme.dart';
import 'package:client_side/features/auth/view/pages/signup_page.dart';
import 'package:client_side/features/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/auth/viewmodel/auth_viewmodel.dart';

void main() async {
  // 1. Ensure Flutter is ready
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Riverpod container
  final container = ProviderContainer();

  // 3. Load SharedPreferences (where the token is saved)
  await container.read(authViewModelProvider.notifier).initSharedPreferences();

  // 4. Check for existing login token and fetch user data
  await container.read(authViewModelProvider.notifier).getData();

  // 5. Start the App
  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the user's authentication status
    final currentUser = ref.watch(currentUserProvider);
    return MaterialApp(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      home: currentUser == null ? const SignupPage() : const HomePage(),
    );
  }
}
