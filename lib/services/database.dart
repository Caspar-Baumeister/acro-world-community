import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String? uid;
  DataBaseService({this.uid});

  // collection reference
  final CollectionReference infoCollection =
      FirebaseFirestore.instance.collection('info');

  // USER DATA

  // set all by id
  Future updateUserData(
      {required String userName,
      String bio = "",
      required String imgUrl}) async {
    return await infoCollection
        .doc(uid)
        .set({'userName': userName, 'bio': bio, 'imgUrl': imgUrl});
  }

  // set specific by id
  Future updateUserDataField({
    required String field,
    required String value,
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
  Future<DocumentSnapshot<Object?>> getUserInfoField(String field) async {
    return infoCollection.doc(uid).get().then((value) => value.get(field));
  }

  // MESSAGES
  // set by id
  Future updateMessageData(
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

  // get by id
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
