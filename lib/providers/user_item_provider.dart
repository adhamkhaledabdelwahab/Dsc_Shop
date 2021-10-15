import 'package:dsc_shop/models/ItemModel.dart';
import 'package:dsc_shop/services/database_service.dart';
import 'package:flutter/material.dart';

class UserItemsProvider extends ChangeNotifier {
  List<ItemModel> myCart = [];
  List<ItemModel> myWishList = [];
  final _databaseService = DatabaseServices();

  UserItemsProvider(String userId, [List<ItemModel>? newCartList, List<ItemModel>? newWishList]) {
    updateMyCart(userId, newCartList);
    updateMyWishlist(userId, newWishList);
  }

  void updateMyCart(String userId, [List<ItemModel>? newList]) {
    if(newList != null){
      myCart = newList;
      notifyListeners();
    }else {
      _databaseService.getMyCart(userId).then((value) {
        myCart = value;
        notifyListeners();
      });
    }
  }

  void updateMyWishlist(String userId, [List<ItemModel>? newList]) {
    if(newList != null){
      myWishList = newList;
      notifyListeners();
    }else {
      _databaseService.getMyWishlist(userId).then((value) {
        myWishList = value;
        notifyListeners();
      });
    }
  }

  void addToCart(ItemModel item, String userId) {
    myCart.add(item);
    notifyListeners();
    _databaseService.addToMyCart(item.id, userId).then((value) {
      print(value);
      if (value == null) {
        myCart.removeWhere((element) => element.id == item.id);
        notifyListeners();
      }
    });
  }

  void addToWishList(ItemModel item, String userId) {
    myWishList.add(item);
    notifyListeners();
    _databaseService.addToMyWishlist(item.id, userId).then((value) {
      print(value);
      if (value == null) {
        myWishList.removeWhere((element) => element.id == item.id);
        notifyListeners();
      }
    });
  }

  void removeFromCart(ItemModel item, String userId) {
    myCart.removeWhere((element) => element.id == item.id);
    notifyListeners();
    _databaseService.removeFromMyCart(item.id, userId).then((value) {
      print(value);
      if(value == null){
        myCart.add(item);
        notifyListeners();
      }
    });
  }

  void removeFromWishList(ItemModel item, String userId) {
    myWishList.removeWhere((element) => element.id == item.id);
    notifyListeners();
    _databaseService.removeFromMyWishlist(item.id, userId).then((value) {
      print(value);
      if(value == null){
        myWishList.add(item);
        notifyListeners();
      }
    });
  }
}
