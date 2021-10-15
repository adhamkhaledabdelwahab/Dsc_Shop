class ItemModel {
  final int id;
  final String title;
  final num price;
  final String description;
  final String category;
  final String image;

  ItemModel(
      {required this.id,
      required this.title,
      required this.price,
      required this.description,
      required this.category,
      required this.image});

  ItemModel.fromJson(Map<dynamic, dynamic> json) :
      id = json["id"],
      title = json["title"],
      price = json["price"],
      description = json["description"],
      category = json["category"],
      image = json["image"];
}
