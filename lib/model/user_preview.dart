// import 'package:friends/models/user.dart';

// class UserPreview {
//   final String id;
//   final String username;
//   final String? name;
//   final String? profileImage;

//   UserPreview({
//     required this.id,
//     required this.username,
//     this.name,
//     this.profileImage,
//   });

//   factory UserPreview.fromUser(User user) {
//     return UserPreview(
//       id: user.id,
//       username: user.username,
//       name: user.name,
//       profileImage: user.avatar,
//     );
//   }

//   factory UserPreview.fromJson(Map<String, dynamic> json) {
//     return UserPreview(
//       id: json['id'],
//       username: json['username'],
//       name: json['name'],
//       profileImage: json['profileImage'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'username': username,
//       if (name != null) 'name': name,
//       if (profileImage != null) 'profileImage': profileImage,
//     };
//   }
// }


import 'package:friends/models/user.dart';
import 'package:hive/hive.dart';

part 'user_preview.g.dart';

@HiveType(typeId: 17)  // Make sure this typeId is unique across your Hive types
class UserPreview {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String username;
  
  @HiveField(2)
  final String? name;
  
  @HiveField(3)
  final String? profileImage;

  UserPreview({
    required this.id,
    required this.username,
    this.name,
    this.profileImage,
  });

  factory UserPreview.fromUser(User user) {
    return UserPreview(
      id: user.id,
      username: user.username,
      name: user.name,
      profileImage: user.avatar,
    );
  }

  factory UserPreview.fromJson(Map<String, dynamic> json) {
    return UserPreview(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      if (name != null) 'name': name,
      if (profileImage != null) 'profileImage': profileImage,
    };
  }
}