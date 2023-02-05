import 'package:acroworld/components/loading_indicator/loading_indicator.dart';
import 'package:acroworld/components/standart_button.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/gender_model.dart';
import 'package:acroworld/screens/authentication_screens/choose_gender_screen/choose_gender_body.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class YourGenderButtonWidget extends StatelessWidget {
  const YourGenderButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Query if user has a gender

    // if he does -> show gender
    // if not show button to where you can choose (maybe modal or page with back button)
    return Query(
      options: QueryOptions(
        document: Queries.meGender,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
      builder: (QueryResult meGenderResult,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (meGenderResult.hasException || !meGenderResult.isConcrete) {
          print("error in meGender query");
          print(meGenderResult.exception);
          return Container();
        } else if (meGenderResult.isLoading) {
          return const LoadingIndicator();
        } else {
          GenderModel gender = GenderModel.fromJson(
              meGenderResult.data!["me"]?[0]?['acro_role']);

          if (gender.id == null || gender.name == null) {
            return StandartButton(
                text: "Choose a role",
                onPressed: () => buildMortal(
                    context,
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: ChooseGenderBody(
                          onContinue: () => Navigator.of(context).pop()),
                    )));
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text(
                    "Role:",
                    style: STANDART_DESCRIPTION,
                  ),
                  const SizedBox(width: 5),
                  Text(gender.name!, style: SUB_TITLE)
                ],
              ),
              const SizedBox(height: 10),
              StandartButton(
                  text: "Change role",
                  onPressed: () => buildMortal(
                      context,
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.85,
                        child: ChooseGenderBody(
                            genderId: gender.id,
                            onContinue: () {
                              refetch!();
                              Navigator.of(context).pop();
                            }),
                      )))
            ],
          );
        }
      },
    );
  }
}
