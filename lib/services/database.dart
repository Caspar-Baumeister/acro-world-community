import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DataBaseService {
  final String? uid;
  DataBaseService({this.uid});

  // collection reference
  final CollectionReference infoCollection =
      FirebaseFirestore.instance.collection('info');

  final CollectionReference communitiesCollection =
      FirebaseFirestore.instance.collection('communities');
  // USER DATA

  // create by id
  Future createUserInfo({
    String userName = "",
    String bio = "",
    String imgUrl = "",
    List<String> communities = const [],
  }) async {
    return await infoCollection.doc(uid).set({
      "userName": userName,
      "bio": bio,
      "imgUrl": imgUrl,
      "communities": communities,
      "last_created_jam": DateTime.now(),
      "last_created_community": DateTime.now()
    });
  }

  // update field by id
  Future updateUserDataField({
    required String field,
    required value,
  }) async {
    return await infoCollection
        .doc(uid)
        .set({field: value}, SetOptions(merge: true));
  }

  // get by id
  Future<DocumentSnapshot<Object?>> getUserInfo() async {
    return infoCollection.doc(uid).get();
  }

  // get field by id
  Future<Object?> getUserInfoField(String field) async {
    return infoCollection.doc(uid).get().then((value) => value.get(field));
  }

  // User profile image by id
  Future<String> getProfileImage() async {
    return await FirebaseStorage.instance.ref(uid).getDownloadURL();
  }

  // add community to communities of user
  Future addCommunityToUser({
    required String community,
  }) async {
    // get existing list
    List<Map> communities = List<Map>.from(await infoCollection
        .doc(uid)
        .get()
        .then((value) => value.get("communities")));
    // add community
    communities.add({"community_id": community, "created_at": Timestamp.now()});
    // post updated list
    return await infoCollection.doc(uid).update({"communities": communities});
  }

  // add community to communities of user
  Future deleteCommunityOfUser({
    required String community,
  }) async {
    // get existing list
    List<Map> communities = await infoCollection
        .doc(uid)
        .get()
        .then((value) => value.get("communities"));
    // remove community
    communities.removeWhere((map) => map["community_id"] == community);
    // post updated list
    return await infoCollection.doc(uid).update({"communities": communities});
  }

  // MESSAGES
  // set by id
  Future addMessageData(
      {required String cid,
      required String message,
      required String username,
      required String imgUrl}) async {
    final messageCollection =
        FirebaseFirestore.instance.collection('communities/$cid/messages');

    final newMessage = {
      'message': message,
      'uid': uid,
      'username': username,
      'imgUrl': imgUrl,
      "createdAt": DateTime.now()
    };

    await messageCollection.add(newMessage);
  }

  // get all
  Stream<QuerySnapshot<Object?>>? getMessages(String cid) {
    return FirebaseFirestore.instance
        .collection('communities/$cid/messages')
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  // COMMUNITIES
  // get all
  Stream<QuerySnapshot<Object?>>? getCommunities() {
    return FirebaseFirestore.instance
        .collection('communities')
        // .orderBy("createdAt", descending: true)
        .snapshots();
  }

  // get all
  Stream<DocumentSnapshot<Object?>>? getUserCommunities() {
    return infoCollection.doc(uid).snapshots();
  }

  // change/set specific by id
  Future updateCommunityDataField({
    required String cid,
    required String field,
    required dynamic value,
  }) async {
    return await communitiesCollection
        .doc(cid)
        .set({field: value}, SetOptions(merge: true));
  }

  // get by id
  Future<DocumentSnapshot<Object?>> getCommunity(String cid) async {
    return communitiesCollection.doc(cid).get();
  }

  Future<QuerySnapshot<Object?>> getCommunitiesByIds(List<String> cids) async {
    return communitiesCollection.where('id', arrayContains: cids).get();
    // return communitiesCollection.doc(cid).get();
  }

  // set by id
  Future<void> createCommunity({
    required String cid,
  }) async {
    final newCommunity = {
      'confirmed': false,
      'next_jam': Timestamp.now(),
    };
    await communitiesCollection.doc(cid).set(newCommunity);
  }

  // JAMS //

  // delete jam
  Future deleteJam({
    required String jid,
    required String cid,
  }) async {
    return await FirebaseFirestore.instance
        .collection('communities/$cid/jams')
        .doc(jid)
        .delete();
  }

  // set by id
  Future addJam(
      {required String cid,
      required String name,
      required String imgUrl,
      required String location,
      required Timestamp date,
      required LatLng latlng,
      String info = ""}) async {
    final jamsCollection =
        FirebaseFirestore.instance.collection('communities/$cid/jams');

    final newJam = {
      'name': name,
      'location': location,
      'imgUrl': imgUrl,
      'date': date,
      'participants': [],
      'createdBy': uid,
      'info': info,
      'latlng': [latlng.latitude, latlng.longitude],
      'createdAt': DateTime.now()
    };

    await jamsCollection.add(newJam);
  }

  // update field
  Future updateJamField({
    required String jid,
    required String cid,
    required String field,
    required dynamic value,
  }) async {
    return await FirebaseFirestore.instance
        .collection('communities/$cid/jams')
        .doc(jid)
        .set({field: value}, SetOptions(merge: true));
  }

  // get all
  Stream<QuerySnapshot<Object?>>? getJams(String cid) {
    return FirebaseFirestore.instance
        .collection('communities/$cid/jams')
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  // // get jam by id
  // Stream<QuerySnapshot<Object?>>? getJam(String cid) {
  //   return FirebaseFirestore.instance
  //       .collection('communities/$cid/jams')
  //       .orderBy("createdAt", descending: true)
  //       .snapshots();
  // }

  // // get info Stream
  // Stream<QuerySnapshot> get info {
  //   return infoCollection.snapshots();
  // }

  // // get info Stream
  // Stream<DocumentSnapshot<Object?>> get infoStream {
  //   print("inside stream: ${infoCollection.doc(uid).snapshots()}");
  //   return infoCollection.doc(uid).snapshots();
  // }
}
