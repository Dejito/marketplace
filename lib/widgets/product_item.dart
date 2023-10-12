import 'package:flutter/material.dart';
import 'package:marketplace/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const ProductItem(
      {super.key,
      required this.id,
      required this.title,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      child: GridTile(
        footer: GridTileBar(
          title: Text(
            title,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite),
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
          ),
          backgroundColor: Colors.black54,
        ),
        child: GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, ProductDetailScreen.route, arguments: title);
          },
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
