import 'package:dsc_shop/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    bool isAR = languageProvider.myLanguage == Locale("ar");
    return Scaffold(
      appBar: AppBar(
        title: Text("About DSC Shop"),
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/logo.png"))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              isAR ? "متجر DSC" : "DSC Shop :",
              textDirection: isAR ? TextDirection.rtl : TextDirection.ltr,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: Text(
              isAR
                  ? "متجر Dsc هو تطبيق لعرض مجموعة من"
                      " عناصر مختلفة حيث يكون لكل عنصر عنوانه الخاص"
                      " المعرف والفئة والوصف ويمكن للمستخدم إضافة أي عنصر"
                      " في قائمة أمنياته كمفضل له أو في عربته"
                      " للشراء في المستقبل أو في كليهما ، إلى جانب يمكن للمستخدم تحديث اسمه"
                      " وصورته الشخصية ، التبديل بين الوضعين الفاتح والداكن و"
                      " التبديل بين اللغتين العربية والإنجليزية."
                      "\n تم إنشاء متجر DSC بواسطة ادهم خالد عبدالوهاب 8/2021 تحت"
                      " إشراف مجموعة DSC الأزهر"
                  : "Dsc Shop is an application for displaying a group for "
                      "different items where each item has its own title, "
                      "id, category and description and user can add any item "
                      "into his wishlist as his favourite or into his cart for "
                      "future buying or into both, beside user can update his name "
                      "and his profile picture, toggle between light and dark modes and "
                      "toggle between two languages arabic and english."
                      "\nDSC Shop has been created by Adham Khaled Abdel Wahab 8/2021 under "
                      "supervision of DSC Al-Azhar Group",
              textDirection: isAR ? TextDirection.rtl : TextDirection.ltr,
              style: TextStyle(
                height: 1.5,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
