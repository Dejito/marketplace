import 'package:flutter/material.dart';
import 'package:marketplace/providers/product.dart';
import 'package:marketplace/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {

  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);

    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      child: GridTile(
        footer: GridTileBar(
          title: Text(
            product.title,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            onPressed: () {
              product.toggleIsFavorite();
            },
            icon: Icon(product.isFavorite == true ? Icons.favorite : Icons.favorite_border,
              color: Colors.deepOrange,
            ),
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
          ),
          backgroundColor: Colors.black54,
        ),
        child: GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, ProductDetailScreen.route, arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
