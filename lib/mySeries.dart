import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class MyBarSeries {
  String year;
  int subscribers;
  charts.Color barColor;

  MyBarSeries({
    @required this.year,
    @required this.subscribers,
    @required this.barColor,
  });
}

class MyTimeSeriesSeries {
  DateTime time;
  double value;

  MyTimeSeriesSeries({
    @required this.time,
    @required this.value
  });
}

class MyStackedAreaSeries {
  double xValue;
  double yValue;
  //final List<OneStackedAreaSeries> series;

  MyStackedAreaSeries({
    //@required this.series
    @required this.xValue,
    @required this.yValue
  });
}

class OneStackedAreaSeries {
  double xValue;
  double yValue;

  OneStackedAreaSeries(this.xValue, this.yValue);
}