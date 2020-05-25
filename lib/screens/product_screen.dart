import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/product_item.dart';
import 'package:shop_app/providers/product_state.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Our movies"),
      ),
      body: ProductsGrid(),
    );
  }
}

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductState>(context);
    final products = productsData.products;
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
