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

  static double parameter1Value = 0;
  static double parameter2Value = 1;
  static double parameter3Value = 2;
  TextEditingController controller1 = new TextEditingController(text: parameter1Value.toString());
  TextEditingController controller2 = new TextEditingController(text: parameter2Value.toString());
  TextEditingController controller3 = new TextEditingController(text: parameter3Value.toString());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            Expanded(
              flex: 1, 
              child: MyAppState.returnButtonRow(
                MyAppState.button1Function(context),
                MyAppState.button2Function(context),
                MyAppState.button3Function(context),
                MyAppState.button4Function(context),
                () {},
                MyAppState.button6Function(context)
              )
            ),
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
                          if (double.tryParse(value) != null) {
                            parameter1Value = double.tryParse(value);
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
                                parameter1Value--;
                                controller1.text = parameter1Value.toString();
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
                                parameter1Value++;
                                controller1.text = parameter1Value.toString();
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
                          if (double.tryParse(value) != null) {
                            parameter2Value = double.tryParse(value);
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
                                parameter2Value--;
                                controller2.text = parameter2Value.toString();
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
                                parameter2Value++;
                                controller2.text = parameter2Value.toString();
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
                          if (double.tryParse(value) != null) {
                            parameter3Value = double.tryParse(value);
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
                                parameter3Value--;
                                controller3.text = parameter1Value.toString();
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
                                parameter3Value++;
                                controller3.text = parameter3Value.toString();
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
                    if (validText)  {
                      ConnectUSBPageState.sendParamsToSTM(
                        parameter1Value.toInt(), 
                        parameter2Value.toInt(), 
                        parameter3Value.toInt()
                      );
                      Fluttertoast.showToast(
                        msg: parameterText1 + ': ' + parameter1Value.toString() + '\r\n' +
                          parameterText2 + ': ' + parameter2Value.toString() + '\r\n' +
                          parameterText3 + ': ' + parameter3Value.toString(),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 15
                      );
                    }
                    else {
                      Fluttertoast.showToast(
                        msg: 'Error en input',
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