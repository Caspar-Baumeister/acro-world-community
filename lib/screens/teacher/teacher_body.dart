import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/home/communities/search_bar_widget.dart';
import 'package:acroworld/screens/teacher/widgets/new_teacher_card.dart';
import 'package:acroworld/shared/widgets/comming_soon_widget.dart';
import 'package:flutter/material.dart';

class TeacherBody extends StatefulWidget {
  const TeacherBody({Key? key}) : super(key: key);

  @override
  State<TeacherBody> createState() => _TeacherBodyState();
}

class _TeacherBodyState extends State<TeacherBody> {
  String query = "";

  List<Map<String, dynamic>> filterTeacher() {
    if (query == "") {
      return teacher;
    }

    return List.from(teacher.where((t) {
      if (t["name"].toString().toLowerCase().contains(query.toLowerCase()) ||
          t["city"].toString().toLowerCase().contains(query.toLowerCase())) {
        return true;
      }
      return false;
    }));
  }

  @override
  Widget build(BuildContext context) {
    final showTeacher = filterTeacher();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchBarWidget(
            onChanged: (String value) {
              setState(() {
                query = value;
              });
            },
          ),
        ),
        teacher.isEmpty
            ? const CommingSoon(
                header: "What is the teacher page",
                content:
                    "On the teacher page you have the opportunity to discover the local teachers that suit you best. You can see their teaching style, level, and user feedback. You can also instantly join their community and participate in their classes and jams.")
            : SingleChildScrollView(
                child: Column(
                    children: List.from(showTeacher.map((json) =>
                        NewTeacherCard(
                            teacher: TeacherModel.fromJson(json)))))),
      ],
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
  // {
  //   "profilePicUrl":
  //       "https://scontent-ber1-1.xx.fbcdn.net/v/t39.30808-6/263936984_4532660423449463_2314880072060778611_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=EXRPBPSKpYoAX8LBiiH&tn=8hbuseDTqPi0G57h&_nc_ht=scontent-ber1-1.xx&oh=00_AT827kqixSIwfSbeHYDptwWTAFPETttWfZ8KPZgmQgQ_fw&oe=63163A59",
  //   "name": "Adrian Iselin",
  //   "id": 1,
  //   "description":
  //       "Partner Acrobatics, is a loose term that describes a movement practice composed of gymnastics, dance, and yoga with a partner. In our training you can learn broad range of moves and techniques from a beginner up to an advanced level. Read the individual descriptions to find the course best suited for you.",
  //   "level": "Intermediate, Advanced",
  //   "city": "Berlin",
  //   "likes": 420,
  //   "pictureUrls": [
  //     "https://www.motionsberlin.de/wp-content/uploads/2017/06/DSC06304.jpeg",
  //     "https://scontent-ber1-1.xx.fbcdn.net/v/t39.30808-6/263936984_4532660423449463_2314880072060778611_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=Xn8f4P11ZtkAX8CnpsS&tn=4cycqK5dbKSO2vJw&_nc_ht=scontent-ber1-1.xx&oh=00_AT8dpRR4S4Mg2fC6vbnvOC2UREid186FbqXq70L2UyHvcw&oe=62D2FDD9",
  //     "https://scontent-ber1-1.xx.fbcdn.net/v/t1.18169-9/12991108_1012117508837123_6623269657676488078_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=174925&_nc_ohc=LvtdBTMTy4AAX8hLBYO&_nc_ht=scontent-ber1-1.xx&oh=00_AT-smGTQqbJetonBbwduywpXumr7j4cAwhJUMoUKVHrybg&oe=62F2BE19",
  //     "https://scontent-ber1-1.xx.fbcdn.net/v/t31.18172-8/26060045_1540387719343430_2264592422009933218_o.jpg?_nc_cat=102&ccb=1-7&_nc_sid=730e14&_nc_ohc=P0iZC91wUp0AX8fl0m9&_nc_ht=scontent-ber1-1.xx&oh=00_AT_UHy4KIII1I9C2hY3KZ7t1FV-hSDp8BXidfvESz4c2Nw&oe=62F31649",
  //     "https://static.wixstatic.com/media/02f860_bd8bd63b3e7741ac8b55053035caa4d4~mv2.jpg/v1/crop/x_132,y_0,w_3434,h_5566/fill/w_1256,h_2036,al_c,q_90,usm_0.66_1.00_0.01,enc_auto/me%2C%20oumou%2C%20bw.jpg",
  //     "https://scontent-ber1-1.xx.fbcdn.net/v/t31.18172-8/26060305_1540387529343449_1199659952056611722_o.jpg?_nc_cat=109&ccb=1-7&_nc_sid=730e14&_nc_ohc=3-pBcDmAd0YAX9zs849&_nc_ht=scontent-ber1-1.xx&oh=00_AT_ixGqcnORmKsZAQwdJjWwotnij99JXvxlrCJ4zsFaNgw&oe=62F4F01E",
  //   ],
  // },
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
