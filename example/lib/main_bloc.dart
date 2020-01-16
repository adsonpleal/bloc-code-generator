import 'package:bloc/bloc.dart';
import 'package:bloc_code_generator/annotations.dart';

part 'main_bloc.g.dart';

class MainState {
  final int counter;

  MainState(this.counter);
}

@GenerateBloc(MainState)
class MainBloc extends _$Bloc {

  @override
  MainState get initialState => MainState(0);

  Stream<MainState> _mapIncrementToState() async* {
    yield MainState(state.counter + 1);
  }

  Stream<MainState> _mapDecrementToState() async* {
    yield MainState(state.counter - 1);
  }

  Stream<MainState> _mapIncrementByToState(int value) async* {
    yield MainState(state.counter + value);
  }

}
