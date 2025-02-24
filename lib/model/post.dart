// import 'package:friends/model/comment.dart';
// import 'package:friends/model/user_preview.dart';
// import 'package:hive/hive.dart';

// part 'post.g.dart';

// @HiveType(typeId: 16)
// class Post {
//   @HiveField(0)
//   final String id;
  
//   @HiveField(1)
//   final String userId;
  
//   @HiveField(2)
//   final String? caption;
  
//   @HiveField(3)
//   final String? mediaUrl;
  
//   @HiveField(4)
//   final List<String> likes;
  
//   @HiveField(5)
//   final List<Comment> comments;
  
//   @HiveField(6)
//   final DateTime createdAt;
  
//   @HiveField(7)
//   final UserPreview? user;
  
//   @HiveField(8)
//   final int commentCount;
  

//   Post({
//     required this.id,
//     required this.userId,
//     this.caption,
//     this.mediaUrl,
//     required this.likes,
//     this.comments = const [],
//     required this.createdAt,
//     this.user,
//     this.commentCount = 0,
//   });


// factory Post.fromJson(Map<String, dynamic> json) {
//   return Post(
//     id: json['_id'],
//     userId: json['userId'] is Map<String, dynamic> ? json['userId']['_id'] : json['userId'], // ✅ Ensure userId is a String
//     caption: json['caption'],
//     mediaUrl: json['mediaUrl'],
//     likes: List<String>.from(json['likes'] ?? []),
//     comments: (json['comments'] as List<dynamic>?)
//         ?.map((comment) => Comment.fromJson(comment))
//         .toList() ?? [],
//     commentCount: json['commentCount'] ?? 0,
//     createdAt: DateTime.parse(json['createdAt']),
//     user: json['user'] != null ? UserPreview.fromJson(json['user']) : null,
//   );
// }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'userId': userId,
//       if (caption != null) 'caption': caption,
//       if (mediaUrl != null) 'mediaUrl': mediaUrl,
//       'likes': likes,
//       'comments': comments.map((comment) => comment.toJson()).toList(),
//       'commentCount': commentCount,
//       'createdAt': createdAt.toIso8601String(),
//       if (user != null) 'user': user!.toJson(),
//     };
//   }

//   Post copyWith({
//     String? id,
//     String? userId,
//     String? caption,
//     String? mediaUrl,
//     List<String>? likes,
//     List<Comment>? comments,
//     int? commentCount,
//     DateTime? createdAt,
//     UserPreview? user,
//   }) {
//     return Post(
//       id: id ?? this.id,
//       userId: userId ?? this.userId,
//       caption: caption ?? this.caption,
//       mediaUrl: mediaUrl ?? this.mediaUrl,
//       likes: likes ?? this.likes,
//       comments: comments ?? this.comments,
//       commentCount: commentCount ?? this.commentCount,
//       createdAt: createdAt ?? this.createdAt,
//       user: user ?? this.user,
//     );
//   }
// }




import 'package:friends/model/comment.dart';
import 'package:friends/model/user_preview.dart';
import 'package:hive/hive.dart';

// part 'post.g.dart';

// @HiveType(typeId: 16)
// class Post {
//   @HiveField(0)
//   final String id;

//   @HiveField(1)
//   final String userId;

//   @HiveField(2)
//   final String content;

//   @HiveField(3)
//   final String? mediaUrl;

//   @HiveField(4)
//   final List<String> likes;

//   @HiveField(5)
//   final List<Comment> comments;

//   @HiveField(6)
//   final UserPreview? user;

//   @HiveField(7)
//   final int commentCount;

//   @HiveField(8)
//   final DateTime createdAt;

//   @HiveField(9)
//   final bool isDeleted;

//   Post({
//     required this.id,
//     required this.userId,
//     required this.content,
//     this.mediaUrl,
//     required this.likes,
//     this.comments = const [],
//     this.user,
//     required this.commentCount,
//     required this.createdAt,
//     required this.isDeleted,
//   });

