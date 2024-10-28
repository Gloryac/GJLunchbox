import 'package:flutter/material.dart';
import 'dart:math' as math;

class WeightDisplay extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;

  const WeightDisplay({
    Key? key,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  _WeightDisplayState createState() => _WeightDisplayState();
}

class _WeightDisplayState extends State<WeightDisplay> {
  bool isKg = true;

  double get displayValue => isKg ? widget.value : widget.value * 2.20462;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Unit Toggle
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleButton('kg', isKg),
              _buildToggleButton('lb', !isKg),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Weight Display
        Stack(
          alignment: Alignment.center,
          children: [
            // Triangle Indicator
            Positioned(
              top: 0,
              child: CustomPaint(
                size: const Size(20, 10),
                painter: TrianglePainter(color: Colors.orange),
              ),
            ),

            // Value Container
            Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFB8C5B6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  displayValue.round().toString(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Scale
        SizedBox(
          width: 200,
          height: 100,
          child: CustomPaint(
            painter: ScalePainter(
              value: widget.value,
              isKg: isKg,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isKg = text == 'kg';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ScalePainter extends CustomPainter {
  final double value;
  final bool isKg;

  ScalePainter({required this.value, required this.isKg});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      paint,
    );

    // Draw ticks
    final tickCount = 20;
    final tickAngle = math.pi / (tickCount - 1);

    for (int i = 0; i < tickCount; i++) {
      final angle = math.pi + (i * tickAngle);
      final tickLength = i % 5 == 0 ? 15.0 : 10.0;

      final startPoint = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      final endPoint = Offset(
        center.dx + (radius - tickLength) * math.cos(angle),
        center.dy + (radius - tickLength) * math.sin(angle),
      );

      canvas.drawLine(startPoint, endPoint, paint);

      // Draw labels for major ticks
      if (i % 10 == 0) {
        final labelValue = (50 + (i * 2)).toString();
        final textPainter = TextPainter(
          text: TextSpan(
            text: labelValue,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        textPainter.paint(
          canvas,
          endPoint.translate(-textPainter.width / 2, 5),
        );
      }
    }

    // Draw indicator line
    final currentAngle = math.pi + (((value - 50) / 20) * math.pi);
    final indicatorPaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2;

    final indicatorEnd = Offset(
      center.dx + (radius - 5) * math.cos(currentAngle),
      center.dy + (radius - 5) * math.sin(currentAngle),
    );

    canvas.drawLine(center, indicatorEnd, indicatorPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}