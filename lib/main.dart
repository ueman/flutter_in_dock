import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

final _screenshareKey = GlobalKey();
const _channel = MethodChannel('sync');

void main() {
  runApp(const MyApp());
  WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
    _syncToDockIcon();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _screenshareKey,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              textScaleFactor: 4,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> _syncToDockIcon() async {
  final renderObject = _screenshareKey.currentContext!.findRenderObject()
      as RenderRepaintBoundary;

  final image = await renderObject.toImage(pixelRatio: 0.3);
  final bytedata = await image.toByteData(format: ImageByteFormat.png);
  final bytelist = bytedata!.buffer.asUint8List();
  await _channel.invokeMethod('sync', bytelist);
}
