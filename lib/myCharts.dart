import 'package:flutter/material.dart';
import 'package:ventilador1/mySeries.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MyBarChart extends StatelessWidget {
  final List<MyBarSeries> data;

  MyBarChart ({@required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<MyBarSeries, String>> series = [
      charts.Series(
        id: "Subscribers",
        data: data,
        domainFn: (MyBarSeries series, _) => series.year,
        measureFn: (MyBarSeries series, _) => series.subscribers,
        colorFn: (MyBarSeries series, _) => series.barColor
      )
    ];
    return Container(
      height: 100,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "My Bar Chart",
                style: Theme.of(context).textTheme.bodyText2
              ),
              Expanded(
                child: charts.BarChart(
                  series, 
                  animate: true
                )
              )
            ],
          )
        ),
      )
    );
  }
}

class MyTimeSeriesChart extends StatelessWidget {

  final List<MyTimeSeriesSeries> data;
  final bool animate;
  final double opacity;
  final bool fillArea;
  final String title;
  final Color graphColor;
  final Color graphBackgroundColor;
  final double minAxis, maxAxis;

  MyTimeSeriesChart ({
    @required this.data, 
    @required this.title, 
    @required this.animate, 
    @required this.fillArea, 
    @required this.opacity, 
    @required this.graphColor,
    @required this.graphBackgroundColor,
    @required this.minAxis,
    @required this.maxAxis,
  });

  @override
  Widget build(BuildContext context) {
    List<charts.Series<MyTimeSeriesSeries, DateTime>> series = [
      charts.Series(
        id: "Blobs",
        data: data,
        domainFn: (MyTimeSeriesSeries series, _) => series.time,
        measureFn: (MyTimeSeriesSeries series, _) => series.value,
        seriesColor: charts.ColorUtil.fromDartColor(graphColor),
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
                title,
                style: Theme.of(context).textTheme.bodyText2
              ),
              Expanded(
                child: charts.TimeSeriesChart(
                  series, 
                  animate: animate,
                  defaultRenderer: new charts.LineRendererConfig(includeArea: fillArea, stacked: false, areaOpacity: opacity),
                  primaryMeasureAxis: new charts.NumericAxisSpec(tickProviderSpec: new charts.StaticNumericTickProviderSpec(<charts.TickSpec<double>>[new charts.TickSpec(minAxis), new charts.TickSpec(maxAxis)])),
                )
              )
            ],
          )
        ),
        color: graphBackgroundColor,
        elevation: 0,
      )
    );
  }
}

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