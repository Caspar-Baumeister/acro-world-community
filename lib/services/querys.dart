class Querys {
  static String allCommunities = "query MyQuery{communities{id name}}";
  static String userCommunities =
      "query MyQuery {user_communities{community { id name }}}";
}
