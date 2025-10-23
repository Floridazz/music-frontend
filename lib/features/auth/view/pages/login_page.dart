import 'package:client_side/core/theme/app_pallete.dart';
import 'package:client_side/core/widgets/custom_field.dart';
import 'package:client_side/core/widgets/loader.dart';
import 'package:client_side/features/auth/view/pages/signup_page.dart';
import 'package:client_side/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils.dart';
import '../../../home/view/pages/home_page.dart';
import '../../viewmodel/auth_viewmodel.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    // ref.watch subscribes the widget to the provider, so whenever the provider’s state changes, the widget rebuilds automatically.
    // instead of rebuilding the widget on every state change, we only rebuild when isLoading changes
    final isLoading = ref.watch(
      authViewModelProvider.select((val) => val?.isLoading == true),
    );

    // ref.listen(provider, listener) lets you react to provider state changes without rebuilding the widget but is used for side effects instead
    // whenever the authViewModelProvider emits a new value (loading, data, or error), run the code inside this callback (the value here is AsyncValue type).
    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        // AsyncValue has a .when() method, which lets you cleanly handle its three possible states: success, error and loading.
        data: (data) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (_) => false,
          );
        },
        error: (error, st) {
          showSnackBar(context, 'Account created successfully! Please login.');
        },
        loading:
            () {}, //We don't do loader here because the listen function is type void, so basically we cant return anything.
      );
    });
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign In.',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomField(controller: emailController, hintText: 'Email'),
                    const SizedBox(height: 30),
                    CustomField(
                      controller: passwordController,
                      hintText: 'Password',
                      isObscureText: true,
                    ),
                    const SizedBox(height: 20),
                    AuthGradientButton(
                      buttonText: 'Sign in',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          // ref.read is like give me current data once and don't rebuild
                          await ref
                              .read(authViewModelProvider.notifier)
                              .loginUser(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                        } else {
                          showSnackBar(context, 'Missing fields!');
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: ' Sign Up',
                              style: TextStyle(
                                color: Pallete.gradient2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
