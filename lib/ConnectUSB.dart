import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:usb_serial/usb_serial.dart';
import 'package:usb_serial/transaction.dart';
import 'ConfigurationPage.dart';
import 'DisplayValuesPage.dart';
import 'Graph1.dart';
import 'Graph2.dart';
import 'Graph3.dart';
import 'main.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

void main() => runApp(ConnectUSBPage());

class ConnectUSBPage extends StatefulWidget {
  @override
  ConnectUSBPageState createState() => ConnectUSBPageState();
}

class ConnectUSBPageState extends State<ConnectUSBPage> {
  static UsbPort _port;
  String _status = "Idle";
  List<Widget> _ports = [];
  List<Widget> _serialData = [];
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  int _deviceId;
  TextEditingController _textController = TextEditingController();

  Future<bool> _connectTo(device) async {
    
    _serialData.clear();

    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction.dispose();
      _transaction = null;
    }

    if (_port != null) {
      _port.close();
      _port = null;
    }

    if (device == null) {
      _deviceId = null;
      _status = "Disconnected";
      return true;
    }

    _port = await device.create();
    if (!await _port.open()) {
      _status = "Failed to open port";
      return false;
    }

    _deviceId = device.deviceId;
    await _port.setDTR(true);
    await _port.setRTS(true);
    await _port.setPortParameters(
        115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    _transaction = Transaction.stringTerminated(
        _port.inputStream, Uint8List.fromList([13, 10]));

    _subscription = _transaction.stream.listen((String line) {
      parseDataFromUSB(line);
      _serialData.add(Text(line));
      if (_serialData.length > 2) {
        _serialData.removeAt(0);
      }
    });
    _status = "Connected";
    return true;
  }

  void _getPorts() async {
    _ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    print(devices);

    devices.forEach((device) {
      _ports.add(ListTile(
          leading: Icon(Icons.usb),
          title: Text(device.productName),
          subtitle: Text(device.manufacturerName),
          trailing: RaisedButton(
            child:
                Text(_deviceId == device.deviceId ? "Disconnect" : "Connect"),
            onPressed: () {
              _connectTo(_deviceId == device.deviceId ? null : device)
                  .then((res) {
                _getPorts();
              });
            },
          )));
    });
    print(_ports);
  }

  @override
  void initState() {
    super.initState();

    UsbSerial.usbEventStream.listen((UsbEvent event) {
      _getPorts();
    });

    _getPorts();

    //testTimer = Timer.periodic(Duration(milliseconds: timerRate), testFunc);

    // Force the orientation to be landscape 
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    ConfigurationPage.param1 = graph1Freq;
    ConfigurationPage.param2 = graph2Freq;
    ConfigurationPage.param3 = graph3Amplitude;
    ConfigurationPage.k1 = k1Amplitude;
    ConfigurationPage.k2 = k2Amplitude;
    ConfigurationPage.k3 = k3Amplitude;
  }

  static int timerRate = 15;
  static Timer testTimer;
  static int counter = 0;
  static double counterr = 0;
  static String textSample;
  static double graph1Freq = 2.7;
  static double graph2Freq = 4.8;
  static double graph3Amplitude = 2;
  static double k1Amplitude = 5;
  static double k2Amplitude = 1;
  static double k3Amplitude = 3;
  static List<Widget> textWidgets = new List<Widget>();
  static void testFunc(Timer timer) {
    textSample = "";
    textWidgets.clear();
    counter++;
    textWidgets.add(Text("aaa,123456\r\n"));
    textWidgets.add(Text("DATA,123456\r\n"));
    textWidgets.add(Text("TOGRAPH: 123456\r\n"));

    double graphVariable1 = math.sin(graph1Freq * counter/100);
    double graphVariable2 = math.sin(graph2Freq * counter/100);
    double graphVariable3 = (graphVariable1 + graphVariable2) * graph3Amplitude;
    double rand1 = k1Amplitude * (1 + math.Random().nextInt(10) / 100);
    double rand2 = k2Amplitude * (1 + math.Random().nextInt(10) / 100);
    double rand3 = k3Amplitude * (1 + math.Random().nextInt(10) / 100);
    double rand4 = rand1 + rand2 + rand3;

    textSample = "DATATOGRAPH: ";
    textSample += MyAppState.value1Identifier + rand1.toString();
    textSample += ",";
    textSample += MyAppState.value2Identifier + rand2.toString();
    textSample += ",";
    textSample += MyAppState.value3Identifier + rand3.toString();
    textSample += ",";
    textSample += MyAppState.value4Identifier + rand4.toString();
    textSample += ",";
    textSample += MyAppState.graph1Identifier + graphVariable1.toString();
    textSample += ",";
    textSample += MyAppState.graph2Identifier + graphVariable2.toString();
    textSample += ",";
    textSample += MyAppState.graph3Identifier + graphVariable3.toString();
    textSample += ",";
    textSample += MyAppState.xIdentifier + (counterr*5).toString();
    textSample += ",";
    textSample += "\r\n";

    textWidgets[0] = (Text(textSample));
    parseDataFromUSB(textSample);
    counterr++;
    if (counterr > MyAppState.graphLength)
      counterr = 0;
  }

