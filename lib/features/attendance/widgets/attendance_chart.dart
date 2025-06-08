import 'package:flutter/material.dart';

class AttendanceChart extends StatelessWidget {
  final int present;
  final int absent;
  final int late;
  final int excused;

  const AttendanceChart({
    super.key,
    required this.present,
    required this.absent,
    required this.late,
    required this.excused,
  });

  @override
  Widget build(BuildContext context) {
    final total = present + absent + late + excused;
    double percent(int value) => total == 0 ? 0 : value / total;

    return SizedBox(
      height: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatBar(
            color: Colors.green,
            label: 'Présent',
            value: present,
            percent: percent(present),
          ),
          _StatBar(
            color: Colors.red,
            label: 'Absent',
            value: absent,
            percent: percent(absent),
          ),
          _StatBar(
            color: Colors.orange,
            label: 'Retard',
            value: late,
            percent: percent(late),
          ),
          _StatBar(
            color: Colors.blue,
            label: 'Excusé',
            value: excused,
            percent: percent(excused),
          ),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final Color color;
  final String label;
  final int value;
  final double percent;

  const _StatBar({
    required this.color,
    required this.label,
    required this.value,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final maxHeight = 100.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 22,
          height: maxHeight * percent,
          color: color,
        ),
        const SizedBox(height: 8),
        Text('$value', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}