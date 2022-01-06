import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

// StreamTransformer transformer<T>(
//   T Function(Map<String,dynamic> json) fromJson) =>
//   StreamTransformer<QuerySnapshot, List<T>>.fromHandlers(
//     handleData: (QuerySnapshot data, EventSink<List<T>> sink) {
//       final snaps = data.docs.map((doc) => doc.data()).toList();
//       final users = snaps.map((json) => json != null ? fromJson(json)).toList();
//     }
//   );