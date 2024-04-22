EventType mapStringToEventType(String eventTypeString) {
  switch (eventTypeString) {
    case 'FestivalsAndCons':
      return EventType.FestivalsAndCons;
    case 'Retreats':
      return EventType.Retreats;
    case 'Trainings':
      return EventType.Trainings;
    case 'Workshops':
      return EventType.Workshops;
    case 'Classes':
      return EventType.Classes;
    case 'Jams':
      return EventType.Jams;
    default:
      throw ArgumentError('Invalid event type string: $eventTypeString');
  }
}

// build an extension on the EventType enum to convert it to a string
extension EventTypeValue on EventType {
  String get value {
    switch (this) {
      case EventType.FestivalsAndCons:
        return 'Festivals and Conventions';
      case EventType.Retreats:
        return 'Retreats';
      case EventType.Trainings:
        return 'Trainings';
      case EventType.Workshops:
        return 'Workshops';
      case EventType.Classes:
        return 'Classes';
      case EventType.Jams:
        return 'Jams';
      default:
        throw ArgumentError('Invalid event type: $this');
    }
  }
}

enum EventType {
  FestivalsAndCons,
  Retreats,
  Trainings,
  Workshops,
  Classes,
  Jams
}
