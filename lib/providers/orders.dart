import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double price;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.price,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  static const url =
      'https://fir-learning-project-18dfb.firebaseio.com/orders.json';
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> setOrders() async {
    try {
      final response = await http.get(url).timeout(Duration(seconds: 10));
      //print(response.body.toString());
      final decodeData = json.decode(response.body) as Map<String, dynamic>;
      if (decodeData == null) return;
      final List<OrderItem> temporary = [];
      decodeData.forEach(
        (orderId, data) {
          temporary.add(
            OrderItem(
              id: orderId,
              dateTime: DateTime.parse(data['dateTime']),
              price: data['price'],
              products: (data['products'] as List<dynamic>)
                  .map(
                    (element) => CartItem(
                      id: element['id'],
                      name: element['name'],
                      price: element['price'],
                      quantity: element['quantity'],
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );
      _orders = temporary.reversed.toList();
      notifyListeners();
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw e;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw e;
    } on Error catch (e) {
      print('General Error: $e');
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final time = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'price': total,
            'dateTime': time.toIso8601String(),
            'products': cartProducts
                .map(
                  (element) => {
                    'id': element.id,
                    'name': element.name,
                    'quantity': element.quantity,
                    'price': element.price,
                  },
                )
                .toList(),
          },
        ),
      );
      _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            price: total,
            dateTime: time,
            products: cartProducts),
      );
      notifyListeners();
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw e;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw e;
    } on Error catch (e) {
      print('General Error: $e');
      throw e;
    }
  }
}
