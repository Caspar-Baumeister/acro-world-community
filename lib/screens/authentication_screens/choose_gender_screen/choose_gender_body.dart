import 'package:acroworld/components/standart_button.dart';
import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class ChooseGenderBody extends StatefulWidget {
  const ChooseGenderBody({Key? key, required this.onContinue, this.genderId})
      : super(key: key);

  final Function onContinue;
  final String? genderId;

  @override
  State<ChooseGenderBody> createState() => _ChooseGenderBodyState();
}

class _ChooseGenderBodyState extends State<ChooseGenderBody> {
  @override
  void initState() {
    gender = widget.genderId;
    super.initState();
  }

  String? gender; // 0, 1, 2...
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return SafeArea(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Which applies more to you?",
                textAlign: TextAlign.center,
                style: MAIN_TITLE,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "We use this information to indicate a distribution of the participants for classes and jams.",
                textAlign: TextAlign.center,
                style: STANDART_DESCRIPTION,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() {
                        gender = "83a6536f-53ba-44d2-80d9-9842375ebe8b";
                      }),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          height: 200.0 +
                              (gender == "83a6536f-53ba-44d2-80d9-9842375ebe8b"
                                  ? 20
                                  : 0),
                          width: STANDART_BUTTON_WIDTH +
                              (gender == "83a6536f-53ba-44d2-80d9-9842375ebe8b"
                                  ? 40
                                  : 0),
                          child:
                              gender == "83a6536f-53ba-44d2-80d9-9842375ebe8b"
                                  ? Image.asset(
                                      "assets/flyer.jpg",
                                      fit: BoxFit.cover,
                                    )
                                  : ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.7),
                                          BlendMode.color),
                                      child: Image.asset(
                                        "assets/flyer.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 10,
                      right: 20,
                      child: Text(
                        "Flyer",
                        style: MAIN_TITLE,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() {
                        gender = "dc321f52-fce9-4b00-bef6-e59fb05f4624";
                      }),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          height: 200.0 +
                              (gender == "dc321f52-fce9-4b00-bef6-e59fb05f4624"
                                  ? 20
                                  : 0),
                          width: STANDART_BUTTON_WIDTH +
                              (gender == "dc321f52-fce9-4b00-bef6-e59fb05f4624"
                                  ? 40
                                  : 0),
                          child:
                              gender == "dc321f52-fce9-4b00-bef6-e59fb05f4624"
                                  ? Image.asset(
                                      "assets/base.jpg",
                                      fit: BoxFit.cover,
                                    )
                                  : ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.9),
                                          BlendMode.color),
                                      child: Image.asset(
                                        "assets/base.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                        ),
                      ),
                    ),
                    const Positioned(
                        top: 10,
                        left: 20,
                        child: Text(
                          "Base",
                          style: MAIN_TITLE,
                        ))
                  ],
                ),
              ],
            )),
            const SizedBox(height: 10),
            Mutation(
                options: MutationOptions(
                  document: Mutations.setGender,
                  onError: (error) {
                    print("error in setGender");
                    print(error);
                  },
                  onCompleted: (dynamic resultData) {
                    setState(() {
                      loading = false;
                    });
                    print("resultData");
                    print(resultData);
                    widget.onContinue();
                  },
                ),
                builder: (runMutation, result) {
                  return StandartButton(
                      text: "Confirm",
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                        print("set gender inputs");
                        print(userProvider.activeUser!.id!);
                        print(gender);
                        runMutation({
                          'user_id': userProvider.activeUser!.id!,
                          'gender_id': gender
                        });
                      },
                      isFilled: true,
                      disabled: gender == null,
                      loading: loading);
                }),
            const SizedBox(height: 20),
            StandartButton(
              text: "Skip",
              onPressed: () => widget.onContinue(),
              disabled: loading,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
