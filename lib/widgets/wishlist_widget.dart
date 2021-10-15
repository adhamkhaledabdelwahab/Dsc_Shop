import 'package:dsc_shop/models/ItemModel.dart';
import 'package:dsc_shop/providers/user_item_provider.dart';
import 'package:dsc_shop/widgets/shop_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget(
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myItemsProvider = Provider.of<UserItemsProvider>(context);
    final myWishlistItems = myItemsProvider.myWishList;
    return ListView.builder(
      itemCount: myWishlistItems.length,
      itemBuilder: (context, index) {
        ItemModel item = myWishlistItems[index];
        if(index == myWishlistItems.length - 1){
          return Padding(
            padding: EdgeInsets.only(bottom: 80),
            child: ShopItem(item: item,),
          );
        }
        return ShopItem(
          item: item,
        );
      },
    );
  }
}
