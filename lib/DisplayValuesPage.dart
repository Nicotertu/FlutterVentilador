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
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => Graph1Page()));
          },
          color: MyAppState.buttonBackgroundColor,
        ),
        RaisedButton(
          child: Text(MyAppState.button4Title, 
            style: TextStyle(fontSize: MyAppState.buttonTextSize, color: MyAppState.buttonTextColor, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => Graph2Page()));
          },
          color: MyAppState.buttonBackgroundColor,
        ),
        RaisedButton(
          child: Text(MyAppState.button5Title, 
            style: TextStyle(fontSize: MyAppState.buttonTextSize, color: MyAppState.buttonTextColor, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => Graph3Page()));
          },
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
                      Expanded(flex: 1, child: (MyAppState.stackedAreaSeries1.length == 0 || MyAppState.stackedAreaChart1 == null) ? Text("Error graficando") : MyAppState.stackedAreaChart1),
                      Expanded(flex: 1, child: (MyAppState.stackedAreaSeries2.length == 0 || MyAppState.stackedAreaChart2 == null) ? Text("Error graficando") : MyAppState.stackedAreaChart2),
                      Expanded(flex: 1, child: (MyAppState.stackedAreaSeries3.length == 0 || MyAppState.stackedAreaChart3 == null) ? Text("Error graficando") : MyAppState.stackedAreaChart3),
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