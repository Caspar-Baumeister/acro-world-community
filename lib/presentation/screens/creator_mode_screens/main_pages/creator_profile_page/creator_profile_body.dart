import 'package:acroworld/presentation/components/buttons/floating_button.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/images/custom_avatar_cached_network_image.dart';
import 'package:acroworld/provider/creator_provider.dart';
import 'package:acroworld/provider/user_role_provider.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/all_page_routes.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/profile_page_route.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatorProfileBody extends StatelessWidget {
  const CreatorProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    CreatorProvider creatorProvider = Provider.of<CreatorProvider>(context);
    if (creatorProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        creatorProvider.activeTeacher != null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppPaddings.medium),
                child: FloatingButton(
                  onPressed: () {
                    Navigator.of(context).push(EditCreatorProfilePageRoute());
                  },
                  insideWidget: Row(
                    children: [
                      CustomAvatarCachedNetworkImage(
                          imageUrl:
                              creatorProvider.activeTeacher!.profilImgUrl),
                      const SizedBox(width: AppPaddings.medium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              creatorProvider.activeTeacher!.name.toString(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const Text("View profile"),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded)
                    ],
                  ),
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppPaddings.large),
          child: Center(
            child: StandardButton(
              text: "User Mode",
              onPressed: () {
                final graphQLSingleton = GraphQLClientSingleton();
                graphQLSingleton.updateClient(false);
                Provider.of<UserRoleProvider>(context, listen: false)
                    .setIsCreator(false);
                print("Switch to User Mode");
                // Switch to creator mode
                Navigator.of(context).push(ProfilePageRoute());
              },
              isFilled: true,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: AppPaddings.medium,
          ),
          child: Text("Settings",
              style: Theme.of(context).textTheme.headlineMedium),
        ),
        const SizedBox(height: AppPaddings.small),
        CustomSettingComponent(
          title: "Payment",
          content: creatorProvider.activeTeacher?.stripeId != null
              ? creatorProvider.activeTeacher?.isStripeEnabled == true
                  ? "View Stripe dashboard"
                  : "Continue Stripe setup"
              : "Connect to Stripe",
          onPressed: () async {
            if (creatorProvider.activeTeacher?.stripeId != null &&
                creatorProvider.activeTeacher?.isStripeEnabled != true) {
              // stripe id is set but not enabled
              await creatorProvider.createStripeUser().then((value) {
                if (value != null) {
                  // open stripe dashboard
                  customLaunch(value);
                } else {
                  showErrorToast("Failed to open stripe dashboard");
                }
              });
            } else if (creatorProvider.activeTeacher?.isStripeEnabled == true &&
                creatorProvider.activeTeacher?.stripeId != null) {
              // open stripe dashboard
              await creatorProvider.getStripeLoginLink().then((value) {
                if (value != null) {
                  // open stripe dashboard
                  customLaunch(value);
                } else {
                  // refresh Stripe status
                  // TODO: refresh stripe status
                  // TODO: take the link from before and open it
                  showErrorToast("not implemented yet");
                }
              });
            } else {
              // connect to stripe
              await creatorProvider.createStripeUser().then((value) {
                if (value != null) {
                  // open stripe dashboard
                  customLaunch(value);
                } else {
                  showErrorToast("Failed to open stripe dashboard");
                }
              });
            }
          },
        ),
      ],
    );
  }
}

class CustomSettingComponent extends StatefulWidget {
  const CustomSettingComponent({
    super.key,
    required this.title,
    required this.content,
    required this.onPressed,
  });

  final String title;
  final String content;
  final Function onPressed;

  @override
  State<CustomSettingComponent> createState() => _CustomSettingComponentState();
}

class _CustomSettingComponentState extends State<CustomSettingComponent> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppPaddings.medium, vertical: AppPaddings.small),
      child: GestureDetector(
        onTap: () async {
          setState(() {
            isLoading = true;
          });
          await widget.onPressed();
          setState(() {
            isLoading = false;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(AppPaddings.medium),
          decoration: BoxDecoration(
            color: CustomColors.backgroundColor,
            borderRadius: AppBorders.smallRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.content,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              isLoading
                  ? SizedBox(
                      height: AppDimensions.iconSizeMedium,
                      width: AppDimensions.iconSizeMedium,
                      child: const CircularProgressIndicator())
                  : const Icon(Icons.arrow_forward_ios_rounded)
            ],
          ),
        ),
      ),
    );
  }
}
