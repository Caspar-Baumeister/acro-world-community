import 'package:acroworld/models/jam_model.dart';

// Should be fired when any CRUD operation happens on a jam
class CrudJamEvent {
  Jam jam;
  CrudJamEvent(this.jam);
}
