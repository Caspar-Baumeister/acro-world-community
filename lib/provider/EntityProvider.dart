import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EntityProvider<T> extends ChangeNotifier {
  final List<T> _entities;
  get entities => _entities;

  EntityProvider(this._entities);

  void add(T item) {
    _entities.add(item);
    notifyListeners();
  }
}
