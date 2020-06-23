import 'dart:developer';

import 'package:flutter/material.dart';
import 'ConfigurationPage.dart';
import 'Graph1.dart';
import 'Graph2.dart';
import 'Graph3.dart';
import 'main.dart';

class DisplayPage extends StatelessWidget {

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
          onPressed: () {},
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          title: Text(MyAppState.appTitle, style: MyAppState.titleTextStyle),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          width: size.width, 
          height: size.height, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(flex: 1, child: returnButtonRow(context)),
              Expanded(flex: 10, child: Row(children: <Widget>[
                  Expanded(flex: 1, child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(margin: EdgeInsets.all(2), color: MyAppState.leftValuesBackgroundColor, child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value1Title, style: TextStyle(fontSize: MyAppState.leftValuesTitleTextSize, color: MyAppState.leftValuesTextColor)))),
                          Container(margin: EdgeInsets.all(2), color: MyAppState.leftValuesBackgroundColor, child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value1, style: TextStyle(fontSize: MyAppState.leftValuesTextSize, color: MyAppState.leftValuesTextColor)))),
                        ],
                      ),
                      Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(margin: EdgeInsets.all(2), color: MyAppState.leftValuesBackgroundColor, child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value2Title, style: TextStyle(fontSize: MyAppState.leftValuesTitleTextSize, color: MyAppState.leftValuesTextColor)))),
                          Container(margin: EdgeInsets.all(2), color: MyAppState.leftValuesBackgroundColor, child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value2, style: TextStyle(fontSize: MyAppState.leftValuesTextSize, color: MyAppState.leftValuesTextColor)))),
                        ],
                      ),
                      Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(margin: EdgeInsets.all(2), color: MyAppState.leftValuesBackgroundColor, child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value3Title, style: TextStyle(fontSize: MyAppState.leftValuesTitleTextSize, color: MyAppState.leftValuesTextColor)))),
                          Container(margin: EdgeInsets.all(2), color: MyAppState.leftValuesBackgroundColor, child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value3, style: TextStyle(fontSize: MyAppState.leftValuesTextSize, color: MyAppState.leftValuesTextColor)))),
                        ],
                      ),
                      Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(margin: EdgeInsets.all(2), color: MyAppState.leftValuesBackgroundColor, child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value4Title, style: TextStyle(fontSize: MyAppState.leftValuesTitleTextSize, color: MyAppState.leftValuesTextColor)))),
                          Container(margin: EdgeInsets.all(2), color: MyAppState.leftValuesBackgroundColor, child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value4, style: TextStyle(fontSize: MyAppState.leftValuesTextSize, color: MyAppState.leftValuesTextColor)))),
                        ],
                      ),
                  ],
                  )
                  ),
                  Expanded(flex: 8, child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, 
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                    children: <Widget>[
                      Expanded(
                        flex: 1, 
                        child: Container(
                          child: GestureDetector(
                            //child: (MyAppState.stackedAreaSeries1.length == 0 || MyAppState.stackedAreaChart1 == null) ? Text("Error graficando") : MyAppState.stackedAreaChart1,
                            child: (MyAppState.lineChart1Data.length == 0 || MyAppState.lineChart1 == null) ? Text("Error graficando") : MyAppState.lineChart1,
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
                              Future<List<String>> createAlert(BuildContext context) {
                                return showDialog(context: context, builder: (context) { 
                                  return AlertDialog(
                                    title: Text('Configurar rango'),
                                    content: Column(
                                      children: <Widget>[
                                        TextField(
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          controller: minY,
                                        ), 
                                        Text('Valor minimo Y'),
                                        TextField(
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          controller: maxY,
                                        ), 
                                        Text('Valor maximo Y'),
                                        
                                      ],
                                    ),
                                    actions: <Widget>[
                                      RaisedButton(
                                          child: Text('Set'),
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                              [
                                                minY.text.toString() == ''? MyAppState.minYgraph1.toString() : minY.text.toString(), 
                                                maxY.text.toString() == ''? MyAppState.maxYgraph1.toString() : maxY.text.toString()
                                              ]
                                            );
                                          },
                                        )
                                    ],
                                  );
                                }
                                
                                );
                              }

                              createAlert(context).then((onValue){
                                MyAppState.minYgraph1 = double.tryParse(onValue[0]);
                                MyAppState.maxYgraph1 = double.tryParse(onValue[1]);
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1, 
                        child: Container(
                          child: GestureDetector(
                            //child: (MyAppState.stackedAreaSeries2.length == 0 || MyAppState.stackedAreaChart2 == null) ? Text("Error graficando") : MyAppState.stackedAreaChart2,
                            child: (MyAppState.lineChart2Data.length == 0 || MyAppState.lineChart2 == null) ? Text("Error graficando") : MyAppState.lineChart2,
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
                              Future<List<String>> createAlert(BuildContext context) {
                                return showDialog(context: context, builder: (context) { 
                                  return AlertDialog(
                                    title: Text('Configurar rango'),
                                    content: Column(
                                      children: <Widget>[
                                        TextField(
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          controller: minY,
                                        ), 
                                        Text('Valor minimo Y'),
                                        TextField(
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          controller: maxY,
                                        ), 
                                        Text('Valor maximo Y'),
                                        
                                      ],
                                    ),
                                    actions: <Widget>[
                                      RaisedButton(
                                          child: Text('Set'),
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                              [
                                                minY.text.toString() == ''? MyAppState.minYgraph2.toString() : minY.text.toString(), 
                                                maxY.text.toString() == ''? MyAppState.maxYgraph2.toString() : maxY.text.toString()
                                              ]
                                            );
                                          },
                                        )
                                    ],
                                  );
                                }
                                
                                );
                              }

                              createAlert(context).then((onValue){
                                MyAppState.minYgraph2 = double.tryParse(onValue[0]);
                                MyAppState.maxYgraph2 = double.tryParse(onValue[1]);
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1, 
                        child: Container(
                          child: GestureDetector(
                            //child: (MyAppState.stackedAreaSeries3.length == 0 || MyAppState.stackedAreaChart3 == null) ? Text("Error graficando") : MyAppState.stackedAreaChart3,
                            child: (MyAppState.lineChart3Data.length == 0 || MyAppState.lineChart3 == null) ? Text("Error graficando") : MyAppState.lineChart3,
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
                              Future<List<String>> createAlert(BuildContext context) {
                                return showDialog(context: context, builder: (context) { 
                                  return AlertDialog(
                                    title: Text('Configurar rango'),
                                    content: Column(
                                      children: <Widget>[
                                        TextField(
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          controller: minY,
                                        ), 
                                        Text('Valor minimo Y'),
                                        TextField(
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          controller: maxY,
                                        ), 
                                        Text('Valor maximo Y'),
                                        
                                      ],
                                    ),
                                    actions: <Widget>[
                                      RaisedButton(
                                          child: Text('Set'),
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                              [
                                                minY.text.toString() == ''? MyAppState.minYgraph3.toString() : minY.text.toString(), 
                                                maxY.text.toString() == ''? MyAppState.maxYgraph3.toString() : maxY.text.toString()
                                              ]
                                            );
                                          },
                                        )
                                    ],
                                  );
                                }
                                
                                );
                              }

                              createAlert(context).then((onValue){
                                MyAppState.minYgraph3 = double.tryParse(onValue[0]);
                                MyAppState.maxYgraph3 = double.tryParse(onValue[1]);
                              });
                            },
                          ),
                        ),
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