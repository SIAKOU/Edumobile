import 'package:flutter/material.dart';
import '../widgets/calendar_widget.dart';

class ScheduleMonthView extends StatelessWidget {
  const ScheduleMonthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vue mensuelle')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: CalendarWidget(),
      ),
    );
  }
}