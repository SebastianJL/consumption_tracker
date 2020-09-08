import 'package:consumption_tracker/src/consumption_entry.dart';
import 'package:consumption_tracker/src/consumption_entry_cubit.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartsTab extends StatelessWidget {
  static const List<Color> gradientColors = <Color>[
    Color(0xff23b6e6),
    Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
      child: BlocBuilder<ConsumptionEntryCubit, ConsumptionEntryState>(
        builder: (context, state) {
          List<ConsumptionEntry> data;
          if (state is ConsumptionEntryData) {
            data = state.entries;
          }
          if (data.isEmpty) return Center(child: Text('No Data'));
          return LineChart(createData(data));
        },
      ),
    );
  }

  LineChartData createData(List<ConsumptionEntry> data) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      axisTitleData: FlAxisTitleData(
          bottomTitle: AxisTitle(showTitle: true, titleText: 'km'),
          leftTitle: AxisTitle(showTitle: true, titleText: 'L')),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
//      minX: 0,
//      maxX: 11,
      minY: 0,
//      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: data
              .map((e) => FlSpot(e.distance.toDouble(), e.volume.toDouble()))
              .toList(),
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
