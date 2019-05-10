A Dart package that generates code for the [bloc library](https://github.com/felangel/bloc).


## GenerateBloc Annotation

**GenerateBloc** is a dart annotation that requires a `State` as parameter, the state can be a primitive or a object. It handles the bloc's generation.

## How it works

By adding the annotation to your `Bloc` class like this:

```dart
part 'my_bloc.g.dart';

@GenerateBloc(MyState)
class MyBloc extends _$Bloc {
 @override
  MyState get initialState => MyState();

  Stream<MyState> _mapDoSomethingToState(int someValue, SomeModel someModel) async* {
    yield MyState.doSomething(someValue, someModel);
  }
}
```

And running
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

The generator will create the `my_bloc.g.dart` file for you:

```dart
part of 'main_bloc.dart';

enum _$EventType { doSomething }

class _$Event {
  final _$EventType type;
  final List<dynamic> payload;

  _$Event({this.type, this.payload});
}

abstract class _$Bloc extends Bloc<_$Event, MyState> {
  Stream<MyState> mapEventToState(_$Event event) async* {
    switch (event.type) {
      case _$EventType.doSomething:
        yield* _mapDoSomethingToState(event.payload[0], event.payload[1]);
        break;
    }
  }

  void dispatchDoSomethingEvent(int someValue, SomeModel someModel) {
    dispatch(_$Event(
      type: _$EventType.increment,
      payload: [someValue, someModel],
    ));
  }

  Stream<MyState> _mapDoSomethingToState(int someValue, SomeModel someModel);
}
```


It gets all `_map<NAME>ToState` methods, creates the dispatchers and maps the right events to them. 

By using the generator you don't need to handle the events, only the `mapToState` methods.

## Examples

- [Counter](https://github.com/adsonpleal/bloc-code-generator/tree/master/sample) - an example of how to create a counter bloc

### Maintainers

- [Adson Leal](https://github.com/adsonpleal)