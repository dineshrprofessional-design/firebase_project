import 'package:chart_application/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override   
  Widget build(BuildContext context) {
    
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login + Signup Animated App",
      home: LoginScreen(),
    );
  }
}
final  auth = FirebaseAuth.instance;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildGradientBackground(
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
                      child: _buildGlassCard(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildInputField(
                                label: "Email",
                                ctrl: emailCtrl,
                                icon: Icons.email,
                              ),

                              const SizedBox(height: 15),

                              _buildInputField(
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

                              _buildGradientButton(
                                text: "Login",
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    print("Login Success");
                                  }
                                },
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

// =======================================================================================
// CREATE ACCOUNT (SIGNUP) SCREEN
// =======================================================================================

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildGradientBackground(
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

                      _buildGlassCard(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildInputField(
                                label: "Full Name",
                                ctrl: nameCtrl,
                                icon: Icons.person,
                              ),

                              const SizedBox(height: 15),

                              _buildInputField(
                                label: "Email",
                                ctrl: emailCtrl,
                                icon: Icons.email,
                              ),

                              const SizedBox(height: 15),

                              _buildInputField(
                                label: "Password",
                                ctrl: passCtrl,
                                icon: Icons.lock,
                                isPassword: true,
                                obscure: obscure1,
                                onVisibilityTap: () {
                                  setState(() => obscure1 = !obscure1);
                                },
                              ),

                              const SizedBox(height: 15),

                              _buildInputField(
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

                              _buildGradientButton(
                                text: "Create Account",
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    print("Account Created");
                                  }
                                },
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

// =======================================================================================
// REUSABLE WIDGETS
// =======================================================================================

// Gradient background
Widget _buildGradientBackground({required Widget child}) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xff3E8EFB), Color(0xff6A4DF5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: child,
  );
}

// Frosted glass card
Widget _buildGlassCard({required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.symmetric(horizontal: 25),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
    ),
    child: child,
  );
}

// Input field
Widget _buildInputField({
  required String label,
  required TextEditingController ctrl,
  required IconData icon,
  bool isPassword = false,
  bool obscure = false,
  VoidCallback? onVisibilityTap,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: ctrl,
    obscureText: obscure,
    style: const TextStyle(color: Colors.white),
    validator: validator ?? (v) => v!.isEmpty ? "Please enter $label" : null,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      prefixIcon: Icon(icon, color: Colors.white),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
              onPressed: onVisibilityTap,
            )
          : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    ),
  );
}

// Gradient Button
Widget _buildGradientButton({
  required String text,
  required VoidCallback onTap,
}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 400),
    width: double.infinity,
    height: 50,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xffFBCB3E), Color(0xffF55F4D)],
      ),
      borderRadius: BorderRadius.circular(15),
    ),
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
