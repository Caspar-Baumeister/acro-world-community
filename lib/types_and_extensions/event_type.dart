EventType mapStringToEventType(String eventTypeString) {
  switch (eventTypeString) {
    case 'FestivalsAndCons':
      return EventType.FestivalsAndCons;
    case 'Retreats':
      return EventType.Retreats;
    case 'Trainings':
      return EventType.Trainings;
    default:
      throw ArgumentError('Invalid event type string: $eventTypeString');
  }
}

// build an extension on the EventType enum to convert it to a string
extension EventTypeValue on EventType {
  String get value {
    switch (this) {
      case EventType.FestivalsAndCons:
        return 'FestivalsAndCons';
      case EventType.Retreats:
        return 'Retreats';
      case EventType.Trainings:
        return 'Trainings';
      default:
        throw ArgumentError('Invalid event type: $this');
    }
  }
}

enum EventType {
  FestivalsAndCons,
  Retreats,
  Trainings,
}
