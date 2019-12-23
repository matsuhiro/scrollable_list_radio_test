import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return _Item(message: '$index');
        },
      ),
    );
  }
}

class _Item extends StatefulWidget {
  _Item({this.message});

  final String message;

  @override
  State<StatefulWidget> createState() => _ItemState(message);
}

class _ItemState extends State<_Item> {
  _ItemState(this.message);
  final String message;

  bool _isChecked = false;

  Future<bool> _loadCheckState() async {
    final prefs = await SharedPreferences.getInstance();
    final isChecked = prefs.getBool(message) ?? false;
    return isChecked;
  }

  void _saveCheckedState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(message, _isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FutureBuilder(
          future: _loadCheckState(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              _isChecked = snapshot.data;
              return Row(
                children: <Widget>[
                  Text('$message'),
                  Checkbox(
                    value: _isChecked,
                    onChanged: (bool isChecked) {
                      setState(() {
                        _isChecked = isChecked;
                        _saveCheckedState();
                      });
                    },
                  ),
                ],
              );
            } else {
              return Text('loading...');
            }
          }),
    );
  }
}
