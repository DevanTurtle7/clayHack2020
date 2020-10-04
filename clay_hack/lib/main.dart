import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import "data.dart";

void main() {
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Corner Clerk',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage());
  }
}

class GridPage extends StatefulWidget {
  const GridPage({Key key, this.mealExchanges}) : super(key: key);

  final int mealExchanges;

  @override
  GridPageState createState() => GridPageState();
}

class GridPageState extends State<GridPage> {
  double money;

  void updateCount(index, add) {
    setState(() {
      if (add) {
        food[index].count += 1;
      } else if (food[index].count > 0) {
        food[index].count -= 1;
      }

      updateRemaining();
    });
  }

  void updateRemaining() {
    setState(() {
      money = (10 * widget.mealExchanges).toDouble();

      for (Product product in food) {
        money -= product.count * product.price;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (money == null) {
      money = (9.5 * widget.mealExchanges).toDouble();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Remaining: \$" + money.toStringAsFixed(2),
            overflow: TextOverflow.fade,
          ),
          backgroundColor: Colors.orange,
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CartPage(mealExchanges: widget.mealExchanges)));
              },
            )
          ],
        ),
        body: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300.0),
            itemCount: food.length,
            itemBuilder: (BuildContext context, int index) => Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                  Expanded(
                    child:
                  Image(
                      image: NetworkImage(food[index].image),
                      width: 200)),
                  Text((food[index].name)),
                  Text(("Price: \$" + food[index].price.toString())),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child:
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
                  )),
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
        title: Text("Corner Clerk"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 50, left: 30, right: 30),
              child: Text("How many meal exchanges would you like to spend?",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 20))),
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
                    child: Text("Next",
                        style: TextStyle(fontSize: 20, color: Colors.white))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GridPage(
                                mealExchanges: mealExchanges,
                              )));
                },
              ))
        ],
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({Key key, this.mealExchanges}) : super(key: key);

  final int mealExchanges;

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  var items = [];
  double price = 0;

  void updateCart() {
    for (int index = 0; index < food.length; index++) {
      if (food[index].count > 0) {
        items.add(index);
        price += (food[index].count * food[index].price);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    updateCart();
    return Scaffold(
        appBar: AppBar(
          title: Text("Cart"),
          backgroundColor: Colors.orange,
        ),
        body: Column(
          children: [
            Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Item",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      Text("Count",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      Text("Price",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                    ])),
            Container(
              height: 400,
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    Product foodItem = food[items[index]];
                    var foodPrice = foodItem.count * foodItem.price;
                    return Padding(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(foodItem.name.toString(),
                                style: TextStyle(fontSize: 20)),
                            Text(foodItem.count.toString(),
                                style: TextStyle(fontSize: 20)),
                            Text("\$" + foodPrice.toString(),
                                style: TextStyle(fontSize: 20))
                          ],
                        ));
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Divider(height: 1),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Meal Exchanges: \$" +
                              (widget.mealExchanges * 9.5).toStringAsFixed(2),
                          style: TextStyle(fontSize: 25),
                        ),
                        Text("Cost: -\$" + price.toStringAsFixed(2),
                            style: TextStyle(fontSize: 25)),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Divider(
                              height: 1,
                            )),
                        Text(
                            "Remaining: \$" +
                                ((widget.mealExchanges * 9.5) - price)
                                    .toStringAsFixed(2),
                            style: TextStyle(fontSize: 25))
                      ],
                    )
                  ],
                ))
          ],
        ));
  }
}
