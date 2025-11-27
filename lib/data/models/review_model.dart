class ReviewModel {
  final String id;
  final String teacherId;
  final String userId;
  final String userName;
  final String? userImageUrl;
  final String content;
  final int rating; // Changed to int to match GraphQL schema
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isVerified;
  final List<String> images;

  const ReviewModel({
    required this.id,
    required this.teacherId,
    required this.userId,
    required this.userName,
    this.userImageUrl,
    required this.content,
    required this.rating,
    required this.createdAt,
    this.updatedAt,
    this.isVerified = false,
    this.images = const [],
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      teacherId: json['teacher_id'] as String,
      userId: json['user_id'] as String,
      userName: json['user']?['name'] as String? ?? 'Unknown User',
      userImageUrl: json['user']?['image_url'] as String?,
      content: json['content'] as String,
      rating: json['rating'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      isVerified: json['isVerified'] as bool? ?? false,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacherId': teacherId,
      'userId': userId,
      'userName': userName,
      'userImageUrl': userImageUrl,
      'content': content,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isVerified': isVerified,
      'images': images,
    };
  }
}

class ReviewStats {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // rating -> count

  const ReviewStats({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  factory ReviewStats.fromJson(Map<String, dynamic> json) {
    return ReviewStats(
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: json['totalReviews'] as int,
      ratingDistribution: Map<int, int>.from(json['ratingDistribution'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'ratingDistribution': ratingDistribution,
    };
  }
}
