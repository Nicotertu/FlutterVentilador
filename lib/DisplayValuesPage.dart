import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ventilador1/ConfigurationPage.dart';
import 'package:ventilador1/ConnectUSB.dart';
import 'Graph1.dart';
import 'Graph2.dart';
import 'Graph3.dart';
import 'main.dart';

class DisplayPage extends StatefulWidget {
  @override
  DisplayPageState createState() => DisplayPageState();
}

class DisplayPageState extends State<DisplayPage> {
  static const String leftValue1Title = "Vti (mL)";
  static const String leftValue2Title = "Vte (mL)";
  static const String leftValue3Title = "PIP (cmH2O)";
  static const String leftValue4Title = "PEEP (cmH2O)";
  static const String leftValue5Title = "PIF (LPM)";
  static const String leftValue6Title = "PEF (LPM)";
  static const String rightValue1Title = "RR (BPM)";
  static const String rightValue2Title = "I:E";
  static const String rightValue3Title = "Ti (s)";
  static const String rightValue4Title = "Te (s)";
  static const String rightValue5Title = "Volumen (mL)";
  static String leftValue1Vti = "0";
  static String leftValue2Vte = "0";
  static String leftValue3PIP = "0";
  static String leftValue4PEEP = "0";
  static String leftValue5PIF = "0";
  static String leftValue6PEF = "0";
  static String rightValue1RR = "0";
  static String rightValue2IE = "0";
  static String rightValue3Ti = "0";
  static String rightValue4Te = "0";
  static String rightValue5Vol = "0";
  static String cycle = '0';
  bool paused = true;

  static void updateLeftStrings(double value1, double value2, double value3, double value4, double value5, double value6) {
    leftValue1Vti = value1.toInt().toString();
    leftValue2Vte = value2.toInt().toString();
    leftValue3PIP = value3.toStringAsFixed(2);
    leftValue4PEEP = value4.toStringAsFixed(2);
    leftValue5PIF = value5.toStringAsFixed(2);
    leftValue6PEF = value6.toStringAsFixed(2);
  }

  static void updateRightStrings(int value1, double value2, double value3, double value4, int value5) {
    rightValue1RR = value1.toString();
    rightValue2IE = value2.toString();
    rightValue3Ti = value3.toString();
    rightValue4Te = value4.toString();
    rightValue5Vol = value5.toString();
  }

