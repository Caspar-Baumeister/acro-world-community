import 'package:acroworld/presentation/components/buttons/floating_button.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/images/custom_avatar_cached_network_image.dart';
import 'package:acroworld/provider/creator_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatorProfileBody extends StatelessWidget {
  const CreatorProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    CreatorProvider creatorProvider = Provider.of<CreatorProvider>(context);
    print("image: ${creatorProvider.activeTeacher}");
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
                  onPressed: () {},
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
              onPressed: () {},
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
          content: creatorProvider.activeTeacher?.isStripeEnabled ?? false
              ? "View Stripe dashboard"
              : "Connect to Stripe",
          onPressed: () {},
        ),
      ],
    );
  }
}

class CustomSettingComponent extends StatelessWidget {
  const CustomSettingComponent({
    super.key,
    required this.title,
    required this.content,
    required this.onPressed,
  });

  final String title;
  final String content;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppPaddings.medium, vertical: AppPaddings.small),
      child: GestureDetector(
        onTap: onPressed,
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
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      content,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded)
            ],
          ),
        ),
      ),
    );
  }
}
