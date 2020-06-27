import 'dart:async';
import 'dart:developer';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
              child: Text(button6Title, 
                style: mediumButtonTextStyleDark,
              ),
              onPressed: button6Func,
              color: buttonBackgroundColorLight,
            )
          ],
        ),
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
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: maxController,
            ),
            Text('Valor maximo Y', style: mediumTextStyleDark),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter, 
                child: RaisedButton(
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
                    adjustGraphInterval(graph);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }
    );
  }

  static TextEditingController  param1Controller = new TextEditingController(), 
                                param2Controller = new TextEditingController(), 
                                param3Controller = new TextEditingController();
  static Future<List<String>> changeParametersDialog(BuildContext context) {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Configurar parametros', style: largeTextStyleDark),
        content: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Actual: ' + currentValue5RR.toString()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: param1Controller,
            ), 
            Text('RR', style: mediumTextStyleDark),
            TextField(
              decoration: InputDecoration(labelText: 'Actual: ' + currentValue6Vol.toString()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: param2Controller,
            ),
            Text('Volumen', style: mediumTextStyleDark),
            TextField(
              decoration: InputDecoration(labelText: 'Actual: ' + currentValue7IE.toString()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: param3Controller,
            ),
            Text('I:E', style: mediumTextStyleDark),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter, 
                child: RaisedButton(
                  color: buttonBackgroundColorDark,
                  child: Text('Set', style: largeButtonTextStyleLight),
                  onPressed: () {
                    bool validText = param1Controller.text != '' && param2Controller.text != '' && param3Controller.text != '';
                    bool validNumbers = int.tryParse(param1Controller.text) != null && int.tryParse(param2Controller.text) != null && int.tryParse(param3Controller.text) != null;
                    if (validText && validNumbers) {
                      ConnectUSBPageState.sendParamsToSTM(
                        int.tryParse(param1Controller.text), 
                        int.tryParse(param2Controller.text),
                        int.tryParse(param3Controller.text), 
                      );
                      HospitalConfigurationPageState.acceptedInputToast(param1Controller, param2Controller, param3Controller);
                      Navigator.pop(context);
                    }
                    else {
                      Fluttertoast.showToast(
                        msg: 'Llene todos los campos',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 25
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  static void verticalPan(double delta, int graph) {
    switch (graph) {
      case 1:
        double newDelta = delta * (maxYgraph1 - minYgraph1) / 40;
        maxYgraph1 += newDelta;
        minYgraph1 += newDelta;
        break;
      case 2:
        double newDelta = delta * (maxYgraph2 - minYgraph2) / 40;
        maxYgraph2 += newDelta;
        minYgraph2 += newDelta;
        break;
      case 3:
        double newDelta = delta * (maxYgraph3 - minYgraph3) / 40;
        maxYgraph3 += newDelta;
        minYgraph3 += newDelta;
        break;
      default:
    }
  }

  static void zoomGraph(double delta, int graph) {
    switch (graph) {
      case 1:
        // TODO: DOESNT WORK
        double range = ((maxYgraph1 - minYgraph1) * delta).clamp(0, 200);
        log('a');
        minYgraph1 = - range / 2;
        maxYgraph1 = range / 2;
        break;
      default:
    }
  }

  static void adjustGraphInterval(int graph) {
    switch (graph) {
      case 1:
        graph1Interval = ((maxYgraph1 - minYgraph1) / 4).roundToDouble();
        break;
      case 2:
        graph2Interval = ((maxYgraph2 - minYgraph2) / 4).roundToDouble();
        break;
      case 3:
        graph3Interval = ((maxYgraph3 - minYgraph3) / 4).roundToDouble();
        break;
      default:
    }
  }
  
  static void showErrorToast(String data) {
    Fluttertoast.showToast(
      msg: data,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: MyAppState.toastBackground,
      textColor: MyAppState.toastTextColor,
      fontSize: 15
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
  static const String appTitle = "Ventilador UTP";
  static const double smallFontSize = 15;
  static const double mediumFontSize = 22;
  static const double largeFontSize = 35;
  static const double borderEdge = 10;
  static const Color buttonBackgroundColorLight = Colors.white;
  static const Color buttonBackgroundColorDark = Colors.black;
  static const Color buttonTextColorDark = Colors.black;
  static const Color buttonTextColorLight = Colors.white;
  static Color canvasColor = Colors.blue[900];
  static Color valueTextColorLight = Colors.white;
  static Color valueTextColorDark  = Colors.black;
  static Color graphColor1 = Colors.lightBlue;
  static Color graphBackgroundColor1 = Colors.lightBlueAccent;
  static Color graphColor2 = Colors.lime;
  static Color graphBackgroundColor2 = Colors.limeAccent;
  static Color graphColor3 = Colors.pink;
  static Color graphBackgroundColor3 = Colors.pinkAccent;
  static Color graphGridColor = Colors.lightBlue;
  static Color graphAxisLabelColor = Colors.white;
  static Color appTitleColor = Colors.black;
  static Color dividerColorLight = Colors.white;
  static Color dividerColorDark = Colors.black;
  static Color toastBackground = Colors.white;
  static Color toastTextColor = Colors.black;

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
  static double graph1Interval = 1;
  static double graph2Interval = 1;
  static double graph3Interval = 1;
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
  static double currentValue1Vti = 0;
  static double currentValue2Vte = 0;
  static double currentValue3PIP = 0;
  static double currentValue4PEEP = 0;
  static int currentValue5RR = 0;
  static int currentValue6Vol = 0;
  static int currentValue7IE = 0;

  // identifiers for when the data is received from STM32
  static const String inputAccepted = 'Combination accepted!';
  static const String inputError1 = 'Tidal volume too high! Ignoring...';
  static const String inputError2 = 'Tidal volume too low! Ignoring...';
  static const String inputError3 = 'Respiration rate too high! Ignoring...';
  static const String inputError4 = 'Respiration rate too low! Ignoring...';
  static const String inputError5 = 'Respiration relation too high! Ignoring...';
  static const String inputError6 = 'Respiration relation too low! Ignoring...';
  static const String inputError7 = 'Impossible combination! Ignoring...';
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
  static const String respirationRateIdentifier = 'RR: ';
  static const String inspirationExpirationIdentifier = 'X: ';
  static const String volumeIdentifier = 'Tidal Vol: ';

  // identifiers for when the data is transmited to STM32
  static const String pauseIdentifier = 'PAUSE';
  static const String resumeIdentifier = 'RESUME';
  static const String calibrateIdentifier = 'CAL';
  static const String stopIdentifier = 'STOP';
  static const String restartIdentifier = 'Reiniciar';
  static const String paramIdentifier = 'PARAMS';
  static const String kIdentifier = 'Kval';
  static const String ambuIdentifier = 'PLOT';
  static const String printpIdentifier = 'PRINTP';

  static Timer refreshScreenTimer;
  static int screenRefreshRate = (0).round(); // 30 Hz in milliseconds
  void refreshScreen(Timer timer) {
    setState(() {
      DisplayPageState.updateStrings(
        currentValue1Vti, 
        currentValue2Vte, 
        currentValue3PIP, 
        currentValue4PEEP,
        currentValue5RR,
        currentValue6Vol,
        currentValue7IE
      );
      lineChart1 = MyLineChart(
        data: lineChart1Data,
        horizontalInterval: graph1Interval,
        gridColor: graphGridColor,
        axisLabelColor: graphAxisLabelColor,
        lineColor: graphColor1,
        lineWidth: 1,
        areaColor: graphBackgroundColor1,
        minY: minYgraph1,
        maxY: maxYgraph1,
        minX: minXgraph1,
        maxX: maxXgraph1,
        cutoffY: 0,);
      lineChart2 = MyLineChart(
        data: lineChart2Data,
        horizontalInterval: graph2Interval,
        gridColor: graphGridColor,
        axisLabelColor: graphAxisLabelColor,
        lineColor: graphColor2,
        lineWidth: 1,
        areaColor: graphBackgroundColor2,
        minY: minYgraph2,
        maxY: maxYgraph2,
        minX: minXgraph2,
        maxX: maxXgraph2,
        cutoffY: 0,);
      lineChart3 = MyLineChart(
        data: lineChart3Data,
        horizontalInterval: graph3Interval,
        gridColor: graphGridColor,
        axisLabelColor: graphAxisLabelColor,
        lineColor: graphColor3,
        lineWidth: 1,
        areaColor: graphBackgroundColor3,
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

    // Hide android menu
    SystemChrome.setEnabledSystemUIOverlays([]);

    // Force the orientation to be landscape 
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
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

  static void getDataFromUSBToValues(double value, int valueIndex) {
    switch (valueIndex) {
      case 1:
        currentValue1Vti = value;
        break;
      case 2:
        currentValue2Vte = value;
        break;
      case 3:
        currentValue3PIP = value;
        break;
      case 4:
        currentValue4PEEP = value;
        break;
      default:
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
          space: 0,
        ),
      ),
      home: ConnectUSBPage(),
    );
  }
}
