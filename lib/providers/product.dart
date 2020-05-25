import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    this.isFavorite = false,
  });

  void toggleFavorite(){
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
