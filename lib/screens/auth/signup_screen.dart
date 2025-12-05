import 'package:flutter/material.dart';
import '../../auth/auth_service.dart';
import '../../widgets/auth_widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  bool obscure1 = true;
  bool obscure2 = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await AuthService.createUserWithEmailAndPassword(
          email: emailCtrl.text,
          password: passCtrl.text,
          displayName: nameCtrl.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Account created successfully!"),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate back to login or to home screen
          Navigator.pop(context);
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
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    children: [
                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 30),

                      buildGlassCard(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              buildInputField(
                                label: "Full Name",
                                ctrl: nameCtrl,
                                icon: Icons.person,
                              ),

                              const SizedBox(height: 15),

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
                                obscure: obscure1,
                                onVisibilityTap: () {
                                  setState(() => obscure1 = !obscure1);
                                },
                                validator: (v) {
                                  if (v!.isEmpty) return "Please enter Password";
                                  if (v.length < 6) {
                                    return "Password must be at least 6 characters";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 15),

                              buildInputField(
                                label: "Confirm Password",
                                ctrl: confirmPassCtrl,
                                icon: Icons.lock,
                                isPassword: true,
                                obscure: obscure2,
                                onVisibilityTap: () {
                                  setState(() => obscure2 = !obscure2);
                                },
                                validator: (v) {
                                  if (v!.isEmpty) return "Required";
                                  if (v != passCtrl.text) {
                                    return "Passwords do not match";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              buildGradientButton(
                                text: "Create Account",
                                isLoading: _isLoading,
                                onTap: _isLoading ? null : _handleSignup,
                              ),

                              const SizedBox(height: 12),

                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Already have an account? Login",
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

