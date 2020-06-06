import 'package:flutter/material.dart';
import 'package:shop_app/models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _products = {};

  Map<String, CartItem> get products {
    return {..._products};
  }

  int get productsCount {
    int count = 0;
    _products.forEach(
      (key, value) {
        count += value.quantity;
      },
    );
    return count;
  }

  double get totalCost {
    double total = 0.0;
    _products.forEach(
      (key, value) {
        total += value.quantity * value.price;
      },
    );
    return total;
  }

  void addProduct(String productId, double price, String name) {
    if (_products.containsKey(productId)) {
      _products.update(
        productId,
        (existingCartProduct) => CartItem(
          id: existingCartProduct.id,
          name: existingCartProduct.name,
          quantity: existingCartProduct.quantity + 1,
          price: existingCartProduct.price,
        ),
      );
    } else {
      _products.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          name: name,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeProduct(String productId) {
    var x=_products.entries.firstWhere((element) => element.key == productId);
    if (x.value.quantity != 1) {
      //print('Przed: ${x.value.quantity}');
      _products.update(
        productId,
        (existingCartProduct) => CartItem(
          id: existingCartProduct.id,
          name: existingCartProduct.name,
          quantity: existingCartProduct.quantity - 1,
          price: existingCartProduct.price,
        ),
      );
      //print('Po: ${x.value.quantity}');
    } else {
      _products.remove(productId);
    }
    notifyListeners();
  }

  void clearCart(){
    _products = {};
    notifyListeners();
  }
}
