import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/all_page_routes.dart';
import 'package:acroworld/screens/modals/base_modal.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CreateCreatorProfileModal extends StatefulWidget {
  const CreateCreatorProfileModal({super.key});

  @override
  State<CreateCreatorProfileModal> createState() =>
      _CreateCreatorProfileModalState();
}

class _CreateCreatorProfileModalState extends State<CreateCreatorProfileModal> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BaseModal(
      title: "Create Partner Account",
      noPadding: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPaddings.medium),
            child: Text(
              'To create events, you first need to create a creator account.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: CustomColors.secondaryTextColor),
            ),
          ),
          const SizedBox(height: AppPaddings.medium),
          StandardButton(
            text: "Continue",
            onPressed: onPressed,
            loading: isLoading,
          ),
        ],
      ),
    );
  }

  void onPressed() async {
    // set loading to true
    setState(() {
      isLoading = true;
    });

    // create instance of gql client
    final client = GraphQLClientSingleton().client;

    // create mutation to sign up as teacher
    const mutation = '''
      mutation signUpAsTeacher {
        signup_as_teacher {
          success
        }
      }
    ''';

    // call the mutation
    await client.mutate(MutationOptions(
      document: gql(mutation),
      onCompleted: (data) => onSuccess(data),
      onError: (error) => onError(error),
    ));

    // set loading to false
    setState(() {
      isLoading = false;
    });
  }

  onSuccess(Map<String, dynamic>? data) async {
    print("data: $data");
    if (data?["signup_as_teacher"]?["success"] == true) {
      // reset token from refresh token
      await TokenSingletonService().refreshToken();
      // close the modal
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
        Navigator.of(context).push(CreateCreatorProfilePageRoute());
      });
    } else {
      // Send error
      CustomErrorHandler.captureException(data.toString(),
          stackTrace: StackTrace.current);
      // show error message
      showErrorToast(
          "An error occurred. Please try again later or contact the support.");
    }
  }

  onError(OperationException? error) {
    // Send error
    CustomErrorHandler.captureException(error?.graphqlErrors.toString(),
        stackTrace: StackTrace.current);
    showErrorToast(
        "An error occurred. Please try again later or contact the support.");
  }
}
