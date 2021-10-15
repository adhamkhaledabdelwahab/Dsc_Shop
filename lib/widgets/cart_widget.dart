import 'package:dsc_shop/models/ItemModel.dart';
import 'package:dsc_shop/providers/user_item_provider.dart';
import 'package:dsc_shop/widgets/shop_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatelessWidget {
  const CartWidget(
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myItemsProvider = Provider.of<UserItemsProvider>(context);
    final myCartItems = myItemsProvider.myCart;
    return ListView.builder(
      itemCount: myCartItems.length,
      itemBuilder: (context, index) {
        ItemModel item = myCartItems[index];
        if(index == myCartItems.length - 1){
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
