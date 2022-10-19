import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/screens/home/map/map.dart';
import 'package:acroworld/screens/single_class_page/widgets/class_event_calendar.dart';
import 'package:acroworld/screens/single_class_page/widgets/link_button.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:acroworld/shared/helper_functions.dart';
import 'package:acroworld/shared/widgets/open_google_maps.dart';
import 'package:acroworld/widgets/spaced_column/spaced_column.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SingleClassBody extends StatelessWidget {
  const SingleClassBody(
      {Key? key, required this.classEvents, required this.classe})
      : super(key: key);

  final List<ClassEvent> classEvents;
  final ClassModel classe;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        classe.imageUrl != null
            ? SizedBox(
                height: 200.0,
                width: double.infinity,
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    height: 52.0,
                    placeholder: (context, url) => Container(
                      color: Colors.black12,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.black12,
                      child: const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                    imageUrl: classe.imageUrl!,
                  ),
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SpacedColumn(
            space: 10,
            children: [
              const SizedBox(height: 20),
              ReadMoreText(
                classe.description,
                trimLines: 2,
                colorClickableText: Colors.blue,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle: const TextStyle(color: PRIMARY_COLOR),
                lessStyle: const TextStyle(color: PRIMARY_COLOR),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  classe.requirements != null
                      ? Container(
                          constraints: const BoxConstraints(maxWidth: 180),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Requirements",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(classe.requirements!)
                            ],
                          ),
                        )
                      : Container(),
                  classe.pricing != null
                      ? Container(
                          constraints: const BoxConstraints(maxWidth: 150),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Prices",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                classe.pricing!,
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        )
                      : Container()
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  classe.uscUrl != null
                      ? LinkButton(text: "Urban Sport", link: classe.uscUrl!)
                      : Container(),
                  classe.classPassUrl != null
                      ? LinkButton(
                          text: "Class Pass", link: classe.classPassUrl!)
                      : Container(),
                  classe.websiteUrl != null
                      ? LinkButton(text: "Website", link: classe.websiteUrl!)
                      : Container(),
                ],
              ),
              const Divider(),
              classe.latitude != null && classe.longitude != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Avenue",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            OpenGoogleMaps(
                              latitude: classe.latitude!,
                              longitude: classe.longitude!,
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          constraints: const BoxConstraints(maxHeight: 150),
                          child: MapWidget(
                            zoom: 15.0,
                            center: LatLng(classe.latitude!, classe.longitude!),
                            markerLocation:
                                LatLng(classe.latitude!, classe.longitude!),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              classe.latitude != null && classe.longitude != null
                  ? const Divider()
                  : Container(),
              SizedBox(
                child:
                    ClassEventCalendar(kEvents: classEventToHash(classEvents)),
              ),
              const SizedBox(height: 40)
            ],
          ),
        ),
      ],
    ));
  }
}
