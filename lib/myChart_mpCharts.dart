import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'main.dart';

class MyLineChart extends StatefulWidget {
  final List<FlSpot> data;
  final double cutoffY;
  final double minY;
  final double maxY;
  final double minX;
  final double maxX;
  final double lineWidth;
  final double horizontalInterval;
  final double verticalInterval;
  final Color lineColor;
  final Color gridColor;
  final Color axisLabelColor;
  final Color areaColor;

  MyLineChart({
    @required this.data,
    this.horizontalInterval = 1,
    this.verticalInterval = 0.5,
    this.lineColor,
    this.areaColor,
    @required this.gridColor,
    @required this.axisLabelColor,
    this.minY = -10, 
    this.maxY = 10, 
    this.minX = -10, 
    this.maxX = 10, 
    this.lineWidth = 2,
    this.cutoffY = 0,
  });

  @override
  MyLineChartState createState() => MyLineChartState();

}

class MyLineChartState extends State<MyLineChart> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
/*
    return SfCartesianChart(
      primaryXAxis: NumericAxis(desiredIntervals: 5),
      primaryYAxis: NumericAxis(desiredIntervals: 5),
      backgroundColor: Colors.black,
      plotAreaBackgroundColor: Colors.white,
      plotAreaBorderColor: Colors.purple,
      borderColor: Colors.green,
      borderWidth: 3,
      series: <LineSeries<FlSpot, double>>[
        LineSeries<FlSpot, double>(
          dataSource: widget.data,
          xValueMapper: (FlSpot sales, _) => sales.x,
          yValueMapper: (FlSpot sales, _) => sales.y,
          animationDuration: 0,
        )
      ]
    );*/

    return LineChart(
      LineChartData(
        clipData: FlClipData(bottom: true, top: true, right: true, left: true),
        borderData: FlBorderData(border: Border.all(color: widget.gridColor), show: false),
        gridData: FlGridData(
          drawHorizontalLine: true, 
          drawVerticalLine: true,
          verticalInterval: widget.verticalInterval,
          horizontalInterval:  widget.horizontalInterval
        ),
        minY: widget.minY,
        maxY: widget.maxY,
        minX: widget.minX,
        maxX: widget.maxX,
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(showTitles: true, interval: widget.verticalInterval, textStyle: MyAppState.smallTextStyleLight),
          topTitles: SideTitles(showTitles: false),
          leftTitles: SideTitles(showTitles: true, interval: widget.horizontalInterval, textStyle: MyAppState.smallTextStyleLight),
          rightTitles: SideTitles(showTitles: false)
        ),
        //extraLinesData: ExtraLinesData(verticalLines: [VerticalLine(x: 1500)]),
        //rangeAnnotations: RangeAnnotations(verticalRangeAnnotations: [VerticalRangeAnnotation(x1: 0, x2: 100)]),
        lineTouchData: LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            dotData: FlDotData(show: false),
            isCurved: false,
            barWidth: widget.lineWidth,
            colors: [
              widget.lineColor
            ],
            belowBarData: BarAreaData(
              show: true,
              colors: [widget.areaColor],
              cutOffY: widget.cutoffY,
              applyCutOffY: true,
            ),
            aboveBarData: BarAreaData(
              show: true,
              colors: [widget.areaColor],
              cutOffY: widget.cutoffY,
              applyCutOffY: true,
            ),
            spots: [
              ...?widget.data
            ]
          ),
        ]
      ),
      swapAnimationDuration: Duration(milliseconds: 0)
    );
  }
}