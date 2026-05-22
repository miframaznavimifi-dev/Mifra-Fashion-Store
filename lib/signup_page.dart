import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _rememberMe = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ✅ Firebase Auth register
  Future<void> _signup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showSnack('Please fill in all fields!', isError: true);
      return;
    }

    if (password != confirm) {
      _showSnack('Passwords do not match!', isError: true);
      return;
    }

    if (password.length < 6) {
      _showSnack('Password must be at least 6 characters!', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // ✅ Firebase Auth-ல் register
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✅ Display name update
      await credential.user?.updateDisplayName(name);

      // ✅ Firestore-ல் user details save
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'phone': '',
        'address': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // ✅ Register success → HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed!';
      if (e.code == 'email-already-in-use') message = 'This email is already in use!';
      if (e.code == 'weak-password') message = 'Password is too weak!';
      if (e.code == 'invalid-email') message = 'Invalid email address!';
      _showSnack(message, isError: true);
    } catch (e) {
      _showSnack('Error: $e', isError: true);
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
                      icon: const Padding(padding: EdgeInsets.only(left: 6.0),
                          child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Expanded(
                    child: Text('MIFRA\nFASHION STORES',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'serif', fontSize: 20,
                          fontWeight: FontWeight.bold, height: 1.2, color: Colors.black87)),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 40),

              const Text('Sign Up',
                style: TextStyle(fontFamily: 'serif', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 4),
              const Text('Create a new account',
                style: TextStyle(fontFamily: 'serif', fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
              const SizedBox(height: 40),

              // ✅ User Name
              _buildLabel('User Name'),
              _buildTextField(_nameController, false),
              const SizedBox(height: 24),

              // ✅ Email
              _buildLabel('Email'),
              _buildTextField(_emailController, false, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 24),

              // ✅ Password
              _buildLabel('Password'),
              _buildPasswordField(_passwordController, _obscurePassword, () {
                setState(() => _obscurePassword = !_obscurePassword);
              }),
              const SizedBox(height: 24),

              // ✅ Confirm Password
              _buildLabel('Confirm Password'),
              _buildPasswordField(_confirmPasswordController, _obscureConfirm, () {
                setState(() => _obscureConfirm = !_obscureConfirm);
              }),
              const SizedBox(height: 24),

              // Remember me
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (val) => setState(() => _rememberMe = val ?? false),
                    activeColor: const Color(0xFFBD232B),
                  ),
                  const Text('Remember me',
                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'serif', color: Colors.black87)),
                ],
              ),
              const SizedBox(height: 40),

              // ✅ Signup Button — Firebase register
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBD232B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign Up',
                          style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'serif')),
                ),
              ),
              const SizedBox(height: 20),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ',
                      style: TextStyle(fontFamily: 'serif', fontSize: 14)),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => const LoginPage())),
                    child: const Text('Login',
                        style: TextStyle(fontFamily: 'serif', fontSize: 14,
                            fontWeight: FontWeight.bold, color: Color(0xFFBD232B))),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(label,
          style: const TextStyle(fontFamily: 'serif', fontSize: 16,
              fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }

  Widget _buildTextField(TextEditingController controller, bool obscure,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        contentPadding: EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, bool obscure, VoidCallback toggle) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.black54),
          onPressed: toggle,
        ),
      ),
    );
  }
}