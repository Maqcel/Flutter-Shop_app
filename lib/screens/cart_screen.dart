import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/card_item.dart';
import 'package:shop_app/providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartDetails = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          TotalCard(cartDetails: cartDetails),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: cartDetails.products.length,
              itemBuilder: (context, i) => CardItem(
                name: cartDetails.products.values.toList()[i].name,
                quantity: cartDetails.products.values.toList()[i].quantity,
                id: cartDetails.products.values.toList()[i].id,
                price: cartDetails.products.values.toList()[i].price,
                deleteId: cartDetails.products.keys.toList()[i],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TotalCard extends StatelessWidget {
  const TotalCard({
    Key key,
    @required this.cartDetails,
  }) : super(key: key);

  final Cart cartDetails;

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return Card(
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Total:', style: TextStyle(fontSize: 20)),
                Spacer(),
                Chip(
                    label: Text(
                      '${cartDetails.totalCost.toStringAsFixed(2)}\$',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.payment),
                  onPressed: () {},
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
