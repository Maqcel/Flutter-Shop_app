import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/orders_drawer.dart';
import 'package:shop_app/providers/orders.dart';
import 'dart:math';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key key}) : super(key: key);

  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    setState(
      () {
        _isLoading = true;
      },
    );
    Provider.of<Orders>(context, listen: false).setOrders().then(
      (value) {
        setState(
          () {
            _isLoading = false;
          },
        );
      },
    ).catchError(
      (onError) {
        return showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text(
                'Something went wrong, most likely no internet connection'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(OrdersScreen.routeName);
                },
                child: Text('Try again!'),
              ),
            ],
          ),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersDetails = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your orders!"),
      ),
      drawer: OrdersDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ordersDetails.orders.length == 0
              ? Center(
                  child: Text('Add some orders!'),
                )
              : ListView.builder(
                  itemCount: ordersDetails.orders.length,
                  itemBuilder: (ctx, i) =>
                      OrderCreator(order: ordersDetails.orders[i]),
                ),
    );
  }
}

class OrderCreator extends StatefulWidget {
  final OrderItem order;
  const OrderCreator({Key key, this.order}) : super(key: key);

  @override
  _OrderCreatorState createState() => _OrderCreatorState();
}

class _OrderCreatorState extends State<OrderCreator> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              '\$ ${widget.order.price}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
                DateFormat('dd/MM/yyyy kk:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(!_expanded ? Icons.expand_more : Icons.expand_less),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: min(widget.order.products.length * 45.0, 120),
              child: ListView(
                children: widget.order.products
                    .map((element) => ExpandedInfo(element))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class ExpandedInfo extends StatelessWidget {
  final CartItem prod;
  ExpandedInfo(this.prod);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          prod.name,
          style: TextStyle(fontSize: 18),
        ),
        Text(
          '${prod.quantity}×\$${prod.price}',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ],
    );
  }
}
