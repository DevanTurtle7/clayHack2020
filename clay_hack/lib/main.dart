import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import "data.dart";

void main() {
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the thingy this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GridPage()));
              },
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class GridPage extends StatefulWidget {
  const GridPage({Key key}) : super(key: key);

  @override
  GridPageState createState() => GridPageState();
}

class GridPageState extends State<GridPage> {
  void updateCount(index, add) {
    setState(() {
      if (add) {
        food[index].count += 1;
      } else if (food[index].count > 0) {
        food[index].count -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Grid"),
          backgroundColor: Colors.orange,
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: (){},
              )
          ],
        ),
        body: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300.0),
            itemCount: food.length,
            itemBuilder: (BuildContext context, int index) => Card(
                    child: Column(children: [
                  Image(
                      image: NetworkImage(food[index].image),
                      width: 200,
                      height: 130),
                  Text((food[index].name)),
                  Text(("Price: " + food[index].price.toString())),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Ink(
                          height: 20,
                          width: 20,
                          decoration: const ShapeDecoration(
                            color: Colors.orange,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.all(0.0),
                            icon: Icon(Icons.remove, size: 20),
                            color: Colors.white,
                            onPressed: () {
                              updateCount(index, false);
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            food[index].count.toString(),
                            style: TextStyle(fontSize: 30.0),
                          )),
                      Ink(
                          height: 20,
                          width: 20,
                          decoration: const ShapeDecoration(
                            color: Colors.orange,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.all(0.0),
                            icon: Icon(Icons.add, size: 20),
                            color: Colors.white,
                            onPressed: () {
                              updateCount(index, true);
                            },
                          )),
                    ],
                  ),
                ]))));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int mealExchanges = 0;

  void addMealExchange(add) {
    setState(() {
      if (add) {
        mealExchanges += 1;
      } else if (mealExchanges > 0) {
        mealExchanges -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 20, left: 30, right: 30),
              child: Text("How many meal exchanges would you like to spend?",
                  style: TextStyle(fontSize: 20))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Ink(
                  height: 30,
                  width: 30,
                  decoration: const ShapeDecoration(
                    color: Colors.orange,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(Icons.remove, size: 20),
                    color: Colors.white,
                    onPressed: () {
                      addMealExchange(false);
                    },
                  )),
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    mealExchanges.toString(),
                    style: TextStyle(fontSize: 90.0),
                  )),
              Ink(
                  height: 30,
                  width: 30,
                  decoration: const ShapeDecoration(
                    color: Colors.orange,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(Icons.add, size: 20),
                    color: Colors.white,
                    onPressed: () {
                      addMealExchange(true);
                    },
                  )),
            ],
          ),
          Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: RaisedButton(
                color: Colors.orange,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Next", style: TextStyle(fontSize: 20))),
                onPressed: () {},
              ))
        ],
      ),
    );
  }
}
