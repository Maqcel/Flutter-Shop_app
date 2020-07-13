import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';
import 'dart:convert';

class ProductState with ChangeNotifier {
  List<Product> _products = [
    Product(
        id: 'f1',
        desc:
            "A determined woman works with a hardened boxing trainer to become a professional.",
        name: "Million Dollar Baby",
        price: 19.99,
        imageUrl: 'https://tinyurl.com/yc6bpbdz'),
    Product(
        id: 'f2',
        desc:
            "Disgruntled Korean War veteran Walt Kowalski sets out to reform his neighbor, Thao Lor, a Hmong teenager who tried to steal Kowalski's prized possession: a 1972 Gran Torino.",
        name: "Gran Torino",
        price: 14.99,
        imageUrl: "https://tinyurl.com/y7vmnc5s"),
    Product(
        id: 'f3',
        desc:
            "With his wife's disappearance having become the focus of an intense media circus, a man sees the spotlight turned on him when it's suspected that he may not be innocent.",
        name: "Gone Girl",
        price: 19.99,
        imageUrl: "https://tinyurl.com/y9foc6ff"),
    Product(
        id: 'f4',
        desc:
            'A successful entrepreneur accused of murder and a witness preparation expert have less than three hours to come up with an impregnable defence.',
        name: 'Contratiempo',
        price: 12.99,
        imageUrl: 'https://tinyurl.com/yb27dyge'),
    Product(
        id: 'f5',
        desc:
            'In Gotham City, mentally troubled comedian Arthur Fleck is disregarded and mistreated by society. He then embarks on a downward spiral of revolution and bloody crime. This path brings him face-to-face with his alter-ego: the Joker.',
        name: 'Joker',
        price: 24.99,
        imageUrl: 'https://tinyurl.com/y8sco6xz'),
    Product(
        id: 'f6',
        desc:
            'A sexually frustrated suburban father has a mid-life crisis after becoming infatuated with his daughter\'s best friend.',
        name: 'American Beauty',
        price: 9.99,
        imageUrl: 'https://tinyurl.com/y7up3hgu'),
    Product(
        id: 'f7',
        desc:
            'Dumped by his girlfriend, a high school grad decides to embark on an overseas adventure in Europe with his friends.',
        name: 'Eurotrip',
        price: 11.99,
        imageUrl: 'https://tinyurl.com/yd7vja6a'),
    Product(
        id: 'f8',
        desc:
            'A middle-aged husband\'s life changes dramatically when his wife asks him for a divorce. He seeks to rediscover his manhood with the help of a newfound friend, Jacob, learning to pick up girls at bars.',
        name: 'Crazy, Stupid, Love',
        price: 14.99,
        imageUrl: 'https://tinyurl.com/y8h2cn2x'),
  ];

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favoriteProducts {
    return _products.where((element) => element.isFavorite).toList();
  }

  void addProduct(Product product) {
    const url =
        'https://fir-learning-project-18dfb.firebaseio.com/products.json'; //* Added .json its Firebase thing

    http
        .post(
      url,
      body: json.encode(
        {
          'name': product.name,
          'description': product.desc,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        },
      ),
    )
        .then(
      //! it's triggered after post method ends
      (value) {
        //! value is a response from the web serwer
        //print(json.decode(value.body));
        Product newProduct = new Product(
          id: json.decode(value.body)['name'],
          desc: product.desc,
          name: product.name,
          price: product.price,
          imageUrl: product.imageUrl,
        );
        _products.add(newProduct);
        notifyListeners();
      },
    ); //* data need to be converted into json, json.encode can convert maps to json
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
