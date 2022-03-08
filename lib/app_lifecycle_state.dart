import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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

const imgUrl = 'https://bit.ly/3x7J5Qt';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AppLifecycleState has 4 states: resumed, inactive, pause, detached, which
    // allows us to act upon
    final state = useAppLifecycleState();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Opacity(
          // if app state is resumed, set opacity to full, otherwise set it
          // to 0.0 to hide credit card info.
          opacity: state == AppLifecycleState.resumed ? 1.0 : 0.0,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withAlpha(100),
                  spreadRadius: 10,
                )
              ],
            ),
            child: Image.asset('assets/card.png'),
          ),
        ),
      ),
    );
  }
}
