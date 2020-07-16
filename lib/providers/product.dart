import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String desc;
  final String name;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.desc,
    @required this.name,
    @required this.price,
    @required this.imageUrl,
    @required this.isFavorite,
  });

  Future<void> toggleFavorite() async {
    final url =
        'https://fir-learning-project-18dfb.firebaseio.com/products/$id.json';
    try {
      await http
          .patch(
            url,
            body: json.encode(
              {
                'isFavorite': !isFavorite,
              },
            ),
          )
          .timeout(Duration(seconds: 10));
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
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
