import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/sensor_provider.dart';
import '../../widgets/custom_card.dart';
import '../../models/sensor_model.dart';

class MonitoringPage extends ConsumerStatefulWidget {
  const MonitoringPage({super.key});

  @override
  ConsumerState<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends ConsumerState<MonitoringPage> {
  @override
  Widget build(BuildContext context) {
    final sensorAsync = ref.watch(sensorDataProvider);
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WormGuard Monitoring'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(sensorDataProvider),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(sensorDataProvider),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Status Koneksi
              _buildConnectionStatus(),
              const SizedBox(height: 16),

              // Card Soil Moisture
              sensorAsync.when(
                data: (data) => _buildMoistureCard(data),
                loading: () => const CustomCard(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => CustomCard(
                  child: Text('Error: $err'),
                ),
              ),
              const SizedBox(height: 16),

              // Card pH Air
              sensorAsync.when(
                data: (data) => _buildPhCard(data),
                loading: () => const CustomCard(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => CustomCard(
                  child: Text('Error: $err'),
                ),
              ),
              const SizedBox(height: 24),

              // Section Riwayat Singkat
              const Text(
                'Riwayat Sensor Terbaru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              historyAsync.when(
                data: (history) => _buildHistoryList(history),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Gagal memuat riwayat: $err'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Online',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildMoistureCard(SensorData data) {
    final moisture = data.soilMoisture;
    final status = data.moistureStatus;
    Color statusColor;
    if (status == 'Kering') statusColor = Colors.orange;
    else if (status == 'Normal') statusColor = Colors.green;
    else statusColor = Colors.blue;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kelembaban Tanah',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: moisture / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            minHeight: 20,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 8),
          Text(
            '${moisture.toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('0%'),
              Text('100%', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          if (moisture < 40)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Peringatan: Kelembaban terlalu rendah!',
                        style: TextStyle(color: Colors.red),
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

  Widget _buildPhCard(SensorData data) {
    final ph = data.ph;
    final status = data.phStatus;
    Color statusColor;
    if (status == 'Asam') statusColor = Colors.red;
    else if (status == 'Netral') statusColor = Colors.green;
    else statusColor = Colors.purple;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'pH Air',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              height: 100,
              child: CustomPaint(
                painter: _PhBarPainter(ph),
                size: const Size(double.infinity, 100),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'pH: ${ph.toStringAsFixed(1)}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          if (ph < 6 || ph > 7.5)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Peringatan: pH di luar rentang normal!',
                        style: TextStyle(color: Colors.orange),
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

  Widget _buildHistoryList(List<Map<String, dynamic>> history) {
    return Column(
      children: history.map((item) {
        final isSoil = item['type'] == 'soil';
        final value = item['value'];
        final time = item['timestamp'] as DateTime;
        return ListTile(
          leading: Icon(
            isSoil ? Icons.water_drop : Icons.science,
            color: isSoil ? Colors.blue : Colors.purple,
          ),
          title: Text(isSoil ? 'Kelembaban: $value%' : 'pH: $value'),
          subtitle: Text('${time.hour}:${time.minute.toString().padLeft(2, '0')}'),
          dense: true,
        );
      }).toList(),
    );
  }
}

// Custom painter untuk pH bar
class _PhBarPainter extends CustomPainter {
  final double ph;
  _PhBarPainter(this.ph);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    final barWidth = size.width * 0.8;
    final barLeft = (size.width - barWidth) / 2;
    final barHeight = 30.0;
    final barTop = (size.height - barHeight) / 2;

    // Background bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(barLeft, barTop, barWidth, barHeight),
        const Radius.circular(15),
      ),
      paint,
    );

    // Colored indicator
    double indicatorX = barLeft + (ph / 14) * barWidth;
    Paint indicatorPaint = Paint()
      ..color = _getPhColor(ph)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(indicatorX, barTop + barHeight / 2),
      15,
      indicatorPaint,
    );

    // Range text
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '0',
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(barLeft - 5, barTop + barHeight + 5));

    final textPainter2 = TextPainter(
      text: const TextSpan(
        text: '14',
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter2.layout();
    textPainter2.paint(canvas, Offset(barLeft + barWidth - 10, barTop + barHeight + 5));
  }

  Color _getPhColor(double ph) {
    if (ph < 6) return Colors.red;
    if (ph <= 7.5) return Colors.green;
    return Colors.purple;
  }

  @override
  bool shouldRepaint(covariant _PhBarPainter oldDelegate) {
    return oldDelegate.ph != ph;
  }
}