import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/providers/cart.dart';

class CardItem extends StatelessWidget {
  final CartItem product;
  const CardItem(this.product);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(product.id),
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
        Provider.of<Cart>(context,listen: false).removeProduct(product.id);
        //TODO Fix the mistake with updating the cart, think about the idea how to remove just one quantity
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
                  child: Text('\$${product.price}'),
                ))),
            title: Text(product.name),
            subtitle: Text('Total: ${(product.price * product.quantity)}\$'),
            trailing: Text('${product.quantity}'),
          ),
        ),
      ),
    );
  }
}
