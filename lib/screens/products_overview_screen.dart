import 'package:flutter/material.dart';

import 'package:marketplace/widgets/product_item.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    final loadedProducts = products.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Marketplace"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 3 / 2),
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
           value: loadedProducts[index],
          child : const ProductItem(),
        ),
        itemCount: loadedProducts.length,
      ),
    );
  }
}
