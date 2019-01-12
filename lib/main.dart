import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

final sumStreamController = StreamController<int>();
final sumStream = sumStreamController.stream;

Stream<int> randStream(int range) async* {
  var randomNumberGen = new Random();
  int randomNumber = randomNumberGen.nextInt(range);
  yield randomNumber;
}

void addStreams(Stream<int> stream1, Stream<int> stream2) async {
  int result1, result2;
  await for (int num in stream1) {
    result1 = num;
  }
  await for (int num in stream2) {
    result2 = num;
  }
  final result = result1 + result2;
  print(result);
  sumStreamController.add(result);
}

void gen() => addStreams(randStream(100), randStream(100));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Time Stream'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Time:',
            ),
            StreamBuilder(
                stream: sumStream,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) =>
                    Text(
                      '${snapshot.data}',
                      style: Theme.of(context).textTheme.body2,
                    )),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          setState(() {
            gen();
          });
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
