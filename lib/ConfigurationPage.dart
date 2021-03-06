import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ConnectUSB.dart';
import 'DisplayValuesPage.dart';
import 'main.dart';

class ConfigurationPage extends StatelessWidget {

  static const double buttonPadding = 2;
  static const double buttonElevation = 0;
  static const double buttonWidth = 150;
  static const String button1Text = 'Parametros';
  static const String button2Text = 'K (x, kp, kv)';
  static const String button3Text = 'Pausa';
  static const String button4Text = 'Continuar';
  static const String button5Text = 'Calibrar';
  static const String button6Text = 'Detener';
  static const String button7Text = 'Reiniciar';
  static const String button8Text = 'Ambu';

  static TextEditingController param1Text = new TextEditingController();
  static TextEditingController param2Text = new TextEditingController();
  static TextEditingController param3Text = new TextEditingController();
  static String param1DecorationText = 'Parameter 1 (current: ' + param1.toString() + ')';
  static String param2DecorationText = 'Parameter 2 (current: ' + param2.toString() + ')';
  static String param3DecorationText = 'Parameter 3 (current: ' + param3.toString() + ')';
  
  static TextEditingController k1Text = new TextEditingController();
  static TextEditingController k2Text = new TextEditingController();
  static TextEditingController k3Text = new TextEditingController();
  static String k1DecorationText = 'Kx (current: ' + k1.toString() + ')';
  static String k2DecorationText = 'Kp (current: ' + k2.toString() + ')';
  static String k3DecorationText = 'Kv (current: ' + k3.toString() + ')';

  static double param1, param2, param3;
  static double k1, k2, k3;

  void adjustKMethod() {
    MyAppState.generateSeries();
    
    if (!ConnectUSBPageState.connectedToSTM()) {
      if (k1Text.text != "") {
        k1DecorationText = "Kx (current: " + k1Text.text + ")";
        k1 = double.tryParse(k1Text.text) == null ? k1 : double.tryParse(k1Text.text);
        ConnectUSBPageState.changeK(1, k1);
      }
      if (k2Text.text != "") {
        k2DecorationText = "Kp (current: " + k2Text.text + ")";
        k2 = double.tryParse(k2Text.text) == null ? k2 : double.tryParse(k2Text.text);
        ConnectUSBPageState.changeK(2, k2);
      }
      if (k3Text.text != "") {
        k3DecorationText = "Kv (current: " + k3Text.text + ")";
        k3 = double.tryParse(k3Text.text) == null ? k3 : double.tryParse(k3Text.text);
        ConnectUSBPageState.changeK(3, k3);
      }
    }
    else {
      String text1 = k1Text.text == "" ? k1 : k1Text.text;
      String text2 = k2Text.text == "" ? k2 : k2Text.text;
      String text3 = k3Text.text == "" ? k3 : k3Text.text;
      k1DecorationText = "Kx (current: " + text1 + ")";
      k2DecorationText = "Kp (current: " + text2 + ")";
      k3DecorationText = "Kv (current: " + text3 + ")";
      ConnectUSBPageState.sendKValToSTM(
        k1Text.text == "" ? k1 : k1Text.text, 
        k2Text.text == "" ? k2 : k2Text.text, 
        k3Text.text == "" ? k3 : k3Text.text, 
      );
    }
    
    k1Text.text = "";
    k2Text.text = "";
    k3Text.text = "";
  }

  void pauseMethod() {
    if (ConnectUSBPageState.connectedToSTM()) {
      ConnectUSBPageState.sendDataToSTM(MyAppState.pauseIdentifier);
    }
    else {
      if (ConnectUSBPageState.testTimer.isActive)
        ConnectUSBPageState.testTimer.cancel();
    }
  }

  void resumeMethod() {
    if (ConnectUSBPageState.connectedToSTM()) {
      ConnectUSBPageState.sendDataToSTM(MyAppState.resumeIdentifier);
    } 
    else {
      if (!ConnectUSBPageState.testTimer.isActive)
        ConnectUSBPageState.testTimer = Timer.periodic(Duration(milliseconds: ConnectUSBPageState.timerRate), ConnectUSBPageState.testFunc);
    }
  }

  void calibrateMethod() {
    if (ConnectUSBPageState.connectedToSTM()) {
      ConnectUSBPageState.sendDataToSTM(MyAppState.calibrateIdentifier);
    }
    else {

    }
  }

  void stopMethod() {
    if (ConnectUSBPageState.connectedToSTM()) {
      ConnectUSBPageState.sendDataToSTM(MyAppState.stopIdentifier);
    } 
    else {
      if (ConnectUSBPageState.testTimer.isActive)
        ConnectUSBPageState.testTimer.cancel();
    }
    MyAppState.generateSeries();
  }

  void restartMethod() {
    MyAppState.generateSeries();

    if (ConnectUSBPageState.connectedToSTM()) {
      ConnectUSBPageState.sendDataToSTM(MyAppState.restartIdentifier);
    }
    else {
      if (!ConnectUSBPageState.testTimer.isActive)
        ConnectUSBPageState.testTimer = Timer.periodic(Duration(milliseconds: ConnectUSBPageState.timerRate), ConnectUSBPageState.testFunc);
    }
  }

