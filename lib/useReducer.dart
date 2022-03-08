import 'dart:math';

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

enum ImageAction {
  rotateRight,
  rotateLeft,
  increateAlpha,
  decreaseAlpha,
}

@immutable
class ImageState {
  final double rotationDeg;
  final double alpha;

  const ImageState({
    required this.rotationDeg,
    required this.alpha,
  });

  const ImageState.zero()
      : rotationDeg = 0.0,
        alpha = 0.0;

  ImageState rotateRight() => ImageState(
        rotationDeg: rotationDeg + 10.0,
        alpha: alpha,
      );
  ImageState rotateLeft() => ImageState(
        rotationDeg: rotationDeg - 10.0,
        alpha: alpha,
      );
  ImageState increaseAlpha() => ImageState(
        rotationDeg: rotationDeg,
        alpha: min(alpha + 0.1, 1.0),
      );
  ImageState decreaseAlpha() => ImageState(
        rotationDeg: rotationDeg,
        alpha: max(alpha - 0.1, 0.0),
      );
}

ImageState reducer(ImageState oldState, ImageAction? action) {
  switch (action) {
    case ImageAction.rotateRight:
      return oldState.rotateRight();
    case ImageAction.rotateLeft:
      return oldState.rotateLeft();
    case ImageAction.increateAlpha:
      return oldState.increaseAlpha();
    case ImageAction.decreaseAlpha:
      return oldState.decreaseAlpha();
    case null:
      return oldState;
  }
}

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = useReducer<ImageState, ImageAction?>(
      reducer,
      initialState: const ImageState.zero(),
      initialAction: null,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              RotateLeftButton(store: store),
              RotateRightButton(store: store),
              DecreaseAlphaButton(store: store),
              IncreaseAlphaButton(store: store),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
          Opacity(
            opacity: store.state.alpha,
            child: RotationTransition(
                turns: AlwaysStoppedAnimation(store.state.rotationDeg / 360.0),
                child: Image.network(imgUrl)),
          ),
        ],
      ),
    );
  }
}

class IncreaseAlphaButton extends StatelessWidget {
  const IncreaseAlphaButton({
    Key? key,
    required this.store,
  }) : super(key: key);

  final Store<ImageState, ImageAction?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          store.dispatch(ImageAction.increateAlpha);
        },
        child: const Text('More visible'));
  }
}

class DecreaseAlphaButton extends StatelessWidget {
  const DecreaseAlphaButton({
    Key? key,
    required this.store,
  }) : super(key: key);

  final Store<ImageState, ImageAction?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          store.dispatch(ImageAction.decreaseAlpha);
        },
        child: const Text('Less invisible'));
  }
}

class RotateRightButton extends StatelessWidget {
  const RotateRightButton({
    Key? key,
    required this.store,
  }) : super(key: key);

  final Store<ImageState, ImageAction?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          store.dispatch(ImageAction.rotateRight);
        },
        child: const Text('Rotate Right'));
  }
}

class RotateLeftButton extends StatelessWidget {
  const RotateLeftButton({
    Key? key,
    required this.store,
  }) : super(key: key);

  final Store<ImageState, ImageAction?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          store.dispatch(ImageAction.rotateLeft);
        },
        child: const Text('Rotate Left'));
  }
}
