import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:collection';

final database = Firestore.instance;

class Product {
  final String name;
  final double price;
  var count = 0;

  Product({this.name, this.price});
}

HashMap cart = new HashMap<String, Product>();

void main() async {
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

  void updateCount(name, add) {
    setState(() {
      if (add) {
        cart[name].count += 1;
      } else if (cart[name].count > 0) {
        cart[name].count -= 1;
      }

      updateRemaining();
    });
  }

  void updateRemaining() {
    setState(() {
      money = (9.5 * widget.mealExchanges).toDouble();

      cart.forEach((key, value) {
        money -= value.count * value.price;
      });
      });
  }

  @override
  Widget build(BuildContext context) {
    if (money == null) {
      money = (9.5 * widget.mealExchanges).toDouble();
    }
    /*
    return Scaffold(body: FutureBuilder(
      future: Firestore.instance.collection("products").getDocuments(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print(snapshot.data.documents[0]);
        return Text(snapshot.data.documents[0]["image"].toString());
      }
    ),);   */
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
      body: FutureBuilder(
          future: Firestore.instance.collection("products").getDocuments(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300.0),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  var this_document = snapshot.data.documents[index];
                  var product_name = this_document["name"];
                  var product_image = this_document["image"];
                  var product_price = this_document["price"];

                  if (cart[product_name] == null) {
                    Product thisProduct = Product(name: product_name, price: product_price);

                    cart[product_name] = thisProduct;
                  }

                  print(cart);
                  print(cart[product_name].count);

                  return Card(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                        Expanded(
                            child: Image(
                                image: NetworkImage(
                                    product_image),
                                width: 200)),
                        Text(product_name),
                        Text(("Price: \$" + product_price.toString())),
                        Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(
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
                                        updateCount(product_name, false);
                                      },
                                    )),
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Text(
                                     cart[product_name].count.toString(),
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
                                        updateCount(product_name, true);
                                      },
                                    )),
                              ],
                            )),
                      ]));
                });
          }),
    );
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
    cart.forEach((key, value) {
      if (value.count > 0) {
        items.add(value);
        price += (value.count * value.price);
      }
    });
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
                      Text("Count",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      Text("Item",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      Text("Price",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                    ])),
            Expanded(
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    Product foodItem = cart[items[index].name];
                    var foodPrice = foodItem.count * foodItem.price;
                    return Padding(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: 15, right: 25),
                                child: Text(
                                  foodItem.count.toStringAsFixed(0),
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                )),
                            Expanded(
                                flex: 3,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(foodItem.name.toString(),
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(fontSize: 20)))),
                            Padding(
                                padding: EdgeInsets.only(left: 25, right: 15),
                                child: Text("\$" + foodPrice.toStringAsFixed(2),
                                    style: TextStyle(fontSize: 20)))
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
