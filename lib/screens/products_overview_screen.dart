import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/badge.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products_list_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/drawer.dart';
import '../widgets/product_grid.dart';

enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<Products>(context).fetchAndSetProducts(); Won't work
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = !_isInit;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
            shadowColor: const Color.fromARGB(0, 0, 0, 0),
            title: const Center(child: Text('Pasale')),
            actions: [
              Consumer<Cart>(
                builder: (context, cart, widget) => Badge(
                  child: widget as Widget,
                  value: cart.itemCount.toString(),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, CartScreen.CartScreenRoute);
                  },
                ),
              ),
              PopupMenuButton(
                onSelected: (FilterOptions selectedValue) {
                  setState(() {
                    if (selectedValue == FilterOptions.Favorites) {
                      _showOnlyFavorites = true;
                    } else {
                      _showOnlyFavorites = false;
                    }
                  });
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    child: Text('Only Fav'),
                    value: FilterOptions.Favorites,
                  ),
                  const PopupMenuItem(
                    child: Text('Show all'),
                    value: FilterOptions.All,
                  ),
                ],
                icon: const Icon(
                  Icons.more_vert,
                ),
              ),
            ]),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(5),
        color: Color.fromARGB(235, 255, 255, 255),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(_showOnlyFavorites),
      ),
    );
  }
}
