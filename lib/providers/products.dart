import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marketplace/model/http_exception.dart';

import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {

  final String authToken;

  Products(this.authToken, this._items);

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //   'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //   'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    // print("is authToken $authToken");
    final baseUrls = "https://marketplace-f3f0d-default-rtdb.firebaseio.com/products.json?auth=$authToken";
    print("base url>>>>>> $baseUrls");
    try {
      final response = await http.get(Uri.parse(baseUrls));
      print("resp body ${json.decode(response.body)}");
      if (json.decode(response.body) == 'null') {
        return;
      }
      final decodedData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedData = [];
      decodedData.forEach((prodID, prodData) {
        loadedData.add(Product(
            id: prodID,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            isFavorite: prodData['isFavorite']));
      });
      _items = loadedData;
      notifyListeners();
      // print(json.decode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final baseUrl =
        "https://marketplace-f3f0d-default-rtdb.firebaseio.com/products.json?auth=$authToken";
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: json.encode({
          // "id": DateTime.now().toString(),
          "title": product.title,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
        isFavorite: product.isFavorite,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String prodId, Product newProduct) async {
    final baseUrl =
        "https://marketplace-f3f0d-default-rtdb.firebaseio.com/products/$prodId.json?auth=$authToken";
    await http.patch(
      Uri.parse(baseUrl), // final response =
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        // isFavorite: product.isFavorite,
      }),
    );
    final prodIndex = _items.indexWhere((prod) => prod.id == prodId);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {}
  }

  Future<void> deleteProduct(String prodId) async {
    final baseUrl =
        "https://marketplace-f3f0d-default-rtdb.firebaseio.com/products/$prodId.json?auth=$authToken";
    final deletedProdIndex = _items.indexWhere((element) => prodId == element.id);
    final deletedProduct = _items[deletedProdIndex];
    _items.removeAt(deletedProdIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(baseUrl));

    if (response.statusCode >= 400) {
      _items.insert(deletedProdIndex, deletedProduct);
      notifyListeners();
      throw HttpException("Something went wrong!");
    }
    // } catch(e) {
    //   rethrow;
    // }
    // deletedProduct = null;
    // deletedProduct = null;
  }
}
