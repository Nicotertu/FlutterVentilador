import 'dart:async';
import 'package:flutter/material.dart';
import 'ConnectUSB.dart';
import 'myCharts.dart';
import 'mySeries.dart';
import 'package:wakelock/wakelock.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // button names
  static const String button1Title = "Display";
  static const String button2Title = "Conectar USB";
  static const String button3Title = "Grafica 1";
  static const String button4Title = "Grafica 2";
  static const String button5Title = "Grafica 3";
  static const String button6Title = "Configuracion";

  // Art style
  static const double buttonTextSize = 20;
  static const Color buttonBackgroundColor = Colors.brown;
  static const Color buttonTextColor = Colors.white;
  static Color canvasColor = Colors.brown[100];
  static const double leftValuesTitleTextSize = 20;
  static const double leftValuesTextSize = 30;
  static Color leftValuesBackgroundColor = Colors.brown[100];
  static Color leftValuesTextColor = Colors.brown[900];
  static Color graphColor = Colors.brown[600];
  static Color graphBackgroundColor = Colors.brown[100];
  static Color graphGridColor = Colors.brown[900];
  static const String appTitle = "Ventilador UTP";
  static Color appTitleColor = Colors.brown[800];
  static TextTheme textTheme = GoogleFonts.indieFlowerTextTheme();
  static TextStyle titleTextStyle = GoogleFonts.nunito();

  // Graph values
  static const int graphLength = 200;
  static double currentGraphPosition = 0;
  static double xPosition = 0;
  static List<MyStackedAreaSeries> stackedAreaSeries1;
  static List<MyStackedAreaSeries> stackedAreaSeries2;
  static List<MyStackedAreaSeries> stackedAreaSeries3;
  static MyStackedAreaChart stackedAreaChart1;
  static MyStackedAreaChart stackedAreaChart2;
  static MyStackedAreaChart stackedAreaChart3;

  // Display values
  static const String value1Title = "Volumen in";
  static const String value2Title = "Volumen exp";
  static const String value3Title = "PIP";
  static const String value4Title = "PEEP";
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
  static int screenRefreshRate = (100).round(); // 30 Hz in milliseconds
  void refreshScreen(Timer timer) async {
    setState(() {
      value1 = currentValue1.toStringAsFixed(2);
      value2 = currentValue2.toStringAsFixed(2);
      value3 = currentValue3.toStringAsFixed(2);
      value4 = currentValue4.toStringAsFixed(2);
      stackedAreaChart1 = MyStackedAreaChart(
        data: stackedAreaSeries1, 
        title: "", 
        animate: false, 
        fillArea: true, 
        opacity: 0.9, 
        graphColor: graphColor,
        graphBackgroundColor: graphBackgroundColor,
        gridColor: graphGridColor,
        minAxis: -10,
        maxAxis: 10,
      );
      stackedAreaChart2 = MyStackedAreaChart(
        data: stackedAreaSeries2, 
        title: "", 
        animate: false, 
        fillArea: true, 
        opacity: 0.75, 
        graphColor: graphColor,
        graphBackgroundColor: graphBackgroundColor,
        gridColor: graphGridColor,
        minAxis: -10,
        maxAxis: 10,
      );
      stackedAreaChart3 = MyStackedAreaChart(
        data: stackedAreaSeries3, 
        title: "", 
        animate: false, 
        fillArea: true, 
        opacity: 0.5, 
        graphColor: graphColor,
        graphBackgroundColor: graphBackgroundColor,
        gridColor: graphGridColor,
        minAxis: -100,
      );
    });
  }

  @override
  void initState() {
    super.initState();
  
    generateSeries();

    // Invoke a repeating function that refreshes the screen to update values and graphs
    //refreshScreenTimer = Timer.periodic(Duration(milliseconds: screenRefreshRate), refreshScreen);

    // Disable screen being able to sleep
    Wakelock.enable();
  }

  @override
  void dispose() {
    super.dispose();
    refreshScreenTimer.cancel();
  }

  static void getDataFromUSBToGraph(double xValue, double yValue, List<MyStackedAreaSeries> series) {
    int index = null;
    for (var i = 0; i < series.length; i++) {
      if (series[i].xValue == null) {
        index = i;
        break;
      }
      if (series[i].xValue > xValue) {
        index = i;
        break;
      }
    }
    if (index == null) {
      series.add(new MyStackedAreaSeries(xValue: xValue, yValue: yValue));
    }
    else {
      // Set the current point to the data
      series[index].xValue = xValue;
      series[index].yValue = yValue;

      if (index < graphLength) {
        series[index + 1].xValue = xValue;
        series[index + 1].yValue = null;
      }
    }
/*
    // Set the current point to the data
    series[currentGraphPosition.round()].xValue = xValue;
    series[currentGraphPosition.round()].yValue = yValue;

    if (currentGraphPosition.round() < graphLength) {
      series[currentGraphPosition.round() + 1].xValue = xValue;
      series[currentGraphPosition.round() + 1].yValue = null;
    }*/
  }

  static void generateSeries() {
    // create graph series in a fixed size to prevent resizing
    stackedAreaSeries1 = new List<MyStackedAreaSeries>();
    stackedAreaSeries2 = new List<MyStackedAreaSeries>();
    stackedAreaSeries3 = new List<MyStackedAreaSeries>();

    for (int i = 0; i <= graphLength; i++) {
      stackedAreaSeries1.add(new MyStackedAreaSeries(xValue: 0, yValue: null));
      stackedAreaSeries2.add(new MyStackedAreaSeries(xValue: 0, yValue: null));
      stackedAreaSeries3.add(new MyStackedAreaSeries(xValue: 0, yValue: null));
    }
  }

  @override 
  Widget build(BuildContext context) {
    return MaterialApp (
      theme: ThemeData(
        textTheme: textTheme,
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
