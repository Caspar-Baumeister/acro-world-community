class Querys {
  static String allCommunities = "query MyQuery{communities{id name}}";
  static String userCommunities =
      "query MyQuery {user_communities{community { id name }}}";
  static String me =
      "query MyQuery {me { bio id image_url last_proposed_community_at name}}";
}
