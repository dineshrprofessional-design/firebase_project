import 'package:flutter/material.dart';
import '../../auth/auth_service.dart';
import '../../widgets/auth_widgets.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  bool _obscure = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _logoAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 1)),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await AuthService.signInWithEmailAndPassword(
          email: emailCtrl.text,
          password: passCtrl.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login successful!"),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to home or next screen
          // Navigator.pushReplacement(...);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceFirst('Exception: ', '')),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildGradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// LOGO
                  ScaleTransition(
                    scale: _logoAnim,
                    child: const Icon(
                      Icons.lock_outline_rounded,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 15),

                  FadeTransition(
                    opacity: _fadeAnim,
                    child: const Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// LOGIN FORM
                  SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: buildGlassCard(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              buildInputField(
                                label: "Email",
                                ctrl: emailCtrl,
                                icon: Icons.email,
                                validator: (v) {
                                  if (v!.isEmpty) return "Please enter Email";
                                  if (!v.contains('@') || !v.contains('.')) {
                                    return "Please enter a valid email";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 15),

                              buildInputField(
                                label: "Password",
                                ctrl: passCtrl,
                                icon: Icons.lock,
                                isPassword: true,
                                obscure: _obscure,
                                onVisibilityTap: () {
                                  setState(() => _obscure = !_obscure);
                                },
                              ),

                              const SizedBox(height: 20),

                              buildGradientButton(
                                text: "Login",
                                isLoading: _isLoading,
                                onTap: _isLoading ? null : _handleLogin,
                              ),

                              const SizedBox(height: 12),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SignupScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Create an Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

