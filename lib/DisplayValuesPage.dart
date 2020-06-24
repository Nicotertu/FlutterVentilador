import 'package:flutter/material.dart';
import 'Graph1.dart';
import 'Graph2.dart';
import 'Graph3.dart';
import 'main.dart';

class DisplayPage extends StatelessWidget {

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
            Expanded(
              flex: 1, 
              child: MyAppState.returnButtonRow(
                (){},
                MyAppState.button2Function(context),
                MyAppState.button3Function(context),
                MyAppState.button4Function(context),
                MyAppState.button5Function(context),
                MyAppState.button6Function(context)
              )
            ),
            Expanded(flex: 9, child: Row(children: <Widget>[
                VerticalDivider(color: MyAppState.dividerColorLight, width: 0,),
                Expanded(flex: 1, child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(margin: EdgeInsets.all(2), child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value1Title, style: MyAppState.mediumTextStyleLight))),
                        Container(margin: EdgeInsets.all(2), child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value1, style: MyAppState.largeTextStyleLight))),
                      ],
                    ),
                    Divider(color: MyAppState.dividerColorLight),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(margin: EdgeInsets.all(2), child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value2Title, style: MyAppState.mediumTextStyleLight))),
                        Container(margin: EdgeInsets.all(2), child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value2, style: MyAppState.largeTextStyleLight))),
                      ],
                    ),
                    Divider(color: MyAppState.dividerColorLight),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(margin: EdgeInsets.all(2), child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value3Title, style: MyAppState.mediumTextStyleLight))),
                        Container(margin: EdgeInsets.all(2), child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value3, style: MyAppState.largeTextStyleLight))),
                      ],
                    ),
                    Divider(color: MyAppState.dividerColorLight),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(margin: EdgeInsets.all(2), child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value4Title, style: MyAppState.mediumTextStyleLight))),
                        Container(margin: EdgeInsets.all(2), child: FittedBox(fit: BoxFit.fitWidth, child: Text(MyAppState.value4, style: MyAppState.largeTextStyleLight))),
                      ],
                    ),
                ],
                )
                ),
                VerticalDivider(color: MyAppState.dividerColorLight, width: 0,),
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

                          MyAppState.changeYRangeDialog(context, minY, maxY, 1);
                        },
                      ),
                    ),
                    Divider(color: MyAppState.dividerColorLight),
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

                          MyAppState.changeYRangeDialog(context, minY, maxY, 2);
                        },
                      ),
                    ),
                    Divider(color: MyAppState.dividerColorLight),
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

                          MyAppState.changeYRangeDialog(context, minY, maxY, 3);
                        },
                      ),
                    ),
                  ],
                )
                ),
                VerticalDivider(color: MyAppState.dividerColorLight, width: 0,),
              ],
            )
            ),
          ],
        )
      ),
    );
  }

}