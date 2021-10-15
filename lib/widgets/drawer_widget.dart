import 'package:dsc_shop/models/UserModel.dart';
import 'package:dsc_shop/providers/language_provider.dart';
import 'package:dsc_shop/providers/theme_provider.dart';
import 'package:dsc_shop/providers/user_provider.dart';
import 'package:dsc_shop/screens/about_screen.dart';
import 'package:dsc_shop/screens/login_screen.dart';
import 'package:dsc_shop/screens/profile_screen.dart';
import 'package:dsc_shop/services/authentication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key, required this.currentUser}) : super(key: key);

  final UserModel? currentUser;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    bool isDark = themeProvider.myMode == ThemeMode.dark;
    bool isAR = languageProvider.myLanguage == Locale("ar");
    return SafeArea(
      child: Container(
        width: width * 0.55,
        padding: EdgeInsets.symmetric(
            vertical: height * 0.010, horizontal: width * 0.019),
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              child: DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                          currentUser == null || currentUser!.imageUrl.isEmpty
                              ? AssetImage("assets/profile.jpg")
                              : Image.network(currentUser!.imageUrl).image,
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Text(
                      currentUser == null ? "User Name" : currentUser!.name,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Text(
                      currentUser == null ? "User Email" : currentUser!.email,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider(
                                  create: (_) =>
                                      UserProvider(currentUser!.id, currentUser),
                                  child: ProfileScreen()))).then((value) {
                        Provider.of<UserProvider>(context, listen: false)
                            .updateUser(currentUser!.id);
                      });
                    },
                    leading: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    title: Text(
                      languageProvider.myLanguage.toLanguageTag() == "en"
                          ? "Profile"
                          : "الصفحة الشخصية",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Row(
                    children: [
                      Switch(
                        value: isDark,
                        onChanged: (value) {
                          Provider.of<ThemeProvider>(context, listen: false)
                              .updateThemeMode();
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: width * 0.03),
                          child: Text(
                            languageProvider.myLanguage.toLanguageTag() == "en"
                                ? "Dark Mode"
                                : "الوضع المظلم",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(
                      Icons.language,
                      color: Colors.white,
                    ),
                    title: Text(
                      languageProvider.myLanguage.toLanguageTag() == "en"
                          ? "Language"
                          : "اللغه",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: width * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            if (!isAR) {
                              Provider.of<LanguageProvider>(context,
                                      listen: false)
                                  .updateLanguage();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: isAR ? Colors.blue : Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            width: width * 0.1,
                            height: width * 0.1,
                            child: Center(
                                child: Text(
                              "AR",
                              style: TextStyle(
                                  color: isAR ? Colors.white : Colors.red,
                                  fontWeight: FontWeight.w500),
                            )),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (isAR) {
                              Provider.of<LanguageProvider>(context,
                                      listen: false)
                                  .updateLanguage();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: isAR ? Colors.white : Colors.blue,
                                borderRadius: BorderRadius.circular(5)),
                            width: width * 0.1,
                            height: width * 0.1,
                            child: Center(
                                child: Text(
                              "EN",
                              style: TextStyle(
                                  color: isAR ? Colors.red : Colors.white,
                                  fontWeight: FontWeight.w500),
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => AboutScreen()));
                    },
                    leading: Icon(
                      Icons.description,
                      color: Colors.white,
                    ),
                    title: Text(
                      languageProvider.myLanguage.toLanguageTag() == "en"
                          ? "About"
                          : "حول التطبيق",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      AuthenticationService().signOut().then((value) {
                        print(value);
                        if(isDark){
                          Provider.of<ThemeProvider>(context, listen: false).updateThemeMode();
                        }
                        if(isAR){
                          Provider.of<LanguageProvider>(context, listen: false).updateLanguage();
                        }
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => LoginScreen()));
                      });
                    },
                    leading: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    title: Text(
                      languageProvider.myLanguage.toLanguageTag() == "en"
                          ? "Logout"
                          : "تسجيل الخروج",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
