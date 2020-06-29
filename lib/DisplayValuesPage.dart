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

  static const String value1Title = "Vti (mL)";
  static const String value2Title = "Vte (mL)";
  static const String value3Title = "PIP (cmH2O)";
  static const String value4Title = "PEEP (cmH2O)";
  static const String value5Title = "RR";
  static const String value6Title = "Volumen";
  static const String value7Title = "I:E";
  static String value1Vti = "0";
  static String value2Vte = "0";
  static String value3PIP = "0";
  static String value4PEEP = "0";
  static String value5RR = "0";
  static String value6Vol = "0";
  static String value7IE = "0";

  static void updateStrings(double value1, double value2, double value3, double value4, int value5, int value6, int value7) {
    value1Vti = value1.toStringAsFixed(2);
    value2Vte = value2.toStringAsFixed(2);
    value3PIP = value3.toStringAsFixed(2);
    value4PEEP = value4.toStringAsFixed(2);
    value5RR = value5.toString();
    value6Vol = value6.toString();
    value7IE = value7.toString();
  }

  Timer checkIfConnectedTimer;
  int checkIfConnectedRate = 1;
  void checkIfConnected(Timer timer) {
    if (ConnectUSBPageState.disconnectedSTM()) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      Fluttertoast.showToast(msg: 'STM Disconnected');
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
              child: (MyAppState.lineChart1DataA.length == 0 || MyAppState.lineChart1 == null) ? Text("Error graficando") : MyAppState.lineChart1,
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
              child: (MyAppState.lineChart2DataA.length == 0 || MyAppState.lineChart2 == null) ? Text("Error graficando") : MyAppState.lineChart2,
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
              child: (MyAppState.lineChart3DataA.length == 0 || MyAppState.lineChart3 == null) ? Text("Error graficando") : MyAppState.lineChart3,
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
              child: Text(value1Title, style: MyAppState.mediumTextStyleLight)),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(value1Vti, style: MyAppState.largeTextStyleLight)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(value2Title, style: MyAppState.mediumTextStyleLight)),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(value2Vte, style: MyAppState.largeTextStyleLight)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(value3Title, style: MyAppState.mediumTextStyleLight)),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(value3PIP, style: MyAppState.largeTextStyleLight)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(value4Title, style: MyAppState.mediumTextStyleLight)),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(2), 
              child: Text(value4PEEP, style: MyAppState.largeTextStyleLight)),
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
                  value5Title, 
                  style: MyAppState.mediumTextStyleLight,
                  textAlign: TextAlign.end,
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(2), 
                child: Text(
                  value5RR, 
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
                  value6Title, 
                  style: MyAppState.mediumTextStyleLight,
                  textAlign: TextAlign.end,
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(2), 
                child: Text(
                  value6Vol, 
                  style: MyAppState.largeTextStyleLight,
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
                  value7Title, 
                  style: MyAppState.mediumTextStyleLight,
                  textAlign: TextAlign.end,
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(2), 
                child: Text(
                  value7IE, 
                  style: MyAppState.largeTextStyleLight,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
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