  void ambuMethod() {
    if (ConnectUSBPageState.connectedToSTM()) {
      ConnectUSBPageState.sendDataToSTM(MyAppState.plotIdenfitifer);
    }
    else {

    }
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
                Expanded(flex: 1, child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ButtonTheme(
                          minWidth: buttonWidth,
                          padding: EdgeInsets.all(buttonPadding),
                          child: RaisedButton(
                            color: MyAppState.buttonBackgroundColorLight,
                            elevation: buttonElevation,
                            padding: EdgeInsets.all(buttonPadding),
                            child: Text(button2Text, 
                              style: MyAppState.largeButtonTextStyleDark), 
                            onPressed: () async
                            {
                              // K (x, kp, kv)
                              adjustKMethod();
                            },
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(child: TextField(controller: k1Text, decoration: InputDecoration(labelText: k1DecorationText), keyboardType: TextInputType.numberWithOptions(decimal: true)), flex: 1),
                        const SizedBox(width: 25),
                        Expanded(child: TextField(controller: k2Text, decoration: InputDecoration(labelText: k2DecorationText), keyboardType: TextInputType.numberWithOptions(decimal: true)), flex: 1),
                        const SizedBox(width: 25),
                        Expanded(child: TextField(controller: k3Text, decoration: InputDecoration(labelText: k3DecorationText), keyboardType: TextInputType.numberWithOptions(decimal: true)), flex: 1),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonTheme(
                          minWidth: buttonWidth,
                          padding: EdgeInsets.all(buttonPadding),
                          child: RaisedButton(
                            color: MyAppState.buttonBackgroundColorLight,
                            elevation: buttonElevation,
                            padding: EdgeInsets.all(buttonPadding),
                            child: Text(button3Text, 
                              style: MyAppState.largeButtonTextStyleDark), 
                            onPressed: () 
                            {
                              // Pausa
                              pauseMethod();
                            },
                          ),
                        ),
                        const SizedBox(width: 30),
                        ButtonTheme(
                          minWidth: buttonWidth,
                          padding: EdgeInsets.all(buttonPadding),
                          child: RaisedButton(
                            color: MyAppState.buttonBackgroundColorLight,
                            elevation: buttonElevation,
                            padding: EdgeInsets.all(buttonPadding),
                            child: Text(button4Text, 
                              style: MyAppState.largeButtonTextStyleDark), 
                            onPressed: () 
                            {
                              // Continuar
                              resumeMethod();
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonTheme(
                          minWidth: buttonWidth,
                          padding: EdgeInsets.all(buttonPadding),
                          child: RaisedButton(
                            color: MyAppState.buttonBackgroundColorLight,
                            elevation: buttonElevation,
                            padding: EdgeInsets.all(buttonPadding),
                            child: Text(button5Text, 
                              style: MyAppState.largeButtonTextStyleDark), 
                            onPressed: () 
                            {
                              // Calibrar
                              calibrateMethod();
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonTheme(
                          minWidth: buttonWidth,
                          padding: EdgeInsets.all(buttonPadding),
                          child: RaisedButton(
                            color: MyAppState.buttonBackgroundColorLight,
                            elevation: buttonElevation,
                            padding: EdgeInsets.all(buttonPadding),
                            child: Text(button6Text, 
                              style: MyAppState.largeButtonTextStyleDark), 
                            onPressed: () 
                            {
                              // Detener
                              stopMethod();
                            },
                          ),
                        ),
                        const SizedBox(width: 30),
                        ButtonTheme(
                          minWidth: buttonWidth,
                          padding: EdgeInsets.all(buttonPadding),
                          child: RaisedButton(
                            color: MyAppState.buttonBackgroundColorLight,
                            elevation: buttonElevation,
                            padding: EdgeInsets.all(buttonPadding),
                            child: Text(button7Text, 
                              style: MyAppState.largeButtonTextStyleDark), 
                            onPressed: () 
                            {
                              // Reiniciar
                              restartMethod();
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonTheme(
                          minWidth: buttonWidth,
                          padding: EdgeInsets.all(buttonPadding),
                          child: RaisedButton(
                            color: MyAppState.buttonBackgroundColorLight,
                            elevation: buttonElevation,
                            padding: EdgeInsets.all(buttonPadding),
                            child: Text(button8Text, 
                              style: MyAppState.largeButtonTextStyleDark), 
                            onPressed: () 
                            {
                              // Ambu
                              ambuMethod();
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonTheme(
                          minWidth: buttonWidth,
                          padding: EdgeInsets.all(buttonPadding),
                          child: RaisedButton(
                            color: MyAppState.buttonBackgroundColorLight,
                            elevation: buttonElevation,
                            padding: EdgeInsets.all(buttonPadding),
                            child: Text('Detener simulacion', 
                              style: MyAppState.largeButtonTextStyleDark), 
                            onPressed: () 
                            {
                              if (ConnectUSBPageState.testTimer.isActive)
                                ConnectUSBPageState.testTimer.cancel();
                            },
                          ),
                        ),
                        ButtonTheme(
                          minWidth: buttonWidth,
                          padding: EdgeInsets.all(buttonPadding),
                          child: RaisedButton(
                            color: MyAppState.buttonBackgroundColorLight,
                            elevation: buttonElevation,
                            padding: EdgeInsets.all(buttonPadding),
                            child: Text('Salir', 
                              style: MyAppState.largeButtonTextStyleDark), 
                            onPressed: () 
                            {
                              if (Navigator.canPop(context))
                                Navigator.pop(context);

                              Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) => DisplayPage()
                                  )
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                ),
              ],
            )
            ),
          ],
        )
      ),
    );
  }

}