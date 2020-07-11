import 'package:flutter/material.dart';
import 'package:ventilador1/ConnectUSB.dart';
import 'main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HospitalConfigurationPage extends StatefulWidget {
  @override
  HospitalConfigurationPageState createState() => HospitalConfigurationPageState();
}

class HospitalConfigurationPageState extends State<HospitalConfigurationPage> {
  static const double buttonFontSize = 30;
  static const double textFontSize = 30;
  static const double textFieldSeparation = 200;
  static const double verticalSeparationButtonToText = 25;
  static const double verticalSeparationTextToField = 100;
  static const String upperButtonText = '+';
  static const String lowerButtonText = '-';
  static const String parameterText1 = 'RR';
  static const String parameterText2 = 'Volumen';
  static const String parameterText3 = 'I:E';
  static const String hintText1 = 'RR';
  static const String hintText2 = 'Volumen';
  static const String hintText3 = 'I:E';
  static const String confirmButtonText = 'Aceptar';

  TextEditingController controller1 = new TextEditingController(text: MyAppState.rightCurrentValue1RR.toString());
  TextEditingController controller2 = new TextEditingController(text: MyAppState.rightCurrentValue2IE.toString());
  TextEditingController controller3 = new TextEditingController(text: MyAppState.rightCurrentValue5Vol.toString());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static void acceptedInputToast() {
    Fluttertoast.showToast(
      msg: parameterText1 + ': ' + MyAppState.rightCurrentValue1RR.toString() + '\r\n' +
        parameterText2 + ': ' + MyAppState.rightCurrentValue2IE.toString() + '\r\n' +
        parameterText3 + ': ' + MyAppState.rightCurrentValue5Vol.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: MyAppState.toastBackground,
      textColor: MyAppState.toastTextColor,
      fontSize: 15
    );
  }

