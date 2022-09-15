class TeacherModel {
  String profilePicUrl;
  String name;
  int id;
  String description;
  String level;
  String city;
  int likes;
  List<String> pictureUrls;
  List<String> classes;

  TeacherModel({
    required this.profilePicUrl,
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.city,
    required this.likes,
    required this.pictureUrls,
    required this.classes,
    // teaching since
  });

  factory TeacherModel.fromJson(json) {
    return TeacherModel(
      profilePicUrl: json["profilePicUrl"],
      name: json["name"],
      id: json["id"],
      description: json["description"],
      city: json["city"],
      level: json["level"],
      likes: json["likes"],
      pictureUrls: json["pictureUrls"],
      classes: json["classes"],
    );
  }
}

List<Map<String, dynamic>> teacher = [
  {
    "profilePicUrl":
        "https://media-exp1.licdn.com/dms/image/C4D03AQGvYbZQexJcvA/profile-displayphoto-shrink_200_200/0/1571407767743?e=2147483647&v=beta&t=CqLOM_wop1LRa4Bcun4_J226omEf5g65WBiubJOS-4w",
    "name": "Caspar Baumeister",
    "id": 2,
    "description":
        "I'm still new in teaching and try to improve along the way. Mainly I'm here to show, what your teacher profile could look like",
    "level": "Intermediate Advanced",
    "city": "Berlin",
    "likes": 0,
    "pictureUrls": [
      "https://images.unsplash.com/photo-1508081685193-835a84a79091?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YWNyb3lvZ2F8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
      "https://images.unsplash.com/photo-1553871840-00c92ebf239f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8YWNyb3lvZ2F8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
      "https://images.unsplash.com/photo-1541453456074-d59763a931de?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8YWNyb3lvZ2F8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
      "https://images.unsplash.com/photo-1623182965637-e2e2f32818d3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8YWNyb3lvZ2F8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
      "https://images.unsplash.com/photo-1520534827997-83397f6aac19?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YWNyb3lvZ2F8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
      "https://scontent-ber1-1.cdninstagram.com/v/t51.288…SuVPNpqltckXjZsHEMvDlA&oe=6318CCA4&_nc_sid=30a2ef",
      "https://scontent-ber1-1.cdninstagram.com/v/t51.288…yi2fNDMD-bh8a_O4iGVPXg&oe=63188C27&_nc_sid=30a2ef",
      "https://scontent-ber1-1.cdninstagram.com/v/t51.288…RBUPklILXJ4PvxFV8kV1sQ&oe=63180B29&_nc_sid=30a2ef",
    ],
    "classes": ["1", "2", "3"]
  },
  // {
  //   "name": "Teacher Name",
  //   "id": 1,
  //   "description": "Describe your teaching",
  //   "level": [0, 2, 3],
  //   "city": "Berlin",
  //   "likes": 420,
  //   "pictureUrls": [
  // "https://images.unsplash.com/photo-1508081685193-835a84a79091?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YWNyb3lvZ2F8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
  // "https://images.unsplash.com/photo-1553871840-00c92ebf239f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8YWNyb3lvZ2F8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
  // "https://images.unsplash.com/photo-1541453456074-d59763a931de?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8YWNyb3lvZ2F8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
  // "https://images.unsplash.com/photo-1623182965637-e2e2f32818d3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8YWNyb3lvZ2F8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
  // "https://images.unsplash.com/photo-1520534827997-83397f6aac19?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YWNyb3lvZ2F8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
  //   ],
  // },
  {
    "profilePicUrl":
        "data:image/jpeg;base64,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",
    "name": "Adrian Iselin",
    "id": 1,
    "description": """
        Adrian has been teaching internationally since 2015. With a background in Martial Arts and Dance, he eventually moved to Partner Acrobatics. 
        Partner Acrobatics, is a loose term that describes a movement practice composed of gymnastics, dance, and yoga with a partner. 
        In our training you can learn broad range of moves and techniques from a beginner up to an advanced level. 
        Read the individual descriptions to find the course best suited for you.
        """,
    "level": "Intermediate Advanced",
    "city": "Berlin",
    "likes": 2,
    "pictureUrls": [
      "https://www.motionsberlin.de/wp-content/uploads/2017/06/DSC06304.jpeg",
      "https://scontent-ber1-1.xx.fbcdn.net/v/t39.30808-6/263936984_4532660423449463_2314880072060778611_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=Xn8f4P11ZtkAX8CnpsS&tn=4cycqK5dbKSO2vJw&_nc_ht=scontent-ber1-1.xx&oh=00_AT8dpRR4S4Mg2fC6vbnvOC2UREid186FbqXq70L2UyHvcw&oe=62D2FDD9",
      "https://scontent-ber1-1.xx.fbcdn.net/v/t1.18169-9/12991108_1012117508837123_6623269657676488078_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=174925&_nc_ohc=LvtdBTMTy4AAX8hLBYO&_nc_ht=scontent-ber1-1.xx&oh=00_AT-smGTQqbJetonBbwduywpXumr7j4cAwhJUMoUKVHrybg&oe=62F2BE19",
      "https://scontent-ber1-1.xx.fbcdn.net/v/t31.18172-8/26060045_1540387719343430_2264592422009933218_o.jpg?_nc_cat=102&ccb=1-7&_nc_sid=730e14&_nc_ohc=P0iZC91wUp0AX8fl0m9&_nc_ht=scontent-ber1-1.xx&oh=00_AT_UHy4KIII1I9C2hY3KZ7t1FV-hSDp8BXidfvESz4c2Nw&oe=62F31649",
      "https://static.wixstatic.com/media/02f860_bd8bd63b3e7741ac8b55053035caa4d4~mv2.jpg/v1/crop/x_132,y_0,w_3434,h_5566/fill/w_1256,h_2036,al_c,q_90,usm_0.66_1.00_0.01,enc_auto/me%2C%20oumou%2C%20bw.jpg",
      "https://scontent-ber1-1.xx.fbcdn.net/v/t31.18172-8/26060305_1540387529343449_1199659952056611722_o.jpg?_nc_cat=109&ccb=1-7&_nc_sid=730e14&_nc_ohc=3-pBcDmAd0YAX9zs849&_nc_ht=scontent-ber1-1.xx&oh=00_AT_ixGqcnORmKsZAQwdJjWwotnij99JXvxlrCJ4zsFaNgw&oe=62F4F01E",
    ],
    "classes": ["1", "2", "3"]
  },
  // {
  //   "name": "Patrick and Johanna",
  //   "id": 2,
  //   "description":
  //       "Acroyoga combines the power of acrobatics with the mindfulness of yoga, connecting two (or more!) people in a playful way. And it’s easier than it looks! Because it uses technique instead of, say, strength, anyone can learn acroyoga — regardless of age, gender or size.",
  //   "level": [0, 1],
  //   "city": "Berlin",
  //   "likes": 420,
  //   "pictureUrls": [
  //     "https://www.flowmotionstudio.de/wp-content/uploads/2021/01/IMG_7497_edited-edited-300x300.jpg",
  //     "https://www.flowmotionstudio.de/wp-content/uploads/2021/01/BSWS8957-edited-300x300.jpg",
  //     "https://www.flowmotionstudio.de/wp-content/uploads/2021/01/IMG_4714.jpg",
  //     "https://www.flowmotionstudio.de/wp-content/uploads/2021/01/XQDB5872.jpg",
  //     "https://www.flowmotionstudio.de/wp-content/uploads/2021/04/IMG_5166.png",
  //   ],
  // }
];
