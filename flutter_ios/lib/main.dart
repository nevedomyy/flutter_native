import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text('Flutter app'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SliderWidget(),
            ),
            SizedBox(height: 50),
            SizedBox(
              height: 170,
              width: double.infinity,
              child: NativeWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
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
    return Row(
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
    );
  }
}

class NativeWidget extends StatelessWidget {
  final _viewType = "NativeSlider";

  const NativeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: _viewType,
          layoutDirection: TextDirection.ltr,
        );
      case TargetPlatform.android:
      default:
        throw UnsupportedError('Unsupported');
    }
  }
}
