import 'package:acroworld/components/show_more_text.dart';
import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/screens/single_class_page/widgets/link_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SingleEventBody extends StatelessWidget {
  const SingleEventBody({
    Key? key,
    required this.event,
  }) : super(key: key);

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        event.imgUrl != null
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
                    imageUrl: event.imgUrl!,
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
              DescriptionTextWidget(text: event.description ?? ""),
              // TODO: SHOW THE TEACHER THAT PATICIPATE TO THE EVENT
              const SizedBox(height: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...event.links.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: LinkButton(text: e, link: e),
                      ))
                ],
              ),

              // const Divider(),
              // const SizedBox(height: 10),
              // event.location != null
              //     ? Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           const Text(
              //             "Avenue",
              //             style: TextStyle(fontWeight: FontWeight.bold),
              //           ),
              //           FutureBuilder<Address>(
              //             future: getCordinats(event.location),
              //             builder: (context, snapshot) {
              //               if (snapshot.hasData && snapshot.data != null) {
              //                 if (snapshot.data?.coordinates?.latitude !=
              //                         null &&
              //                     snapshot.data?.coordinates?.longitude !=
              //                         null) {
              //                   return Column(
              //                     children: [
              //                       OpenGoogleMaps(
              //                         latitude:
              //                             snapshot.data!.coordinates!.latitude!,
              //                         longitude: snapshot
              //                             .data!.coordinates!.longitude!,
              //                       ),
              //                       const SizedBox(height: 10),
              //                       Container(
              //                         decoration: BoxDecoration(
              //                             borderRadius:
              //                                 BorderRadius.circular(20)),
              //                         constraints:
              //                             const BoxConstraints(maxHeight: 150),
              //                         child: MapWidget(
              //                           zoom: 15.0,
              //                           center: LatLng(
              //                               snapshot
              //                                   .data!.coordinates!.latitude!,
              //                               snapshot
              //                                   .data!.coordinates!.longitude!),
              //                           markerLocation: LatLng(
              //                               snapshot
              //                                   .data!.coordinates!.latitude!,
              //                               snapshot
              //                                   .data!.coordinates!.longitude!),
              //                         ),
              //                       ),
              //                     ],
              //                   );
              //                 }
              //                 return Container();
              //               } else {
              //                 return Container();
              //               }
              //             },
              //           )
              //         ],
              //       )
              //     : Container()
            ],
          ),
        ),
      ],
    ));
  }

  // Future<Address> getCordinats(String? query) async {
  //   List<Address> addresses =
  //       await Geocoder.local.findAddressesFromQuery(query);
  //   return addresses.first;
  // }
}
