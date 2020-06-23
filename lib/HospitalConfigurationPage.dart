import 'package:flutter/material.dart';
import 'ConfigurationPage.dart';
import 'DisplayValuesPage.dart';
import 'main.dart';

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

  static double parameter1Value = 0;
  static double parameter2Value = 1;
  static double parameter3Value = 2;
  TextEditingController controller1 = new TextEditingController(text: parameter1Value.toString());
  TextEditingController controller2 = new TextEditingController(text: parameter2Value.toString());
  TextEditingController controller3 = new TextEditingController(text: parameter3Value.toString());

  Row returnButtonRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        RaisedButton(
          child: Text(MyAppState.button1Title, 
            style: TextStyle(fontSize: MyAppState.buttonTextSize, color: MyAppState.buttonTextColor, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => DisplayPage()));
          },
          color: MyAppState.buttonBackgroundColor,
        ),
        RaisedButton(
          child: Text(MyAppState.button2Title, 
            style: TextStyle(fontSize: MyAppState.buttonTextSize, color: MyAppState.buttonTextColor, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: MyAppState.buttonBackgroundColor,
        ),
        RaisedButton(
          child: Text(MyAppState.button3Title, 
            style: TextStyle(fontSize: MyAppState.buttonTextSize, color: MyAppState.buttonTextColor, fontWeight: FontWeight.bold),
          ),
          onPressed: () {},
          color: MyAppState.buttonBackgroundColor,
        ),
        RaisedButton(
          child: Text(MyAppState.button4Title, 
            style: TextStyle(fontSize: MyAppState.buttonTextSize, color: MyAppState.buttonTextColor, fontWeight: FontWeight.bold),
          ),
          onPressed: () {},
          color: MyAppState.buttonBackgroundColor,
        ),
        RaisedButton(
          child: Text(MyAppState.button5Title, 
            style: TextStyle(fontSize: MyAppState.buttonTextSize, color: MyAppState.buttonTextColor, fontWeight: FontWeight.bold),
          ),
          onPressed: () {},
          color: MyAppState.buttonBackgroundColor,
        ),
        RaisedButton(
          child: Text(MyAppState.button6Title, 
            style: TextStyle(fontSize: MyAppState.buttonTextSize, color: MyAppState.buttonTextColor, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => ConfigurationPage()));
          },
          color: MyAppState.buttonBackgroundColor,
        )
      ],
    );
  }
  
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
            Expanded(flex: 1, child: returnButtonRow(context)),
            Expanded(flex: 10, child: 
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
                        style: TextStyle(
                          //backgroundColor: Colors.deepPurple,
                          fontSize: textFontSize,
                          color: MyAppState.valueTextColor,
                        ),
                        //readOnly: true,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (String value) {
                          if (double.tryParse(value) != null) {
                            parameter1Value = double.tryParse(value);
                          }
                        },
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
                            child: Text(lowerButtonText, style: TextStyle(fontSize: buttonFontSize, color: MyAppState.buttonTextColor,),), 
                            shape: CircleBorder(),
                            color: MyAppState.buttonBackgroundColor,
                          ),
                          RaisedButton(
                            onPressed: ()
                            {
                              if (double.tryParse(controller1.text) != null) {
                                parameter1Value++;
                                controller1.text = parameter1Value.toString();
                              }
                            }, 
                            child: Text(upperButtonText, style: TextStyle(fontSize: buttonFontSize, color: MyAppState.buttonTextColor,),), 
                            shape: CircleBorder(),
                            color: MyAppState.buttonBackgroundColor,
                          ),
                      ],),
                      Divider(),
                      Text(parameterText1, style: TextStyle(fontSize: textFontSize, color: MyAppState.valueTextColor)),
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
                        style: TextStyle(
                          //backgroundColor: Colors.deepPurple,
                          fontSize: textFontSize,
                          color: MyAppState.valueTextColor,
                        ),
                        //readOnly: true,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (String value) {
                          if (double.tryParse(value) != null) {
                            parameter2Value = double.tryParse(value);
                          }
                        },
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
                            child: Text(lowerButtonText, style: TextStyle(fontSize: buttonFontSize, color: MyAppState.buttonTextColor,),), 
                            shape: CircleBorder(),
                            color: MyAppState.buttonBackgroundColor,
                          ),
                          RaisedButton(
                            onPressed: ()
                            {
                              if (double.tryParse(controller2.text) != null) {
                                parameter2Value++;
                                controller2.text = parameter2Value.toString();
                              }
                            }, 
                            child: Text(upperButtonText, style: TextStyle(fontSize: buttonFontSize, color: MyAppState.buttonTextColor,),), 
                            shape: CircleBorder(),
                            color: MyAppState.buttonBackgroundColor,
                          ),
                      ],),
                      Divider(),
                      Text(parameterText2, style: TextStyle(fontSize: textFontSize, color: MyAppState.valueTextColor)),
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
                        style: TextStyle(
                          //backgroundColor: Colors.deepPurple,
                          fontSize: textFontSize,
                          color: MyAppState.valueTextColor,
                        ),
                        //readOnly: true,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (String value) {
                          if (double.tryParse(value) != null) {
                            parameter3Value = double.tryParse(value);
                          }
                        },
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
                            child: Text(lowerButtonText, style: TextStyle(fontSize: buttonFontSize, color: MyAppState.buttonTextColor,),), 
                            shape: CircleBorder(),
                            color: MyAppState.buttonBackgroundColor,
                          ),
                          RaisedButton(
                            onPressed: ()
                            {
                              if (double.tryParse(controller3.text) != null) {
                                parameter3Value++;
                                controller3.text = parameter3Value.toString();
                              }
                            }, 
                            child: Text(upperButtonText, style: TextStyle(fontSize: buttonFontSize, color: MyAppState.buttonTextColor,),), 
                            shape: CircleBorder(),
                            color: MyAppState.buttonBackgroundColor,
                          ),
                      ],),
                      Divider(),
                      Text(parameterText3, style: TextStyle(fontSize: textFontSize, color: MyAppState.valueTextColor)),
                    ],),
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}