import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/cart.dart';

class CardItem extends StatelessWidget {
  final String id;
  final double price;
  final String name;
  final int quantity;
  final String deleteId;

  const CardItem(
      {this.id, this.price, this.name, this.quantity, this.deleteId});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.redAccent,
        child: Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 60,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 50),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeProduct(deleteId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(name),
            subtitle: Text('Total: ${(price * quantity).toStringAsFixed(2)}\$'),
            trailing: Text('$quantity'),
          ),
        ),
      ),
    );
  }
}
