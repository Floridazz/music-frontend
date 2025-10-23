import 'package:client_side/core/providers/current_user_notifier.dart';
import 'package:client_side/core/theme/theme.dart';
import 'package:client_side/features/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/auth/view/pages/signup_page.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).initSharedPreferences();
  await container.read(authViewModelProvider.notifier).getData();
  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
  // WidgetsFlutterBinding.ensureInitialized();
  // runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    return MaterialApp(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      home: currentUser == null ? const SignupPage() : const HomePage(),
    );
  }
}
