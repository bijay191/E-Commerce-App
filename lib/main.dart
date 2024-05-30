import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products_list_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import 'models/palette.dart';

void main() {
  runApp(const MyApp());
}

//For custom material color

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProvider(create: (context) => Cart()),
          ChangeNotifierProvider.value(value: Orders()),
          
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) =>
                Products(Provider.of<Auth>(context, listen: false).token, [],'null'),
            update: ((context, auth, previousProd) {
              return Products(auth.token, previousProd!.items,auth.userId);
            }),
          )
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: Palette.kToDark,
                      onSecondary: Color.fromARGB(233, 255, 255, 255),
                    ),
                fontFamily: 'Lato',
              ),
              home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
              routes: {
                ProductDetailScreen.routeForProductDetailScreen: (ctx) =>
                    ProductDetailScreen(),
                CartScreen.CartScreenRoute: ((context) => const CartScreen()),
                OrdersScreen.routename: (context) => OrdersScreen(),
                UserProductScreen.routename: (context) => UserProductScreen(),
                EditProductScreen.routename: ((context) =>
                    const EditProductScreen()),
                AuthScreen.routeName: ((context) => AuthScreen())
              },
            );
          },
        ));
  }
}
