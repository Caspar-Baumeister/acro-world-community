class ClassModel {
  String city;
  String description;
  String id;
  String name;
  String locationName;
  String? pricing;
  String? requirements;
  String? imageUrl;
  String? uscUrl;
  double? latitude;
  double? longitude;

  String? classPassUrl;

  String? websiteUrl;

  ClassModel(
      {required this.id,
      required this.description,
      required this.locationName,
      required this.city,
      required this.pricing,
      required this.requirements,
      required this.imageUrl,
      required this.uscUrl,
      required this.classPassUrl,
      required this.websiteUrl,
      required this.latitude,
      required this.longitude,
      required this.name});

  factory ClassModel.fromJson(dynamic json) {
    return ClassModel(
      id: json['id'],
      name: json["name"],
      description: json["description"],
      locationName: json["location_name"],
      pricing: json["pricing"],
      city: json["city"],
      requirements: json["requirements"],
      uscUrl: json["usc_url"],
      classPassUrl: json["class_pass_url"],
      websiteUrl: json["website_url"],
      imageUrl: json["image_url"],
      latitude: json["location"]?["coordinates"]?[0],
      longitude: json["location"]?["coordinates"]?[1],
    );
  }
}

List<ClassModel> adrainClasses = [
//   ClassModel(
//       id: "1",
//       description: """
// Join our Experienced Acrobatics Series to get some instruction on partner acrobatics and exchange with other acrobats at your level.
// We will look at a range of skills and techniques, from dynamic skills to partner acrobatic standing tricks.

// Bringing a partner you will be able to train with consistently is recommended but not necessary. Stepping out of your typical role as base or flyer will be encouraged and supported. Come and play with us! Learn some new ways to move your body and those of your friends!
// This is a class for acrobats with at least fundamental experience. We recommend at least 6 months experience and the ability to perform a stable shoulder stand on feet, Foot to foot, Two-High, and 30 sec handstand against the wall.
// As a classic Circus discipline, once skill levels advance, there will be an option to join a performance oriented class.
// Please bear in mind that it is at the discretion of the trainer to exclude participants from the class if a lack of experience might compromise the safety of the class.
// Every 4 sessions will focus on one topic.

// Reservation & Hygiene
// Current regulations require all sports classes to be held on a 2G+ basis.
// Please have your vaccination certificate and same day test center result ready to show when you arrive at class.
// To comply with current restrictions around spacing, we will limit class participation to 24 participants. Participation will only be possible after previous registration with a partner and showing proof of test or vaccination. If you don’t have a partner but would still like to participate, contact us.
// If you use USC, you can reserve your spot directly in the app, up to several weeks in advance. Please still message us to let us know who your partner will be. If you don’t use USC, you can email us at info@adrianiselin.com and can send your contribution via PayPal to the same address. Registrations are only finalized after receipt of payment.
// The cancellation period is 24h. For cancellations less than 24h before class, no refund is possible. If you won’t make it, please let us know as soon as you can, so we can make best use of the available spaces.
// Please arrive with a mask and wear a mask in the dressing room. Once you’ve reached your mat, you can take your mask off. Mats will be placed in the studio at an appropriate distance and we ask you not to move them. We also ask you to disinfect the mat after use.
// If you're new to Acro or are looking for a more introductory level class: https://fb.me/e/1ang9lHvl

// When:
// Monday 20.00h - 22.00h
// Wednesdays 20.30h - 22.30h

// Price:
// Trial Session 15€
// 4 Sessions 50€
// 10 Sessions 100€

// Urban Sports Club memberships
// M (6 sessions per month)
// L (8 sessions per month)
// XL (unlimited sessions per month)
// are welcome.

// To sign up or to ask questions, email us at info@adrianiselin.com

// Feel free to send videos and make requests for tricks you’d like to learn.
// Our policy: If you can't make it to class for any reason, please let us know in advance. Single trial class participation is possible.
// After this, only 4 session passes are available to enable more focus in the training group.

// Find out more at:
// www.adrianiselin.com""",
//       locationName: "Spreefeld, Optionsraum 2, Wilhelmine-Gemberg-Weg 12",
//       name: "Acro // Advanced with Adrian"),
//   ClassModel(
//     id: "1",
//     description: """
// Come join our Open-Level Acro class.
// This class is suitable for total beginners, up to a low intermediate level. We will play with some fundamental skills and dynamics, to build your strength and stability as well as your ability to learn independently. All forms, flows and exercises will be demonstrated with simpler and more challenging options to fit different levels of experience.
// This is an indoor class but we have an outdoor options if weather permits!
// As a classic Circus discipline, once skill levels advance, there will be an option to join a more advanced performance oriented class.

// Reservation & Hygiene
// Current regulations require all sports classes to be held on a 2G+ basis.
// Please have your vaccination certificate and same day test center result ready to show when you arrive at class.
// To comply with current restrictions around spacing, we will limit class participation to 24 participants. Participation will only be possible after previous registration with a partner and showing proof of test or vaccination. If you don’t have a partner but would still like to participate, contact us.
// If you use USC, you can reserve your spot directly in the app, up to several weeks in advance. Please still message us to let us know who your partner will be. If you don’t use USC, you can email us at info@adrianiselin.com and can send your contribution via PayPal to the same address. Registrations are only finalized after receipt of payment.
// The cancellation period is 24h. For cancellations less than 24h before class, no refund is possible. If you won’t make it, please let us know as soon as you can, so we can make best use of the available spaces.
// Please arrive with a mask and wear a mask in the dressing room. Once you’ve reached your mat, you can take your mask off. Mats will be placed in the studio at an appropriate distance and we ask you not to move them. We also ask you to disinfect the mat after use.
// If you're new to Acro or are looking for a more introductory level class: https://fb.me/e/1ang9lHvl

// When:
// Monday 20.00h - 22.00h
// Wednesdays 20.30h - 22.30h

// Price:
// Trial Session 15€
// 4 Sessions 50€
// 10 Sessions 100€

// Urban Sports Club memberships
// M (6 sessions per month)
// L (8 sessions per month)
// XL (unlimited sessions per month)
// are welcome.

// To sign up or to ask questions, email us at info@adrianiselin.com

// Feel free to send videos and make requests for tricks you’d like to learn.
// Our policy: If you can't make it to class for any reason, please let us know in advance. Single trial class participation is possible.
// After this, only 4 session passes are available to enable more focus in the training group.

// Find out more at:
// www.adrianiselin.com""",
//     locationName: "Spreefeld, Optionsraum 2, Wilhelmine-Gemberg-Weg 12",
//     name: "Acro // Advanced with Adrian",
//   )
];
