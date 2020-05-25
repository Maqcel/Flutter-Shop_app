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
              itemBuilder: (context, i) => CardItem(cartDetails.products.values.toList()[i]),
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
                  '${cartDetails.totalCost}\$',
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
  }
}
