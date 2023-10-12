import 'package:flutter/material.dart';
import 'package:marketplace/providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const route = "product_detail_screen";

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final product = Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title:  Text(product.title),
      ),
      body: null,
    );
  }
}
