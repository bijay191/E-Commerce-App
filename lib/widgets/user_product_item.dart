import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_list_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(
      {required this.imageUrl, required this.title, required this.id});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final productsList = Provider.of<Products>(context, listen: false);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routename, arguments: id);
              },
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () async{
                try {
                  productsList.deleteProduct(id);
                } catch (error) {
                  scaffold
                      .showSnackBar(SnackBar(content: Text('Deleting Failed')));
                }
              },
              icon: Icon(Icons.delete)),
        ]),
      ),
    );
  }
}
