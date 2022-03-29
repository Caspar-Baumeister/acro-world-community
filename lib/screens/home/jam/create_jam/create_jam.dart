import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_communities.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/jam/create_jam/app_bar_create_jam.dart';
import 'package:acroworld/screens/home/jam/create_jam/date_time_chooser.dart';
import 'package:acroworld/screens/home/map/map.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/helper_builder.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateJam extends StatefulWidget {
  const CreateJam({required this.cid, Key? key}) : super(key: key);
  final String cid;

  @override
  State<CreateJam> createState() => _CreateJamState();
}

class _CreateJamState extends State<CreateJam> {
  DateTime _chosenDateTime = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String name = '';
  String location = '';
  String imgUrl = '';
  String info = '';
  LatLng? latlng;

  setDateTime(newDateTime) {
    setState(() {
      _chosenDateTime = newDateTime;
    });
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    int maxLenght = 30;
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBarCreateJam(onCreate: onCreate),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      Container(
                        // constraints: const BoxConstraints(maxWidth: 250),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: buildInputDecoration(labelText: 'Name'),
                          validator: (val) =>
                              (val == null || val.isEmpty || val == "")
                                  ? 'Enter a valid jam name'
                                  : null,
                          onChanged: (val) {
                            setState(() => name = val);
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      DateTimeChooser(
                        chosenDateTime: _chosenDateTime,
                        setDateTime: setDateTime,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          autocorrect: true,
                          enableSuggestions: true,
                          decoration: buildInputDecoration(labelText: 'Info'),
                          onChanged: (val) {
                            setState(() => info = val);
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty || val == "") {
                              return 'Provide a short description of the jam';
                            }
                            if (val.split(' ').length > maxLenght) {
                              return 'You cannot use more then $maxLenght';
                            }
                            return null;
                          }),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        constraints: const BoxConstraints(maxHeight: 350),
                        child: MapWidget(
                          onLocationSelected: (location) =>
                              {setState(() => latlng = location)},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  // triggert when create is pressed
  void onCreate() async {
    if (latlng == null) {
      Fluttertoast.showToast(
          msg: "Set a location before creating",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      // get activ user to safe the id
      UserModel user =
          Provider.of<UserProvider>(context, listen: false).activeUser!;

      DataBaseService dataBaseService = DataBaseService(uid: user.uid);
      // creates a new jam object
      dataBaseService.addJam(
          cid: widget.cid,
          name: name,
          imgUrl: imgUrl,
          location: location,
          date: Timestamp.fromDate(_chosenDateTime),
          latlng: latlng!,
          info: info);

      // update the usercommunityprovider and the database,
      // that the user just created a new jam
      UserCommunitiesProvider userCommunitiesProvider =
          Provider.of<UserCommunitiesProvider>(context, listen: false);

      Map communityMap = Map.from(userCommunitiesProvider.userCommunityMaps
          .firstWhere((element) => element["community_id"] == widget.cid));

      communityMap["created_at"] = Timestamp.now();

      List<Map> newCommunities =
          List<Map>.from(userCommunitiesProvider.userCommunityMaps);

      newCommunities
          .removeWhere((element) => element["community_id"] == widget.cid);

      newCommunities.add(communityMap);

      userCommunitiesProvider.userCommunityMaps = newCommunities;
      dataBaseService.updateUserDataField(
          field: "communities", value: newCommunities);

      // update next jam if newer one occurs
      DocumentSnapshot community =
          await dataBaseService.getCommunity(widget.cid);

      if (community
              .get("next_jam")
              .toDate()
              .difference(_chosenDateTime)
              .inHours >
          0) {
        dataBaseService.updateCommunityDataField(
            cid: widget.cid,
            field: "next_jam",
            value: Timestamp.fromDate(_chosenDateTime));
      }

      // redirects to jams

      setState(() {
        loading = false;
      });
      Navigator.pop(context);

      // error handling
    } else {
      setState(() {
        loading = false;
      });
    }
  }
}
