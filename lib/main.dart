import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/app_retain_widget.dart';
import 'package:flutter_background/background_main.dart';
import 'package:flutter_background/counter_service.dart';

void main() {
  runApp(MyApp());

  var channel = const MethodChannel('com.example/background_service');
  var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
  channel.invokeMethod('startService', callbackHandle.toRawHandle());

  CounterService.instance().startCounting();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Background Demo',
      home: AppRetainWidget(
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isCounting = true;

  void toggleCounting() {
    setState((){
      isCounting = !isCounting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Background Demo'),
      ),
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: CounterService.instance().count,
          builder: (context, count, child) {
            return Text('Counting: $count');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          print('alive 1');

          toggleCounting();
          print('is counting: ' + (isCounting ? 'yes' : 'no'));
          if(isCounting){
            var channel = const MethodChannel('com.example/background_service');
            var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
            channel.invokeMethod('stopService', callbackHandle.toRawHandle());
            CounterService.instance().stopCounting();
          }else{
            var channel = const MethodChannel('com.example/background_service');
            var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
            channel.invokeMethod('startService', callbackHandle.toRawHandle());
            CounterService.instance().startCounting();
          }
        },
        child: Text('Start / Stop'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
