import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// a helper function to remove null element from an array which is used in the
// Column widget (which requires children array) while we only use 1 widget
// in this example
extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>([E? Function(T?)? transform]) =>
      map(transform ?? (element) => element)
          .where((element) => element != null)
          .cast();
}

void main() {
  runApp(const MyApp());
}

const url = 'https://bit.ly/3qYOtDm';

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

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // using this block code alone will create a flickering image on the screen
    // final image = useFuture(
    //     NetworkAssetBundle(Uri.parse(url))
    //         .load(url)
    //         .then((data) => data.buffer.asUint8List())
    //         .then((data) => Image.memory(data)));

    // useMemoized creates a future downloading the image and hold it as a complex
    // object waiting to be consumed
    final future = useMemoized(
      // grab the image from network, load it, and store it in an Image widget
      () => NetworkAssetBundle(Uri.parse(url))
          .load(url)
          .then((data) => data.buffer.asUint8List())
          .then(
            (data) => Image.memory(data),
          ),
    );

    final snapshot = useFuture(future); // consuming the future

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          // image.hasData ? image.data! : null,
          snapshot.data
        ].compactMap().toList(),
      ),
    );
  }
}

/* 
useFuture doesn't persist the future in memory so it creates a loop where useFuture
loads an image from the network, it tries to set the image on the screen by calling
the build function. As the build function is called, useFuture is also called. This creates
the flickering og image on the screen and the loop occurs.

In order to let the app know if the image has been downloaded from before and hold on
to its 'already downloaded state', useMemoized hook can help fix that which allows
caching of complex objects and persist data in memory. If it has a cached version
of a complex object from before, it will return the previous instance. Otherwise,
it will kick off that object's Future, which in this case is the image being loaded
from the network
*/
