import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/appbar.dart';
import 'package:shop_app/providers/products_list_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routename = '/userproduct';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBarForShopApp('Products'),
      drawer: AppDrawer(),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(EditProductScreen.routename);
        },
      ),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder:(context, snapshot) => snapshot.connectionState == ConnectionState.waiting? Center(child: CircularProgressIndicator()):  RefreshIndicator(
          onRefresh: () {
            return _refreshProduct(context);
          },
          child: Consumer<Products>(
            builder:(context, productsData, child) =>  Padding(
              padding: const EdgeInsets.all(5),
              child: ListView.builder(
                itemBuilder: (context, index) => Column(
                  children: [
                    UserProductItem(
                        imageUrl: productsData.items[index].imageUrl,
                        id: productsData.items[index].id,
                        title: productsData.items[index].title),
                    const Divider(),
                  ],
                ),
                itemCount: productsData.items.length,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
