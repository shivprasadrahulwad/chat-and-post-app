import 'package:friends/model/user_preview.dart';

// class Comment {
//   final String id;
//   final String postId;
//   final String postType;
//   final String userId;
//   final UserPreview? user;
//   final String content;
//   final String? parentId;
//   final List<String> likes;
//   final int replyCount;
//   final DateTime createdAt;
//   final List<Comment> replies;

//   Comment({
//     required this.id,
//     required this.postId,
//     required this.postType,
//     required this.userId,
//     this.user,
//     required this.content,
//     this.parentId,
//     List<String>? likes,
//     this.replyCount = 0,
//     DateTime? createdAt,
//     List<Comment>? replies,
//   })  : likes = likes ?? [],
//         createdAt = createdAt ?? DateTime.now(),
//         replies = replies ?? [];

//   factory Comment.fromJson(Map<String, dynamic> json) {
//     return Comment(
//       id: json['_id'],
//       postId: json['postId'],
//       postType: json['postType'],
//       userId: json['userId'],
//       user: json['userId'] is Map 
//           ? UserPreview.fromJson(json['userId'])
//           : null,
//       content: json['content'],
//       parentId: json['parentId'],
//       likes: List<String>.from(json['likes'] ?? []),
//       replyCount: json['replyCount'] ?? 0,
//       createdAt: json['createdAt'] != null 
//           ? DateTime.parse(json['createdAt'])
//           : DateTime.now(),
//       replies: json['replies'] != null
//           ? List<Comment>.from(
//               json['replies'].map((x) => Comment.fromJson(x)))
//           : [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'postId': postId,
//       'postType': postType,
//       'userId': userId,
//       'content': content,
//       'parentId': parentId,
//       'likes': likes,
//       'replyCount': replyCount,
//       'createdAt': createdAt.toIso8601String(),
//       'replies': replies.map((x) => x.toJson()).toList(),
//     };
//   }

//   Comment copyWith({
//     String? id,
//     String? postId,
//     String? postType,
//     String? userId,
//     UserPreview? user,
//     String? content,
//     String? parentId,
//     List<String>? likes,
//     int? replyCount,
//     DateTime? createdAt,
//     List<Comment>? replies,
//   }) {
//     return Comment(
//       id: id ?? this.id,
//       postId: postId ?? this.postId,
//       postType: postType ?? this.postType,
//       userId: userId ?? this.userId,
//       user: user ?? this.user,
//       content: content ?? this.content,
//       parentId: parentId ?? this.parentId,
//       likes: likes ?? this.likes,
//       replyCount: replyCount ?? this.replyCount,
//       createdAt: createdAt ?? this.createdAt,
//       replies: replies ?? this.replies,
//     );
//   }
// }


import 'package:hive/hive.dart';
import 'user_preview.dart';

part 'comment.g.dart';

@HiveType(typeId: 18)
class Comment {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String postId;

  @HiveField(2)
  final String postType;

  @HiveField(3)
  final String userId;

  @HiveField(4)
  final UserPreview? user;

  @HiveField(5)
  final String content;

  @HiveField(6)
  final String? parentId;

  @HiveField(7)
  final List<String> likes;

  @HiveField(8)
  final int replyCount;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final List<Comment> replies;

  Comment({
    required this.id,
    required this.postId,
    required this.postType,
    required this.userId,
    this.user,
    required this.content,
    this.parentId,
    List<String>? likes,
    this.replyCount = 0,
    DateTime? createdAt,
    List<Comment>? replies,
  })  : likes = likes ?? [],
        createdAt = createdAt ?? DateTime.now(),
        replies = replies ?? [];

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      postId: json['postId'],
      postType: json['postType'],
      userId: json['userId'],
      user: json['userId'] is Map
          ? UserPreview.fromJson(json['userId'])
          : null,
      content: json['content'],
      parentId: json['parentId'],
      likes: List<String>.from(json['likes'] ?? []),
      replyCount: json['replyCount'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      replies: json['replies'] != null
          ? List<Comment>.from(
              json['replies'].map((x) => Comment.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'postId': postId,
      'postType': postType,
      'userId': userId,
      'content': content,
      'parentId': parentId,
      'likes': likes,
      'replyCount': replyCount,
      'createdAt': createdAt.toIso8601String(),
      'replies': replies.map((x) => x.toJson()).toList(),
    };
  }

  Comment copyWith({
    String? id,
    String? postId,
    String? postType,
    String? userId,
    UserPreview? user,
    String? content,
    String? parentId,
    List<String>? likes,
    int? replyCount,
    DateTime? createdAt,
    List<Comment>? replies,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      postType: postType ?? this.postType,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      content: content ?? this.content,
      parentId: parentId ?? this.parentId,
      likes: likes ?? this.likes,
      replyCount: replyCount ?? this.replyCount,
      createdAt: createdAt ?? this.createdAt,
      replies: replies ?? this.replies,
    );
  }
}