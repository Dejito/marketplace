import 'package:flutter/material.dart';

import 'package:marketplace/providers/auth.dart';
import 'package:marketplace/providers/cart.dart';
import 'package:marketplace/providers/orders.dart';
import 'package:marketplace/providers/products.dart';
import 'package:marketplace/screens/auth_screen.dart';
import 'package:marketplace/screens/cart_screen.dart';
import 'package:marketplace/screens/edit_product_screen.dart';
import 'package:marketplace/screens/orders_screen.dart';
import 'package:marketplace/screens/product_detail_screen.dart';
import 'package:marketplace/screens/products_overview_screen.dart';
import 'package:marketplace/screens/user_products_screen.dart';
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
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products("", []),
          update: (context, auth, previousProduct) => Products(auth.loginToken, previousProduct!.items),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(""),
          update: (BuildContext context, value, Orders? previous) {
            return Orders(previous!.authToken);
          },
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) =>
            MaterialApp(
              title: 'Marketplace app',
              theme: ThemeData(
                iconTheme: const IconThemeData(color: Colors.deepOrange),
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                primaryColor: Colors.deepOrange,
                useMaterial3: true,
              ),
              // initialRoute: '/',
              home: auth.isSetLoginToken ? const ProductsOverviewScreen() : const AuthScreen(),
              routes: {
                // '/': (context) => const AuthScreen(),
                ProductsOverviewScreen.route: (context) => const ProductsOverviewScreen(),
                ProductDetailScreen.route: (context) => const ProductDetailScreen(),
                CartScreen.routeName: (context) => const CartScreen(),
                OrdersScreen.routeName: (context) => const OrdersScreen(),
                UserProductsScreen.routeName: (context) => const UserProductsScreen(),
                EditProductScreen.routeName: (context) => const EditProductScreen()
              },
              onUnknownRoute: (_) {
                return MaterialPageRoute(
                  builder: (context) => const ProductsOverviewScreen(),
                );
              },
              debugShowCheckedModeBanner: false,
            ),

      ),
    );
  }
}
