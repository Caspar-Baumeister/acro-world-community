import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EssentialsPage extends StatelessWidget {
  const EssentialsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: false,
        titleSpacing: 20.0,
        title: const Text('Essentials'),
      ),
      body: const SafeArea(
          child: SingleChildScrollView(
              child: Column(
        children: [
          EssentialsCard(
            title: "Acronyc",
            description:
                "Our recommended book for acroyogies who want to dive deep into the technique and beauty of acroyoga. Click here to order it online and get a discount trough our code.",
            code: "ACROWORLD",
            imgUrl: "assets/acronyc.png",
            link: "https://acronyc.de/warenkorb/",
          ),
          EssentialsCard(
              imgUrl: "assets/online_Kurs_Webseite_3.png",
              title: "Online Kurs für Einsteiger",
              description:
                  "GERMAN! Der Acro Yoga Online Kurs für Einsteiger ist darauf ausgelegt, dir die Grundlagen des AcroYoga mit wirklich ALLEN Details beizubringen. Der perfekte Start, um Schritt für Schritt in deinem eigenen Tempo den Einstieg ins AcroYoga zu finden!",
              code: "ACROWORLD10",
              link:
                  "https://elopage.com/s/feeltheflow/acroyoga-online-kurs-fuer-einsteiger")
        ],
      ))),
    );
  }
}

class EssentialsCard extends StatelessWidget {
  const EssentialsCard(
      {Key? key,
      required this.imgUrl,
      required this.title,
      required this.description,
      required this.code,
      required this.link})
      : super(key: key);

  final String imgUrl;
  final String title;
  final String description;
  final String code;
  final String link;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        Clipboard.setData(ClipboardData(text: code));
        Fluttertoast.showToast(
            msg: "Code copied! You will be redirected to the website",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        await Future.delayed(const Duration(seconds: 4));
        customLaunch(link);
      },
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
        ),
        height: CLASS_CARD_HEIGHT * 1.5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Card Image

            SizedBox(
              height: CLASS_CARD_HEIGHT * 1.0,
              width: screenWidth * 0.3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  imgUrl,
                  width: screenWidth * 0.3,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 8, left: 8, right: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // item name
                    Text(title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: H16W7),
                    // item description
                    Text(description,
                        maxLines: 8,
                        overflow: TextOverflow.ellipsis,
                        style: H12W4),
                    // item rabat code
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Code: ",
                          style: H14W4,
                        ),
                        Text(code,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: H14W4.copyWith(color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
