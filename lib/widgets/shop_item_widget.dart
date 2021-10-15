import 'package:dsc_shop/models/ItemModel.dart';
import 'package:dsc_shop/providers/user_item_provider.dart';
import 'package:dsc_shop/providers/user_provider.dart';
import 'package:dsc_shop/screens/item_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopItem extends StatelessWidget {
  const ShopItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<UserItemsProvider>(context);
    final cart = itemProvider.myCart;
    final wishList = itemProvider.myWishList;
    final isCart = cart.any((element) => element.id == item.id);
    final isWishlist = wishList.any((element) => element.id == item.id);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final provider = Provider.of<UserItemsProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.user;
    return Padding(
      padding: EdgeInsets.only(
          left: width * 0.05, right: width * 0.05, top: height * 0.02),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                      create: (_) => UserItemsProvider(currentUser!.id,
                          itemProvider.myCart, itemProvider.myWishList),
                      child: ItemScreen(
                        item: item,
                        userId: currentUser!.id,
                      )))).then((value) {
            if (value != null) {
              //TODO
              provider.updateMyCart("", value[0]);
              provider.updateMyWishlist("", value[1]);
            }
          });
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          elevation: 30.0,
          child: Column(
            children: [
              Container(
                // width: width * 0.5,
                height: height * 0.3,
                margin: EdgeInsets.symmetric(vertical: height * 0.02),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: Image.network(item.image).image)),
              ),
              Divider(
                thickness: 2,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: height * 0.003),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Text(
                          item.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                      child: IconButton(
                          onPressed: () {
                            if (isCart) {
                              provider.removeFromCart(item, currentUser!.id);
                            } else {
                              provider.addToCart(item, currentUser!.id);
                            }
                          },
                          tooltip: !isCart ? "Add To Cart" : "Remove From Cart",
                          icon: Icon(
                            !isCart
                                ? Icons.add_shopping_cart_outlined
                                : Icons.remove_shopping_cart_outlined,
                            size: 30,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                      child: IconButton(
                          onPressed: () {
                            if (isWishlist) {
                              provider.removeFromWishList(
                                  item, currentUser!.id);
                            } else {
                              provider.addToWishList(item, currentUser!.id);
                            }
                          },
                          tooltip: !isWishlist
                              ? "Add To WishList"
                              : "Remove From WishList",
                          icon: Icon(
                            !isWishlist
                                ? Icons.favorite_border
                                : Icons.favorite,
                            size: 30,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
