import 'package:flutter/material.dart';
import 'package:marketplace/providers/product.dart';
import 'package:marketplace/screens/cart_screen.dart';
import 'package:marketplace/widgets/app_drawer.dart';
import 'package:marketplace/widgets/badge.dart';

import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  static const route = 'products_overview_screen';

  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {

  // @override
  // void initState() {
  //   Future.delayed(const Duration(seconds: 0)).then((_) => Provider.of<Products>(context, listen: false).fetchAndSetProducts());
  //   super.initState();
  // }

  var _isInit = true;
  var _isLoading = false;
  bool _filteredOption = false;


  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }


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
      drawer: const AppDrawer(),
      body: _isLoading ? const Center(child: CircularProgressIndicator(),) : ProductsGrid(filteredProducts: _filteredOption),
    );
  }
}
