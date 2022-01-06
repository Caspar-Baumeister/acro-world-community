import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String? uid;
  DataBaseService({this.uid});

  // collection reference
  final CollectionReference infoCollection =
      FirebaseFirestore.instance.collection('info');

  Future updateUserData(
      {required String userName,
      String bio = "",
      required String networkImageUrl}) async {
    return await infoCollection
        .doc(uid)
        .set({'userName': userName, 'bio': bio, 'imgUrl': networkImageUrl});
  }

  Future updateMessageData(
      {required String cid,
      required String message,
      required String username,
      required String netImgUrl}) async {
    final messageCollection =
        FirebaseFirestore.instance.collection('communities/$cid/messages');

    final newMessage = {
      'message': message,
      'uid': uid,
      'username': username,
      'netImgUrl': netImgUrl,
      "createdAt": DateTime.now()
    };

    await messageCollection.add(newMessage);
  }

  // get info Stream
  Stream<QuerySnapshot> get info {
    return infoCollection.snapshots();
  }

  // get info Stream
  Future<DocumentSnapshot<Object?>> getUserInfo() async {
    return infoCollection.doc(uid).get();
  }

  // get messages for a specific community id
  Stream<QuerySnapshot<Object?>>? getMessages(String cid) {
    return FirebaseFirestore.instance
        .collection('communities/$cid/messages')
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  // get all communitys
  Stream<QuerySnapshot<Object?>>? getCommunities() {
    return FirebaseFirestore.instance
        .collection('communities')
        // .orderBy("createdAt", descending: true)
        .snapshots();
  }
}
