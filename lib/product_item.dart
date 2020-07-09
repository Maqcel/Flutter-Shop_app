import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

import 'providers/product.dart';
import 'screens/product_detail_screen.dart';

Widget iconCreate(
    Function function, Icon icon, String type, BuildContext context) {
  final cart = Provider.of<Cart>(context);
  final product = Provider.of<Product>(context);
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
        onPressed: () {
          if (function != null) function();
          if (type == "cart"){
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Item added to cart!"),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () {
                    cart.removeProduct(product.id);
                  },
                ),
              ),
            );
          }
        },
        color: Colors.black87,
      ),
    ),
  );
}

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          title: Container(),
          trailing: iconCreate(
            () => cart.addProduct(product.id, product.price, product.name),
            Icon(Icons.add_shopping_cart),
            "cart",
            context,
          ),
          leading: iconCreate(
            product.toggleFavorite,
            Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
            "fav",
            context,
          ),
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
