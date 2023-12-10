import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 1.1,
              fontSizeDelta: 2.0,
            ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _methodChannel = const MethodChannel('com.example.ios_flutter.m');
  final _eventChannel = const EventChannel('com.example.ios_flutter.e');
  double _sliderValue = 0;

  @override
  void initState() {
    super.initState();
    _eventChannel.receiveBroadcastStream().listen(_onChange);
  }

  void _onChange(dynamic value) {
    _sliderValue = value;
    setState(() {});
  }

  void _onValueChange(double value) {
    _methodChannel.invokeMethod('valueChange', {'value': value});
    _onChange(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Flutter module'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CupertinoSlider(
                    value: _sliderValue,
                    min: 0,
                    max: 10,
                    onChanged: _onValueChange,
                  ),
                ),
                Expanded(
                  child: Text(_sliderValue.toStringAsFixed(2)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
