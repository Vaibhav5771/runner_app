import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';           // ← add this
import '../../components/custom_button.dart';
import '../../components/custom_textfield.dart';
import '../../components/social_button.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Print what we're trying
      print('Email: ${_emailController.text.trim()}');
      print('Password length: ${_passwordController.text.length}');

      // Check if Supabase is initialized
      try {
        final session = Supabase.instance.client.auth.currentSession;
        print('Current session: $session');
      } catch (e) {
        print('Error getting session: $e');
      }

      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      print('Response: ${response.toString()}');
      print('User: ${response.user}');
      print('Session: ${response.session}');

      if (response.user != null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _errorMessage = 'Login failed: No user returned';
        });
      }
    } on AuthException catch (e) {
      print('AuthException: ${e.message}');
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e, stackTrace) {
      print('Unknown error type: ${e.runtimeType}');
      print('Error message: $e');
      print('Stack trace: $stackTrace');

      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00C850),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            /// HEADER
            const Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              "Sign in to continue",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            /// WHITE CONTAINER
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show error if any
                      if (_errorMessage != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red.shade800),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      const Text("Email"),
                      const SizedBox(height: 8),

                      CustomTextField(
                        controller: _emailController,           // ← added
                        hint: "johndoe@gmail.com",
                        iconPath: "assets/icons/email.svg",
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 20),

                      const Text("Password"),
                      const SizedBox(height: 8),

                      CustomTextField(
                        controller: _passwordController,        // ← added
                        hint: "Enter your password",
                        iconPath: "assets/icons/password.svg",
                        isPassword: true,
                      ),

                      const SizedBox(height: 12),

                      // Optional: Forgot password link
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: implement forgot password (magic link or reset flow)
                          },
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(color: Color(0xFF00C850)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      CustomButton(
                        text: _isLoading ? "Signing in..." : "Sign In",
                        onPressed: !_isLoading ? _signIn : null,
                        // You can also change color/opacity when loading
                      ),

                      const SizedBox(height: 20),

                      /// OR
                      Row(
                        children: const [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("OR"),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const SocialButton(
                        text: "Continue with Google",
                        iconPath: "assets/icons/google.svg",
                      ),

                      const SizedBox(height: 16),

                      const SocialButton(
                        text: "Continue with Digilocker",
                        iconPath: "assets/icons/digilocker.svg",
                      ),

                      const SizedBox(height: 25),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: "Don’t have an account? ",
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: "Sign up",
                                  style: TextStyle(
                                    color: Color(0xFF00C850),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: Image.asset(
                          "assets/images/Logo.png",
                          height: 60,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}