import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EcgChart extends StatelessWidget {
  final List<double> data;

  const EcgChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minY: -1.5,
          maxY: 1.5,
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                data.length,
                (i) => FlSpot(i.toDouble(), data[i]),
              ),
              isCurved: true,
              color: Colors.pink,
              barWidth: 2,
              dotData: FlDotData(show: false),
            )
          ],
        ),
      ),
    );
  }
}
