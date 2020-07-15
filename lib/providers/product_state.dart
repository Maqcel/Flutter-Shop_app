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
      final response = await http.get(url);
      //print(response.body.toString());
      final decodeData = json.decode(response.body) as Map<String, dynamic>;
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
            ),
          );
        },
      );
      _products = temporary;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
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
      );
      //print(json.decode(response.body));
      Product newProduct = new Product(
        id: json.decode(response.body)['name'],
        desc: product.desc,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Product findById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  void updateProduct(String id, Product updated) {
    final productIndex = _products.indexWhere((element) => element.id == id);
    _products[productIndex] = updated;
    notifyListeners();
  }

  void deleteProduct(String id) {
    final productIndex = _products.indexWhere((element) => element.id == id);
    _products.removeAt(productIndex);
    notifyListeners();
  }
}
