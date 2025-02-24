import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:friends/constants/global_variables.dart';
import 'package:friends/model/comment.dart';
import 'package:friends/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class CommentServices {
  static Future<Comment?> sendComment({
    required BuildContext context,
    required String content,
    required String postId,
    required String postType,
    required String userId,
    String? parentId,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.user.token;

      print('Starting comment send process...');

      if (token == null || token.isEmpty) {
        throw const HttpException('Authentication token not found');
      }

      // Validate MongoDB ObjectID format
      if (!isValidObjectId(postId) || !isValidObjectId(userId)) {
        throw const HttpException('Invalid post ID or user ID format');
      }

      if (parentId != null && !isValidObjectId(parentId)) {
        throw const HttpException('Invalid parent comment ID format');
      }

      final payload = {
        'content': content,
        'postId': postId,
        'postType': postType,
        'userId': userId,
        if (parentId != null) 'parentId': parentId,
        'createdAt': DateTime.now().toIso8601String(),
      };

      final url = '$uri/api/sendComment';
      print('Sending request to: $url');
      print('Headers: ${{'Content-Type': 'application/json', 'x-auth-token': token}}');
      print('Payload: ${jsonEncode(payload)}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(payload),
      );

      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return Comment.fromJson(responseData);
      } else {
        String errorMessage;
        try {
          final errorData = jsonDecode(response.body) as Map<String, dynamic>?;
          errorMessage = errorData?['error'] ?? 'Failed to send comment';
        } catch (e) {
          errorMessage = 'Server error: ${response.body}';
        }
        throw HttpException(errorMessage);
      }
    } catch (e) {
      print('Service Error: $e');
      rethrow;
    }
  }

  static Future<List<Comment>> getComments({
    required BuildContext context,
    required String postId,
    required String postType,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.user.token;

      if (token == null || token.isEmpty) {
        throw const HttpException('Authentication token not found');
      }

      if (!isValidObjectId(postId)) {
        throw const HttpException('Invalid post ID format');
      }

      final response = await http.get(
        Uri.parse('$uri/api/comments/$postId?postType=$postType'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((json) => Comment.fromJson(json)).toList();
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>?;
        throw HttpException(errorData?['error'] ?? 'Failed to fetch comments');
      }
    } catch (e) {
      print('Service Error: $e');
      rethrow;
    }
  }

  // Helper method to validate MongoDB ObjectID format
  static bool isValidObjectId(String id) {
    // MongoDB ObjectID is a 24-character hex string
    RegExp objectIdPattern = RegExp(r'^[0-9a-fA-F]{24}$');
    return objectIdPattern.hasMatch(id);
  }
}