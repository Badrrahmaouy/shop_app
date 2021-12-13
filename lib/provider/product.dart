import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String id, bool isFav) async {
    isFavorite = !isFav;
    notifyListeners();
    final url = Uri.parse(
        'https://shopapp-29edc-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
    final response = await http.patch(
      url,
      body: json.encode({
        'isFavorite': !isFav,
      }),
    );
    if (response.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException('Could not toggle favorite.');
    }
  }
}
