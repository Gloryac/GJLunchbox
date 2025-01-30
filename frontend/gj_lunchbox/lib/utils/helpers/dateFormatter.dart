import 'package:intl/intl.dart';

class DateFormatter {
  static String formatMealPlanDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(date.year, date.month, date.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    if (selectedDate == today) {
      return 'Today, ${DateFormat('MMMM d').format(date).toLowerCase()}';
    } else if (selectedDate == yesterday) {
      return 'Yesterday, ${DateFormat('MMMM d').format(date).toLowerCase()}';
    } else if (selectedDate == tomorrow) {
      return 'Tomorrow, ${DateFormat('MMMM d').format(date).toLowerCase()}';
    } else {
      return '${DateFormat('EEEE').format(date)}, ${DateFormat('MMMM d').format(date).toLowerCase()}';
    }
  }
}