import 'package:flutter/material.dart';
import 'ConfigurationPage.dart';
import 'DisplayValuesPage.dart';
import 'Graph1.dart';
import 'Graph3.dart';
import 'main.dart';

class Graph2Page extends StatelessWidget {

  final TextEditingController minY = new TextEditingController();
  final TextEditingController maxY = new TextEditingController();

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
                    crossAxisAlignment: CrossAxisAlignment.center, 
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                    children: <Widget>[
                      Expanded(
                        flex: 1, 
                        child: Container(
                          child: GestureDetector(
                            child: MyAppState.lineChart2Data.length != 0 ? 
                              MyAppState.lineChart2 : 
                              Text("Error graficando"),
                            onTap: () 
                            {
                              Navigator.pop(context);
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => DisplayPage()));
                            },
                            onDoubleTap: ()
                            {
                              createAlert(context).then((onValue){
                                MyAppState.minYgraph2 = double.tryParse(onValue[0]);
                                MyAppState.maxYgraph2 = double.tryParse(onValue[1]);
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