  Timer checkIfConnectedTimer;
  int checkIfConnectedRate = 1;
  void checkIfConnected(Timer timer) {
    //return;
    if (ConnectUSBPageState.disconnectedSTM()) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      Fluttertoast.showToast(msg: 'USB Disconnected');
    }

  }

  @override
  void initState() {
    super.initState();

    checkIfConnectedTimer = Timer.periodic(Duration(seconds: checkIfConnectedRate), checkIfConnected);
    
    // Hide android menu
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    super.dispose();
    checkIfConnectedTimer.cancel();
  }

  Widget graphColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, 
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
      children: <Widget>[
        Expanded(
          flex: 1, 
          child: GestureDetector(child:
            Container(
              padding: EdgeInsets.only(left: 20, right: 10, top: 10),
              width: double.infinity,
              child: MyAppState.lineChart1 == null ? Text("Error graficando") : MyAppState.lineChart1,
              //child: ((MyAppState.lineChart1DataA.length == 0 && MyAppState.lineChart1DataB.length == 0) || MyAppState.lineChart1 == null) ? Text("Error graficando") : MyAppState.lineChart1,
            ),
            onTap: ()
            {
              Navigator.pop(context);
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => Graph1Page()));
            },
            onDoubleTap: ()
            {
              TextEditingController minY = new TextEditingController();
              TextEditingController maxY = new TextEditingController();

              MyAppState.changeYRangeDialog(context, minY, maxY, 1);
            },
            onVerticalDragUpdate: (details) 
            {
              MyAppState.verticalPan(details.delta.dy, 1);
            },
            onScaleUpdate: (details) 
            {
              MyAppState.zoomGraph(details.scale, 1);
            },
          ),
        ),
        Expanded(
          flex: 1, 
          child: GestureDetector(child:
            Container(
              padding: EdgeInsets.only(left: 20, right: 10, top: 10),
              width: double.infinity,
              child: MyAppState.lineChart2 == null ? Text("Error graficando") : MyAppState.lineChart2,
              //child: ((MyAppState.lineChart2DataA.length == 0 && MyAppState.lineChart2DataB.length == 0) || MyAppState.lineChart2 == null) ? Text("Error graficando") : MyAppState.lineChart2,
            ),
            onTap: ()
            {
              Navigator.pop(context);
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => Graph2Page()));
            },
            onDoubleTap: ()
            {
              TextEditingController minY = new TextEditingController();
              TextEditingController maxY = new TextEditingController();

              MyAppState.changeYRangeDialog(context, minY, maxY, 2);
            },
            onVerticalDragUpdate: (details) 
            {
              MyAppState.verticalPan(details.delta.dy, 2);
            },
            onScaleUpdate: (details) 
            {
              MyAppState.zoomGraph(details.scale, 2);
            },
          ),
        ),
        Expanded(
          flex: 1, 
          child: GestureDetector(child:
            Container(
              padding: EdgeInsets.only(left: 20, right: 10, top: 10),
              width: double.infinity,
              child: MyAppState.lineChart3 == null ? Text("Error graficando") : MyAppState.lineChart3,
              //child: ((MyAppState.lineChart3DataA.length == 0 && MyAppState.lineChart3DataB.length == 0) || MyAppState.lineChart3 == null) ? Text("Error graficando") : MyAppState.lineChart3,
            ),
            onTap: ()
            {
              Navigator.pop(context);
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => Graph3Page()));
            },
            onDoubleTap: ()
            {
              TextEditingController minY = new TextEditingController();
              TextEditingController maxY = new TextEditingController();

              MyAppState.changeYRangeDialog(context, minY, maxY, 3);
            },
            onVerticalDragUpdate: (details) 
            {
              MyAppState.verticalPan(details.delta.dy, 3);
            },
            onScaleUpdate: (details) 
            {
              MyAppState.zoomGraph(details.scale, 3);
            },
          ),
        ),
      ],
    );
  }

  Widget leftValues() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(leftValue1Title, style: MyAppState.mediumTextStyleLight)),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(leftValue1Vti, style: MyAppState.largeTextStyleLight)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(leftValue2Title, style: MyAppState.mediumTextStyleLight)),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(leftValue2Vte, style: MyAppState.largeTextStyleLight)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(leftValue3Title, style: MyAppState.mediumTextStyleLight)),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(leftValue3PIP, style: MyAppState.largeTextStyleLight)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(leftValue4Title, style: MyAppState.mediumTextStyleLight)),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(leftValue4PEEP, style: MyAppState.largeTextStyleLight)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(leftValue5Title, style: MyAppState.mediumTextStyleLight)),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(leftValue5PIF, style: MyAppState.largeTextStyleLight)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(leftValue6Title, style: MyAppState.mediumTextStyleLight)),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(leftValue6PEF, style: MyAppState.largeTextStyleLight)),
          ],
        ),
      ],
    );
  }

  Widget rightValues() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
      children: <Widget>[
        GestureDetector(
          onDoubleTap: () {
            MyAppState.changeParametersDialog(context);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(2), 
                child: Text(
                  rightValue1Title, 
                  style: MyAppState.mediumTextStyleLight,
                  textAlign: TextAlign.end,
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(2), 
                child: Text(
                  rightValue1RR, 
                  style: MyAppState.largeTextStyleLight,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onLongPress: () {
            if (Navigator.canPop(context)){
              Navigator.pop(context);
            }
            Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => ConfigurationPage()));
          },
          onDoubleTap: () {
            MyAppState.changeParametersDialog(context);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(2), 
                child: Text(
                  rightValue2Title, 
                  style: MyAppState.mediumTextStyleLight,
                  textAlign: TextAlign.end,
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(2), 
                child: Text(
                  "1 : " + rightValue2IE, 
                  style: MyAppState.largeTextStyleLight,
                  textAlign: TextAlign.end,
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(2), 
                child: Text(
                  rightValue3Title + ": " + rightValue3Ti, 
                  style: MyAppState.mediumTextStyleLight,
                  textAlign: TextAlign.end,
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(2), 
                child: Text(
                  rightValue4Title + ": " + rightValue4Te, 
                  style: MyAppState.mediumTextStyleLight,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            MyAppState.changeParametersDialog(context);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(2), 
                child: Text(
                  rightValue5Title, 
                  style: MyAppState.mediumTextStyleLight,
                  textAlign: TextAlign.end,
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(2), 
                child: Text(
                  rightValue5Vol, 
                  style: MyAppState.largeTextStyleLight,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        RaisedButton(
          onPressed: () {
            if(Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        RaisedButton(
          onPressed: () {
            if (paused) {
              ConnectUSBPageState.sendDataToSTM(MyAppState.resumeIdentifier);
            }
            else {
              ConnectUSBPageState.sendDataToSTM(MyAppState.pauseIdentifier);
            }
            paused = !paused;
          }, 
          child: Text(
            paused? 'Iniciar' : 'Pausar',
            style: MyAppState.mediumButtonTextStyleDark,
          ),
          color: MyAppState.buttonBackgroundColorLight,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      /*appBar: AppBar(
          title: Text(MyAppState.appTitle, style: TextStyle(color: MyAppState.buttonTextColor, fontSize: MyAppState.titleFontSize, fontStyle: MyAppState.fontStyle)),
          centerTitle: true,
        ),*/
      body: Container(
        padding: EdgeInsets.all(MyAppState.borderEdge),
        width: size.width, 
        height: size.height, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 9, child: Row(children: <Widget>[
                Expanded(flex: 1, child: leftValues()),
                Expanded(flex: 6, child: graphColumn(context)),
                Expanded(flex: 1, child: rightValues()),
              ],
            )
            ),
          ],
        )
      ),
    );
  }

}