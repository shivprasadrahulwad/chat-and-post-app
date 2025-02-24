import 'dart:convert';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:friends/model/user_preview.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart'; 
import 'package:friends/constants/global_variables.dart';
import 'package:friends/model/post.dart';
import 'package:friends/providers/user_provider.dart';
import 'package:provider/provider.dart';

class PostService {

    final cloudinary = CloudinaryPublic('dybzzlqhv', 'se7irpmg', cache: false);
  
  Future<String?> uploadImageToCloudinary(File imageFile) async {
    try {
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist');
      }

      final cloudinaryFile = CloudinaryFile.fromFile(
        imageFile.path,
        folder: 'posts',
        resourceType: CloudinaryResourceType.Image,
      );

      final response = await cloudinary.uploadFile(cloudinaryFile);
      print('Cloudinary upload response: ${response.secureUrl}');
      return response.secureUrl;
    } on CloudinaryException catch (e) {
      print('Cloudinary specific error: $e');
      throw Exception('Failed to upload to Cloudinary: $e');
    } catch (e) {
      print('General upload error: $e');
      throw Exception('Image upload failed: $e');
    }
  }

Future<Post?> sendPost({
  required BuildContext context,
  required String content,
  required String userId,
  String? mediaUrl,
  List<String> mentions = const [],
}) async {
  try {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.user.token;
    final currentUser = userProvider.user;

    if (token == null || token.isEmpty) {
      throw const HttpException('Authentication token not found');
    }

    if (userId.isEmpty || content.isEmpty) {
      throw const HttpException('Required fields cannot be empty');
    }

    // Create UserPreview using the fromUser factory
    final userPreview = UserPreview(
      id: currentUser.id,
      username: currentUser.username,
      name: currentUser.name,
      profileImage: currentUser.avatar,
    );

    // Debug logging for user preview
    print('UserPreview data:');
    print(userPreview.toJson());

    final payload = {
      'content': content,
      'userId': userId,
      'mediaUrl': mediaUrl,
      'user': userPreview.toJson(),
      'mentions': mentions,
      'createdAt': DateTime.now().toIso8601String(),
    };

    // Debug logging for final payload
    print('Final payload:');
    print(jsonEncode(payload));

    final response = await http.post(
      Uri.parse('$uri/api/sendPost'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
      body: jsonEncode(payload),
    );

    // Debug logging for response
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return Post.fromJson(responseData);
    } else {
      final errorData = jsonDecode(response.body) as Map<String, dynamic>?;
      throw HttpException(errorData?['error'] ?? 'Failed to send post');
    }
  } catch (e) {
    print('Service Error: $e');
    rethrow;
  }
}

Future<void> sendReport({
  required BuildContext context,
  required String postId,
  required String userId,
  required String reportReason,
  bool isReported = true,
}) async {
  try {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.user.token;

    if (token == null || token.isEmpty) {
      throw const HttpException('Authentication token not found');
    }

    if (postId.isEmpty || userId.isEmpty || reportReason.isEmpty) {
      throw const HttpException('Required fields cannot be empty');
    }

    final payload = {
      'postId': postId,
      'userId': userId,
      'isReported': isReported,
      'reportReason': reportReason,
    };

    print('Final report payload:');
    print(jsonEncode(payload));

    final response = await http.post(
      Uri.parse('$uri/api/reportPost'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
      body: jsonEncode(payload),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    // Improved error handling
    if (response.statusCode != 200) {
      // Try to parse JSON error first
      try {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>?;
        throw HttpException(errorData?['error'] ?? 'Failed to report post');
      } catch (e) {
        // If JSON parsing fails, use the raw response body or a default message
        throw HttpException(
          response.body.isNotEmpty 
              ? 'Server error: ${response.body}'
              : 'Failed to report post (Status: ${response.statusCode})'
        );
      }
    }
  } catch (e) {
    print('Service Error: $e');
    rethrow;
  }
}

Future<List<Post>> fetchPostsAfterDate({
  required BuildContext context,
  required DateTime afterDate,
}) async {
  try {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.user.token;

    if (token == null || token.isEmpty) {
      throw const HttpException('Authentication token not found');
    }

    final queryParams = {
      'afterDate': afterDate.toIso8601String(),
    };

    final uris = Uri.parse('$uri/api/posts').replace(queryParameters: queryParams);
    
    final response = await http.get(
      uris,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> postsJson = jsonDecode(response.body);
      return postsJson.map((json) => Post.fromJson(json)).toList();
    } else {
      final errorData = jsonDecode(response.body) as Map<String, dynamic>?;
      throw HttpException(errorData?['error'] ?? 'Failed to fetch posts');
    }
  } catch (e) {
    print('Service Error: $e');
    rethrow;
  }
}







/////////////////  hive post///////////

  static const String _boxName = 'posts';
  late Box<Post> _box;
  
  Future<void> init() async {
    _box = await Hive.openBox<Post>(_boxName);
  }

  Future<void> savePost(Post post) async {
    await _box.put(post.id, post);
  }

  Future<void> savePosts(List<Post> posts) async {
    final Map<String, Post> entries = {
      for (var post in posts) post.id: post
    };
    await _box.putAll(entries);
  }

  List<Post> getAllPosts() {
    return _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> updatePostLikes(String postId, List<String> newLikes) async {
    final post = _box.get(postId);
    if (post != null) {
      final updatedPost = post.copyWith(likes: newLikes);
      await _box.put(postId, updatedPost);
    }
  }

  Future<void> deletePost(String postId) async {
    await _box.delete(postId);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}