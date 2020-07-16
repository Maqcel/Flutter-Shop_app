import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';
import 'dart:convert';

class ProductState with ChangeNotifier {
  List<Product> _products = [];
  static const url =
      'https://fir-learning-project-18dfb.firebaseio.com/products.json'; //* Added .json its Firebase thing
  List<Product> get products {
    return [..._products];
  }

  List<Product> get favoriteProducts {
    return _products.where((element) => element.isFavorite).toList();
  }

  Future<void> setProduct() async {
    try {
      final response = await http.get(url).timeout(Duration(seconds: 10));
      //print(response.body.toString());
      final decodeData = json.decode(response.body) as Map<String, dynamic>;
      if (decodeData == null) return;
      final List<Product> temporary = [];
      decodeData.forEach(
        (prodId, movie) {
          temporary.add(
            Product(
              id: prodId,
              desc: movie['description'],
              name: movie['name'],
              price: movie['price'],
              imageUrl: movie['imageUrl'],
              isFavorite: movie['isFavorite'],
            ),
          );
        },
      );
      _products = temporary;
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

  Future<void> addProduct(Product product) async {
    try {
      final response = await http
          .post(
            url,
            body: json.encode(
              {
                'name': product.name,
                'description': product.desc,
                'imageUrl': product.imageUrl,
                'price': product.price,
                'isFavorite': product.isFavorite,
              }, //* data need to be converted into json, json.encode can convert maps to json
            ),
          )
          .timeout(Duration(seconds: 10));
      //print(json.decode(response.body));
      Product newProduct = new Product(
        id: json.decode(response.body)['name'],
        desc: product.desc,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: false,
      );
      _products.add(newProduct);
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

  Product findById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(String id, Product updated) async {
    final productIndex = _products.indexWhere((element) => element.id == id);
    final movieURL =
        'https://fir-learning-project-18dfb.firebaseio.com/products/$id.json';
    try {
      await http
          .patch(
            movieURL,
            body: json.encode(
              {
                'name': updated.name,
                'description': updated.desc,
                'imageUrl': updated.imageUrl,
                'price': updated.price,
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
    _products[productIndex] = updated;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final movieURL =
        'https://fir-learning-project-18dfb.firebaseio.com/products/$id.json';
    try {
      await http.delete(movieURL);
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

    final productIndex = _products.indexWhere((element) => element.id == id);
    _products.removeAt(productIndex);
    notifyListeners();
  }
}
