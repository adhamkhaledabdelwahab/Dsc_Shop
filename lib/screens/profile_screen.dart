import 'package:dsc_shop/models/UserModel.dart';
import 'package:dsc_shop/providers/theme_provider.dart';
import 'package:dsc_shop/providers/user_provider.dart';
import 'package:dsc_shop/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void takePhoto(
      ImageSource source, UserModel userUpdated, BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.getImage(
      source: source,
    );
    if (pickedFile != null) {
      updateUserProfileImage(pickedFile, userUpdated.id, context);
    }
  }

  void updateUserProfileImage(
      PickedFile? image, String userId, BuildContext context,
      [bool remove = false]) {
    DatabaseServices()
        .updateUserProfileImage(image, userId, context, remove)
        .then((value) {
      print(value);
      Provider.of<UserProvider>(context, listen: false).updateUser(userId);
    });
  }

  void updateUserName(String name, String userId, BuildContext context) {
    DatabaseServices().updateUserName(name, userId).then((value) {
      print(value);
      Provider.of<UserProvider>(context, listen: false).updateUser(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.user;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 40),
            child: Center(
              child: imageProfile(context, currentUser),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              "Username",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'sans-serif'),
            ),
            subtitle: Text(
              currentUser != null ? currentUser.name : "User Name",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'sans-serif'),
            ),
            trailing: Icon(Icons.edit),
            onTap: () {
              if (currentUser != null) {
                showUsernameBottomSheet(context, currentUser);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(
              "Email",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                  fontFamily: 'sans-serif'),
            ),
            subtitle: Text(
              currentUser != null ? currentUser.email : "example@example.com",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'sans-serif'),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageProfile(BuildContext mContext, UserModel? userUpdated) {
    final width = MediaQuery.of(mContext).size.width;
    final height = MediaQuery.of(mContext).size.height;
    final theme = Provider.of<ThemeProvider>(mContext);
    final isDark = theme.myMode == ThemeMode.dark;
    return Stack(
      children: [
        CircleAvatar(
          // radius: width * 0.27,
          radius: 90,
          backgroundImage: userUpdated == null || userUpdated.imageUrl.isEmpty
              ? AssetImage("assets/profile.jpg")
              : Image.network(userUpdated.imageUrl).image,
        ),
        Positioned(
            bottom: 0,
            left: 5,
            child: InkWell(
              onTap: () {
                if (userUpdated != null) {
                  showModalBottomSheet(
                    backgroundColor: isDark ? Colors.black : Colors.white,
                    context: mContext,
                    builder: ((builder) =>
                        bottomSheet(mContext, height, userUpdated, isDark)),
                  );
                }
              },
              child: Stack(children: [
                Icon(
                  Icons.circle,
                  size: 50.0,
                  color: Colors.teal.shade400,
                ),
                Positioned(
                  top: 15,
                  left: 12,
                  child: Icon(
                    Icons.camera_alt,
                    size: 23.0,
                    color: Colors.white,
                  ),
                ),
              ]),
            )),
      ],
    );
  }

  Widget bottomSheet(
      BuildContext context, double height, UserModel userUpdated, bool isDark) {
    return Container(
      // height: height * 0.12,
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: isDark ? Colors.black : Colors.white,
      child: Column(
        children: [
          Text(
            "Choose profile photo",
            style: TextStyle(
                fontSize: 20.0, color: isDark ? Colors.white : Colors.black),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            direction: Axis.horizontal,
            children: [
              FlatButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.camera, userUpdated, context);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.camera,
                      color: isDark ? Colors.white : Colors.black),
                  label: Text(
                    "Camera",
                    style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white : Colors.black),
                  )),
              FlatButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery, userUpdated, context);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.image,
                    color: isDark ? Colors.white : Colors.black),
                label: Text("Gallery",
                    style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white : Colors.black)),
              ),
              FlatButton.icon(
                onPressed: () {
                  updateUserProfileImage(null, userUpdated.id, context, true);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.delete,
                    color: isDark ? Colors.white : Colors.black),
                label: Text("Remove",
                    style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white : Colors.black)),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> showUsernameBottomSheet(
      BuildContext mContext, UserModel userModel) {
    final theme = Provider.of<ThemeProvider>(mContext, listen: false);
    final isDark = theme.myMode == ThemeMode.dark;
    final width = MediaQuery.of(mContext).size.width;
    final height = MediaQuery.of(mContext).size.height;
    return showModalBottomSheet<void>(
      context: mContext,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: isDark ? Colors.black : Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      )),
      builder: (BuildContext context) {
        TextEditingController _userName = TextEditingController();
        _userName.text = userModel.name;
        FocusNode node = FocusNode();
        node.requestFocus();
        GlobalKey<FormState> myKey = GlobalKey<FormState>();
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.05, horizontal: width * 0.05),
            child: Form(
              key: myKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                    child: TextFormField(
                      focusNode: node,
                      validator: (val) {
                        if (val!.isEmpty)
                          return "Invalid User Name, Username cannot be empty!!!";
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          prefixIcon: Icon(Icons.person_pin),
                          labelText: 'Username'),
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'sans-serif-condensed',
                          color: isDark ? Colors.white : Colors.black),
                      keyboardType: TextInputType.name,
                      controller: _userName,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.blue.shade200,
                          minimumSize: Size(88, 36),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                        onPressed: () {
                          if (myKey.currentState!.validate()) {
                            updateUserName(
                                _userName.text.trim(), userModel.id, mContext);
                            Navigator.pop(context);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                              vertical: height * 0.01),
                          child: Text(
                            "Edit",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.blue.shade200,
                          minimumSize: Size(88, 36),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                              vertical: height * 0.01),
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
