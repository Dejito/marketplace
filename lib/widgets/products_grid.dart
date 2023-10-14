import 'package:flutter/material.dart';

import 'package:marketplace/widgets/product_item.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    super.key,
    required this.filteredProducts,
  });

  final bool filteredProducts;

  @override
  Widget build(BuildContext context) {
    final loadedProducts = filteredProducts ? Provider.of<Products>(context).favoriteItems : Provider.of<Products>(context).items;
    print(loadedProducts.length);
    print(filteredProducts);
    // final loadedProducts = products.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 3 / 2),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: loadedProducts[index],
        child: const ProductItem(),
      ),
      itemCount: loadedProducts.length,
    );
  }
}
