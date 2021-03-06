import 'package:flutter/material.dart';
import 'DisplayValuesPage.dart';
import 'main.dart';

class Graph3Page extends StatelessWidget {

  final TextEditingController minY = new TextEditingController();
  final TextEditingController maxY = new TextEditingController();

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
            Expanded(child: Row(children: <Widget>[
                Expanded(flex: 1, child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                  children: <Widget>[
                    Expanded(
                      flex: 1, 
                      child: Container(
                        width: double.infinity,
                        child: GestureDetector(
                          child: (MyAppState.lineChart3DataA.length != 0 && MyAppState.lineChart3DataB.length != 0) ? 
                            MyAppState.lineChart3 : 
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
                            MyAppState.changeYRangeDialog(context, minY, maxY, 3);
                          },
                          onVerticalDragUpdate: (details) 
                          {
                            MyAppState.verticalPan(details.delta.dy, 3);
                          },
                          onScaleUpdate: (details) 
                          {
                            MyAppState.zoomGraph(details.scale, 3);
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

