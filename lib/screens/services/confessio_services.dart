import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:friends/constants/global_variables.dart';
import 'package:friends/constants/utils.dart';
import 'package:friends/model/confession.dart';
import 'package:friends/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ConfessionService {
  Future<Confession?> sendConfession({
    required BuildContext context,
    required String content,
    required String category,
    required String userId,
    required bool isAnonymous,
    List<String> mentions = const [],
    String? reportReason,  // Added optional reportReason
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.user.token;
      
      if (token == null || token.isEmpty) {
        throw const HttpException('Authentication token not found');
      }

      if (content.isEmpty || category.isEmpty || userId.isEmpty) {
        throw const HttpException('Required fields cannot be empty');
      }

      final payload = {
        'content': content,
        'category': category,
        'userId': userId,
        'isAnonymous': isAnonymous,
        'mentions': mentions,
        'createdAt': DateTime.now().toIso8601String(),
        'reportReason': reportReason,
      };

      final response = await http.post(
        Uri.parse('$uri/api/sendConfession'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return Confession.fromJson(responseData);
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>?;
        throw HttpException(errorData?['error'] ?? 'Failed to send confession');
      }
    } catch (e) {
      print('Service Error: $e');
      rethrow;
    }
  }


    Future<List<Confession>> fetchConfessionsAfterDate({
    required BuildContext context,
    required DateTime timestamp,
    int limit = 50,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.user.token;
      
      if (token == null || token.isEmpty) {
        throw const HttpException('Authentication token not found');
      }

      final queryParams = {
        'timestamp': timestamp.toIso8601String(),
        'limit': limit.toString(),
      };

      final uris = Uri.parse('$uri/api/confessions/after').replace(queryParameters: queryParams);

      final response = await http.get(
        uris,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData
            .map((json) => Confession.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>?;
        throw HttpException(errorData?['error'] ?? 'Failed to fetch confessions');
      }
    } catch (e) {
      print('Service Error: $e');
      rethrow;
    }
  }





  Future<Confession> sendConfessionReport({
  required BuildContext context,
  required String confessionId,
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

    if (confessionId.isEmpty || userId.isEmpty || reportReason.isEmpty) {
      throw const HttpException('Required fields cannot be empty');
    }

    final payload = {
      'confessionId': confessionId,
      'userId': userId,
      'isReported': isReported,
      'reportReason': reportReason,
    };

    print('Sending report payload:');
    print(jsonEncode(payload));

    final response = await http.post(
      Uri.parse('$uri/api/confessions/report'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
      body: jsonEncode(payload),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      try {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>?;
        throw HttpException(errorData?['error'] ?? 'Failed to report confession');
      } catch (e) {
        throw HttpException(
          response.body.isNotEmpty
              ? 'Server error: ${response.body}'
              : 'Failed to report confession (Status: ${response.statusCode})'
        );
      }
    }

    // Parse the updated confession from response
    final updatedConfession = Confession.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>
    );
    
    return updatedConfession;
  } catch (e) {
    print('Service Error: $e');
    rethrow;
  }
}

  
}