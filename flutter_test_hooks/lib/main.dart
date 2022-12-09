import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>([
    E? Function(T?)? transform,
  ]) =>
      map(
        transform ?? (e) => e,
      ).where((e) => e != null).cast();
}

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
      home: const MyHomePage(),
    );
  }
}

const url = 'https://bit.ly/3x7J5Qt';
const imageHeight = 300.0;

//normalization is the process of creating a range of smaller values using the smallest and biggest desireed numbers.
//the range created will act as a scale, so if the smallest number is 0 and the buggest 300, on the normalised range, 150 will be 0.5
extension Normalize on num {
  num normalized(num selfRangeMin, num selfRangeMax,
          [num normalizedRangeMin = 0.0, num normalizedRangeMax = 1.0]) =>
      (normalizedRangeMax - normalizedRangeMin) *
          ((this - selfRangeMin) / (selfRangeMax - selfRangeMin)) +
      normalizedRangeMin;
}

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //if we don't do this animation with the animation hook, then we have to make it stateful and also use ticker providers, then dispose them off
    final opacity = useAnimationController(
        duration: const Duration(seconds: 1),
        initialValue: 1.0,
        upperBound: 1.0,
        lowerBound: 0.0);
    final size = useAnimationController(
        duration: const Duration(seconds: 1),
        initialValue: 1.0,
        upperBound: 1.0,
        lowerBound: 0.0);
    final controller = useScrollController();

    useEffect(() {
      controller.addListener(() {
        final newOpacity = max(imageHeight - controller.offset, 0.0);
        final normalized = newOpacity.normalized(0, imageHeight).toDouble();
        opacity.value = normalized;
        size.value = normalized;
      });
      return null;
    }, [controller]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(children: [
        SizeTransition(
          sizeFactor: size,
          axis: Axis.vertical,
          axisAlignment: -1.0,
          child: FadeTransition(
              opacity: opacity,
              child:
                  Image.network(url, height: imageHeight, fit: BoxFit.cover)),
        ),
        Expanded(
          child: ListView.builder(
              controller: controller,
              itemCount: 100,
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text('Person ${index + 1}'),
                );
              })),
        )
      ]),
    );
  }
}
