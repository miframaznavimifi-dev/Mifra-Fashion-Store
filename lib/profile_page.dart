import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'first_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = true;
  bool _isSaving = false;

  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Firestore-லிருந்து user data load பண்ணும்
  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      _email = user.email ?? '';

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        _nameController.text = data['name'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _addressController.text = data['address'] ?? '';
      } else {
        // Document இல்லாட்டால் email-லிருந்து name எடுக்கும்
        _nameController.text = user.displayName ?? '';
      }
    } catch (e) {
      _showSnack('Data load பண்ண முடியவில்லை: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Firestore-ல் user data save பண்ணும்
  Future<void> _saveUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    if (_nameController.text.trim().isEmpty) {
      _showSnack('பெயர் கட்டாயம் உள்ளிடவும்', isError: true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'email': _email,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Firebase Auth display name update
      await user.updateDisplayName(_nameController.text.trim());

      setState(() => _isEditing = false);
      _showSnack('Profile சேமிக்கப்பட்டது ✓');
    } on FirebaseException catch (e) {
      _showSnack('பிழை: ${e.message}', isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // Logout
  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout', style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold)),
        content: const Text('நிச்சயமாக logout பண்ணணுமா?', style: TextStyle(fontFamily: 'serif')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _auth.signOut();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const FirstPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBD232B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red : const Color(0xFF1D9E75),
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFFBD232B)))
            : Column(
                children: [
                  // Status Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('9:41',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                              color: Color(0xFFBD232B), shape: BoxShape.circle),
                          child: IconButton(
                            icon: const Padding(
                              padding: EdgeInsets.only(left: 6.0),
                              child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const Spacer(),
                        const Text('My Profile',
                            style: TextStyle(
                                fontFamily: 'serif',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        const Spacer(),
                        // Edit / Save button
                        GestureDetector(
                          onTap: _isEditing ? _saveUserData : () => setState(() => _isEditing = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: _isEditing ? const Color(0xFF1D9E75) : const Color(0xFFBD232B),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : Text(
                                    _isEditing ? 'Save' : 'Edit',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'serif',
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          // Avatar
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Color(0xFFBD232B),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _nameController.text.isNotEmpty
                                    ? _nameController.text[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'serif'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Email (read-only)
                          Text(_email,
                              style: const TextStyle(
                                  fontFamily: 'serif',
                                  fontSize: 14,
                                  color: Colors.black54)),
                          const SizedBox(height: 32),

                          // Form fields
                          _buildField(
                            label: 'Full Name',
                            controller: _nameController,
                            icon: Icons.person_outline,
                            enabled: _isEditing,
                          ),
                          const SizedBox(height: 20),
                          _buildField(
                            label: 'Phone Number',
                            controller: _phoneController,
                            icon: Icons.phone_outlined,
                            enabled: _isEditing,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 20),
                          _buildField(
                            label: 'Address',
                            controller: _addressController,
                            icon: Icons.location_on_outlined,
                            enabled: _isEditing,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 20),

                          // Email field (always read-only)
                          _buildField(
                            label: 'Email',
                            controller: TextEditingController(text: _email),
                            icon: Icons.email_outlined,
                            enabled: false,
                          ),
                          const SizedBox(height: 40),

                          // Order History shortcut
                          _buildMenuTile(
                            icon: Icons.shopping_bag_outlined,
                            title: 'Order History',
                            onTap: () {
                              Navigator.pushNamed(context, '/orders');
                            },
                          ),
                          const SizedBox(height: 12),

                          // Logout button
                          _buildMenuTile(
                            icon: Icons.logout,
                            title: 'Logout',
                            isDestructive: true,
                            onTap: _logout,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontFamily: 'serif',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black54)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: enabled ? const Color(0xFFF5F5F5) : const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: enabled ? const Color(0xFFBD232B) : Colors.transparent,
              width: enabled ? 1.5 : 0,
            ),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(
                fontFamily: 'serif', fontSize: 16, color: Colors.black),
            decoration: InputDecoration(
              prefixIcon: Icon(icon,
                  color: enabled ? const Color(0xFFBD232B) : Colors.black38,
                  size: 20),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDestructive
              ? const Color(0xFFFCEBEB)
              : const Color(0xFFDBDBDB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isDestructive ? const Color(0xFFBD232B) : Colors.black,
                size: 22),
            const SizedBox(width: 12),
            Text(title,
                style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDestructive ? const Color(0xFFBD232B) : Colors.black)),
            const Spacer(),
            Icon(Icons.arrow_forward_ios,
                size: 16,
                color: isDestructive ? const Color(0xFFBD232B) : Colors.black54),
          ],
        ),
      ),
    );
  }
}