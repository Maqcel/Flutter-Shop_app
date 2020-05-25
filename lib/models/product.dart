import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Product {
  final String id;
  final String desc;
  final String name;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.desc,
    @required this.name,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });
}

Widget iconCreate(Function function, Icon icon) {
  return Container(
    width: 48,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: Colors.black87, width: 2),
      color: Colors.white54,
      
    ),
    child: CircleAvatar(
      radius: 25,
      backgroundColor: Colors.white54,
      child: IconButton(
        icon: icon,
        onPressed: () {},
        color: Colors.black87,
      ),
    ),
  );
}

class ProductItem extends StatelessWidget {
  final Product product;
  ProductItem(this.product);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          title: Container(),
          trailing: iconCreate(null, Icon(Icons.shopping_basket)),
          leading: iconCreate(null, Icon(Icons.favorite)),
        ),
        header: Container(
          margin: EdgeInsets.only(top: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white54,
              border: Border.all(color: Colors.black87, width: 1),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.all(3),
            child: Center(
              child: Text(
                product.name,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
