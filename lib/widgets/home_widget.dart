import 'package:dsc_shop/models/ItemModel.dart';
import 'package:dsc_shop/providers/item_provider.dart';
import 'package:dsc_shop/widgets/shop_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget(
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final shopItems = itemProvider.items;
    return ListView.builder(
      itemCount: shopItems.length,
      itemBuilder: (context, index) {
        ItemModel item = shopItems[index];
        if(index == shopItems.length - 1){
          return Padding(
            padding: EdgeInsets.only(bottom: 80),
            child: ShopItem(item: item,),
          );
        }
        return ShopItem(item: item,);
      },
    );
  }
}
