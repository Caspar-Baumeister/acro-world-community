class Fragments {
  static const String jamFragment = '''
    created_at
    created_by {
      name
      image_url
      id
      bio
    }
    date
    id
    info
    latitude
    longitude
    name
    community_id
    created_by_id
    participants {
      user {
        name
        id
        image_url
        bio
      }
    }
''';
}
