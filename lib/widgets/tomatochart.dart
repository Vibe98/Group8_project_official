import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TomatoChart extends StatelessWidget {
  final double data;
  final String name;
  final double objective;
  final int number;


  TomatoChart({required this.data, required this.name, required this.objective, required this.number});


  @override
  Widget build(BuildContext context) {
    
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: objective,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.transparent,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.transparent,
      fontWeight: FontWeight.bold,
      fontSize: 2,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = name;
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4.0,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 30,
            
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  final _barsGradient1 =  const LinearGradient(
    colors: [
      Colors.lightBlueAccent,
      Colors.lightGreenAccent
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  final _barsGradient2 =  const LinearGradient(
    colors: [
      Colors.deepOrange,
      Colors.amber
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  final _barsGradient3 = const LinearGradient(
    colors: [
      Colors.purple,
      Colors.pink
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: data > objective ? objective : data,
              gradient: number == 1 ? _barsGradient1 : number == 2 ? _barsGradient2 : _barsGradient3,
              backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: objective,
            color: const Color.fromARGB(255, 96, 119, 113),
          ),
            )
          ],
          showingTooltipIndicators: [0],
          
        ),
        
      ];
}