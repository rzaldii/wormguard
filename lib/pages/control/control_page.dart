import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/control_provider.dart';
import '../../models/control_model.dart';

class ControlPage extends ConsumerStatefulWidget {
  const ControlPage({super.key});

  @override
  ConsumerState<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends ConsumerState<ControlPage> {
  static const Color _green = Color(0xFF44824F);
  static const Color _brown = Color(0xFF8B6B54);
  static const Color _bgGrey = Color(0xFFF0F0F0);
  static const Color _blue = Color(0xFF2196F3);

  // ✅ Tambahan: update langsung + snackbar
  void _updatePump(bool status) {
    final control = ref.read(controlProvider);

    ref.read(controlProvider.notifier).state = ControlModel(
      isAuto: control.isAuto,
      pumpStatus: status,
    );

    final message = status ? 'Otomatisasi Berhasil Diaktifkan' : 'Otomatisasi Berhasil Dinonaktifkan';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Peringatan: $message',
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _showEditDialog() {}

  // void _showSuccessDialog() {}

  @override
  Widget build(BuildContext context) {
    final control = ref.watch(controlProvider);

    return Scaffold(
      backgroundColor: _bgGrey,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                // children: [
                //   GestureDetector(
                //     onTap: () => Navigator.maybePop(context),
                //     child: Container(
                //       width: 40,
                //       height: 40,
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         shape: BoxShape.circle,
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.black.withOpacity(0.08),
                //             blurRadius: 6,
                //             offset: const Offset(0, 2),
                //           ),
                //         ],
                //       ),
                //       child: const Icon(Icons.chevron_left, color: Colors.black87),
                //     ),
                //   ),
                // ],
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Kontrol Otomatisasi',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _brown,
              ),
            ),
            Text(
              'WormGuard',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 24),

            // Main card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Status Pompa (sekarang toggle langsung)
                    GestureDetector(
                      onTap: () => _updatePump(!control.pumpStatus),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.access_time,
                                        size: 14, color: Colors.grey[500]),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Status Otomatisasi',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: control.pumpStatus
                                            ? _green
                                            : Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      control.pumpStatus ? 'Aktif' : 'Mati',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Terakhir update: ${TimeOfDay.now().format(context)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),

                            Container(
                              width: 72,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _blue.withOpacity(0.6),
                                  width: 2,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(Icons.water_drop,
                                      color: Colors.grey[500], size: 28),
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: control.pumpStatus
                                            ? _green
                                            : Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Kontrol Pompa
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kontrol Otomatisasi',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),

                          Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _updatePump(true),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      decoration: BoxDecoration(
                                        color: control.pumpStatus
                                            ? _blue
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'ON',
                                        style: TextStyle(
                                          color: control.pumpStatus
                                              ? Colors.white
                                              : Colors.black45,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _updatePump(false),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      decoration: BoxDecoration(
                                        color: !control.pumpStatus
                                            ? _blue
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'OFF',
                                        style: TextStyle(
                                          color: !control.pumpStatus
                                              ? Colors.white
                                              : Colors.black45,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
}