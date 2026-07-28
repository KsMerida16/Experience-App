import 'package:experience_app/feature/auth/presentation/state/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;

  bool obscureConfirm = true;

  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 30),

              GestureDetector(
                onTap: () {
                  context.pop();
                },

                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF006FFD),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Create Account',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                'Create an account to start shopping.',
                style: TextStyle(color: Color(0xFF71727A)),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: nameController,
                decoration: _inputDecoration('Full name'),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('Email'),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: obscurePassword,

                decoration: _inputDecoration('Password').copyWith(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: confirmPasswordController,
                obscureText: obscureConfirm,

                decoration: _inputDecoration('Confirm password').copyWith(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureConfirm = !obscureConfirm;
                      });
                    },
                    icon: Icon(
                      obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006FFD),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (passwordController.text !=
                              confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Passwords do not match'),
                              ),
                            );

                            return;
                          }

                          setState(() => isSubmitting = true);

                          await ref
                              .read(authProvider.notifier)
                              .signUp(
                                emailController.text.trim(),
                                passwordController.text,
                                name: nameController.text.trim(),
                              );

                          if (!context.mounted) return;

                          final state = ref.read(authProvider);

                          setState(() => isSubmitting = false);

                          if (state.hasError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(_mapError(state.error))),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Account created successfully'),
                              ),
                            );

                            context.pop();
                          }
                        },

                  child: isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Create Account',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () {
                    context.pop();
                  },

                  child: const Text(
                    'Already have an account? Sign In',
                    style: TextStyle(color: Color(0xFF006FFD)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _mapError(Object? error) {
    if (error is Exception &&
        error.toString().contains('email-already-in-use')) {
      return 'Ese correo ya está registrado';
    }
    if (error is Exception && error.toString().contains('weak-password')) {
      return 'La contraseña es muy débil (mínimo 6 caracteres)';
    }
    return 'No se pudo crear la cuenta';
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,

      filled: true,
      fillColor: const Color(0xFFF8F9FE),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFE8E9F1)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF006FFD), width: 2),
      ),
    );
  }
}
