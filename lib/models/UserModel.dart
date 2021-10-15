class UserModel {
  final String id;
  final String name;
  final String email;
  final String imageUrl;

  UserModel({required this.id, required this.name, required this.email, required this.imageUrl});

  UserModel.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        imageUrl = json['imageUrl'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'imageUrl': imageUrl,
  };
}
