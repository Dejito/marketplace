import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String prodId;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {
        required this.id,
        required this.prodId,
      required this.title,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
   Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }


  int get getCartItems {
    return _items.length;
}

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeItem(String prodId) {
    _items.remove(prodId);
    notifyListeners();
  }

  double get getTotalAmount {
    double totalAmount = 0;
    _items.forEach((key, item) {
      totalAmount += item.price * item.quantity;
    });
    return totalAmount;
    // notifyListeners();
  }

  void addItem(String prodId, double price, String title) {
    if (_items.containsKey(prodId)) {
      _items.update(
          prodId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1,
              price: existingCartItem.price, prodId: prodId));
    } else {
      _items.putIfAbsent(
          prodId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price, prodId: prodId = prodId));
    }
    notifyListeners();
  }
}
