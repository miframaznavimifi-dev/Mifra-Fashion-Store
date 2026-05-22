import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ✅ Firebase Auth login
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack('Email மற்றும் Password உள்ளிடவும்!', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      // ✅ Login success → HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Login தோல்வி!';
      if (e.code == 'user-not-found') message = 'இந்த email பதிவு செய்யப்படவில்லை!';
      if (e.code == 'wrong-password') message = 'Password தவறு!';
      if (e.code == 'invalid-email') message = 'Email சரியில்லை!';
      if (e.code == 'invalid-credential') message = 'Email அல்லது Password தவறு!';
      _showSnack(message, isError: true);
    } catch (e) {
      _showSnack('பிழை: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red : const Color(0xFF1D9E75),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Bar
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('9:41', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
                    Row(children: const [
                      Icon(Icons.signal_cellular_4_bar, size: 16, color: Colors.black),
                      SizedBox(width: 4),
                      Icon(Icons.wifi, size: 16, color: Colors.black),
                      SizedBox(width: 4),
                      Icon(Icons.battery_full, size: 16, color: Colors.black),
                    ]),
                  ],
                ),
              ),

              // Header
              Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: const BoxDecoration(color: Color(0xFFBD232B), shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Padding(
                        padding: EdgeInsets.only(left: 6.0),
                        child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Expanded(
                    child: Text('MIFRA\nFASHION STORES',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'serif', fontSize: 20, fontWeight: FontWeight.bold, height: 1.2, color: Colors.black87)),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 40),

              // Welcome text
              const Text('Welcome!',
                style: TextStyle(fontFamily: 'serif', fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 4),
              const Text('Please login or sign up to continue\nexploring the app',
                style: TextStyle(fontFamily: 'serif', fontSize: 15, color: Colors.black87, height: 1.3, fontWeight: FontWeight.w600)),
              const SizedBox(height: 48),

              // ✅ Email field — controller connected
              const Text('Email',
                style: TextStyle(fontFamily: 'serif', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
              const SizedBox(height: 24),

              // ✅ Password field — controller connected
              const Text('Password',
                style: TextStyle(fontFamily: 'serif', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.black),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // ✅ Sign in Button — Firebase login
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBD232B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign in',
                          style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'serif')),
                ),
              ),
              const SizedBox(height: 20),

              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Account இல்லையா? ',
                      style: TextStyle(fontFamily: 'serif', fontSize: 14)),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupPage()),
                    ),
                    child: const Text('Sign Up',
                        style: TextStyle(fontFamily: 'serif', fontSize: 14,
                            fontWeight: FontWeight.bold, color: Color(0xFFBD232B))),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Center(
                child: Text('or', style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 20),

              // Social buttons
              _buildSocialBtn('Continue with Facebook', const Color(0xFF4039BA), Colors.black,
                const CircleAvatar(backgroundColor: Colors.white, radius: 14,
                  child: Icon(Icons.facebook, color: Colors.black, size: 24))),
              const SizedBox(height: 16),
              _buildSocialBtn('Continue with Google', const Color(0xFFDCDCDC), Colors.black,
                const CircleAvatar(backgroundColor: Colors.white, radius: 14,
                  child: Text('G', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)))),
              const SizedBox(height: 16),
              _buildSocialBtn('Continue with Apple', const Color(0xFFDCDCDC), Colors.black,
                const Icon(Icons.apple, color: Colors.black, size: 28)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtn(String text, Color bgColor, Color textColor, Widget iconWidget) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Padding(padding: const EdgeInsets.only(left: 8.0), child: iconWidget),
            Center(
              child: Text(text,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'serif', fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}