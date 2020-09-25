import 'package:consumption_tracker/src/consumption_entry.dart';
import 'package:consumption_tracker/src/consumption_entry_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartsTab extends StatelessWidget {
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
          return LineChart(createData(context, data));
        },
      ),
    );
  }

  LineChartData createData(BuildContext context, List<ConsumptionEntry> data) {
    final textStyle = const TextStyle(
        color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16);
    final List<Color> gradientColors = <Color>[
      Theme.of(context).accentColor,
      Theme.of(context).primaryColor,
    ];
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      axisTitleData: FlAxisTitleData(
          bottomTitle:
              AxisTitle(showTitle: true, titleText: 'km', textStyle: textStyle),
          leftTitle: AxisTitle(
              showTitle: true, titleText: 'l/100km', textStyle: textStyle)),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          interval: 1000,
          reservedSize: 22,
          textStyle: textStyle,
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: textStyle,
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
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (int i = 0; i < data.length - 1; i++)
              FlSpot(data[i].distance.toDouble(),
                  data[i].litersPer100Km(data[i + 1]))
          ],
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
