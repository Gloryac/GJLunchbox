import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatelessWidget {
   const DateWidget({
    super.key,
    required this.selectedDate,
    required this.onDateTapped});

  final DateTime selectedDate;
  final Function(DateTime) onDateTapped;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> onDateTapped(selectedDate),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(DateFormat('EEEE, MMM d').format(selectedDate)),
          Icon(Icons.calendar_today)
        ],
      ),
    );
  }
}
