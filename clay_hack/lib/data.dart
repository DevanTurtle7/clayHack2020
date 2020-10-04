class Product {
  final String name;
  final double price;
  final String image;
  var count = 0;

  Product({this.name, this.price, this.image});
}

var food = [
  Product(
    name: "Sprite 12 Pack",
    price: 7.29,
    image: "https://s3-us-west-2.amazonaws.com/ldsbookstore/products/LDP-MTCS165-sprite.jpeg"
  ), Product(
    name: "Peace Tea",
    price: 1.79,
    image: "https://images.heb.com/is/image/HEBGrocery/002111738"
  ), Product(
    name: "Simple Raspberry Lemonade 52 oz.",
    price: 4.19,
    image: "https://sbfcdn.azureedge.net/media/0001845_simply-raspberry-lemonade-52-oz_600.jpeg"
  ), Product(
    name: "Chips Ahoy Original",
    price: 4.89,
    image: "https://images-na.ssl-images-amazon.com/images/I/81ak1LBmQsL._SY355_.jpg"
  ), Product(
    name: "Cosmic Brownies",
    price: 1.99,
    image: "https://images.heb.com/is/image/HEBGrocery/000390305"
  ), Product(
    name: "Pirouline Creme Filled Wafers",
    price: 5.79,
    image: "https://images-na.ssl-images-amazon.com/images/I/718bsM7jbeL._SX342_.jpg"
  ), Product(
    name: "Nissin Spicy Chicken Chow Mein",
    price: 1.29,
    image: "https://d2lhip1ki8p4nk.cloudfront.net/uploads/products/chow-mein/flavors/Chow_Mein_Spicy_Chicken_Front_328x287.png?mtime=20191210211801"
  )
];
