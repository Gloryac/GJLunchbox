import 'package:dj_lunchbox/utils/constants/colors.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({
    super.key,
    required this.selectedDate,
    required this.onDateTapped,
    this.onDateChange
  });
  final VoidCallback? onDateChange;
  final DateTime selectedDate;
  final Function(DateTime) onDateTapped;

  @override
  Widget build(BuildContext context) {

    String formatDate(DateTime date) {
      final currentDate = DateTime.now();
      final normalizedCurrent = DateTime(currentDate.year, currentDate.month,currentDate.day);
      final normalizedDate = DateTime(date.year,date.month,date.day);
      final difference = normalizedDate.difference(normalizedCurrent).inDays;

      if (difference == 0) {
        return 'Today, ${DateFormat('MMM d').format(date)}';
      } else if (difference == 1) {
        return 'Tomorrow, ${DateFormat('MMM d').format(date)}';
      } else if (difference == -1) {
        return 'Yesterday, ${DateFormat('MMM d').format(date)}';
      } else {
        return DateFormat('EEEE, MMM d').format(date);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          // Row displaying week dates as buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _generateWeekButtons(),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () =>onDateTapped(selectedDate)
            ,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDate(selectedDate),
                  style: AppTextTheme.textStyles.headlineSmall
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }

  List<Widget> _generateWeekButtons() {
    final List<DateTime> weekDates = List.generate(
      7,
          (index) => DateTime.now().subtract(
        Duration(days: DateTime.now().weekday - 1 - index),
      ),
    );

    return weekDates.map((date) {
      final bool isSelected = selectedDate.day == date.day;
      return GestureDetector(
        onTap: () =>{ onDateTapped(date)
        },
        child: Column(
          children: [
            // Date (e.g., "11")
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.orange : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Text(
                DateFormat('d').format(date),
                style: AppTextTheme.textStyles.labelMedium?.copyWith(
                color: isSelected ? Colors.white : Colors.black,
                //fontWeight: FontWeight.bold,
              ),
              ),
            ),
            const SizedBox(height: 4),

            // Day (e.g., "Mon")
            Text(
              DateFormat('EEE').format(date),
              style: AppTextTheme.textStyles.labelSmall?.copyWith(
                color: isSelected ? AppColors.orange : AppColors.lightGreen,
                //fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