  @override 
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      /*appBar: AppBar(
          title: Text(MyAppState.appTitle, style: TextStyle(color: MyAppState.buttonTextColor, fontSize: MyAppState.titleFontSize, fontStyle: MyAppState.fontStyle)),
          centerTitle: true,
        ),*/
      body: Container(
        padding: EdgeInsets.all(20),
        width: size.width, 
        height: size.height, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 9, child: 
              Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(child:
                    Column(children: <Widget>[
                      SizedBox(height: verticalSeparationButtonToText),
                      TextField(
                        controller: controller1,
                        decoration: InputDecoration(/*hintText: hintText1, */border: InputBorder.none),
                        textAlign: TextAlign.center,
                        style: MyAppState.largeTextStyleLight,
                        //readOnly: true,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (String value) {
                          if (controller1.text.contains(',')) {
                            controller1.text = controller1.text.replaceAll(',', '.');
                            controller1.selection = TextSelection.collapsed(offset: controller1.text.length);
                          }
                        },
                        onTap: () {controller1.text = '';},
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: ()
                            {
                              if (double.tryParse(controller1.text) != null) {
                                controller1.text = (double.tryParse(controller1.text) - 1).toString();
                              }
                            }, 
                            child: Text(lowerButtonText, style: MyAppState.largeButtonTextStyleDark,), 
                            shape: CircleBorder(),
                            color: MyAppState.buttonBackgroundColorLight,
                          ),
                          RaisedButton(
                            onPressed: ()
                            {
                              if (double.tryParse(controller1.text) != null) {
                                controller1.text = (double.tryParse(controller1.text) + 1).toString();
                              }
                            }, 
                            child: Text(upperButtonText, style: MyAppState.largeButtonTextStyleDark,), 
                            shape: CircleBorder(),
                            color: MyAppState.buttonBackgroundColorLight,
                          ),
                      ],),
                      Divider(color: MyAppState.dividerColorLight),
                      Text(parameterText1, style: MyAppState.largeTextStyleLight),
                    ],),
                  ),
                  SizedBox(width: textFieldSeparation),
                  Expanded(child:
                    Column(children: <Widget>[
                      SizedBox(height: verticalSeparationButtonToText),
                      TextField(
                        controller: controller2,
                        decoration: InputDecoration(/*hintText: hintText1, */border: InputBorder.none),
                        textAlign: TextAlign.center,
                        style: MyAppState.largeTextStyleLight,
                        //readOnly: true,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (String value) {
                          if (controller2.text.contains(',')) {
                            controller2.text = controller2.text.replaceAll(',', '.');
                            controller2.selection = TextSelection.collapsed(offset: controller2.text.length);
                          }
                        },
                        onTap: () {controller2.text = '';},
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: ()
                            {
                              if (double.tryParse(controller2.text) != null) {
                                controller2.text = (double.tryParse(controller2.text) - 1).toString();
                              }
                            }, 
                            child: Text(lowerButtonText, style: MyAppState.largeButtonTextStyleDark,), 
                            shape: CircleBorder(),
                            color: MyAppState.buttonBackgroundColorLight,
                          ),
                          RaisedButton(
                            onPressed: ()
                            {
                              if (double.tryParse(controller2.text) != null) {
                                controller2.text = (double.tryParse(controller2.text) + 1).toString();
                              }
                            }, 
                            child: Text(upperButtonText, style: MyAppState.largeButtonTextStyleDark,), 
                            shape: CircleBorder(),
                            color: MyAppState.buttonBackgroundColorLight,
                          ),
                      ],),
                      Divider(color: MyAppState.dividerColorLight),
                      Text(parameterText2, style: MyAppState.largeTextStyleLight),
                    ],),
                  ),
                  SizedBox(width: textFieldSeparation),
                  Expanded(child:
                    Column(children: <Widget>[
                      SizedBox(height: verticalSeparationButtonToText),
                      TextField(
                        controller: controller3,
                        decoration: InputDecoration(/*hintText: hintText1, */border: InputBorder.none),
                        textAlign: TextAlign.center,
                        style: MyAppState.largeTextStyleLight,
                        //readOnly: true,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (String value) {
                          if (controller3.text.contains(',')) {
                            controller3.text = controller3.text.replaceAll(',', '.');
                            controller3.selection = TextSelection.collapsed(offset: controller3.text.length);
                          }
                        },
                        onTap: () {controller3.text = '';},
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: ()
                            {
                              if (double.tryParse(controller3.text) != null) {
                                controller3.text = (double.tryParse(controller3.text) - 1).toString();
                              }
                            }, 
                            child: Text(lowerButtonText, style: MyAppState.largeButtonTextStyleDark,), 
                            shape: CircleBorder(),
                            color: MyAppState.buttonBackgroundColorLight,
                          ),
                          RaisedButton(
                            onPressed: ()
                            {
                              if (double.tryParse(controller3.text) != null) {
                                controller3.text = (double.tryParse(controller3.text) + 1).toString();
                              }
                            }, 
                            child: Text(upperButtonText, style: MyAppState.largeButtonTextStyleDark,), 
                            shape: CircleBorder(),
                            color: MyAppState.buttonBackgroundColorLight,
                          ),
                      ],),
                      Divider(color: MyAppState.dividerColorLight),
                      Text(parameterText3, style: MyAppState.largeTextStyleLight,)
                    ],),
                  ),
                ]
              ),
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(onPressed: () {
                    bool validText = controller1.text != '' && controller2.text != '' && controller3.text != '';
                    bool validNumbers = int.tryParse(controller1.text) != null && int.tryParse(controller2.text) != null && int.tryParse(controller3.text) != null;
                    if (validText && validNumbers) {
                      ConnectUSBPageState.sendParamsToSTM(
                        int.tryParse(controller1.text), 
                        double.tryParse(controller2.text),
                        int.tryParse(controller3.text), 
                      );
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
                  child: Text(confirmButtonText, style: MyAppState.largeButtonTextStyleDark), color: MyAppState.buttonBackgroundColorLight,)
                ],)
              ],)
            ),
          ],
        ),
      ),
    );
  }
}