import 'package:dsc_shop/models/ItemModel.dart';
import 'package:dsc_shop/providers/user_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({Key? key, required this.item, required this.userId})
      : super(key: key);

  final ItemModel item;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<UserItemsProvider>(context);
    final cart = itemProvider.myCart;
    final wishList = itemProvider.myWishList;
    final isCart = cart.any((element) => element.id == item.id);
    final isWishlist = wishList.any((element) => element.id == item.id);
    final provider = Provider.of<UserItemsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, [cart, wishList]);
          },
        ),
        title: Text(
          item.title,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(image: Image.network(item.image).image)),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (isWishlist) {
                        provider.removeFromWishList(item, userId);
                      } else {
                        provider.addToWishList(item, userId);
                      }
                    },
                    child: Row(
                      children: [
                        Icon(isWishlist
                            ? Icons.favorite
                            : Icons.favorite_border),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              isWishlist
                                  ? "Remove From WishList"
                                  : "Add To WishList",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (isCart) {
                        provider.removeFromCart(item, userId);
                      } else {
                        provider.addToCart(item, userId);
                      }
                    },
                    child: Row(
                      children: [
                        Icon(isCart
                            ? Icons.remove_shopping_cart_outlined
                            : Icons.add_shopping_cart),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              isCart ? "Remove From Cart" : "Add To Cart",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Expanded(
          //   child: FlatButton.icon(
          //       onPressed: () {
          //         if (isWishlist) {
          //           provider.removeFromWishList(item, userId);
          //         } else {
          //           provider.addToWishList(item, userId);
          //         }
          //       },
          //       icon: Icon(
          //           isWishlist ? Icons.favorite : Icons.favorite_border),
          //       label: Text(isWishlist
          //           ? "Remove From WishList"
          //           : "Add To WishList",)),
          // ),
          // Expanded(
          //   child: FlatButton.icon(
          //       onPressed: () {
          //         if (isCart) {
          //           provider.removeFromCart(item, userId);
          //         } else {
          //           provider.addToCart(item, userId);
          //         }
          //       },
          //       icon: Icon(isCart
          //           ? Icons.remove_shopping_cart_outlined
          //           : Icons.add_shopping_cart),
          //       label: Text(isCart ? "Remove From Cart" : "Add To Cart")),
          // ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 20, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: "Title: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: item.title, style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 20, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: "Category: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: item.category, style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 20, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: "Description: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: item.description, style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
