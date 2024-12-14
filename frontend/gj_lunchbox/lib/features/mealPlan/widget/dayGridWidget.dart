import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayGridWidget extends StatelessWidget {
  const DayGridWidget({super.key, required this.selectedDate});
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 7,
      childAspectRatio: 1.5,
      shrinkWrap: true,
      children: [
        for(int i= 0; i<7;i++)
          Center(
            child: Text(
              DateFormat('d').format(
                selectedDate.add(Duration(days: i - selectedDate.weekday+1)),
          )),
        )
    ],);
  }
}
