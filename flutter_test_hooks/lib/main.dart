import 'dart:async';

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

class CountDown extends ValueNotifier<int> {
  late StreamSubscription sub;

  CountDown({required int from}) : super(from) {
    sub = Stream.periodic(const Duration(seconds: 1), (v) => from - v)
        .takeWhile((value) => value >= 0)
        .listen((event) {
      this.value = event;
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //we cache that instance such that we avoid creating of an instance everytime
    final countDown = useMemoized(() => CountDown(from: 20));

    final notiifier = useListenable(countDown);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        body: Text(notiifier.value.toString()));
  }
}
