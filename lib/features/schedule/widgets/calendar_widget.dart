import 'package:flutter/material.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Intégrer un vrai calendrier (ex: table_calendar)
    final days = List.generate(30, (i) => i + 1);
    return GridView.builder(
      shrinkWrap: true,
      itemCount: days.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemBuilder: (_, i) => Card(
        color: Colors.blue.shade50,
        child: Center(child: Text(days[i].toString())),
      ),
    );
  }
}