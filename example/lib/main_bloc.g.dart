// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

enum _$EventType { increment, decrement, incrementBy }

class _$Event {
  final _$EventType type;
  final List<dynamic> payload;

  _$Event({this.type, this.payload});
}

abstract class _$Bloc extends Bloc<_$Event, MainState> {
  Stream<MainState> mapEventToState(_$Event event) async* {
    switch (event.type) {
      case _$EventType.increment:
        yield* _mapIncrementToState();
        break;
      case _$EventType.decrement:
        yield* _mapDecrementToState();
        break;
      case _$EventType.incrementBy:
        yield* _mapIncrementByToState(event.payload[0]);
        break;
    }
  }

  void dispatchIncrementEvent() {
    add(_$Event(
      type: _$EventType.increment,
    ));
  }

  void dispatchDecrementEvent() {
    add(_$Event(
      type: _$EventType.decrement,
    ));
  }

  void dispatchIncrementByEvent(int value) {
    add(_$Event(
      type: _$EventType.incrementBy,
      payload: [value],
    ));
  }

  Stream<MainState> _mapIncrementToState();

  Stream<MainState> _mapDecrementToState();

  Stream<MainState> _mapIncrementByToState(int value);
}
