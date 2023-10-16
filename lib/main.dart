import 'package:flutter/material.dart';

import 'package:marketplace/providers/cart.dart';
import 'package:marketplace/providers/orders.dart';
import 'package:marketplace/providers/products.dart';
import 'package:marketplace/screens/cart_screen.dart';
import 'package:marketplace/screens/orders_screen.dart';
import 'package:marketplace/screens/product_detail_screen.dart';
import 'package:marketplace/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(create: (context) => Orders())
      ],
      child: MaterialApp(
        title: 'Marketplace app',
        theme: ThemeData(
          iconTheme: const IconThemeData(color: Colors.deepOrange),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          primaryColor: Colors.deepOrange,
          useMaterial3: true,
        ),
        initialRoute: '/',
        // home: const ProductsOverviewScreen(),
        routes: {
          '/': (context) => const ProductsOverviewScreen(),
          ProductDetailScreen.route: (context) => const ProductDetailScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          OrdersScreen.routeName: (context) => const OrdersScreen()
        },
        onUnknownRoute: (_) {
          return MaterialPageRoute(
            builder: (context) => const ProductsOverviewScreen(),
          );
        },
      ),
    );
  }
}
