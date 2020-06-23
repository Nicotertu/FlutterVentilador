import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'ConnectUSB.dart';
import 'myChart_mpCharts.dart';
import 'package:wakelock/wakelock.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // Top button names
  static const String button1Title = "Display";
  static const String button2Title = "Conectar USB";
  static const String button3Title = "Grafica 1";
  static const String button4Title = "Grafica 2";
  static const String button5Title = "Conf. Hospital";
  static const String button6Title = "Conf. UTP";

  // Art style
  static const double titleFontSize = 50;
  static const double buttonTextSize = 20;
  static const Color buttonBackgroundColor = Colors.white;
  static const Color buttonTextColor = Colors.black;
  static Color canvasColor = Colors.black;
  static const double leftValuesTitleTextSize = 20;
  static const double leftValuesTextSize = 30;
  static Color valueTextColor = Colors.white;
  static Color graphColor = Colors.limeAccent[350];
  static Color graphBackgroundColor = Colors.brown[300];
  static Color graphGridColor = Colors.white;
  static Color graphAxisLabelColor = Colors.white;
  static const String appTitle = "Ventilador UTP";
  static Color appTitleColor = Colors.brown[800];
  //static TextTheme textTheme = GoogleFonts.ralewayTextTheme();
  static TextStyle titleTextStyle = GoogleFonts.raleway();
  static FontStyle fontStyle = titleTextStyle.fontStyle;

  // Graph variables
  static const int graphLength = 100;
  static List<FlSpot> lineChart1Data;
  static List<FlSpot> lineChart2Data;
  static List<FlSpot> lineChart3Data;
  static MyLineChart lineChart1;
  static MyLineChart lineChart2;
  static MyLineChart lineChart3;
  static double minYgraph1 = -1;
  static double maxYgraph1 = 1;
  static double minYgraph2 = -1;
  static double maxYgraph2 = 1;
  static double minYgraph3 = -4;
  static double maxYgraph3 = 4;
  static double minXgraph1 = 0;
  static double maxXgraph1 = 4;
  static double minXgraph2 = 0;
  static double maxXgraph2 = 4;
  static double minXgraph3 = 0;
  static double maxXgraph3 = 4;
  
  // Display values
  static const String value1Title = "Vti (mL)";
  static const String value2Title = "Vte (mL)";
  static const String value3Title = "PIP (cmH2O)";
  static const String value4Title = "PEEP (cmH2O)";
  static String value1 = "0";
  static String value2 = "0";
  static String value3 = "0";
  static String value4 = "0";
  static double currentValue1 = 0;
  static double currentValue2 = 0;
  static double currentValue3 = 0;
  static double currentValue4 = 0;

  // identifiers for when the data is received from STM32
  static const String receivingValuesIdentifier = "DATATOGRAPH: ";
  static const String value1Identifier = 'rUUuno';
  static const String value2Identifier = 'rdos';
  static const String value3Identifier = 'rtres';
  static const String value4Identifier = 'rcuatro';
  static const String graph1Identifier = 'guno';
  static const String graph2Identifier = 'gdos';
  static const String graph3Identifier = 'gtres';
  static const String graphLengthIdentifier = 'glen';
  static const String xIdentifier = 'xxx';

  // identifiers for when the data is transmited to STM32
  static const String pauseIdentifier = 'PAUSE';
  static const String resumeIdentifier = 'RESUME';
  static const String calibrateIdentifier = 'CAL';
  static const String stopIdentifier = 'STOP';
  static const String restartIdentifier = 'Reiniciar';
  static const String paramIdentifier = 'PARAMS';
  static const String kIdentifier = 'Kval';
  static const String ambuIdentifier = 'PLOT';

  static Timer refreshScreenTimer;
  static int screenRefreshRate = (0).round(); // 30 Hz in milliseconds
  void refreshScreen(Timer timer) async {
    setState(() {
      value1 = currentValue1.toStringAsFixed(2);
      value2 = currentValue2.toStringAsFixed(2);
      value3 = currentValue3.toStringAsFixed(2);
      value4 = currentValue4.toStringAsFixed(2);
      lineChart1 = MyLineChart(
        data: lineChart1Data,
        gridColor: graphGridColor,
        axisLabelColor: graphAxisLabelColor,
        lineColor: graphColor,
        lineWidth: 2,
        areaColor: graphBackgroundColor,
        minY: minYgraph1,
        maxY: maxYgraph1,
        minX: minXgraph1,
        maxX: maxXgraph1,
        cutoffY: 0,);
      lineChart2 = MyLineChart(
        data: lineChart2Data,
        gridColor: graphGridColor,
        axisLabelColor: graphAxisLabelColor,
        lineColor: graphColor,
        lineWidth: 2,
        areaColor: graphBackgroundColor,
        minY: minYgraph2,
        maxY: maxYgraph2,
        minX: minXgraph2,
        maxX: maxXgraph2,
        cutoffY: 0,);
      lineChart3 = MyLineChart(
        data: lineChart3Data,
        gridColor: graphGridColor,
        axisLabelColor: graphAxisLabelColor,
        lineColor: graphColor,
        lineWidth: 2,
        areaColor: graphBackgroundColor,
        minY: minYgraph3,
        maxY: maxYgraph3,
        minX: minXgraph3,
        maxX: maxXgraph3,
        cutoffY: 0,);
    });
  }

  @override
  void initState() {
    super.initState();
  
    generateSeries();

    // Invoke a repeating function that refreshes the screen to update values and graphs
    refreshScreenTimer = Timer.periodic(Duration(milliseconds: screenRefreshRate), refreshScreen);

    // Disable screen being able to sleep
    Wakelock.enable();
  }

  @override
  void dispose() {
    super.dispose();
    refreshScreenTimer.cancel();
  }

  static int lastIndexModified1 = null;
  static int lastIndexModified2 = null;
  static int lastIndexModified3 = null;
  
  static void getDataFromUSBToGraph(double xValue, double yValue, List<FlSpot> series, int graph) {
    int index = null;
    xValue = convertMillisecondToSecond(xValue);
    for (int i = 0; i < series.length; i++) {
      if (series[i].y == null) {
        index = i;
        break;
      }
      if (series[i].x >= xValue) {
        index = i;
        break;
      }
    }
    if (index == null) {
      series.add(new FlSpot(xValue, yValue));
      lastIndexModified1 = series.length - 1;
      lastIndexModified2 = series.length - 1;
      lastIndexModified3 = series.length - 1;
    }
    else {
      switch (graph) {
        case 1:
          lastIndexModified1 = modifyGraph(xValue, yValue, series, index, lastIndexModified1);
          break;
        case 2:
          lastIndexModified2 = modifyGraph(xValue, yValue, series, index, lastIndexModified2);
          break;
        case 3:
          lastIndexModified3 = modifyGraph(xValue, yValue, series, index, lastIndexModified3);
          break;
        default:
      }
    }
  }

  static int modifyGraph(double xValue, double yValue, List<FlSpot>series, int index, int lastIndex) {
    if (lastIndex != null) {
      if (index - lastIndex > 0) {
        for (int i = 1; i < index - lastIndex; i++) {
          series.removeAt(lastIndex + 1);
        }
        // Set the current point to the data
        series[lastIndex + 1] = new FlSpot(xValue, yValue);
        if (series.length > lastIndex + 2)
          series[lastIndex + 2] = new FlSpot(xValue, null);
        return lastIndex + 1;
      }
      else {
        for (var i = lastIndex + 1; i < series.length; i++) {
        }
        series.removeRange(lastIndex + 1, series.length);
        if (index > 0) {
          series.removeRange(0, index);
        }
        series[0] = new FlSpot(xValue, yValue);
        if (series.length > 1)
          series[1] = new FlSpot(xValue, null);
        return 0;
      }
    }
    else {
      series[index] = new FlSpot(xValue, yValue);
      return index;
    }
  }

  static void generateSeries() {
    lineChart1Data = new List<FlSpot>();
    lineChart2Data = new List<FlSpot>();
    lineChart3Data = new List<FlSpot>();
    
    for (double i = 0; i < graphLength; i++) {
      lineChart1Data.add(FlSpot(i*10,null));
      lineChart2Data.add(FlSpot(i*10,null)); 
      lineChart3Data.add(FlSpot(i*10,null));
    }
    return;
  }

  static double convertMillisecondToSecond(double number) {
    return number/1000.0;
  }

  static void changeGraphXSize (double size) {
    maxXgraph1 = size;
    maxXgraph2 = size;
    maxXgraph3 = size;
  }

  @override 
  Widget build(BuildContext context) {
    return MaterialApp (
      theme: ThemeData(
        //textTheme: textTheme,
        primaryColor: appTitleColor,
        canvasColor: canvasColor,
        dividerTheme: DividerThemeData(
          space: 15,
        ),
      ),
      home: ConnectUSBPage(),
    );
  }
}
