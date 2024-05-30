import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_list_provider.dart';

enum FilterOptions { Favorites, All }

class CartWidget extends StatelessWidget {
  bool showFavs;
  CartWidget(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context);
    return PopupMenuButton(
      onSelected: (FilterOptions selectedValue) {
        if (selectedValue == FilterOptions.Favorites) {
          showFavs = true;
        } else {
          showFavs = false;
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          child: Text('Only Fav'),
          value: FilterOptions.Favorites,
        ),
        PopupMenuItem(
          child: Text('Show all'),
          value: FilterOptions.All,
        )
      ],
      icon: Icon(
        Icons.more_vert,
      ),
    );
  }
}
