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

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final StreamController<double> controller;
    controller = useStreamController<double>(
      onListen: () {
        controller.sink.add(0);
      },
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        body: StreamBuilder<double>(
            stream: controller.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else {
                final rotation = snapshot.data ?? 0;
                return GestureDetector(
                  onTap: () {
                    controller.sink.add(rotation + 10.0);
                  },
                  child: RotationTransition(
                      turns: AlwaysStoppedAnimation(rotation),
                      child: Center(child: Image.network(url))),
                );
              }
            }));
  }
}
