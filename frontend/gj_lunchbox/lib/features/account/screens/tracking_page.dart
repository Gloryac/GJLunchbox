import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  DateTime selectedDate = DateTime.now();
  late List<String> months;
  late int selectedMonthIndex;

  @override
  void initState() {
    super.initState();
    _initializeMonths();
  }

  void _initializeMonths() {
    final now = DateTime.now();
    months = [];

    // Generate 12 months starting from current month
    for (int i = 0; i < 12; i++) {
      final monthDate = DateTime(now.year, now.month + i, 1);
      months.add(_getMonthName(monthDate.month));
    }

    selectedMonthIndex = 0; // Current month is selected by default
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month - 1];
  }

  void _onMonthSelected(int index) {
    setState(() {
      selectedMonthIndex = index;
      final now = DateTime.now();
      selectedDate = DateTime(now.year, now.month + index, 1);
    });

    // Here you can add callback to connect with meal plan page
    _onMonthChanged(selectedDate);
  }

  void _onMonthChanged(DateTime date) {
    // TODO: Connect this to your meal plan page
    // You can pass this date to update meal plans, calories, etc.
    print('Month changed to: ${_getMonthName(date.month)} ${date.year}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tracking',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Analyze your monthly and annual calorie intake\nfrom the calculated statistics below',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              _buildMonthSelector(),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildCalorieScoreCard(),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildCalorieChart(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: months.asMap().entries.map((entry) {
          final index = entry.key;
          final month = entry.value;
          return GestureDetector(
            onTap: () => _onMonthSelected(index),
            child: _buildMonthButton(month, index == selectedMonthIndex),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMonthButton(String month, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.only(right: 32),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange[600]?.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          month,
          style: TextStyle(
            color: isSelected ? Colors.orange[600] : Colors.grey[400],
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCalorieScoreCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'YOUR CALORIE SCORE',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 140,
            child: CustomPaint(
              size: const Size(200, 140),
              painter: GaugeChartPainter(),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '1000',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Carbs', Colors.orange[600]!),
              const SizedBox(width: 28),
              _buildLegendItem('Proteins', Colors.green[600]!),
              const SizedBox(width: 28),
              _buildLegendItem('Vitamin', Colors.grey[300]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCalorieChart() {
    return Container(
      height: 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Report',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '11 July, 2014',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '1,300 calories',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 500,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.15),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.15),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1000,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 0),
                      const FlSpot(1, 1000),
                      const FlSpot(2, 1200),
                      const FlSpot(3, 800),
                      const FlSpot(4, 800),
                      const FlSpot(5, 1800),
                      const FlSpot(6, 1300),
                      const FlSpot(7, 0),
                    ],
                    isCurved: true,
                    color: Colors.green[600],
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.green.withOpacity(0.1),
                    ),
                  ),
                ],
                lineTouchData: const LineTouchData(enabled: false),
                minX: 0,
                maxX: 7,
                minY: 0,
                maxY: 3000,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GaugeChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.85);
    final radius = size.width * 0.35;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = 3.14159; // 180 degrees in radians
    const sweepAngle = 3.14159; // 180 degrees in radians

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    // Draw background arc
    paint.color = Colors.grey.withOpacity(0.1);
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

    // Draw segments with slight gaps
    const gapAngle = 0.05; // Small gap between segments

    // Orange segment (Carbs) - 40% of the arc
    paint.color = Colors.orange[600]!;
    canvas.drawArc(rect, startAngle, sweepAngle * 0.4 - gapAngle, false, paint);

    // Green segment (Proteins) - 30% of the arc
    paint.color = Colors.green[600]!;
    canvas.drawArc(rect, startAngle + sweepAngle * 0.4 + gapAngle,
        sweepAngle * 0.3 - gapAngle, false, paint);

    // Light gray segment (Vitamin) - 30% of the arc
    paint.color = Colors.grey[300]!;
    canvas.drawArc(rect, startAngle + sweepAngle * 0.7 + gapAngle,
        sweepAngle * 0.3 - gapAngle, false, paint);

    // Draw small dots/markers on the arc
    paint.style = PaintingStyle.fill;
    paint.color = Colors.grey.withOpacity(0.3);

    for (int i = 0; i <= 8; i++) {
      final angle = startAngle + (sweepAngle * i / 8);
      final dotX = center.dx + radius * 0.9 * cos(angle);
      final dotY = center.dy + radius * 0.9 * sin(angle);
      canvas.drawCircle(Offset(dotX, dotY), 2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}