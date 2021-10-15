import 'package:dsc_shop/models/ItemModel.dart';
import 'package:dsc_shop/services/api_service.dart';
import 'package:flutter/material.dart';

class ItemProvider extends ChangeNotifier{
  List<ItemModel> items = [];

  ItemProvider(){
    APIService().getItems().then((value) {
      items = value;
      notifyListeners();
    });
  }
}