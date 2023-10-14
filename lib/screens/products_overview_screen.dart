import 'package:flutter/material.dart';
import 'package:marketplace/screens/cart_screen.dart';
import 'package:marketplace/widgets/badge.dart';

import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _filteredOption = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Marketplace"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorites) {
                  _filteredOption = true;
                } else {
                  _filteredOption = false;
                }
              });
            },
            itemBuilder: (_) {
              return [
                const PopupMenuItem(
                  value: FilterOptions.all,
                  child: Text("Show all"),
                ),
                const PopupMenuItem(
                  value: FilterOptions.favorites,
                  child: Text("Favorites"),
                ),
              ];
            },
          ),
          Consumer<Cart>(
            builder: (BuildContext context, cart, ch) => Badger(
              value: cart.getCartItems.toString(),
              child: ch!,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: ProductsGrid(filteredProducts: _filteredOption),
    );
  }
}
