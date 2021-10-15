import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_shop/models/ItemModel.dart';
import 'package:dsc_shop/models/UserModel.dart';
import 'package:dsc_shop/services/api_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  showUploaderDialog(BuildContext context, UploadTask task) {
    AlertDialog alert = AlertDialog(
      content: StreamBuilder<TaskSnapshot>(
          stream: task.snapshotEvents,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final progress =
                  snapshot.data!.bytesTransferred / snapshot.data!.totalBytes;
              final percentage = (progress * 100).toStringAsFixed(2);

              // double res = (snapshot.data!.bytesTransferred / 1024.0) / 1000;
              // double res2 = (snapshot.data!.totalBytes / 1024.0) / 1000;

              if (percentage == "100.00") {
                Navigator.pop(context);
              }
              return Row(
                children: [
                  CircularProgressIndicator(),
                  Container(
                    margin: EdgeInsets.only(left: 7),
                    child: Text('$percentage %'),
                    // child: Text('${res.toStringAsFixed(2)}/${res2.toStringAsFixed(2)} MB'),
                  )
                ],
              );
            }
            return Row(
              children: [
                CircularProgressIndicator(),
                Container(
                  margin: EdgeInsets.only(left: 7),
                  child: Text("Uploading..."),
                )
              ],
            );
          }),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<String> uploadFile(
      PickedFile image, String userId, BuildContext context) async {
    String baseName = basename(File(image.path).path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("Profiles/$userId").child(baseName);
    UploadTask uploadTask = ref.putFile(File(image.path));
    String url = "";
    showUploaderDialog(context, uploadTask);
    await uploadTask.then((res) async {
      url = await res.ref.getDownloadURL();
    });
    // Navigator.pop(context);
    return url;
  }

  Future<String?> saveUser(UserModel user) async {
    try {
      await _firestore.collection("Users").doc(user.id).set(user.toJson());
      return "Successfully Added";
    } on FirebaseException catch (e) {
      print("MyFirebaseFirestoreException saveUser: $e");
    }
  }

  Future<String?> updateUserProfileImage(
      PickedFile? file, String userId, BuildContext context,
      [bool remove = false]) async {
    try {
      UserModel user = (await getUser(userId))!;
      if (!remove) {
        if(user.imageUrl.isNotEmpty) {
          FirebaseStorage storage = FirebaseStorage.instance;
          storage.refFromURL(user.imageUrl).delete();
        }
        String url = await uploadFile(file!, userId, context);
        await _firestore
            .collection("Users")
            .doc(userId)
            .update({"imageUrl": url});
        return "Successfully Updated";
      } else {
        FirebaseStorage storage = FirebaseStorage.instance;
        storage.refFromURL(user.imageUrl).delete();
        await _firestore
            .collection("Users")
            .doc(userId)
            .update({"imageUrl": ""});
        return "Successfully Updated";
      }
    } on FirebaseException catch (e) {
      print("MyFirebaseFirestoreException updateUserImage: $e");
    }
  }

  Future<String?> updateUserName(String name, String userId) async {
    try {
      await _firestore.collection("Users").doc(userId).update({"name": name});
      return "Successfully Updated";
    } on FirebaseException catch (e) {
      print("MyFirebaseFirestoreException updateUserName: $e");
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final result = await _firestore.collection("Users").doc(userId).get();
      UserModel user = UserModel.fromJson(result.data()!);
      return user;
    } on FirebaseException catch (e) {
      print("MyFirebaseFirestoreException getUser: $e");
    }
  }

  Future<List<ItemModel>> getMyCart(String userId) async {
    List<ItemModel> items = [];
    try {
      final result = await _firestore.collection("Cart").doc(userId).get();
      if (result.data() != null && result.data()!['myCart'] != null) {
        List<dynamic> myCart = result.data()!['myCart'];
        if (myCart.length > 0) {
          for (var element in myCart) {
            ItemModel item = await APIService().getItem(element.toInt());
            items.add(item);
          }
        }
      }
    } on FirebaseException catch (e) {
      print("MyFirebaseFirestoreException getMyCart: $e");
    }
    return items;
  }

  Future<List<ItemModel>> getMyWishlist(String userId) async {
    List<ItemModel> items = [];
    try {
      final result = await _firestore.collection("Wishlist").doc(userId).get();
      if (result.data() != null && result.data()!['myWishlist'] != null) {
        List<dynamic> myWishlist = result.data()!['myWishlist'];
        if (myWishlist.length > 0) {
          for (var element in myWishlist) {
            ItemModel item = await APIService().getItem(element.toInt());
            items.add(item);
          }
        }
      }
    } on FirebaseException catch (e) {
      print("MyFirebaseFirestoreException getMyWishlist: $e");
    }
    return items;
  }

  Future<String?> addToMyCart(int itemId, String userId) async {
    try {
      final result = await _firestore.collection("Cart").doc(userId).get();
      if (result.data() != null && result.data()!['myCart'] != null) {
        List<dynamic> myCart = result.data()!['myCart'];
        myCart.add(itemId);
        await _firestore
            .collection("Cart")
            .doc(userId)
            .update({"myCart": myCart});
        return "Successfully Added";
      } else {
        await _firestore.collection("Cart").doc(userId).set({
          "myCart": [itemId]
        });
        return "Successfully Added";
      }
    } on FirebaseException catch (e) {
      print("MyFirebaseFirestoreException addToMyCart: $e");
    }
  }

  Future<String?> addToMyWishlist(int itemId, String userId) async {
    try {
      final result = await _firestore.collection("Wishlist").doc(userId).get();
      if (result.data() != null && result.data()!['myWishlist'] != null) {
        List<dynamic> myWishlist = result.data()!['myWishlist'];
        if (!myWishlist.contains(itemId)) {
          myWishlist.add(itemId);
          await _firestore
              .collection("Wishlist")
              .doc(userId)
              .update({"myWishlist": myWishlist});
          return "Successfully Added";
        }
      } else {
        await _firestore.collection("Wishlist").doc(userId).set({
          "myWishlist": [itemId]
        });
        return "Successfully Added";
      }
    } on FirebaseException catch (e) {
      print("MyFirebaseFirestoreException addToMyCart: $e");
    }
  }

  Future<String?> removeFromMyCart(int itemId, String userId) async {
    try {
      final result = await _firestore.collection("Cart").doc(userId).get();
      if (result.data() != null && result.data()!['myCart'] != null) {
        List<dynamic> myCart = result.data()!['myCart'];
        myCart.removeWhere((element) => element.toInt() == itemId);
        await _firestore
            .collection("Cart")
            .doc(userId)
            .update({"myCart": myCart});
        return "Successfully Removed";
      }
    } on FirebaseException catch (e) {
      print("MyFirebaseFirestoreException addToMyCart: $e");
    }
  }

  Future<String?> removeFromMyWishlist(int itemId, String userId) async {
    try {
      final result = await _firestore.collection("Wishlist").doc(userId).get();
      if (result.data() != null && result.data()!['myWishlist'] != null) {
        List<dynamic> myWishlist = result.data()!['myWishlist'];
        myWishlist.removeWhere((element) => element.toInt() == itemId);
        await _firestore
            .collection("Wishlist")
            .doc(userId)
            .update({"myWishlist": myWishlist});
        return "Successfully Removed";
      }
    } on FirebaseException catch (e) {
      print("MyFirebaseFirestoreException addToMyCart: $e");
    }
  }
}
