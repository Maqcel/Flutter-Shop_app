import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/orders_drawer.dart';
import 'package:shop_app/providers/product_state.dart';
import 'package:shop_app/screens/Edit_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Provider.of<ProductState>(context, listen: false)
                    .deleteProduct(id)
                    .catchError(
                  (onError) {
                    return showDialog<Null>(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: Text('Couldn\'t delete!'),
                        content: Text(
                            'Something went wrong, most likely no internet connection'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                  UserProductScreen.routeName);
                            },
                            child: Text('Go back!'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user_products';

  Future<void> _onRefresh(BuildContext context) async {
    await Provider.of<ProductState>(context, listen: false)
        .setProduct()
        .catchError(
      (onError) {
        return showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text('Couldn\'t refresh!'),
            content: Text(
                'Something went wrong, most likely no internet connection'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(UserProductScreen.routeName);
                },
                child: Text('Go back!'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductState>(context);
    return Container(
      child: Scaffold(
        drawer: OrdersDrawer(),
        appBar: AppBar(
          title: Text("Your Products"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: productData.products.length,
              itemBuilder: (_, i) => Column(
                children: <Widget>[
                  UserProductItem(
                    productData.products[i].id,
                    productData.products[i].name,
                    productData.products[i].imageUrl,
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
