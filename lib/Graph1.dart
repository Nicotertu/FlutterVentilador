import 'package:flutter/material.dart';
import 'DisplayValuesPage.dart';
import 'main.dart';

class Graph1Page extends StatelessWidget {
  final TextEditingController minY = new TextEditingController();
  final TextEditingController maxY = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(/*
      appBar: AppBar(
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
                MyAppState.button5Function(context),
                MyAppState.button6Function(context)
              )
            ),
            Expanded(flex: 9, child: Row(children: <Widget>[
                Expanded(flex: 1, child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center, 
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                  children: <Widget>[
                    Expanded(
                      flex: 1, 
                      child: Container(
                        child: GestureDetector(
                          child: MyAppState.lineChart1Data.length != 0 ? 
                            MyAppState.lineChart1 : 
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
                            MyAppState.changeYRangeDialog(context, minY, maxY, 1);
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

