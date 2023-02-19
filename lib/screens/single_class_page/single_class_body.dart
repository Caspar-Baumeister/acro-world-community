import 'package:acroworld/components/open_google_maps.dart';
import 'package:acroworld/components/show_more_text.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/components/map.dart';
import 'package:acroworld/screens/single_class_page/widgets/class_event_calendar.dart';
import 'package:acroworld/screens/single_class_page/widgets/link_button.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              DescriptionTextWidget(text: classe.description),
              const SizedBox(height: 10),
              classe.requirements != null && classe.requirements != ""
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Requirements",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            classe.requirements!,
                            textAlign: TextAlign.start,
                          )
                        ],
                      ),
                    )
                  : Container(),
              classe.pricing != null && classe.pricing != ""
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Prices",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            classe.pricing!,
                            textAlign: TextAlign.start,
                          )
                        ],
                      ),
                    )
                  : Container(),
              (classe.uscUrl != null && classe.uscUrl != "") ||
                      (classe.classPassUrl != null &&
                          classe.classPassUrl != "") ||
                      (classe.websiteUrl != null && classe.websiteUrl != "")
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Links",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Container(),
              Container(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      classe.uscUrl != null && classe.uscUrl != ""
                          ? LinkButton(
                              text: "Urban Sport", link: classe.uscUrl!)
                          : Container(),
                      classe.classPassUrl != null && classe.classPassUrl != ""
                          ? LinkButton(
                              text: "Class Pass", link: classe.classPassUrl!)
                          : Container(),
                      classe.websiteUrl != null && classe.websiteUrl != ""
                          ? LinkButton(
                              text: "Website", link: classe.websiteUrl!)
                          : Container(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Divider(),
              const SizedBox(height: 6),
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
                              latitude: classe.latitude! * 1.0,
                              longitude: classe.longitude! * 1.0,
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
                            center: LatLng(classe.latitude! * 1.0,
                                classe.longitude! * 1.0),
                            markerLocation: LatLng(classe.latitude! * 1.0,
                                classe.longitude! * 1.0),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              classe.latitude != null && classe.longitude != null
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.0),
                      child: Divider(),
                    )
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
