import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/badge.dart';
import 'package:shop_app/product_item.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product_state.dart';
import 'package:shop_app/screens/cart_screen.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _showFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Our movies"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  _showFavorites = true;
                } else
                  _showFavorites = false;
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Show All'), value: false),
              PopupMenuItem(child: Text('Show Favorites'), value: true),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.productsCount.toString(),
              color: Colors.redAccent,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_basket),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: ProductsGrid(_showFavorites),
    );
  }
}

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;

  const ProductsGrid(this.showFavorites);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductState>(context);
    final products =
        showFavorites ? productsData.favoriteProducts : productsData.products;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (contex, i) => ChangeNotifierProvider.value(
        value: products[
            i], //! products are already existing value is better aproach here
        child: ProductItem(),
      ),
      itemCount: products.length,
      padding: const EdgeInsets.all(10.0),
    );
  }
}
