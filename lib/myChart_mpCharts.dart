import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';



class MyLineChart extends StatefulWidget {
  final List<FlSpot> data;
  final double cutoffY;
  final double minY;
  final double maxY;
  final double lineWidth;
  final Color lineColor;
  final Color areaColor;

  MyLineChart({
    @required this.data,
    this.lineColor,
    this.areaColor,
    this.minY = -10, 
    this.maxY = 10, 
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
    return SizedBox(
      width: 700,
      height: 180,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            drawHorizontalLine: true, 
            drawVerticalLine: true),
          minY: widget.minY,
          maxY: widget.maxY,
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
      )
    );
  }
}