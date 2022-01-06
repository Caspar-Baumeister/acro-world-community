class Community {
  String id;
  Community({required this.id});

  factory Community.fromJson(String id) {
    return Community(id: id);
  }
}
