import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

// a simple Stream of string data which gets a new time every 1 second
Stream<String> getTime() => Stream.periodic(
      const Duration(seconds: 1),
      (_) => DateTime.now().toIso8601String(),
    );

class HomePage extends HookWidget {
  // is stateless widget with states
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // this is a Stream hook which returns an AsyncSnapshot of a type.
    //Snapshot has methods like hasData() or data variable
    final dateTime = useStream(getTime());
    return Scaffold(
        appBar: AppBar(
      title: Text(dateTime.data ?? 'Home Page'), // .data is from snapshot
    ));
  }
}
