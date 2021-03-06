import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'multi_counter_store.dart';

class MultiCounterExample extends StatefulWidget {
  static const String routeName = '/page/multi_counter';
  static const String name = "MultiCounterExample";

  const MultiCounterExample();

  @override
  _MultiCounterExampleState createState() => _MultiCounterExampleState();
}

class _MultiCounterExampleState extends State<MultiCounterExample> {

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Multi Counter'),
        ),
        body: CounterListPage(),
      );
}

class CounterListPage extends StatelessWidget {
  CounterListPage();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MultiCounterStore>(context);

    return Observer(
        builder: (_) => Column(children: <Widget>[
              RaisedButton(
                onPressed: store.addCounter,
                child: const Text('Add Counter'),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: store.counters.length,
                  itemBuilder: (_, index) => ListTile(
                      trailing: const Icon(Icons.navigate_next),
                      title: Text('Count: ${store.counters[index].value}'),
                      leading: IconButton(
                          color: Colors.red,
                          icon: const Icon(Icons.delete),
                          onPressed: () => store.removeCounter(index)),
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Scaffold(
                                  appBar: AppBar(
                                    title: const Text('Multi Counter'),
                                  ),
                                  body: CounterViewPage(
                                      store: store, index: index)),
                            ),
                          )))
            ]));
  }
}

class CounterViewPage extends StatelessWidget {
  const CounterViewPage({@required this.store, @required this.index});

  final int index;
  final MultiCounterStore store;

  @override
  Widget build(BuildContext context) {
    final counter = store.counters[index];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                RaisedButton(
                  child: const Icon(Icons.remove),
                  onPressed: counter.decrement,
                ),
                Expanded(
                  child: Center(
                    child: Observer(
                        builder: (_) => Text(
                              '${counter.value}',
                              style: const TextStyle(fontSize: 20),
                            )),
                  ),
                ),
                RaisedButton(
                  child: const Icon(Icons.add),
                  onPressed: counter.increment,
                ),
              ],
            ),
            FlatButton(
              child: const Text('Reset'),
              textColor: Colors.red,
              onPressed: counter.reset,
            )
          ],
        ),
      ),
    );
  }
}
