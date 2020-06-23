import 'package:flutter/material.dart';
import 'ConfigurationPage.dart';
import 'Graph1.dart';
import 'Graph2.dart';
import 'Graph3.dart';
import 'HospitalConfigurationPage.dart';
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
          onPressed: () 
          {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => HospitalConfigurationPage()));
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

  Future<List<String>> createAlert(BuildContext context, TextEditingController minY, TextEditingController maxY, int graph) {
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
                switch (graph) {
                  case 1:
                    Navigator.of(context).pop(
                      [
                        minY.text.toString() == ''? MyAppState.minYgraph1.toString() : minY.text.toString(),
                        maxY.text.toString() == ''? MyAppState.maxYgraph1.toString() : maxY.text.toString(),
                      ]
                    );
                    break;
                  case 2:
                    Navigator.of(context).pop(
                      [
                        minY.text.toString() == ''? MyAppState.minYgraph2.toString() : minY.text.toString(),
                        maxY.text.toString() == ''? MyAppState.maxYgraph2.toString() : maxY.text.toString(),
                      ]
                    );
                    break;
                  case 3:
                    Navigator.of(context).pop(
                      [
                        minY.text.toString() == ''? MyAppState.minYgraph3.toString() : minY.text.toString(),
                        maxY.text.toString() == ''? MyAppState.maxYgraph3.toString() : maxY.text.toString(),
                      ]
                    );
                    break;
                  default:
                }
              },
            )
        ],
      );
    }
    
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
            Expanded(flex: 1, child: returnButtonRow(context)),
            Expanded(flex: 10, child: Row(children: <Widget>[
                Expanded(flex: 1, child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(margin: EdgeInsets.all(2), /*color: MyAppState.leftValuesBackgroundColor, */child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value1Title, style: TextStyle(fontSize: MyAppState.leftValuesTitleTextSize, color: MyAppState.valueTextColor)))),
                        Container(margin: EdgeInsets.all(2), /*color: MyAppState.leftValuesBackgroundColor, */child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value1, style: TextStyle(fontSize: MyAppState.leftValuesTextSize, color: MyAppState.valueTextColor)))),
                      ],
                    ),
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(margin: EdgeInsets.all(2), /*color: MyAppState.leftValuesBackgroundColor, */child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value2Title, style: TextStyle(fontSize: MyAppState.leftValuesTitleTextSize, color: MyAppState.valueTextColor)))),
                        Container(margin: EdgeInsets.all(2), /*color: MyAppState.leftValuesBackgroundColor, */child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value2, style: TextStyle(fontSize: MyAppState.leftValuesTextSize, color: MyAppState.valueTextColor)))),
                      ],
                    ),
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(margin: EdgeInsets.all(2), /*color: MyAppState.leftValuesBackgroundColor, */child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value3Title, style: TextStyle(fontSize: MyAppState.leftValuesTitleTextSize, color: MyAppState.valueTextColor)))),
                        Container(margin: EdgeInsets.all(2), /*color: MyAppState.leftValuesBackgroundColor, */child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value3, style: TextStyle(fontSize: MyAppState.leftValuesTextSize, color: MyAppState.valueTextColor)))),
                      ],
                    ),
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(margin: EdgeInsets.all(2), /*color: MyAppState.leftValuesBackgroundColor, */child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value4Title, style: TextStyle(fontSize: MyAppState.leftValuesTitleTextSize, color: MyAppState.valueTextColor)))),
                        Container(margin: EdgeInsets.all(2), /*color: MyAppState.leftValuesBackgroundColor, */child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value4, style: TextStyle(fontSize: MyAppState.leftValuesTextSize, color: MyAppState.valueTextColor)))),
                      ],
                    ),
                ],
                )
                ),
                Expanded(flex: 6, child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                  children: <Widget>[
                    Expanded(
                      flex: 1, 
                      child: GestureDetector(
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

                          createAlert(context, minY, maxY, 1).then((onValue){
                            MyAppState.minYgraph1 = MyAppState.convertMillisecondToSecond(double.tryParse(onValue[0]));
                            MyAppState.maxYgraph1 = MyAppState.convertMillisecondToSecond(double.tryParse(onValue[1]));
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1, 
                      child: GestureDetector(
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

                          createAlert(context, minY, maxY, 2).then((onValue){
                            MyAppState.minYgraph2 = MyAppState.convertMillisecondToSecond(double.tryParse(onValue[0]));
                            MyAppState.maxYgraph2 = MyAppState.convertMillisecondToSecond(double.tryParse(onValue[1]));
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1, 
                      child: GestureDetector(
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

                          createAlert(context, minY, maxY, 3).then((onValue){
                            MyAppState.minYgraph3 = MyAppState.convertMillisecondToSecond(double.tryParse(onValue[0]));
                            MyAppState.maxYgraph3 = MyAppState.convertMillisecondToSecond(double.tryParse(onValue[1]));
                          });
                        },
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