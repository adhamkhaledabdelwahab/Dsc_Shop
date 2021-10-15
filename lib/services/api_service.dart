import 'dart:convert';

import 'package:dsc_shop/models/ItemModel.dart';
import 'package:http/http.dart' as http;

class APIService {
  final _allItems = "https://fakestoreapi.com/products/";
  final _allCategories = "https://fakestoreapi.com/products/categories";
  final _item = "https://fakestoreapi.com/products/";

  Future<List<ItemModel>> getItems() async {
    List<ItemModel> items = [];
    final response = await http.get(Uri.parse(_allItems));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      data.forEach((element) {
        items.add(ItemModel.fromJson(element));
      });
    } else {
      print("Failed to load Data");
    }

    return items;
  }

  Future<ItemModel> getItem(int id) async {
    late ItemModel item;
    final response = await http.get(Uri.parse("$_item$id"));

    if (response.statusCode == 200) {
      Map<dynamic, dynamic> data = json.decode(response.body);
      item = ItemModel.fromJson(data);
    } else {
      print("Failed to load Data");
    }

    return item;
  }

  Future<List<String>> getCategories() async {
    List<String> items = [];
    final response = await http.get(Uri.parse(_allCategories));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      data.forEach((element) {
        items.add(element);
      });
    } else {
      print("Failed to load Data");
    }

    return items;
  }
}
