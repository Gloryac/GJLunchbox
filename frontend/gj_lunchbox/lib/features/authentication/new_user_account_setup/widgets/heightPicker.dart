import 'package:flutter/material.dart';

class HeightPicker extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final ValueChanged<int>? onChanged;

  const HeightPicker({
    super.key,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    this.onChanged,
  });

  @override
  _HeightPickerState createState() => _HeightPickerState();
}

class _HeightPickerState extends State<HeightPicker> {
  late ScrollController _scrollController;
  late int _selectedValue;
  final double itemExtent = 60.0;
  final int visibleItems = 5;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    _scrollController = ScrollController(
      // Set initial offset so the selected value is in the center of the picker
      initialScrollOffset:
      ((_selectedValue - widget.minValue) * itemExtent) -
          (itemExtent * ((visibleItems - 1) / 2)),
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final value = widget.minValue + (offset / itemExtent).round();
    if (value != _selectedValue) {
      setState(() {
        _selectedValue = value.clamp(widget.minValue, widget.maxValue);
      });
      widget.onChanged?.call(_selectedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemExtent * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Scrollable number list
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                final targetOffset =
                    (_selectedValue - widget.minValue) * itemExtent -
                        (itemExtent * ((visibleItems - 1) / 2));
                _scrollController.animateTo(
                  targetOffset,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
              return true;
            },
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemExtent: itemExtent,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final value = widget.minValue + index;
                if (value > widget.maxValue) return null;
                final isSelected = value == _selectedValue;
                return Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                        fontSize: isSelected ? 24 : 18,
                        fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? Colors.black
                            : const Color(0xFF90A783), // Subtle green color
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Center indicator box
          Positioned.fill(
            child: Center(
              child: Container(
                width: itemExtent,
                height: itemExtent * 1.2,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9ECEB), // Match center background color
                  border: Border.all(
                    color: const Color(0xFFDEE2E2),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Ruler marks at the bottom
          Positioned(
            bottom: 10, // Adjusted for better spacing
            left: 0,
            right: 0,
            child: Container(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  11, // Creates 11 marks
                      (index) => Container(
                    width: 1,
                    height: index % 5 == 0 ? 10 : 5,
                    color: Colors.grey[500], // Match the image color
                  ),
                ),
              ),
            ),
          ),
          // Top inverted triangle indicator
          Positioned(
            top: 0,
            child: CustomPaint(
              size: const Size(20, 10), // Width and height of the triangle
              painter: TrianglePainter(),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the inverted triangle
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
