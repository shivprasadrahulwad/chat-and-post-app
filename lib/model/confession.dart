import 'package:collection/collection.dart';

// class Confession {
//   final String id;
//   final String content;
//   final String category;
//   final String userId;
//   final DateTime createdAt;
//   final bool isAnonymous;
//   final List<String> mentions;
//   final int likesCount;
//   final int commentsCount;
//   final bool isDeleted;
//   final bool isReported;
//   final String? reportReason;
//   final bool isLikedByCurrentUser;

//   factory Confession.fromJson(Map<String, dynamic> json) {
//     return Confession(
//       id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
//       content: json['content']?.toString() ?? '',
//       category: json['category']?.toString() ?? 'General',
//       userId: json['userId']?.toString() ?? '',
//       createdAt: json['createdAt'] != null 
//         ? DateTime.parse(json['createdAt'].toString())
//         : DateTime.now(),
//       isAnonymous: json['isAnonymous'] ?? true,
//       mentions: List<String>.from(json['mentions'] ?? []),
//       likesCount: json['likesCount']?.toInt() ?? 0,
//       commentsCount: json['commentsCount']?.toInt() ?? 0,
//       isDeleted: json['isDeleted'] ?? false,
//       isReported: json['isReported'] ?? false,
//       reportReason: json['reportReason']?.toString(),
//       isLikedByCurrentUser: json['isLikedByCurrentUser']?? false,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'content': content,
//     'category': category,
//     'userId': userId,
//     'createdAt': createdAt.toIso8601String(),
//     'isAnonymous': isAnonymous,
//     'mentions': mentions,
//     'likesCount': likesCount,
//     'commentsCount': commentsCount,
//     'isDeleted': isDeleted,
//     'isReported': isReported,
//     'reportReason': reportReason,
//     'isLikedByCurrentUser': isLikedByCurrentUser,
//   };

//   Confession({
//     required this.id,
//     required this.content,
//     required this.category,
//     required this.userId,
//     required this.createdAt,
//     required this.isAnonymous,
//     required this.mentions,
//     required this.likesCount,
//     required this.commentsCount,
//     required this.isDeleted,
//     required this.isReported,
//     this.reportReason,
//     this.isLikedByCurrentUser = false,
//   });

//   Confession copyWith({
//     String? id,
//     String? content,
//     String? category,
//     String? userId,
//     DateTime? createdAt,
//     bool? isAnonymous,
//     List<String>? mentions,
//     int? likesCount,
//     int? commentsCount,
//     bool? isDeleted,
//     bool? isReported,
//     String? reportReason,
//     bool? isLikedByCurrentUser,
//   }) {
//     return Confession(
//       id: id ?? this.id,
//       content: content ?? this.content,
//       category: category ?? this.category,
//       userId: userId ?? this.userId,
//       createdAt: createdAt ?? this.createdAt,
//       isAnonymous: isAnonymous ?? this.isAnonymous,
//       mentions: mentions ?? List<String>.from(this.mentions),
//       likesCount: likesCount ?? this.likesCount,
//       commentsCount: commentsCount ?? this.commentsCount,
//       isDeleted: isDeleted ?? this.isDeleted,
//       isReported: isReported ?? this.isReported,
//       reportReason: reportReason ?? this.reportReason,
//       isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
//     );
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     return other is Confession &&
//         other.id == id &&
//         other.content == content &&
//         other.category == category &&
//         other.userId == userId &&
//         other.createdAt == createdAt &&
//         other.isAnonymous == isAnonymous &&
//         const ListEquality().equals(other.mentions, mentions) &&
//         other.likesCount == likesCount &&
//         other.commentsCount == commentsCount &&
//         other.isDeleted == isDeleted &&
//         other.isReported == isReported &&
//         other.reportReason == reportReason;
//   }

//   @override
//   int get hashCode {
//     return Object.hash(
//       id,
//       content,
//       category,
//       userId,
//       createdAt,
//       isAnonymous,
//       Object.hashAll(mentions),
//       likesCount,
//       commentsCount,
//       isDeleted,
//       isReported,
//       reportReason,
//     );
//   }
// }



import 'package:hive/hive.dart';

part 'confession.g.dart';

@HiveType(typeId: 15)
class Confession {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String content;
  
  @HiveField(2)
  final String category;
  
  @HiveField(3)
  final String userId;
  
  @HiveField(4)
  final DateTime createdAt;
  
  @HiveField(5)
  final bool isAnonymous;
  
  @HiveField(6)
  final List<String> mentions;
  
  @HiveField(7)
  final int likesCount;
  
  @HiveField(8)
  final int commentsCount;
  
  @HiveField(9)
  final bool isDeleted;
  
  @HiveField(10)
  final bool isReported;
  
  @HiveField(11)
  final String? reportReason;
  
  @HiveField(12)
  final bool isLikedByCurrentUser;

  factory Confession.fromJson(Map<String, dynamic> json) {
    return Confession(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      category: json['category']?.toString() ?? 'General',
      userId: json['userId']?.toString() ?? '',
      createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt'].toString())
        : DateTime.now(),
      isAnonymous: json['isAnonymous'] ?? true,
      mentions: List<String>.from(json['mentions'] ?? []),
      likesCount: json['likesCount']?.toInt() ?? 0,
      commentsCount: json['commentsCount']?.toInt() ?? 0,
      isDeleted: json['isDeleted'] ?? false,
      isReported: json['isReported'] ?? false,
      reportReason: json['reportReason']?.toString(),
      isLikedByCurrentUser: json['isLikedByCurrentUser']?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'category': category,
    'userId': userId,
    'createdAt': createdAt.toIso8601String(),
    'isAnonymous': isAnonymous,
    'mentions': mentions,
    'likesCount': likesCount,
    'commentsCount': commentsCount,
    'isDeleted': isDeleted,
    'isReported': isReported,
    'reportReason': reportReason,
    'isLikedByCurrentUser': isLikedByCurrentUser,
  };

  Confession({
    required this.id,
    required this.content,
    required this.category,
    required this.userId,
    required this.createdAt,
    required this.isAnonymous,
    required this.mentions,
    required this.likesCount,
    required this.commentsCount,
    required this.isDeleted,
    required this.isReported,
    this.reportReason,
    this.isLikedByCurrentUser = false,
  });

  Confession copyWith({
    String? id,
    String? content,
    String? category,
    String? userId,
    DateTime? createdAt,
    bool? isAnonymous,
    List<String>? mentions,
    int? likesCount,
    int? commentsCount,
    bool? isDeleted,
    bool? isReported,
    String? reportReason,
    bool? isLikedByCurrentUser,
  }) {
    return Confession(
      id: id ?? this.id,
      content: content ?? this.content,
      category: category ?? this.category,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      mentions: mentions ?? List<String>.from(this.mentions),
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isDeleted: isDeleted ?? this.isDeleted,
      isReported: isReported ?? this.isReported,
      reportReason: reportReason ?? this.reportReason,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Confession &&
        other.id == id &&
        other.content == content &&
        other.category == category &&
        other.userId == userId &&
        other.createdAt == createdAt &&
        other.isAnonymous == isAnonymous &&
        const ListEquality().equals(other.mentions, mentions) &&
        other.likesCount == likesCount &&
        other.commentsCount == commentsCount &&
        other.isDeleted == isDeleted &&
        other.isReported == isReported &&
        other.reportReason == reportReason;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      content,
      category,
      userId,
      createdAt,
      isAnonymous,
      Object.hashAll(mentions),
      likesCount,
      commentsCount,
      isDeleted,
      isReported,
      reportReason,
    );
  }
}