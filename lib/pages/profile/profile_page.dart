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
  static const Color _bgGrey = Color(0xFFF0F0F0);
  static const Color _red = Color(0xFFD32F2F);

  String _username = 'carmen_cihui';

  // ── 1. Edit dialog ──
  void _showEditDialog() {
    final usernameCtrl = TextEditingController(text: _username);
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: _brown,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
              child: Row(
              ),
            ),
              TextField(
                controller: usernameCtrl,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: _green),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Batal — stroke cokelat, teks cokelat
                  OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _brown, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                    ),
                    child: const Text('Batal',
                        style: TextStyle(
                            color: _brown,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 12),
                  // Simpan — background cokelat, teks putih
                  ElevatedButton(
                    onPressed: () {
                      final newUsername = usernameCtrl.text.trim();
                      Navigator.of(ctx).pop();
                      _showConfirmSaveDialog(newUsername);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _brown,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                    ),
                    child: const Text('Simpan',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── 2. Konfirmasi simpan ──
  void _showConfirmSaveDialog(String newUsername) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 48),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Apakah anda yakin?',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Batal kiri — kembali ke edit dialog
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _showEditDialog();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _brown, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                    ),
                    child: const Text('Batal',
                        style: TextStyle(
                            color: _brown,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 12),
                  // Simpan kanan — simpan & tutup
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _username = newUsername);
                      Navigator.of(ctx).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _brown,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                    ),
                    child: const Text('Simpan',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── 3. Konfirmasi logout ──
  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 48),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Apakah anda yakin Logout?',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Batal kiri — stroke cokelat, teks cokelat
                  OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _brown, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                    ),
                    child: const Text('Batal',
                        style: TextStyle(
                            color: _brown,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 12),
                  // Ya kanan — background cokelat, teks putih
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      ref.read(authProvider.notifier).logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _brown,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 8),
                    ),
                    child: const Text('Ya',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgGrey,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
              ),
            ),

            // ── Title ──
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: _brown,
              ),
            ),

            const SizedBox(height: 24),

            // ── Avatar ──
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 56, color: _green),
            ),

            const SizedBox(height: 10),

            // ── Username label ──
            Text(
              _username,
              style: const TextStyle(
                fontSize: 18,
                color: _green,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 28),

            // ── Menu card ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuRow(
                      icon: Icons.edit_outlined,
                      iconColor: Colors.black87,
                      label: 'Edit Profile',
                      labelColor: Colors.black87,
                      onTap: _showEditDialog,
                      showDivider: true,
                    ),
                    _buildMenuRow(
                      icon: Icons.logout_rounded,
                      iconColor: _red,
                      label: 'Logout',
                      labelColor: _red,
                      onTap: _showLogoutDialog,
                      showDivider: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required Color labelColor,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      color: labelColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward, color: labelColor, size: 18),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: Colors.grey[200],
            indent: 20,
            endIndent: 20,
          ),
      ],
    );
  }
}