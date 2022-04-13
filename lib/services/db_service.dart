import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Serializable {
  Map<String, dynamic> toJson();
}

abstract class FirestoreService<T, TCreateDto extends Serializable> {
  late CollectionReference collection;

  FirestoreService(String collectionName) {
    collection = FirebaseFirestore.instance.collection(collectionName);
  }

  T fromSnapshot(DocumentSnapshot<Object?> snapshot);

  Future<T> get(String uid) async {
    return fromSnapshot(await collection.doc(uid).get());
  }

  Future<void> create(TCreateDto object) async {
    return await collection.doc().set(object.toJson());
  }

  Future<void> update(String uid, T object) async {
    return await collection.doc(uid).set(object);
  }

  Future<void> delete(String uid) async {
    return await collection.doc(uid).delete();
  }
}
