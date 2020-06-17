import 'package:flutter/material.dart';
import 'package:ventilador1/mySeries.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MyStackedAreaChart extends StatefulWidget {
  final List<MyStackedAreaSeries> data;
  final String title;
  final bool animate;
  final bool fillArea;
  final double opacity;
  final Color graphColor;
  final Color graphBackgroundColor;
  final Color gridColor;
  final double minAxis;
  final double maxAxis;

  MyStackedAreaChart({
    @required this.data,
    @required this.title, 
    @required this.animate, 
    @required this.fillArea, 
    this.opacity = 1, 
    @required this.graphColor,
    @required this.graphBackgroundColor,
    @required this.gridColor,
    this.minAxis = 1,
    this.maxAxis = 1,
  });

  @override
  _MyStackedAreaChartState createState() => _MyStackedAreaChartState();
}

class _MyStackedAreaChartState extends State<MyStackedAreaChart> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<MyStackedAreaSeries, double>> series = [
      charts.Series(
        id: "Lungs",
        data: widget.data,
        domainFn: (MyStackedAreaSeries series, _) => series.xValue,
        measureFn: (MyStackedAreaSeries series, _) => series.yValue,
        seriesColor: charts.ColorUtil.fromDartColor(widget.graphColor),
      )
    ];
    return Container(
      height: 400,
      padding: EdgeInsets.all(0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              Text(
                widget.title,
                style: Theme.of(context).textTheme.overline
              ),
              Expanded(
                child: charts.LineChart(
                  series,
                  animate: widget.animate,
                  
                  defaultRenderer: charts.LineRendererConfig(
                    includeArea: widget.fillArea,
                    areaOpacity: widget.opacity,
                    stacked: false,
                  ),
                  primaryMeasureAxis: new charts.NumericAxisSpec(
                    showAxisLine: false,
                    renderSpec: new charts.GridlineRendererSpec(
                      lineStyle: charts.LineStyleSpec(color: charts.ColorUtil.fromDartColor(widget.gridColor)),
                      labelStyle: new charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(widget.gridColor))
                      
                    )
                  ),
                  domainAxis: new charts.NumericAxisSpec(
                    showAxisLine: false,
                    renderSpec: new charts.GridlineRendererSpec(
                      lineStyle: charts.LineStyleSpec(color: charts.ColorUtil.fromDartColor(widget.gridColor)),
                      labelStyle: new charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(widget.gridColor))
                      
                    )
                  ),
                  
                )
              )
            ],
          )
        ),
        color: widget.graphBackgroundColor,
        elevation: 0,
      )
    );
  }  
}