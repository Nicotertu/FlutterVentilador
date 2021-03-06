import 'dart:async';
import 'dart:developer';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  // change graph y axis range  
  static bool autoRange = false;
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
            Divider(color: dividerColorDark,),
            ListTile(
              leading: Switch(
                value: autoRange,
                activeColor: Colors.deepPurple,
                activeTrackColor: Colors.purple,
                onChanged: (activated) {
                  autoRange = activated;
                },
              ), 
              title: Text('Auto range Y')
            ),
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
              decoration: InputDecoration(labelText: 'Actual: ' + rightCurrentValue1RR.toString()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: param1Controller,
            ), 
            Text('RR', style: mediumTextStyleDark),
            TextField(
              decoration: InputDecoration(labelText: 'Actual: ' + rightCurrentValue2IE.toString()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: param2Controller,
            ),
            Text('I:E', style: mediumTextStyleDark),
            TextField(
              decoration: InputDecoration(labelText: 'Actual: ' + rightCurrentValue5Vol.toString()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: param3Controller,
            ),
            Text('Volumen', style: mediumTextStyleDark),
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
                      int decimales = 1;
                      double ie = (double.tryParse(param2Controller.text) * pow(10, decimales)).round() / pow(10, decimales);
                      ConnectUSBPageState.sendParamsToSTM(
                        int.tryParse(param1Controller.text),
                        ie, 
                        int.tryParse(param3Controller.text), 
                      );
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
  static List<FlSpot> lineChart1DataA = new List<FlSpot>();
  static List<FlSpot> lineChart1DataB = new List<FlSpot>();
  static List<FlSpot> lineChart2DataA = new List<FlSpot>();
  static List<FlSpot> lineChart2DataB = new List<FlSpot>();
  static List<FlSpot> lineChart3DataA = new List<FlSpot>();
  static List<FlSpot> lineChart3DataB = new List<FlSpot>();
  static MyLineChart lineChart1;
  static MyLineChart lineChart2;
  static MyLineChart lineChart3;
  static double graph1Interval = 1;
  static double graph2Interval = 1;
  static double graph3Interval = 1;
  static double graph1StandardInterval = 0.25;
  static double graph2StandardInterval = 20;
  static double graph3StandardInterval = 10;
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
  static double leftCurrentValue1Vti = 0;
  static double leftCurrentValue2Vte = 0;
  static double leftCurrentValue3PIP = 0;
  static double leftCurrentValue4PEEP = 0;
  static double leftCurrentValue5PIF = 0;
  static double leftCurrentValue6PEF = 0;
  static int rightCurrentValue1RR = 0;
  static double rightCurrentValue2IE = 0;
  static double rightCurrentValue3Ti = 0;
  static double rightCurrentValue4Te = 0;
  static int rightCurrentValue5Vol = 0;

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
  static const String value5Identifier = 'rcinco';
  static const String value6Identifier = 'rseis';
  static const String graph1Identifier = 'guno';
  static const String graph2Identifier = 'gdos';
  static const String graph3Identifier = 'gtres';
  static const String graphLengthIdentifier = 'glen';
  static const String xIdentifier = 'xxx';
  static const String respirationRateIdentifier = 'RR: ';
  static const String inspirationExpirationIdentifier = 'X: ';
  static const String inspirationTimeIdentifier = 'Ti: ';
  static const String expirationTimeIdentifier = 'Te: ';
  static const String volumeIdentifier = 'Tidal Vol: ';
  static const String cycleIdenfitier = 'cycle';

  // identifiers for when the data is transmited to STM32
  static const String pauseIdentifier = 'PAUSE';
  static const String resumeIdentifier = 'RESUME';
  static const String calibrateIdentifier = 'CAL';
  static const String stopIdentifier = 'STOP';
  static const String restartIdentifier = 'Reiniciar';
  static const String paramIdentifier = 'PARAMS';
  static const String kIdentifier = 'Kval';
  static const String plotIdenfitifer = 'PLOT';
  static const String printpIdentifier = 'PRINTP';

  static Timer refreshScreenTimer;
  static int screenRefreshRate = (0).round(); // 30 Hz in milliseconds
  void refreshScreen(Timer timer) {
    // Hide android menu
    SystemChrome.setEnabledSystemUIOverlays([]);

    setState(() {/*
      DisplayPageState.updateStrings(
        currentValue1Vti, 
        currentValue2Vte, 
        currentValue3PIP, 
        currentValue4PEEP,
        currentValue5RR,
        currentValue6IE,
        currentValue7Vol
      );*/
      DisplayPageState.updateLeftStrings(leftCurrentValue1Vti, leftCurrentValue2Vte, leftCurrentValue3PIP, leftCurrentValue4PEEP, leftCurrentValue5PIF, leftCurrentValue6PEF);
      DisplayPageState.updateRightStrings(rightCurrentValue1RR, rightCurrentValue2IE, rightCurrentValue3Ti, rightCurrentValue4Te, rightCurrentValue5Vol);
      lineChart1 = MyLineChart(
        data: lineChart1DataA + [FlSpot(0,null)] + lineChart1DataB,
        horizontalInterval: autoRange? graph1StandardInterval:graph1Interval,
        gridColor: graphGridColor,
        axisLabelColor: graphAxisLabelColor,
        lineColor: graphColor1,
        lineWidth: 1,
        areaColor: graphBackgroundColor1,
        minY: autoRange? null:minYgraph1,
        maxY: autoRange? null:maxYgraph1,
        minX: minXgraph1,
        maxX: maxXgraph1,
        cutoffY: 0,);
      lineChart2 = MyLineChart(
        data: lineChart2DataA + [FlSpot(0,null)] + lineChart2DataB,
        horizontalInterval: autoRange? graph2StandardInterval:graph2Interval,
        gridColor: graphGridColor,
        axisLabelColor: graphAxisLabelColor,
        lineColor: graphColor2,
        lineWidth: 1,
        areaColor: graphBackgroundColor2,
        minY: autoRange? null:minYgraph2,
        maxY: autoRange? null:maxYgraph2,
        minX: minXgraph2,
        maxX: maxXgraph2,
        cutoffY: 0,);
      lineChart3 = MyLineChart(
        data: lineChart3DataA + [FlSpot(0,null)] + lineChart3DataB,
        horizontalInterval: autoRange? graph3StandardInterval:graph3Interval,
        gridColor: graphGridColor,
        axisLabelColor: graphAxisLabelColor,
        lineColor: graphColor3,
        lineWidth: 1,
        areaColor: graphBackgroundColor3,
        minY: autoRange? null:minYgraph3,
        maxY: autoRange? null:maxYgraph3,
        minX: minXgraph3,
        maxX: maxXgraph3,
        cutoffY: 0,);
    });
  }

  @override
  void initState() {
    super.initState();
  
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
  static int currentCycle = 0;
  
  static void getDataFromUSBToGraph(double xValue, double yValue, int graph, bool cycleA/*int cycle*/) {
    xValue = convertMillisecondToSecond(xValue);
    switch (graph) {
      case 1:
        //if (cycle%2 == 0) {
        if (cycleA) {
          int firstLargerXIndex = 0;
          for (int i = 0; i < lineChart1DataB.length; i++) {
            if(lineChart1DataB[i].x > xValue) {
              firstLargerXIndex = i;
              break;
            }
          }
          if (firstLargerXIndex != 0)
            lineChart1DataB.removeRange(0, firstLargerXIndex);
      
          lineChart1DataA.add(FlSpot(xValue, yValue));
        }
        else {
          int firstLargerXIndex = 0;
          for (int i = 0; i < lineChart1DataA.length; i++) {
            if(lineChart1DataA[i].x > xValue) {
              firstLargerXIndex = i;
              break;
            }
          }
          if (firstLargerXIndex != 0)
            lineChart1DataA.removeRange(0, firstLargerXIndex);
      
          lineChart1DataB.add(FlSpot(xValue, yValue));
        }
      break;
      case 2:
        //if (cycle%2 == 0) {
        if (cycleA) {
          int firstLargerXIndex = 0;
          for (int i = 0; i < lineChart2DataB.length; i++) {
            if(lineChart2DataB[i].x > xValue) {
              firstLargerXIndex = i;
              break;
            }
          }
          if (firstLargerXIndex != 0)
            lineChart2DataB.removeRange(0, firstLargerXIndex);
      
          lineChart2DataA.add(FlSpot(xValue, yValue));
        }
        else {
          int firstLargerXIndex = 0;
          for (int i = 0; i < lineChart2DataA.length; i++) {
            if(lineChart2DataA[i].x > xValue) {
              firstLargerXIndex = i;
              break;
            }
          }
          if (firstLargerXIndex != 0)
            lineChart2DataA.removeRange(0, firstLargerXIndex);
      
          lineChart2DataB.add(FlSpot(xValue, yValue));
        }
      break;
      case 3:
        //if (cycle%2 == 0) {
        if (cycleA) {
          int firstLargerXIndex = 0;
          for (int i = 0; i < lineChart3DataB.length; i++) {
            if(lineChart3DataB[i].x > xValue) {
              firstLargerXIndex = i;
              break;
            }
          }
          if (firstLargerXIndex != 0)
            lineChart3DataB.removeRange(0, firstLargerXIndex);
      
          lineChart3DataA.add(FlSpot(xValue, yValue));
        }
        else {
          int firstLargerXIndex = 0;
          for (int i = 0; i < lineChart3DataA.length; i++) {
            if(lineChart3DataA[i].x > xValue) {
              firstLargerXIndex = i;
              break;
            }
          }
          if (firstLargerXIndex != 0)
            lineChart3DataA.removeRange(0, firstLargerXIndex);
      
          lineChart3DataB.add(FlSpot(xValue, yValue));
        }
      break;
      default:
    }
    

    return;
    int index = null;
    xValue = convertMillisecondToSecond(xValue);

    switch (graph) {
      case 1:
        for (int i = 0; i < lineChart1DataA.length; i++) {
          if (lineChart1DataA[i].y == null) {
            index = i;
            break;
          }
          if (lineChart1DataA[i].x >= xValue) {
            index = i;
            break;
          }
        }
        if (index == null) {
          lineChart1DataA.add(new FlSpot(xValue, yValue));
          lastIndexModified1 = lineChart1DataA.length - 1;
        }
        else {
          lastIndexModified1 = modifyGraph(xValue, yValue, 1, index, lastIndexModified1);
        }
        break;
      case 2:
        for (int i = 0; i < lineChart2DataA.length; i++) {
          if (lineChart2DataA[i].y == null) {
            index = i;
            break;
          }
          if (lineChart2DataA[i].x >= xValue) {
            index = i;
            break;
          }
        }
        if (index == null) {
          lineChart2DataA.add(new FlSpot(xValue, yValue));
          lastIndexModified2 = lineChart2DataA.length - 1;
        }
        else {
          lastIndexModified2 = modifyGraph(xValue, yValue, 2, index, lastIndexModified2);
        }
        break;
      case 3:
        for (int i = 0; i < lineChart3DataA.length; i++) {
          if (lineChart3DataA[i].y == null) {
            index = i;
            break;
          }
          if (lineChart3DataA[i].x >= xValue) {
            index = i;
            break;
          }
        }
        if (index == null) {
          lineChart3DataA.add(new FlSpot(xValue, yValue));
          lastIndexModified3 = lineChart3DataA.length - 1;
        }
        else {
          lastIndexModified3 = modifyGraph(xValue, yValue, 3, index, lastIndexModified3);
        }
        break;
      default:
    }
  }

  static int modifyGraph(double xValue, double yValue, int graph, int index, int lastIndex) {
    switch (graph) {
      case 1:
        if (lastIndex != null) {
          if (index - lastIndex > 0) {
            for (int i = 1; i < index - lastIndex; i++) {
              lineChart1DataA.removeAt(lastIndex + 1);
            }
            // Set the current point to the data
            lineChart1DataA[lastIndex + 1] = new FlSpot(xValue, yValue);
            if (lineChart1DataA.length > lastIndex + 2)
              lineChart1DataA[lastIndex + 2] = new FlSpot(xValue, null);
            return lastIndex + 1;
          }
          else {
            for (var i = lastIndex + 1; i < lineChart1DataA.length; i++) {
            }
            lineChart1DataA.removeRange(lastIndex + 1, lineChart1DataA.length);
            if (index > 0) {
              lineChart1DataA.removeRange(0, index);
            }
            lineChart1DataA[0] = new FlSpot(xValue, yValue);
            if (lineChart1DataA.length > 1)
              lineChart1DataA[1] = new FlSpot(xValue, null);
            return 0;
          }
        }
        else {
          lineChart1DataA[index] = new FlSpot(xValue, yValue);
          return index;
        }
        break;
      case 2:
        if (lastIndex != null) {
          if (index - lastIndex > 0) {
            for (int i = 1; i < index - lastIndex; i++) {
              lineChart2DataA.removeAt(lastIndex + 1);
            }
            // Set the current point to the data
            lineChart2DataA[lastIndex + 1] = new FlSpot(xValue, yValue);
            if (lineChart2DataA.length > lastIndex + 2)
              lineChart2DataA[lastIndex + 2] = new FlSpot(xValue, null);
            return lastIndex + 1;
          }
          else {
            for (var i = lastIndex + 1; i < lineChart2DataA.length; i++) {
            }
            lineChart2DataA.removeRange(lastIndex + 1, lineChart2DataA.length);
            if (index > 0) {
              lineChart2DataA.removeRange(0, index);
            }
            lineChart2DataA[0] = new FlSpot(xValue, yValue);
            if (lineChart2DataA.length > 1)
              lineChart2DataA[1] = new FlSpot(xValue, null);
            return 0;
          }
        }
        else {
          lineChart2DataA[index] = new FlSpot(xValue, yValue);
          return index;
        }
        break;
      case 3:
        if (lastIndex != null) {
          if (index - lastIndex > 0) {
            for (int i = 1; i < index - lastIndex; i++) {
              lineChart3DataA.removeAt(lastIndex + 1);
            }
            // Set the current point to the data
            lineChart3DataA[lastIndex + 1] = new FlSpot(xValue, yValue);
            if (lineChart3DataA.length > lastIndex + 2)
              lineChart3DataA[lastIndex + 2] = new FlSpot(xValue, null);
            return lastIndex + 1;
          }
          else {
            for (var i = lastIndex + 1; i < lineChart3DataA.length; i++) {
            }
            lineChart3DataA.removeRange(lastIndex + 1, lineChart3DataA.length);
            if (index > 0) {
              lineChart3DataA.removeRange(0, index);
            }
            lineChart3DataA[0] = new FlSpot(xValue, yValue);
            if (lineChart3DataA.length > 1)
              lineChart3DataA[1] = new FlSpot(xValue, null);
            return 0;
          }
        }
        else {
          lineChart3DataA[index] = new FlSpot(xValue, yValue);
          return index;
        }
        break;
      default:
        return null;
    }
  }

  static void getDataFromUSBToValues(double value, int valueIndex) {
    switch (valueIndex) {
      case 1:
        leftCurrentValue1Vti = value;
        break;
      case 2:
        leftCurrentValue2Vte = value;
        break;
      case 3:
        leftCurrentValue3PIP = value;
        break;
      case 4:
        leftCurrentValue4PEEP = value;
        break;
      case 5:
        leftCurrentValue5PIF = value;
        break;
      case 6:
        leftCurrentValue6PEF = value;
        break;
      default:
    }
  }
  
  static void generateSeries() {
    lineChart1DataA = new List<FlSpot>();
    lineChart2DataA = new List<FlSpot>();
    lineChart3DataA = new List<FlSpot>();
    
    for (double i = 0; i < graphLength; i++) {
      lineChart1DataA.add(FlSpot(i*10,null));
      lineChart2DataA.add(FlSpot(i*10,null)); 
      lineChart3DataA.add(FlSpot(i*10,null));
    }
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