  @override
  void dispose() {
    super.dispose();
    //_connectTo(null);
  }

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
          onPressed: () {},
          color: MyAppState.buttonBackgroundColor,
        ),
        RaisedButton(
          child: Text(MyAppState.button3Title, 
            style: TextStyle(fontSize: MyAppState.buttonTextSize, color: MyAppState.buttonTextColor, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            //Navigator.pop(context);
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
            //Navigator.pop(context);
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
            //Navigator.pop(context);
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
  
  static String lastTextSent = '';
  static void sendDataToSTM(String data) async {
    if (_port != null) {
      await _port.write(Uint8List.fromList((data + '\r\n').codeUnits));
      lastTextSent = data + '\r\n';
    }
  }

  static void parseDataFromUSB(String data) {
    String myData = "";
    if (data.contains(MyAppState.receivingValuesIdentifier)) {
      // remove datatograph initializer
      data = data.replaceAll(new RegExp(MyAppState.receivingValuesIdentifier), '');

      // get the data position first
      double position = 0;
      if (data.contains(MyAppState.xIdentifier)) {
        // grab from the identifier to the end
        String numberString = data.substring(data.indexOf(MyAppState.xIdentifier));
        // remove the identifier
        numberString = numberString.substring(MyAppState.xIdentifier.length);
        // get the index of the next comma
        int commaIndex = numberString.indexOf(',');
        // remove everything after the comma (included)
        numberString = numberString.substring(0, commaIndex - 1);
        // transform into double
        position = double.tryParse(numberString);
      }
      else {
        //ERROR
      }
      myData += data + '\r\n';
      // extract number by number as long as there are commas
      while (data.contains(',')) {
        // find the index of the comma
        int index = data.indexOf(',');
        // grab everything from the beginning to the comma
        String numberString = data.substring(0, index);
        // removing the grabbed number
        data = data.substring(index + 1);
        // Classify the data
        myData = classifyData(myData, numberString, position);
      }

      MyAppState.currentGraphPosition ++;
      if (MyAppState.currentGraphPosition > MyAppState.graphLength) {
        MyAppState.currentGraphPosition = 0;
      } 
    }
  }

  static String classifyData(String myData, String numberString, double position) {
    if (numberString.contains(MyAppState.graph1Identifier)){
      double number = myParse(numberString, MyAppState.graph1Identifier);
      // converting it to string to send it back to the screen
      myData += number.toString() + "\r\n";
      // refreshing the graph data
      MyAppState.getDataFromUSBToGraph(position, number, MyAppState.stackedAreaSeries1);
    }
    else if (numberString.contains(MyAppState.graph2Identifier)) {
      double number = myParse(numberString, MyAppState.graph2Identifier);
      // converting it to string to send it back to the screen
      myData += number.toString() + "\r\n";
      // refreshing the graph data
      MyAppState.getDataFromUSBToGraph(position, number, MyAppState.stackedAreaSeries2);
    }
    else if (numberString.contains(MyAppState.graph3Identifier)) {
      double number = myParse(numberString, MyAppState.graph3Identifier);
      // converting it to string to send it back to the screen
      myData += number.toString() + "\r\n";
      // refreshing the graph data
      MyAppState.getDataFromUSBToGraph(position, number, MyAppState.stackedAreaSeries3);
    }
    else if (numberString.contains(MyAppState.value1Identifier)) {
      double number = myParse(numberString, MyAppState.value1Identifier);
      // converting it to string to send it back to the screen
      myData += number.toStringAsFixed(2) + "\r\n";
      // updating the value
      MyAppState.currentValue1 = number;
    }
    else if (numberString.contains(MyAppState.value2Identifier)) {
      double number = myParse(numberString, MyAppState.value2Identifier);
      // converting it to string to send it back to the screen
      myData += number.toStringAsFixed(2) + "\r\n";
      // updating the value
      MyAppState.currentValue2 = number;
    }
    else if (numberString.contains(MyAppState.value3Identifier)) {
      double number = myParse(numberString, MyAppState.value3Identifier);
      // converting it to string to send it back to the screen
      myData += number.toStringAsFixed(2) + "\r\n";
      // updating the value
      MyAppState.currentValue3 = number;
    }
    else if (numberString.contains(MyAppState.value4Identifier)) {
      double number = myParse(numberString, MyAppState.value4Identifier);
      // converting it to string to send it back to the screen
      myData += number.toStringAsFixed(2) + "\r\n";
      // updating the value
      MyAppState.currentValue4 = number;
    }
    else if (numberString.contains(MyAppState.xIdentifier)) {
      double number = myParse(numberString, MyAppState.xIdentifier);
      // converting it to string to send it back to the screen
      myData += number.toStringAsFixed(2) + "\r\n";
      // updating the value
      MyAppState.xPosition = number;
    }
    return myData;
  }

  static double myParse(String parsingString, String identifier) {
    // remove the identifier
    parsingString = parsingString.substring(identifier.length);
    // return the number as double
    return double.tryParse(parsingString);
  }

  static void pauseTransaction() {
    if (testTimer.isActive) {
      testTimer.cancel();
      sendDataToSTM(MyAppState.pauseIdentifier);
    }
  }

  static void resumeTransaction() {
    if (!testTimer.isActive) {
      testTimer = Timer.periodic(Duration(milliseconds: timerRate), testFunc);
      sendDataToSTM(MyAppState.resumeIdentifier);
    }
  }

  static void resetFunction() {
    counter = 0;
    counterr = 0;
  }

  static void changeParam(int param, double value) {
    switch (param) {
      case 1:
        graph1Freq = value;
        break;
      case 2:
        graph2Freq = value;
        break;
      case 3:
        graph3Amplitude = value;
        break;
      default:
    }
  }

  static void changeK(int param, double value) {
    switch (param) {
      case 1:
        k1Amplitude = value;
        break;
      case 2:
        k2Amplitude = value;
        break;
      case 3:
        k3Amplitude = value;
        break;
      default:
    }
  }

  static void sendParamsToSTM(String param1, String param2, String param3) {
    sendDataToSTM(MyAppState.paramIdentifier + " " + param1 + " " + param2 + " " + param3);
  }

  static void sendKValToSTM(String k1, String k2, String k3) {
    sendDataToSTM(MyAppState.kIdentifier + " " + k1 + " " + k2 + " " + k3);
  }

  static bool connectedToSTM() {
    return _port != null;
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
            Expanded(flex: 10, child: 
              Column(children: <Widget>[
                Text(
                  _ports.length > 0
                      ? "Available Serial Ports"
                      : "No serial devices available",
                  style: Theme.of(context).textTheme.headline6),
                ..._ports,
                Text('Status: $_status\n'),
                ListTile(
                  title: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Text To Send',
                    ),
                  ),
                  trailing: RaisedButton(
                    child: Text("Send"),
                    onPressed: _port == null
                        ? null
                        : () async {
                            if (_port == null) {
                              return;
                            }
                            sendDataToSTM(_textController.text);
                            _textController.text = "";
                          },
                  ),
                ),
                Text("Result Data", style: Theme.of(context).textTheme.headline),
                ...?_serialData,
                Text(lastTextSent),
                // Use this to see raw data from USB
                //...?_serialData,

                // Use this to test without USB connection (generating values within the App)
                //Text(parseDataFromUSB(textWidgets)),

                // Use this to test with USB connection (generating values with STM)
                //Text(parseDataFromUSB(_serialData))
                ],
              )
            )
          ]
        )
      ),
    );
  }
}