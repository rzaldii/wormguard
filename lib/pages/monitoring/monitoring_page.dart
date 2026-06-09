import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/sensor_provider.dart';
import '../../models/sensor_model.dart';
import '../notification/notification_page.dart';

class MonitoringPage extends ConsumerStatefulWidget {
  const MonitoringPage({super.key});

  @override
  ConsumerState<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends ConsumerState<MonitoringPage> {
  static const Color _green = Color(0xFF44824F);
  static const Color _brown = Color(0xFF8B6B54);
  static const Color _bgGrey = Color(0xFFF0F0F0);

  @override
  Widget build(BuildContext context) {
    final sensorAsync = ref.watch(sensorDataProvider);

    return Scaffold(
      backgroundColor: _bgGrey,
      body: Column(
        children: [
          sensorAsync.when(
            data: (data) => _buildTopBar(data),
            loading: () => _buildTopBar(null),
            error: (_, __) => _buildTopBar(null),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.refresh(sensorDataProvider);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: sensorAsync.when(
                  data: (data) => Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildSoilMoistureCard(data),
                      const SizedBox(height: 16),
                      _buildPhCard(data),
                    ],
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, _) => Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Center(child: Text('Error: $err')),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────
  // TOP BAR
  // ────────────────────────────────────────────
  Widget _buildTopBar(SensorData? data) {
    return Container(
      color: _bgGrey,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(),
              ),

              const SizedBox(height: 8),

              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationPage(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
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
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Monitoring',
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
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                _getUpdateText(data),
                style: TextStyle(
                  fontSize: 12,
                  color: data?.pump == true ? _green : Colors.grey[500],
                  fontWeight: data?.pump == true
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String _getUpdateText(SensorData? data) {
    if (data == null) {
      return 'Menunggu data sensor...';
    }

    if (data.pump) {
      return 'Penyemprotan sedang berjalan';
    }

    final updateTime = _parseTimestamp(data.timestamp);
    final now = DateTime.now();
    final diff = now.difference(updateTime);

    if (diff.inSeconds < 5) {
      return 'Update baru saja';
    }

    if (diff.inSeconds < 60) {
      return 'Update ${diff.inSeconds} detik yang lalu';
    }

    if (diff.inMinutes < 60) {
      return 'Update ${diff.inMinutes} menit yang lalu';
    }

    if (diff.inHours < 24) {
      return 'Update ${diff.inHours} jam yang lalu';
    }

    return 'Update ${diff.inDays} hari yang lalu';
  }

  DateTime _parseTimestamp(int timestamp) {
    if (timestamp <= 0) {
      return DateTime.now();
    }

    if (timestamp > 1000000000000) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }

    if (timestamp > 1000000000) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    }

    return DateTime.now();
  }

  // ────────────────────────────────────────────
  // SOIL MOISTURE CARD
  // ────────────────────────────────────────────
  Widget _buildSoilMoistureCard(SensorData data) {
    final moisture = data.soilMoisture;
    final status = data.moistureStatus;

    return Container(
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
          _cardTitleBar('Soil Moisture'),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            child: Row(
              children: [
                SizedBox(
                  width: 130,
                  height: 130,
                  child: CustomPaint(
                    painter: _DonutChartPainter(moisture),
                    child: Center(
                      child: Text(
                        '${moisture.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _brown,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _legendItem(
                        color: Colors.red[400]!,
                        icon: Icons.cancel_outlined,
                        label: 'Kering',
                      ),
                      const SizedBox(height: 10),
                      _legendItem(
                        color: _green,
                        icon: Icons.check_circle_outline,
                        label: 'Normal',
                      ),
                      const SizedBox(height: 10),
                      _legendItem(
                        color: Colors.blue,
                        icon: Icons.water_drop_outlined,
                        label: 'Basah',
                      ),
                      const SizedBox(height: 14),
                      _statusBadge(status, color: _soilStatusColor(moisture)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (moisture < 50) _warningBanner('Kelembaban terlalu rendah!'),
        ],
      ),
    );
  }

  Color _soilStatusColor(double moisture) {
    if (moisture < 50) return Colors.red;
    if (moisture <= 60) return _green;
    return Colors.blue;
  }

  // ────────────────────────────────────────────
  // WATER PH CARD
  // ────────────────────────────────────────────
  Widget _buildPhCard(SensorData data) {
    final ph = data.ph;
    final status = data.phStatus;

    return Container(
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
          _cardTitleBar('Water pH'),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              children: [
                SizedBox(
                  height: 74,
                  child: CustomPaint(
                    painter: _PhGradientBarPainter(ph),
                    size: const Size(double.infinity, 74),
                  ),
                ),

                const SizedBox(height: 12),

                _statusBadge(status, color: _phGradientColor(ph)),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _legendItem(
                      color: Colors.red,
                      icon: Icons.cancel_outlined,
                      label: 'Asam',
                    ),
                    _legendItem(
                      color: _green,
                      icon: Icons.check_circle_outline,
                      label: 'Normal',
                    ),
                    _legendItem(
                      color: Colors.purple,
                      icon: Icons.science_outlined,
                      label: 'Basa',
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '0',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    Text(
                      '6',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    Text(
                      '7.5',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    Text(
                      '14',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (ph < 6 || ph > 7.5) _warningBanner('pH di luar rentang normal!'),
        ],
      ),
    );
  }

  Color _phStatusColor(double ph) {
    if (ph < 6) return Colors.red;
    if (ph <= 7.5) return _green;
    return Colors.purple;
  }

  Color _phGradientColor(double ph) {
    final safePh = ph.clamp(0, 14).toDouble();

    if (safePh <= 3.5) {
      return Color.lerp(Colors.red, Colors.yellow[700]!, safePh / 3.5)!;
    }

    if (safePh <= 7.0) {
      return Color.lerp(
        Colors.yellow[700]!,
        Colors.green,
        (safePh - 3.5) / 3.5,
      )!;
    }

    if (safePh <= 10.5) {
      return Color.lerp(Colors.green, Colors.blue, (safePh - 7.0) / 3.5)!;
    }

    return Color.lerp(
      Colors.blue,
      const Color.fromARGB(255, 114, 39, 176),
      (safePh - 10.5) / 3.5,
    )!;
  }

  // ────────────────────────────────────────────
  // SHARED WIDGETS
  // ────────────────────────────────────────────
  Widget _cardTitleBar(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _brown, width: 2)),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: _brown,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _legendItem({
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status, {Color color = _green}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.check, color: Colors.white, size: 14),
        ],
      ),
    );
  }

  Widget _warningBanner(String message) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
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
    );
  }
}

// ══════════════════════════════════════════════
// DONUT CHART PAINTER
// ══════════════════════════════════════════════
class _DonutChartPainter extends CustomPainter {
  final double moisture;

  _DonutChartPainter(this.moisture);

  @override
  void paint(Canvas canvas, Size size) {
    final safeMoisture = moisture.clamp(0, 100).toDouble();

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    const strokeWidth = 18.0;

    final bgPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final dryAngle = 2 * math.pi * ((100 - safeMoisture) / 100);
    final dryPaint = Paint()
      ..color = Colors.red[400]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2 + 2 * math.pi * (safeMoisture / 100),
      dryAngle,
      false,
      dryPaint,
    );

    final moistAngle = 2 * math.pi * (safeMoisture / 100);
    final moistPaint = Paint()
      ..color = const Color(0xFF44824F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      moistAngle,
      false,
      moistPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.moisture != moisture;
  }
}

// ══════════════════════════════════════════════
// PH GRADIENT BAR PAINTER
// ══════════════════════════════════════════════
class _PhGradientBarPainter extends CustomPainter {
  final double ph;

  _PhGradientBarPainter(this.ph);

  Color _colorForPh(double ph) {
    final safePh = ph.clamp(0, 14).toDouble();

    if (safePh <= 3.5) {
      return Color.lerp(Colors.red, Colors.yellow[700]!, safePh / 3.5)!;
    }

    if (safePh <= 7.0) {
      return Color.lerp(
        Colors.yellow[700]!,
        Colors.green,
        (safePh - 3.5) / 3.5,
      )!;
    }

    if (safePh <= 10.5) {
      return Color.lerp(Colors.green, Colors.blue, (safePh - 7.0) / 3.5)!;
    }

    return Color.lerp(
      Colors.blue,
      const Color.fromARGB(255, 114, 39, 176),
      (safePh - 10.5) / 3.5,
    )!;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final safePh = ph.clamp(0, 14).toDouble();

    const barHeight = 22.0;
    final barTop = size.height - barHeight - 20;
    final barRect = Rect.fromLTWH(0, barTop, size.width, barHeight);
    final rRect = RRect.fromRectAndRadius(barRect, const Radius.circular(11));

    final gradient = LinearGradient(
      colors: [
        Colors.red,
        Colors.yellow[700]!,
        Colors.green,
        Colors.blue,
        const Color.fromARGB(255, 114, 39, 176),
      ],
    ).createShader(barRect);

    final paint = Paint()..shader = gradient;
    canvas.drawRRect(rRect, paint);

    final indicatorX = (safePh / 14) * size.width;
    final triangleTop = barTop - 18;

    final indicatorColor = _colorForPh(safePh);

    final phLabel = 'pH ${safePh.toStringAsFixed(1)}';

    final tp = TextPainter(
      text: TextSpan(
        text: phLabel,
        style: TextStyle(
          color: indicatorColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    double labelX = indicatorX - tp.width / 2;

    if (labelX < 0) {
      labelX = 0;
    }

    if (labelX + tp.width > size.width) {
      labelX = size.width - tp.width;
    }

    tp.paint(canvas, Offset(labelX, triangleTop - 18));

    final path = Path()
      ..moveTo(indicatorX, barTop - 2)
      ..lineTo(indicatorX - 7, triangleTop)
      ..lineTo(indicatorX + 7, triangleTop)
      ..close();

    canvas.drawPath(path, Paint()..color = indicatorColor);
  }

  @override
  bool shouldRepaint(covariant _PhGradientBarPainter oldDelegate) {
    return oldDelegate.ph != ph;
  }
}
