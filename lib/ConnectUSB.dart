import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:usb_serial/usb_serial.dart';
import 'package:usb_serial/transaction.dart';
import 'HospitalConfigurationPage.dart';
import 'ConfigurationPage.dart';
import 'DisplayValuesPage.dart';
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
    //await _port.setDTR(true);
    //await _port.setRTS(true);
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
            color: MyAppState.buttonBackgroundColor,
            child:
                Text(_deviceId == device.deviceId ? "Disconnect" : "Connect", style: TextStyle(fontSize: MyAppState.buttonTextSize, color: MyAppState.buttonTextColor)),
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

  static int millis = 0;
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

    millis = DateTime.now().hour * 3600000 + DateTime.now().minute * 60000 + DateTime.now().second * 1000 + DateTime.now().millisecond;
  }

  static int timerRate = 15;
  static Timer testTimer;
  static int counter = 0;
  static double counterr = 0;
  static double graph1Freq = 2.7;
  static double graph2Freq = 4.8;
  static double graph3Amplitude = 2;
  static double k1Amplitude = 5;
  static double k2Amplitude = 1;
  static double k3Amplitude = 3;
  static List<Widget> textWidgets = new List<Widget>();

  static int arrayLength = 1;
  static List<double> graphVariable1 = new List(arrayLength);
  static List<double> graphVariable2 = new List(arrayLength);
  static List<double> graphVariable3 = new List(arrayLength);
  static List<double> rand1 = new List(arrayLength);
  static List<double> rand2 = new List(arrayLength);
  static List<double> rand3 = new List(arrayLength);
  static List<double> rand4 = new List(arrayLength);
  static List<String> textSample = new List(arrayLength);
  static void testFunc(Timer timer) {
    textSample[counterr.toInt()] = "";
    textWidgets.clear();
    counter++;
    textWidgets.add(Text("aaa,123456\r\n"));

    graphVariable1[counterr.toInt()] = math.sin(graph1Freq * counter/100);
    graphVariable2[counterr.toInt()] = math.sin(graph2Freq * counter/100);
    graphVariable3[counterr.toInt()] = (graphVariable1[counterr.toInt()] + graphVariable2[counterr.toInt()]) * graph3Amplitude;
    rand1[counterr.toInt()] = k1Amplitude * (1 + math.Random().nextInt(10) / 100);
    rand2[counterr.toInt()] = k2Amplitude * (1 + math.Random().nextInt(10) / 100);
    rand3[counterr.toInt()] = k3Amplitude * (1 + math.Random().nextInt(10) / 100);
    rand4[counterr.toInt()] = rand1[counterr.toInt()] + rand2[counterr.toInt()] + rand3[counterr.toInt()];

    textSample[counterr.toInt()] = "DATATOGRAPH: ";
    textSample[counterr.toInt()] += MyAppState.value1Identifier + rand1[counterr.toInt()].toString();
    textSample[counterr.toInt()] += ",";
    textSample[counterr.toInt()] += MyAppState.value2Identifier + rand2[counterr.toInt()].toString();
    textSample[counterr.toInt()] += ",";
    textSample[counterr.toInt()] += MyAppState.value3Identifier + rand3[counterr.toInt()].toString();
    textSample[counterr.toInt()] += ",";
    textSample[counterr.toInt()] += MyAppState.value4Identifier + rand4[counterr.toInt()].toString();
    textSample[counterr.toInt()] += ",";
    textSample[counterr.toInt()] += MyAppState.graph1Identifier + graphVariable1[counterr.toInt()].toStringAsFixed(4);
    textSample[counterr.toInt()] += ",";
    textSample[counterr.toInt()] += MyAppState.graph2Identifier + graphVariable2[counterr.toInt()].toStringAsFixed(4);
    textSample[counterr.toInt()] += ",";
    textSample[counterr.toInt()] += MyAppState.graph3Identifier + graphVariable3[counterr.toInt()].toStringAsFixed(4);
    textSample[counterr.toInt()] += ",";
    int currMillis = -millis + (DateTime.now().hour * 3600000 + DateTime.now().minute * 60000 + DateTime.now().second * 1000 + DateTime.now().millisecond);
    textSample[counterr.toInt()] += MyAppState.xIdentifier + (currMillis%(4000)).toString();
    textSample[counterr.toInt()] += ",";
    textSample[counterr.toInt()] += "\r\n";

    textWidgets[0] = (Text(textSample[counterr.toInt()]));
    counterr++;
    if (counterr >= arrayLength) {
      counterr = 0;
      for (var i = 0; i < textSample.length; i++) { 
        parseDataFromUSB(textSample[i]);
      }
    }
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
        numberString = numberString.substring(0, commaIndex);
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
    }
  }

  static String classifyData(String myData, String numberString, double position) {
    if (numberString.contains(MyAppState.graph1Identifier)){
      double number = myParse(numberString, MyAppState.graph1Identifier);
      // converting it to string to send it back to the screen
      myData += number.toString() + "\r\n";
      // refreshing the graph data
      //MyAppState.getDataFromUSBToGraph(position, number, MyAppState.stackedAreaSeries1);
      MyAppState.getDataFromUSBToGraph(position, number, MyAppState.lineChart1Data, 1);
    }
    else if (numberString.contains(MyAppState.graph2Identifier)) {
      double number = myParse(numberString, MyAppState.graph2Identifier);
      // converting it to string to send it back to the screen
      myData += number.toString() + "\r\n";
      // refreshing the graph data
      //MyAppState.getDataFromUSBToGraph(position, number, MyAppState.stackedAreaSeries2);
      MyAppState.getDataFromUSBToGraph(position, number, MyAppState.lineChart2Data, 2);
    }
    else if (numberString.contains(MyAppState.graph3Identifier)) {
      double number = myParse(numberString, MyAppState.graph3Identifier);
      // converting it to string to send it back to the screen
      myData += number.toString() + "\r\n";
      // refreshing the graph data
      //MyAppState.getDataFromUSBToGraph(position, number, MyAppState.stackedAreaSeries3);
      MyAppState.getDataFromUSBToGraph(position, number, MyAppState.lineChart3Data, 3);
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
    else if (numberString.contains(MyAppState.graphLengthIdentifier)) {
      double number = myParse(numberString, MyAppState.graphLengthIdentifier);
      // converting it to string to send it back to the screen
      myData += number.toStringAsFixed(2) + "\r\n";
      // updating the value
      MyAppState.changeGraphXSize(MyAppState.convertMillisecondToSecond(number));
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

  static void sendParamsToSTM(int param1, int param2, int param3) {
    sendDataToSTM(MyAppState.paramIdentifier + " " + (param1 * 10).toString() + " " + (param2 * 10).toString() + " " + (param3 * 10).toString());
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
              Column(children: <Widget>[
                Text(
                  _ports.length > 0
                      ? "Available Serial Ports"
                      : "No serial devices available",
                  style: TextStyle(fontSize: MyAppState.leftValuesTextSize, color: MyAppState.valueTextColor)),
                ..._ports,
                Text('Status: $_status\n', style: TextStyle(fontSize: MyAppState.leftValuesTextSize, color: MyAppState.valueTextColor)),
                ListTile(
                  title: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Text To Send',
                    ),
                  ),
                  trailing: RaisedButton(
                    color: MyAppState.buttonBackgroundColor,
                    child: Text("Send", style: TextStyle(fontSize: MyAppState.buttonTextSize, color: MyAppState.buttonTextColor)),
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
                Text("Result Data", style: TextStyle(fontSize: MyAppState.leftValuesTextSize, color: MyAppState.valueTextColor)),
                ...?_serialData,
                ...?textWidgets,
                Text('Last text sent to STM: ' + lastTextSent, style: TextStyle(fontSize: MyAppState.leftValuesTextSize - 10, color: MyAppState.valueTextColor)),
                //Text(textSample == null? "jeje":textSample),
                ],
              )
            )
          ]
        )
      ),
    );
  }
}