//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       id: json['_id'],
//       userId: json['userId'] is Map<String, dynamic> ? json['userId']['_id'] : json['userId'],
//       content: json['content'],
//       mediaUrl: json['mediaUrl'],
//       likes: List<String>.from(json['likes'] ?? []),
//       comments: (json['comments'] as List<dynamic>?)
//           ?.map((comment) => Comment.fromJson(comment))
//           .toList() ?? [],
//       user: json['user'] != null ? UserPreview.fromJson(json['user']) : null,
//       commentCount: json['commentCount'] ?? 0,
//       createdAt: DateTime.parse(json['createdAt']),
//       isDeleted: json['isDeleted'] ?? false,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'userId': userId,
//       'content': content,
//       if (mediaUrl != null) 'mediaUrl': mediaUrl,
//       'likes': likes,
//       'comments': comments.map((comment) => comment.toJson()).toList(),
//       if (user != null) 'user': user!.toJson(),
//       'commentCount': commentCount,
//       'createdAt': createdAt.toIso8601String(),
//       'isDeleted': isDeleted,
//     };
//   }

//   Post copyWith({
//     String? id,
//     String? userId,
//     String? content,
//     String? mediaUrl,
//     List<String>? likes,
//     List<Comment>? comments,
//     UserPreview? user,
//     int? commentCount,
//     DateTime? createdAt,
//     bool? isDeleted,
//   }) {
//     return Post(
//       id: id ?? this.id,
//       userId: userId ?? this.userId,
//       content: content ?? this.content,
//       mediaUrl: mediaUrl ?? this.mediaUrl,
//       likes: likes ?? this.likes,
//       comments: comments ?? this.comments,
//       user: user ?? this.user,
//       commentCount: commentCount ?? this.commentCount,
//       createdAt: createdAt ?? this.createdAt,
//       isDeleted: isDeleted ?? this.isDeleted,
//     );
//   }
// }


part 'post.g.dart';

@HiveType(typeId: 16)
class Post {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final String? mediaUrl;

  @HiveField(4)
  final List<String> likes;

  @HiveField(5)
  final List<Comment> comments;

  @HiveField(6)
  final UserPreview? user;

  @HiveField(7)
  final int commentCount;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final bool isDeleted;

  @HiveField(10)
  final bool isReported;
  
  @HiveField(11)
  final String? reportReason;
  
  @HiveField(12)
  final bool isLikedByCurrentUser;

  Post({
    required this.id,
    required this.userId,
    required this.content,
    this.mediaUrl,
    required this.likes,
    this.comments = const [],
    this.user,
    required this.commentCount,
    required this.createdAt,
    required this.isDeleted,
    required this.isReported,
    this.reportReason,
    required this.isLikedByCurrentUser,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      userId: json['userId'] is Map<String, dynamic> ? json['userId']['_id'] : json['userId'],
      content: json['content'],
      mediaUrl: json['mediaUrl'],
      likes: List<String>.from(json['likes'] ?? []),
      comments: (json['comments'] as List<dynamic>?)?.map((comment) => Comment.fromJson(comment)).toList() ?? [],
      user: json['user'] != null ? UserPreview.fromJson(json['user']) : null,
      commentCount: json['commentCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      isDeleted: json['isDeleted'] ?? false,
      isReported: json['isReported'] ?? false,
      reportReason: json['reportReason'],
      isLikedByCurrentUser: json['isLikedByCurrentUser'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'content': content,
      if (mediaUrl != null) 'mediaUrl': mediaUrl,
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson()).toList(),
      if (user != null) 'user': user!.toJson(),
      'commentCount': commentCount,
      'createdAt': createdAt.toIso8601String(),
      'isDeleted': isDeleted,
      'isReported': isReported,
      'reportReason': reportReason,
      'isLikedByCurrentUser': isLikedByCurrentUser,
    };
  }

  Post copyWith({
    String? id,
    String? userId,
    String? content,
    String? mediaUrl,
    List<String>? likes,
    List<Comment>? comments,
    UserPreview? user,
    int? commentCount,
    DateTime? createdAt,
    bool? isDeleted,
    bool? isReported,
    String? reportReason,
    bool? isLikedByCurrentUser,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      user: user ?? this.user,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
      isReported: isReported ?? this.isReported,
      reportReason: reportReason ?? this.reportReason,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
    );
  }
}
