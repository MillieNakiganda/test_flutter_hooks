import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

//Reducer is a combination of state and actions, NewState = oldState + Action

extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>([
    E? Function(T?)? transform,
  ]) =>
      map(
        transform ?? (e) => e,
      ).where((e) => e != null).cast();
}

enum Action { rotateLeft, rotateRight, moreVisible, lessVisible }

@immutable
class State {
  final double rotationDeg;
  final double alpha;
  const State({required this.rotationDeg, required this.alpha});
  const State.zero()
      : rotationDeg = 0.0,
        alpha = 1.0;

  State rotateRight() => State(alpha: alpha, rotationDeg: rotationDeg + 10.0);
  State rotateLeft() => State(alpha: alpha, rotationDeg: rotationDeg - 10.0);
  State increaseAlpha() =>
      State(alpha: min(alpha + 0.1, 1.0), rotationDeg: rotationDeg + 10.0);
  State decreaseAlpha() =>
      State(alpha: max(alpha - 0.1, 1.0), rotationDeg: rotationDeg + 10.0);
}

State reducer(State oldState, Action? action) {
  switch (action) {
    case Action.rotateLeft:
      return oldState.rotateLeft();
    case Action.rotateRight:
      return oldState.rotateRight();
    case Action.moreVisible:
      return oldState.increaseAlpha();
    case Action.lessVisible:
      return oldState.decreaseAlpha();
    case null:
      return oldState;
  }
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
    final store = useReducer<State, Action?>(reducer,
        initialState: const State.zero(), initialAction: null);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    store.dispatch(Action.rotateLeft);
                  },
                  child: const Text('Rotate Left')),
              TextButton(
                  onPressed: () {
                    store.dispatch(Action.rotateRight);
                  },
                  child: const Text('Rotate Right')),
              TextButton(
                  onPressed: () {
                    store.dispatch(Action.lessVisible);
                  },
                  child: const Text('-Alpha')),
              TextButton(
                  onPressed: () {
                    store.dispatch(Action.moreVisible);
                  },
                  child: const Text('+ Alpha'))
            ],
          ),
          const SizedBox(height: 100),
          Opacity(
            opacity: store.state.alpha,
            child: RotationTransition(
                turns: AlwaysStoppedAnimation(store.state.rotationDeg / 360.0),
                child: Image.network(url)),
          ),
        ],
      ),
    );
  }
}
