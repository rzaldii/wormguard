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
          // ── Top bar ──
          _buildTopBar(),

          // ── Scrollable body ──
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.refresh(sensorDataProvider),
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
  //  TOP BAR
  // ────────────────────────────────────────────
  Widget _buildTopBar() {
  return Container(
    color: _bgGrey,
    child: SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
              ),
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
                          builder: (context) =>
                              const NotificationPage(),
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
                        color: Color(0xFF8B6B54),
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

            // Update text
            Text(
              'Update 5 Detik yang lalu',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}

  // ────────────────────────────────────────────
  //  SOIL MOISTURE CARD
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
          // Title bar
          _cardTitleBar('Soil Moisture'),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            child: Row(
              children: [
                // Donut chart
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
                          color: Color(0xFF8B6B54),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // Legend + badge
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
                      const SizedBox(height: 14),
                      _statusBadge(status),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Warning if needed
          if (moisture < 40)
            _warningBanner('Kelembaban terlalu rendah!'),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────
  //  WATER PH CARD
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
          _cardTitleBar('Water Ph'),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              children: [
                // pH gradient bar with indicator
                SizedBox(
                  height: 64,
                  child: CustomPaint(
                    painter: _PhGradientBarPainter(ph),
                    size: const Size(double.infinity, 64),
                  ),
                ),

                const SizedBox(height: 12),

                // Status badge
                _statusBadge(status),

                const SizedBox(height: 16),

                // Legend row
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
                      label: 'Basa',
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (ph < 6 || ph > 7.5)
            _warningBanner('pH di luar rentang normal!'),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────
  //  SHARED WIDGETS
  // ────────────────────────────────────────────
  Widget _cardTitleBar(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF8B6B54), width: 2),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8B6B54),
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

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF44824F),
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
//  DONUT CHART PAINTER
// ══════════════════════════════════════════════
class _DonutChartPainter extends CustomPainter {
  final double moisture;
  _DonutChartPainter(this.moisture);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    const strokeWidth = 18.0;

    final bgPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Dry segment (red) — e.g. bottom 25%
    final dryAngle = 2 * math.pi * ((100 - moisture) / 100);
    final dryPaint = Paint()
      ..color = Colors.red[400]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2 + 2 * math.pi * (moisture / 100),
      dryAngle,
      false,
      dryPaint,
    );

    // Moist segment (green)
    final moistAngle = 2 * math.pi * (moisture / 100);
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
  bool shouldRepaint(covariant _DonutChartPainter old) =>
      old.moisture != moisture;
}

// ══════════════════════════════════════════════
//  PH GRADIENT BAR PAINTER
// ══════════════════════════════════════════════
class _PhGradientBarPainter extends CustomPainter {
  final double ph;
  _PhGradientBarPainter(this.ph);

  @override
  void paint(Canvas canvas, Size size) {
    const barHeight = 22.0;
    final barTop = size.height - barHeight - 20;
    final barRect = Rect.fromLTWH(0, barTop, size.width, barHeight);
    final rRect = RRect.fromRectAndRadius(barRect, const Radius.circular(11));

    // Gradient: red → orange → yellow → green → teal
    final gradient = LinearGradient(
      colors: [
        Colors.red,
        // Colors.orange,
        Colors.yellow[700]!,
        Colors.green,
        // Colors.teal,
        Colors.blue,
        const Color.fromARGB(255, 114, 39, 176),

      ],
    ).createShader(barRect);

    final paint = Paint()..shader = gradient;
    canvas.drawRRect(rRect, paint);

    // Indicator triangle + line
    final indicatorX = (ph / 14) * size.width;
    final triangleTop = barTop - 18;

    // Percentage label above triangle
    final pct = ((ph / 14) * 100).toStringAsFixed(0);
    final tp = TextPainter(
      text: TextSpan(
        text: '$pct%',
        style: const TextStyle(
          color: Color(0xFF44824F),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(indicatorX - tp.width / 2, triangleTop - 16),
    );

    // Triangle
    final path = Path()
      ..moveTo(indicatorX, barTop - 2)
      ..lineTo(indicatorX - 7, triangleTop)
      ..lineTo(indicatorX + 7, triangleTop)
      ..close();

    canvas.drawPath(
      path,
      Paint()..color = const Color(0xFF44824F),
    );
  }

  @override
  bool shouldRepaint(covariant _PhGradientBarPainter old) => old.ph != ph;
}