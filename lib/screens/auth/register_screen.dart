import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../components/custom_button.dart';
import '../../components/custom_textfield.dart';
import '../../components/social_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    // Validate inputs
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your name';
      });
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email';
      });
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a password';
      });
      return;
    }

    if (_passwordController.text.length < 6) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters';
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Print what we're trying
      print('Name: ${_nameController.text.trim()}');
      print('Email: ${_emailController.text.trim()}');
      print('Password length: ${_passwordController.text.length}');

      // Check if Supabase is initialized
      try {
        final session = Supabase.instance.client.auth.currentSession;
        print('Current session: $session');
      } catch (e) {
        print('Error getting session: $e');
      }

      // Sign up with Supabase
      final response = await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        data: {
          'name': _nameController.text.trim(),
        },
      );

      print('Response: ${response.toString()}');
      print('User: ${response.user}');
      print('Session: ${response.session}');

      if (response.user != null) {
        if (!mounted) return;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.user!.confirmedAt != null
                  ? 'Registration successful!'
                  : 'Registration successful! Please check your email to confirm your account.',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // Add a small delay to show the success message
        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;

        // Navigate to home page after successful registration
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _errorMessage = 'Registration failed: No user returned';
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
              "Create Account",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              "Sign up to get started",
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
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red.shade800),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Name Field
                      const Text(
                        "Full Name",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      CustomTextField(
                        controller: _nameController,
                        hint: "John Doe",
                        iconPath: "assets/icons/avatar.svg",
                        keyboardType: TextInputType.name,
                      ),

                      const SizedBox(height: 20),

                      // Email Field
                      const Text(
                        "Email",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      CustomTextField(
                        controller: _emailController,
                        hint: "johndoe@gmail.com",
                        iconPath: "assets/icons/email.svg",
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 20),

                      // Password Field
                      const Text(
                        "Password",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      CustomTextField(
                        controller: _passwordController,
                        hint: "Create a password",
                        iconPath: "assets/icons/password.svg",
                        isPassword: true,
                      ),

                      const SizedBox(height: 20),

                      // Confirm Password Field
                      const Text(
                        "Confirm Password",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      CustomTextField(
                        controller: _confirmPasswordController,
                        hint: "Re-enter your password",
                        iconPath: "assets/icons/password.svg",
                        isPassword: true,
                      ),

                      const SizedBox(height: 30),

                      // Sign Up Button
                      CustomButton(
                        text: _isLoading ? "Creating Account..." : "Sign Up",
                        onPressed: !_isLoading ? _signUp : null,
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

                      // Sign In Link
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: "Sign in",
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

                      // Logo
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