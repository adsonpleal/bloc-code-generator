import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_bloc.dart';
import 'main_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc Generator Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter Page'),
      ),
      body: BlocBuilder<MainBloc, MainState>(
//        bloc: _bloc,
        cubit: _bloc,
        builder: (context, MainState state) => Center(
              child: Text(
                '${state.counter}',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: _bloc.dispatchIncrementEvent,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: FloatingActionButton(
              onPressed: _bloc.dispatchDecrementEvent,
              tooltip: 'Decrement',
              child: Icon(Icons.remove),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: FloatingActionButton(
              onPressed: () => _bloc.dispatchIncrementByEvent(2),
              tooltip: 'Increment by two',
              child: Icon(Icons.exposure_plus_2),
            ),
          ),
        ],
      ),
    );
  }
}
