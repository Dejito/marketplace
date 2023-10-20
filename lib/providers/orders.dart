import 'dart:convert';

import 'package:flutter/foundation.dart';

import './cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrder() async {
    const baseUrl =
        "https://marketplace-f3f0d-default-rtdb.firebaseio.com/orders.json";
    final response = await http.get(Uri.parse(baseUrl));
    if (response.body == 'null') {
      print("stopped here");
      return;
    }
    print(response.body);
    List<OrderItem> loadedData = [];
    final decodedData = json.decode(response.body) as Map<String, dynamic>;
    // if (decodedData == null) {
    //   return;
    // }
    decodedData.forEach(
      (orderId, orderData) {
        loadedData.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: orderId,
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                    prodId: item['prodId'],
                  ),
                ).toList(),
          ),
        );
      },
    );
    _orders = loadedData;
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const baseUrl =
        "https://marketplace-f3f0d-default-rtdb.firebaseio.com/orders.json";
    final dateTime = DateTime.now().toIso8601String();
    final response = await http.post(Uri.parse(baseUrl),
        body: json.encode(
          {
            'amount': total,
            'dateTime': dateTime,
            'products': cartProducts
                .map(
                  (cp) => {
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                    'id': cp.id,
                    'prodId': cp.prodId
                  },
                )
                .toList(),
          },
        ));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
