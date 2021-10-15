import 'dart:math';
import 'package:dsc_shop/models/ItemModel.dart';
import 'package:dsc_shop/models/UserModel.dart';
import 'package:dsc_shop/providers/item_provider.dart';
import 'package:dsc_shop/providers/language_provider.dart';
import 'package:dsc_shop/providers/theme_provider.dart';
import 'package:dsc_shop/providers/user_item_provider.dart';
import 'package:dsc_shop/providers/user_provider.dart';
import 'package:dsc_shop/widgets/cart_widget.dart';
import 'package:dsc_shop/widgets/drawer_widget.dart';
import 'package:dsc_shop/widgets/home_widget.dart';
import 'package:dsc_shop/widgets/wishlist_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dsc_shop/screens/item_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double value = 0;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isDark = themeProvider.myMode == ThemeMode.dark;
    bool isAR = languageProvider.myLanguage == Locale("ar");
    final currentUser = userProvider.user;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
          ),
          MyDrawer(
            currentUser: currentUser,
          ),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: value),
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
            builder: (_, double val, __) {
              return (Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..setEntry(0, 3, 180 * val)
                  ..rotateY((pi / 6) * val),
                child: Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      onPressed: () {
                        setState(() {
                          value = value == 1 ? 0 : 1;
                        });
                      },
                      icon: Icon(Icons.menu),
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {
                            final provider = Provider.of<ItemProvider>(context,
                                listen: false);
                            final provider1 = Provider.of<UserItemsProvider>(
                                context,
                                listen: false);
                            final provider2 = Provider.of<UserProvider>(context,
                                listen: false);
                            List<ItemModel> data = [];
                            if (currentIndex == 0) {
                              data = provider.items;
                            } else if (currentIndex == 1) {
                              data = provider1.myWishList;
                            } else if (currentIndex == 2) {
                              data = provider1.myCart;
                            }
                            showSearch(
                                context: context,
                                delegate: Search(
                                    data,
                                    provider1.myCart,
                                    provider1.myWishList,
                                    provider2.user!,
                                    context));
                          },
                          icon: Icon(Icons.search))
                    ],
                    title: Text("Dsc Shop"),
                  ),
                  body: Stack(
                    children: [
                      Center(
                        child: getCurrentWidget(),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.03,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: BottomNavigationBar(
                              elevation: 50,
                              currentIndex: currentIndex,
                              backgroundColor:
                                  isDark ? Colors.black : Colors.indigo,
                              selectedItemColor: Colors.white,
                              unselectedItemColor: Colors.indigo.shade200,
                              onTap: (index) => setState(() {
                                currentIndex = index;
                              }),
                              items: <BottomNavigationBarItem>[
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.call),
                                  label: isAR ? 'الرئيسيه' : 'Home',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.star),
                                  label: isAR ? 'المفضله' : 'WishList',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.shopping_cart),
                                  label: isAR ? 'السله' : 'Cart',
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
            },
          ),
          GestureDetector(
            onHorizontalDragUpdate: (e) {
              if (e.delta.dx > 0) {
                setState(() {
                  value = 1;
                });
              } else {
                setState(() {
                  value = 0;
                });
              }
            },
          )
        ],
      ),
    );
  }

  Widget? getCurrentWidget() {
    switch (currentIndex) {
      case 0:
        return HomeWidget();
      case 1:
        return WishlistWidget();
      case 2:
        return CartWidget();
      default:
        return null;
    }
  }
}

class Search extends SearchDelegate {
  final List<ItemModel> _RecentItems;
  final List<ItemModel> cart;
  final List<ItemModel> wishList;
  final UserModel user;
  final BuildContext context;

  Search(this._RecentItems, this.cart, this.wishList, this.user, this.context);

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.close)),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<ItemModel> data = [];
    query.isEmpty
        ? data = _RecentItems
        : data.addAll(_RecentItems.where(
            (element) =>
                element.title.toLowerCase().contains(query.toLowerCase()),
          ));
    return ListView.builder(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: height * 0.02),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Image.network(
              data[index].image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            trailing: Icon(Icons.play_arrow, size: height * 0.02),
            title: Text(
              data[index].title,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider(
                          create: (_) =>
                              UserItemsProvider(user.id, cart, wishList),
                          child: ItemScreen(
                            item: data[index],
                            userId: user.id,
                          )))).then((value) {
                if (value != null) {
                  //TODO
                  Provider.of<UserItemsProvider>(context, listen: false)
                      .updateMyCart("", value[0]);
                  Provider.of<UserItemsProvider>(context, listen: false)
                      .updateMyWishlist("", value[1]);
                }
              });
            },
          ),
        );
      },
    );
  }
}
