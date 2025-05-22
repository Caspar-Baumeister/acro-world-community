import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClassTemplateCard extends StatelessWidget {
  const ClassTemplateCard({
    super.key,
    required this.indexClass,
  });

  final ClassModel indexClass;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: indexClass.urlSlug != null || indexClass.id != null
          ? () {
              Map<String, String> pathParameters = {};
              if (indexClass.urlSlug != null) {
                pathParameters["urlSlug"] = indexClass.urlSlug!;
              }

              context.pushNamed(singleEventWrapperRoute,
                  pathParameters: pathParameters);
            }
          : () => showErrorToast("This class is not available anymore"),
      child: ListTile(
        leading: indexClass.imageUrl != null
            ? SizedBox(
                height: 85.0,
                width: 120.0,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: indexClass.imageUrl!,
                  imageBuilder: (context, imageProvider) => Container(
                    height: 85.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    height: 85.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 85.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                ),
              )
            : null,
        title: Text(indexClass.name ?? ""),
        subtitle: Text(indexClass.locationName ?? ""),
        //     style: const TextStyle(fontWeight: FontWeight.w300)),
      ),
    );
  }
}
