import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

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
