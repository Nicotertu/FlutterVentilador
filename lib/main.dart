import 'dart:async';
import 'dart:developer';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ventilador1/HospitalConfigurationPage.dart';
import 'ConfigurationPage.dart';
import 'ConnectUSB.dart';
import 'DisplayValuesPage.dart';
import 'myChart_mpCharts.dart';
import 'package:wakelock/wakelock.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['fonts'], license);
  });
  
  runApp(MyApp());
} 

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // button row
  static Column returnButtonRow(Function button1Func, Function button2Func, Function button3Func, Function button4Func, Function button5Func, Function button6Func) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            RaisedButton(
              child: Text(button1Title, 
                style: mediumButtonTextStyleDark,
              ),
              onPressed: button1Func,
              color: buttonBackgroundColorLight,
            ),
            RaisedButton(
              child: Text(button2Title, 
                style: mediumButtonTextStyleDark,
              ),
              onPressed: button2Func,
              color: buttonBackgroundColorLight,
            ),
            RaisedButton(
              child: Text(button3Title, 
                style: mediumButtonTextStyleDark,
              ),
              onPressed: button3Func,
              color: buttonBackgroundColorLight,
            ),
            RaisedButton(
              child: Text(button4Title, 
                style: mediumButtonTextStyleDark,
              ),
              onPressed: button4Func,
              color: buttonBackgroundColorLight,
            ),
            RaisedButton(
              child: Text(button5Title, 
                style: mediumButtonTextStyleDark,
              ),
              onPressed: button5Func,
              color: buttonBackgroundColorLight,
            ),
            RaisedButton(
              child: Text(button6Title, 
                style: mediumButtonTextStyleDark,
              ),
              onPressed: button6Func,
              color: buttonBackgroundColorLight,
            )
          ],
        ),
        Divider(color: dividerColorLight, height: 0),
      ],
    );
  }
  static Function button1Function(BuildContext context) {
    return () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => DisplayPage()));
    };
  }
  static Function button2Function(BuildContext context) {
    return () {
      if (Navigator.canPop(context))
        Navigator.pop(context);
    };
  }
  static Function button3Function(BuildContext context) {
    return () {};
  }
  static Function button4Function(BuildContext context) {
    return () {};
  }
  static Function button5Function(BuildContext context) {
    return () {
      if (Navigator.canPop(context))
        Navigator.pop(context);
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => HospitalConfigurationPage()));
    };
  }
  static Function button6Function(BuildContext context) {
    return () {
      if (Navigator.canPop(context))
        Navigator.pop(context);
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => ConfigurationPage()));
    };
  }
  
  // change graph y axis range
  static Future <List<String>> changeYRangeDialog(BuildContext context, TextEditingController minController, TextEditingController maxController, int graph) {
    return showDialog(context: context, builder: (context) { 
      return AlertDialog(
        title: Text('Configurar rango', style: largeTextStyleDark),
        content: Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: minController,
            ), 
            Text('Valor minimo Y', style: mediumTextStyleDark),
            SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    controller: maxController,
                  ),
                ],
              ),
            ),
            Text('Valor maximo Y', style: mediumTextStyleDark),
            Divider(color: dividerColorDark, height: 20, thickness: 5),
            RaisedButton(
              color: buttonBackgroundColorDark,
              child: Text('Set', style: largeButtonTextStyleLight),
              onPressed: () {
                if (graph == 1) {
                  minYgraph1 = minController.text == ''? minYgraph1 : double.tryParse(minController.text);
                  maxYgraph1 = maxController.text == ''? maxYgraph1 : double.tryParse(maxController.text);
                }
                else if (graph == 2) {
                  minYgraph2 = minController.text == ''? minYgraph2 : double.tryParse(minController.text);
                  maxYgraph2 = maxController.text == ''? maxYgraph2 : double.tryParse(maxController.text);
                }
                else if (graph == 3) {
                  minYgraph3 = minController.text == ''? minYgraph3 : double.tryParse(minController.text);
                  maxYgraph3 = maxController.text == ''? maxYgraph3 : double.tryParse(maxController.text);
                }
                Navigator.pop(context);
              },
            )
          ],
        ),
        actions: <Widget>[
          
        ],
      );
    }
    );
  }

  // Top button names
  static const String button1Title = "Display";
  static const String button2Title = "Conectar USB";
  static const String button3Title = "Grafica 1";
  static const String button4Title = "Grafica 2";
  static const String button5Title = "Conf. Hospital";
  static const String button6Title = "Conf. UTP";

  // Art style
  static const double smallFontSize = 15;
  static const double mediumFontSize = 22;
  static const double largeFontSize = 35;
  static const Color buttonBackgroundColorLight = Colors.white;
  static const Color buttonBackgroundColorDark = Colors.black;
  static const Color buttonTextColorDark = Colors.black;
  static const Color buttonTextColorLight = Colors.white;
  static Color canvasColor = Colors.black;
  static Color valueTextColorLight = Colors.white;
  static Color valueTextColorDark  = Colors.black;
  static Color graphColor = Colors.lime;
  static Color graphBackgroundColor = Colors.limeAccent;
  static Color graphGridColor = Colors.lime;
  static Color graphAxisLabelColor = Colors.white;
  static const String appTitle = "Ventilador UTP";
  static Color appTitleColor = Colors.black;
  static Color dividerColorLight = Colors.white;
  static Color dividerColorDark = Colors.black;

  // Text style
  static String fontStyle = GoogleFonts.raleway().fontFamily;
  static TextStyle smallButtonTextStyleDark = TextStyle(fontFamily: fontStyle, fontSize: smallFontSize, color: buttonTextColorDark);
  static TextStyle mediumButtonTextStyleDark = TextStyle(fontFamily: fontStyle, fontSize: mediumFontSize, color: buttonTextColorDark);
  static TextStyle largeButtonTextStyleDark = TextStyle(fontFamily: fontStyle, fontSize: largeFontSize, color: buttonTextColorDark);
  static TextStyle smallButtonTextStyleLight = TextStyle(fontFamily: fontStyle, fontSize: smallFontSize, color: buttonTextColorLight);
  static TextStyle mediumButtonTextStyleLight = TextStyle(fontFamily: fontStyle, fontSize: mediumFontSize, color: buttonTextColorLight);
  static TextStyle largeButtonTextStyleLight = TextStyle(fontFamily: fontStyle, fontSize: largeFontSize, color: buttonTextColorLight);
  static TextStyle smallTextStyleLight = TextStyle(fontFamily: fontStyle, fontSize: smallFontSize, color: valueTextColorLight);
  static TextStyle mediumTextStyleLight = TextStyle(fontFamily: fontStyle, fontSize: mediumFontSize, color: valueTextColorLight);
  static TextStyle largeTextStyleLight = TextStyle(fontFamily: fontStyle, fontSize: largeFontSize, color: valueTextColorLight);
  static TextStyle smallTextStyleDark = TextStyle(fontFamily: fontStyle, fontSize: smallFontSize, color: valueTextColorDark);
  static TextStyle mediumTextStyleDark = TextStyle(fontFamily: fontStyle, fontSize: mediumFontSize, color: valueTextColorDark);
  static TextStyle largeTextStyleDark = TextStyle(fontFamily: fontStyle, fontSize: largeFontSize, color: valueTextColorDark);

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
        lineWidth: 1,
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
        lineWidth: 1,
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
        lineWidth: 1,
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
