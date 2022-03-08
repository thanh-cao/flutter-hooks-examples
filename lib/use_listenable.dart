import 'dart:async';
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

class CountDown extends ValueNotifier<int> {
  late StreamSubscription subscription;
  CountDown({required int from}) : super(from) {
    subscription = Stream.periodic(
      const Duration(
        seconds: 1,
      ),
      (value) => from - value,
    ).takeWhile((value) => value >= 0).listen((value) {
      this.value = value;
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // useMemoized create a CountDown instance counting from 20 and persists this instance
    final countDown = useMemoized(() => CountDown(from: 20));
    // useListenable listens to countDown's value to see if there has been any changes,
    // if so, it will call the build function to reflect the changes
    final notifier = useListenable(countDown);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Text(notifier.value.toString()),
    );
  }
}
