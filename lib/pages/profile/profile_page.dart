import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  static const Color _green = Color(0xFF44824F);
  static const Color _brown = Color(0xFF8B6B54);

  bool _isEditing = false;
  final _namaController = TextEditingController(text: 'Bintang Carmenita');
  final _usernameController = TextEditingController(text: 'Carmen');

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Green top section with logo ──
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Green circle blob
              Container(
                height: 260,
                width: double.infinity,
                color: Colors.white,
                child: Stack(
                  children: [
                    Positioned(
                      top: -60,
                      left: -60,
                      right: -60,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: _green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Back button
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.chevron_left, color: Colors.black87),
                    ),
                  ),
                ),
              ),

              // Logo + name centered
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    // Logo shield placeholder
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/images/pp.png",
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'WormGuard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Form fields ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),

                  // Nama Lengkap field
                  _buildField(_namaController, 'Nama Lengkap'),
                  const SizedBox(height: 14),

                  // Username field
                  _buildField(_usernameController, 'Username'),
                  const SizedBox(height: 28),

                  // Edit / Simpan button
                  SizedBox(
                    width: 160,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () => setState(() => _isEditing = !_isEditing),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _brown,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        _isEditing ? 'Simpan' : 'Edit',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),

          // ── Logout bar ──
          GestureDetector(
            onTap: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!, width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      enabled: _isEditing,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70, fontSize: 15),
        filled: true,
        fillColor: const Color(0xFF5A9466),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}