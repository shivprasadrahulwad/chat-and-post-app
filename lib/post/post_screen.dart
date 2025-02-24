import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:friends/model/post.dart';
import 'package:friends/model/user_preview.dart';
import 'package:friends/post/create_post_screen.dart';
import 'package:friends/post/post_card_widget.dart';
import 'package:friends/screens/services/post_services.dart';
import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:io';
import 'dart:convert';

import 'package:uuid/uuid.dart';

// class PostScreen extends StatefulWidget {
//   final String name;
//   final String userId;

//   const PostScreen({
//     super.key,
//     required this.name,
//     required this.userId,
//   });

//   @override
//   State<PostScreen> createState() => _PostScreenState();
// }

// class _PostScreenState extends State<PostScreen> {
//   late final IO.Socket socket;
//   late final PostService postService;
//   List<Post> listPost = [];
//   Box<Post>? postsBox;
//   bool isLoading = true; // Add loading state
//   static const String postsBoxName = 'posts';
  

//     @override
//   void initState() {
//     super.initState();
//     postService = PostService();
//     _initialize();
//   }

//    Future<void> _initialize() async {
//     try {
//       // Initialize socket first
//       _initializeSocket();
      
//       // Then initialize Hive
//       await _initializeHive();
      
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Initialization error: $e');
//       setState(() {
//         isLoading = false;
//       });
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to initialize: $e')),
//         );
//       }
//     }
//   }

//   void _initializeSocket() {
//     socket = IO.io("http://192.168.1.104:5000", <String, dynamic>{
//       "transports": ["websocket"],
//       "autoConnect": false,
//     });
//     connect();
//   }

//   Future<void> _initializeHive() async {
//     if (!Hive.isBoxOpen(postsBoxName)) {
//       postsBox = await Hive.openBox<Post>(postsBoxName);
//     } else {
//       postsBox = Hive.box<Post>(postsBoxName);
//     }
//     _loadLocalPosts();
//   }
//   void _loadLocalPosts() {
//     if (postsBox != null) {
//       setState(() {
//         listPost = postsBox!.values.toList()
//           ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
//       });
//     }
//   }
  

//   Future<void> _savePostToHive(Post post) async {
//     if (postsBox == null) {
//       await _initializeHive();
//     }
//     await postsBox?.put(post.id, post);
//     _loadLocalPosts();
//   }

//   void _navigateToCreatePost() async {
//     if (postsBox == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please wait while the app initializes...')),
//       );
//       return;
//     }

//     final PostData? result = await Navigator.push<PostData>(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const CreatePostScreen(),
//       ),
//     );

//     if (result != null) {
//       await _processPost(result);
//     }
//   }

// Future<void> _processPost(PostData postData) async {
//   if (postsBox == null) {
//     throw Exception('Storage not initialized');
//   }

//   print('Processing post with content: ${postData.content}');
//   print('Number of images: ${postData.images.length}');
  
//   try {
//     String? mediaUrl;
//     String? base64Image;

//     if (postData.images.isNotEmpty) {
//       try {
//         File imageFile = postData.images.first;
//         if (!await imageFile.exists()) {
//           throw Exception('Image file not found');
//         }

//         int fileSize = await imageFile.length();
//         if (fileSize > 10 * 1024 * 1024) {
//           throw Exception('Image file too large (max 10MB)');
//         }

//         // First upload image to Cloudinary
//         mediaUrl = await postService.uploadImageToCloudinary(imageFile);
//         print('Successfully uploaded to Cloudinary: $mediaUrl');

//         if (mediaUrl == null || mediaUrl.isEmpty) {
//           throw Exception('Failed to get upload URL');
//         }

//         // Convert to base64 for socket
//         base64Image = await _imageToBase64(imageFile);

//         // Send to server to get MongoDB ID
//         final Post? savedPost = await postService.sendPost(
//           context: context,
//           content: postData.content,
//           userId: widget.userId,
//           userName: widget.name,
//           mediaUrl: mediaUrl,
//         );

//         if (savedPost != null) {
//           // Create new post with server-generated ID
//           final newPost = Post(
//             id: savedPost.id, // Use server ID instead of UUID
//             userId: widget.userId,
//             caption: postData.content,
//             mediaUrl: mediaUrl,
//             likes: [],
//             createdAt: DateTime.now(),
//             user: UserPreview(
//               id: widget.userId,
//               username: widget.name,
//             ),
//             commentCount: 0,
//           );

//           // Save to Hive with server ID
//           await _savePostToHive(newPost);

//           // Prepare socket message with server ID
//           Map<String, dynamic> messageData = {
//             'type': 'post',
//             'postId': savedPost.id, // Use server ID
//             'msg': postData.content,
//             'senderName': widget.name,
//             'userId': widget.userId,
//             'mediaUrl': mediaUrl,
//             'mediaData': base64Image,
//             'mediaType': 'image/jpeg',
//             'createdAt': savedPost.createdAt.toIso8601String(),
//           };

//           socket.emit('sendMsg', messageData);
//         }
//       } catch (e) {
//         print('Error processing image: $e');
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Failed to upload image: ${e.toString()}'),
//               duration: const Duration(seconds: 4),
//             ),
//           );
//         }
//       }
//     } else {
//       // Text-only post
//       try {
//         // Send to server first to get MongoDB ID
//         final Post? savedPost = await postService.sendPost(
//           context: context,
//           content: postData.content,
//           userId: widget.userId,
//           userName: widget.name,
//         );

//         if (savedPost != null) {
//           // Create new post with server ID
//           final newPost = Post(
//             id: savedPost.id, // Use server ID
//             userId: widget.userId,
//             caption: postData.content,
//             likes: [],
//             createdAt: DateTime.now(),
//             user: UserPreview(
//               id: widget.userId,
//               username: widget.name,
//             ),
//             commentCount: 0,
//           );

//           // Save to Hive with server ID
//           await _savePostToHive(newPost);

//           // Prepare socket message with server ID
//           Map<String, dynamic> messageData = {
//             'type': 'post',
//             'postId': savedPost.id, // Use server ID
//             'msg': postData.content,
//             'senderName': widget.name,
//             'userId': widget.userId,
//             'createdAt': savedPost.createdAt.toIso8601String(),
//           };

//           socket.emit('sendMsg', messageData);
//         }
//       } catch (e) {
//         print('Error processing text post: $e');
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Failed to create text post: ${e.toString()}'),
//               duration: const Duration(seconds: 4),
//             ),
//           );
//         }
//       }
//     }
//   } catch (e) {
//     print('Error in _processPost: $e');
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to create post: ${e.toString()}'),
//           duration: const Duration(seconds: 4),
//         ),
//       );
//     }
//   }
// }


//   Future<String> _imageToBase64(File imageFile) async {
//     List<int> imageBytes = await imageFile.readAsBytes();
//     String base64Image = base64Encode(imageBytes);
//     return base64Image;
//   }

//   void handlePostLike(String postId) {
//     print('Handling like for post: $postId');
//     int postIndex = listPost.indexWhere((post) => post.id == postId);
//     if (postIndex == -1) {
//       print('Post not found: $postId');
//       return;
//     }

//     Post post = listPost[postIndex];
//     bool isLiked = post.likes.contains(widget.userId);
    
//     // Emit like event
//     Map<String, dynamic> likeData = {
//       'postId': postId,
//       'userId': widget.userId,
//       'senderName': widget.name,
//       'action': isLiked ? 'unlike' : 'like'
//     };
//     print('Emitting like data: $likeData');
//     socket.emit('likePost', likeData);
//   }

//   void _handleLikeUpdate(Map<String, dynamic> data) {
//     print('Handling like update: $data');
    
//     setState(() {
//       int postIndex = listPost.indexWhere((post) => post.id == data['postId']);
//       if (postIndex != -1) {
//         Post updatedPost = Post(
//           id: listPost[postIndex].id,
//           userId: listPost[postIndex].userId,
//           caption: listPost[postIndex].caption,
//           mediaUrl: listPost[postIndex].mediaUrl,
//           likes: List<String>.from(listPost[postIndex].likes),
//           createdAt: listPost[postIndex].createdAt,
//           user: listPost[postIndex].user,
//           commentCount: listPost[postIndex].commentCount,
//         );

//         if (data['action'] == 'like') {
//           if (!updatedPost.likes.contains(data['userId'])) {
//             updatedPost.likes.add(data['userId']);
//             print('Added like from user: ${data['userId']}');
//           }
//         } else {
//           updatedPost.likes.remove(data['userId']);
//           print('Removed like from user: ${data['userId']}');
//         }

//         listPost[postIndex] = updatedPost;
//         print('Updated post ${data['postId']} likes count: ${updatedPost.likes.length}');
//       }
//     });
//   }

//  void connect() {
//     socket.connect();
//     socket.onConnect((_) {
//       print('Connected to frontend');
//       socket.emit('joinGroup', 'post_group');
      
//       socket.on('sendMsgServer', (msg) async {
//         print('Received message from server: $msg');
        
//         if (postsBox != null) {  // Add null check
//           // Check if post already exists locally
//           Post? existingPost = postsBox!.get(msg['postId']);
//           if (existingPost == null) {
//             Post newPost = Post(
//               id: msg['postId'] ?? DateTime.now().toString(),
//               userId: msg['userId'],
//               caption: msg['msg'],
//               mediaUrl: msg['mediaUrl'],
//               likes: List<String>.from(msg['likes'] ?? []),
//               createdAt: DateTime.parse(msg['createdAt'] ?? DateTime.now().toIso8601String()),
//               user: UserPreview(
//                 id: msg['userId'],
//                 username: msg['senderName'],
//               ),
//               commentCount: msg['commentCount'] ?? 0,
//             );
            
//             await _savePostToHive(newPost);
//           }
//         }
//       });

//       socket.on('likeUpdateServer', (data) {
//         print('Received like update: $data');
//         _handleLikeUpdate(data);
//       });
//     });

//     socket.on('connect_error', (error) {
//       print('Connection error: $error');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Connection error: ${error.toString()}')),
//         );
//       }
//     });

//     socket.on('connect_timeout', (timeout) {
//       print('Connection timeout: $timeout');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Connection timeout: ${timeout.toString()}')),
//         );
//       }
//     });
//   }

//   void updateLikeStatus(String postId, String userId, bool isLiking) {
//     print('Updating like status for post: $postId, user: $userId, isLiking: $isLiking');
    
//     setState(() {
//       int postIndex = listPost.indexWhere((post) => post.id == postId);
//       if (postIndex != -1) {
//         if (isLiking) {
//           if (!listPost[postIndex].likes.contains(userId)) {
//             listPost[postIndex].likes.add(userId);
//             print('Added like to post $postId');
//           }
//         } else {
//           listPost[postIndex].likes.remove(userId);
//           print('Removed like from post $postId');
//         }
//         print('New like count for post $postId: ${listPost[postIndex].likes.length}');
//       } else {
//         print('Post not found for updating like status: $postId');
//       }
//     });
//   }
  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.name,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Column(
//         children: [
//   Expanded(
//             child: ListView.builder(
//               itemCount: listPost.length,
//               itemBuilder: (context, index) {
//                 final post = listPost[index];
//                 return PostCardWidget(
//                   post: post,
//                   currentUser: UserPreview(
//                     id: widget.userId,
//                     username: widget.name,
//                   ),
//                   onLike: handlePostLike,
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _navigateToCreatePost,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     socket.dispose();
//     postsBox?.close();
//     super.dispose();
//   }
// }












// class PostScreen extends StatefulWidget {
//   final String name;
//   final String userId;

//   const PostScreen({
//     super.key,
//     required this.name,
//     required this.userId,
//   });

//   @override
//   State<PostScreen> createState() => _PostScreenState();
// }

// class _PostScreenState extends State<PostScreen> {
//   late final IO.Socket socket;
//   late final PostService postService;
//   List<Post> listPost = [];
//   Box<Post>? postsBox;
//   bool isLoading = true; // Add loading state
//   static const String postsBoxName = 'posts';
//   late Future<void> _initializationFuture;

//     @override
//   void initState() {
//     super.initState();
//     postService = PostService();
//     _initializationFuture = _initialize();
//   }

// @override
//   Future<void> _initialize() async {
//     try {
//       _initializeSocket();
//       await _initializeHive();
//       await _syncPosts();
      
//       // Add debug print after initialization
//       await _debugPrintHiveContents();
      
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Initialization error: $e');
//       setState(() {
//         isLoading = false;
//       });
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to initialize: $e')),
//         );
//       }
//     }
//   }

//   Future<void> _syncPosts() async {
//     if (postsBox == null) return;

//     try {
//       // Get the most recent post date from Hive
//       DateTime? lastUpdateTime;
//       if (postsBox!.isNotEmpty) {
//         lastUpdateTime = postsBox!.values
//             .map((post) => post.createdAt)
//             .reduce((a, b) => a.isAfter(b) ? a : b);
//       }

//       // If no posts in Hive, fetch last 7 days' posts
//       lastUpdateTime ??= DateTime.now().subtract(const Duration(days: 7));

//       // Fetch posts from server after the last update time
//       final List<Post> serverPosts = await postService.fetchPostsAfterDate(
//         context: context,
//         afterDate: lastUpdateTime,
//       );

//       // Update existing posts and add new ones
//       await Future.forEach(serverPosts, (Post serverPost) async {
//         Post? existingPost = postsBox!.get(serverPost.id);
        
//         if (existingPost != null) {
//           // Update if the server post is different
//           if (_hasPostChanged(existingPost, serverPost)) {
//             await postsBox!.put(serverPost.id, serverPost);
//           }
//         } else {
//           // Add new post
//           await postsBox!.put(serverPost.id, serverPost);
//         }
//       });

//       // Load ALL posts from Hive, not just the newly synced ones
//       _loadLocalPosts();
//     } catch (e) {
//       print('Error syncing posts: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to sync posts: $e')),
//         );
//       }
//     }
//   }


//     bool _hasPostChanged(Post localPost, Post serverPost) {
//     return localPost.content != serverPost.content ||
//         localPost.mediaUrl != serverPost.mediaUrl ||
//         !listEquals(localPost.likes, serverPost.likes) ||
//         localPost.commentCount != serverPost.commentCount;
//   }


//   void _initializeSocket() {
//     socket = IO.io("http://192.168.1.104:5000", <String, dynamic>{
//       "transports": ["websocket"],
//       "autoConnect": false,
//     });
//     connect();
//   }

//   Future<void> _initializeHive() async {
//     if (!Hive.isBoxOpen(postsBoxName)) {
//       postsBox = await Hive.openBox<Post>(postsBoxName);
//     } else {
//       postsBox = Hive.box<Post>(postsBoxName);
//     }
//     _loadLocalPosts();
//   }
  

// void _loadLocalPosts() {
//     if (postsBox != null) {
//       setState(() {
//         // Get ALL posts from Hive
//         listPost = postsBox!.values.toList()
//           ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        
//         print('Loaded ${listPost.length} posts from Hive');
//       });
//     }
//   }

//   Future<void> _debugPrintHiveContents() async {
//     if (postsBox != null) {
//       print('Total posts in Hive: ${postsBox!.length}');
//       print('Posts in listPost: ${listPost.length}');
      
//       final posts = postsBox!.values.toList()
//         ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
//       for (var post in posts) {
//         print('Post ID: ${post.id}, Created: ${post.createdAt}');
//       }
//     }
//   }
  

//   Future<void> _savePostToHive(Post post) async {
//     if (postsBox == null) {
//       await _initializeHive();
//     }
//     await postsBox?.put(post.id, post);
//     _loadLocalPosts();
//   }

//   void _navigateToCreatePost() async {
//     if (postsBox == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please wait while the app initializes...')),
//       );
//       return;
//     }

//     final PostData? result = await Navigator.push<PostData>(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const CreatePostScreen(),
//       ),
//     );

//     if (result != null) {
//       await _processPost(result);
//     }
//   }

// Future<void> _processPost(PostData postData) async {
//   if (postsBox == null) {
//     throw Exception('Storage not initialized');
//   }

//   print('Processing post with content: ${postData.content}');
//   print('Number of images: ${postData.images.length}');
  
//   try {
//     String? mediaUrl;
//     String? base64Image;

//     if (postData.images.isNotEmpty) {
//       try {
//         File imageFile = postData.images.first;
//         if (!await imageFile.exists()) {
//           throw Exception('Image file not found');
//         }

//         int fileSize = await imageFile.length();
//         if (fileSize > 10 * 1024 * 1024) {
//           throw Exception('Image file too large (max 10MB)');
//         }

//         // First upload image to Cloudinary
//         mediaUrl = await postService.uploadImageToCloudinary(imageFile);
//         print('Successfully uploaded to Cloudinary: $mediaUrl');

//         if (mediaUrl == null || mediaUrl.isEmpty) {
//           throw Exception('Failed to get upload URL');
//         }

//         // Convert to base64 for socket
//         base64Image = await _imageToBase64(imageFile);

//         // Send to server to get MongoDB ID
//         final Post? savedPost = await postService.sendPost(
//           context: context,
//           content: postData.content,
//           userId: widget.userId,
//           mediaUrl: mediaUrl,
//         );

//         if (savedPost != null) {
//           // Create new post with server-generated ID
//           final newPost = Post(
//             id: savedPost.id, // Use server ID instead of UUID
//             userId: widget.userId,
//             content: postData.content,
//             mediaUrl: mediaUrl,
//             likes: [],
//             createdAt: DateTime.now(),
//             user: UserPreview(
//               id: widget.userId,
//               username: widget.name,
//             ),
//             commentCount: 0,
//             isDeleted: false,
//           );

//           // Save to Hive with server ID
//           await _savePostToHive(newPost);

//           // Prepare socket message with server ID
//           Map<String, dynamic> messageData = {
//             'type': 'post',
//             'postId': savedPost.id, // Use server ID
//             'msg': postData.content,
//             'senderName': widget.name,
//             'userId': widget.userId,
//             'mediaUrl': mediaUrl,
//             'mediaData': base64Image,
//             'mediaType': 'image/jpeg',
//             'createdAt': savedPost.createdAt.toIso8601String(),
//           };

//           socket.emit('sendMsg', messageData);
//         }
//       } catch (e) {
//         print('Error processing image: $e');
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Failed to upload image: ${e.toString()}'),
//               duration: const Duration(seconds: 4),
//             ),
//           );
//         }
//       }
//     } else {
//       // Text-only post
//       try {
//         // Send to server first to get MongoDB ID
//         final Post? savedPost = await postService.sendPost(
//           context: context,
//           content: postData.content,
//           userId: widget.userId,
//         );

//         if (savedPost != null) {
//           // Create new post with server ID
//           final newPost = Post(
//             id: savedPost.id, // Use server ID
//             userId: widget.userId,
//             content: postData.content,
//             likes: [],
//             createdAt: DateTime.now(),
//             user: UserPreview(
//               id: widget.userId,
//               username: widget.name,
//             ),
//             commentCount: 0,
//             isDeleted: false,
//           );

//           // Save to Hive with server ID
//           await _savePostToHive(newPost);

//           // Prepare socket message with server ID
//           Map<String, dynamic> messageData = {
//             'type': 'post',
//             'postId': savedPost.id, // Use server ID
//             'msg': postData.content,
//             'senderName': widget.name,
//             'userId': widget.userId,
//             'createdAt': savedPost.createdAt.toIso8601String(),
//           };

//           socket.emit('sendMsg', messageData);
//         }
//       } catch (e) {
//         print('Error processing text post: $e');
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Failed to create text post: ${e.toString()}'),
//               duration: const Duration(seconds: 4),
//             ),
//           );
//         }
//       }
//     }
//   } catch (e) {
//     print('Error in _processPost: $e');
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to create post: ${e.toString()}'),
//           duration: const Duration(seconds: 4),
//         ),
//       );
//     }
//   }
// }


//   Future<String> _imageToBase64(File imageFile) async {
//     List<int> imageBytes = await imageFile.readAsBytes();
//     String base64Image = base64Encode(imageBytes);
//     return base64Image;
//   }

//   void handlePostLike(String postId) {
//     print('Handling like for post: $postId');
//     int postIndex = listPost.indexWhere((post) => post.id == postId);
//     if (postIndex == -1) {
//       print('Post not found: $postId');
//       return;
//     }

//     Post post = listPost[postIndex];
//     bool isLiked = post.likes.contains(widget.userId);
    
//     // Emit like event
//     Map<String, dynamic> likeData = {
//       'postId': postId,
//       'userId': widget.userId,
//       'senderName': widget.name,
//       'action': isLiked ? 'unlike' : 'like'
//     };
//     print('Emitting like data: $likeData');
//     socket.emit('likePost', likeData);
//   }

//   void _handleLikeUpdate(Map<String, dynamic> data) {
//     print('Handling like update: $data');
    
//     setState(() {
//       int postIndex = listPost.indexWhere((post) => post.id == data['postId']);
//       if (postIndex != -1) {
//         Post updatedPost = Post(
//           id: listPost[postIndex].id,
//           userId: listPost[postIndex].userId,
//           content: listPost[postIndex].content,
//           mediaUrl: listPost[postIndex].mediaUrl,
//           likes: List<String>.from(listPost[postIndex].likes),
//           createdAt: listPost[postIndex].createdAt,
//           user: listPost[postIndex].user,
//           commentCount: listPost[postIndex].commentCount,
//           isDeleted: listPost[postIndex].isDeleted,
//         );

//         if (data['action'] == 'like') {
//           if (!updatedPost.likes.contains(data['userId'])) {
//             updatedPost.likes.add(data['userId']);
//             print('Added like from user: ${data['userId']}');
//           }
//         } else {
//           updatedPost.likes.remove(data['userId']);
//           print('Removed like from user: ${data['userId']}');
//         }

//         listPost[postIndex] = updatedPost;
//         print('Updated post ${data['postId']} likes count: ${updatedPost.likes.length}');
//       }
//     });
//   }

//  void connect() {
//     socket.connect();
//     socket.onConnect((_) {
//       print('Connected to frontend');
//       socket.emit('joinGroup', 'post_group');
      
//       socket.on('sendMsgServer', (msg) async {
//         print('Received message from server: $msg');
        
//         if (postsBox != null) {  // Add null check
//           // Check if post already exists locally
//           Post? existingPost = postsBox!.get(msg['postId']);
//           if (existingPost == null) {
//             Post newPost = Post(
//               id: msg['postId'] ?? DateTime.now().toString(),
//               userId: msg['userId'],
//               content: msg['msg'],
//               mediaUrl: msg['mediaUrl'],
//               likes: List<String>.from(msg['likes'] ?? []),
//               createdAt: DateTime.parse(msg['createdAt'] ?? DateTime.now().toIso8601String()),
//               user: UserPreview(
//             id: msg['userId'],
//             username: msg['senderName'],
//             name: msg['userName'], // Add name from server
//             profileImage: msg['userProfileImage'], // Add profile image from server
//           ),
//           commentCount: msg['commentCount'] ?? 0,
//           isDeleted: msg['isDeleted'] ?? false,
//           comments: [], // Initialize empty comments li
//             );
            
//             await _savePostToHive(newPost);
//           }
//         }
//       });

//       socket.on('likeUpdateServer', (data) {
//         print('Received like update: $data');
//         _handleLikeUpdate(data);
//       });
//     });

//     socket.on('connect_error', (error) {
//       print('Connection error: $error');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Connection error: ${error.toString()}')),
//         );
//       }
//     });

//     socket.on('connect_timeout', (timeout) {
//       print('Connection timeout: $timeout');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Connection timeout: ${timeout.toString()}')),
//         );
//       }
//     });
//   }

//   void updateLikeStatus(String postId, String userId, bool isLiking) {
//     print('Updating like status for post: $postId, user: $userId, isLiking: $isLiking');
    
//     setState(() {
//       int postIndex = listPost.indexWhere((post) => post.id == postId);
//       if (postIndex != -1) {
//         if (isLiking) {
//           if (!listPost[postIndex].likes.contains(userId)) {
//             listPost[postIndex].likes.add(userId);
//             print('Added like to post $postId');
//           }
//         } else {
//           listPost[postIndex].likes.remove(userId);
//           print('Removed like from post $postId');
//         }
//         print('New like count for post $postId: ${listPost[postIndex].likes.length}');
//       } else {
//         print('Post not found for updating like status: $postId');
//       }
//     });
//   }
  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.name,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//   body: FutureBuilder(
//         future: _initializationFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
          
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: listPost.length,
//                   itemBuilder: (context, index) {
//                     final post = listPost[index];
//                     return PostCardWidget(
//                       post: post,
//                       currentUser: UserPreview(
//                         id: widget.userId,
//                         username: widget.name,
//                       ),
//                       onLike: handlePostLike,
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _navigateToCreatePost,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     socket.dispose();
//     postsBox?.close();
//     super.dispose();
//   }
// }









class PostScreen extends StatefulWidget {
  final String name;
  final String userId;

  const PostScreen({
    super.key,
    required this.name,
    required this.userId,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late final IO.Socket socket;
  late final PostService postService;
  List<Post> listPost = [];
  Box<Post>? postsBox;
  bool isLoading = true; // Add loading state
  static const String postsBoxName = 'posts';
  late Future<void> _initializationFuture;

    @override
  void initState() {
    super.initState();
    postService = PostService();
    _initializationFuture = _initialize();
  }


  Future<void> _initialize() async {
    try {
      _initializeSocket();
      await _clearAndReinitializeHive();
      await _initializeHive();
      await _syncPosts();
      await _debugPrintHiveContents();
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Initialization error: $e');
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initialize: $e')),
        );
      }
    }
  }

  Future<void> _clearAndReinitializeHive() async {
  try {
    if (Hive.isBoxOpen(postsBoxName)) {
      await Hive.box<Post>(postsBoxName).clear();
      await Hive.box<Post>(postsBoxName).close();
    }
    await Hive.deleteBoxFromDisk(postsBoxName);
    await _initializeHive();
  } catch (e) {
    print('Error clearing Hive: $e');
  }
}

  Future<void> _syncPosts() async {
    if (postsBox == null) return;

    try {
      // Get the most recent post date from Hive
      DateTime? lastUpdateTime;
      if (postsBox!.isNotEmpty) {
        lastUpdateTime = postsBox!.values
            .map((post) => post.createdAt)
            .reduce((a, b) => a.isAfter(b) ? a : b);
      }

      // If no posts in Hive, fetch last 7 days' posts
      lastUpdateTime ??= DateTime.now().subtract(const Duration(days: 7));

      // Fetch posts from server after the last update time
      final List<Post> serverPosts = await postService.fetchPostsAfterDate(
        context: context,
        afterDate: lastUpdateTime,
      );

      // Update existing posts and add new ones
      await Future.forEach(serverPosts, (Post serverPost) async {
        Post? existingPost = postsBox!.get(serverPost.id);
        
        if (existingPost != null) {
          // Update if the server post is different
          if (_hasPostChanged(existingPost, serverPost)) {
            await postsBox!.put(serverPost.id, serverPost);
          }
        } else {
          // Add new post
          await postsBox!.put(serverPost.id, serverPost);
        }
      });

      // Load ALL posts from Hive, not just the newly synced ones
      _loadLocalPosts();
    } catch (e) {
      print('Error syncing posts: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sync posts: $e')),
        );
      }
    }
  }


bool _hasPostChanged(Post localPost, Post serverPost) {
    return localPost.content != serverPost.content ||
        localPost.mediaUrl != serverPost.mediaUrl ||
        !listEquals(localPost.likes, serverPost.likes) ||
        localPost.commentCount != serverPost.commentCount ||
        localPost.isDeleted != serverPost.isDeleted ||
        localPost.isReported != serverPost.isReported ||
        localPost.reportReason != serverPost.reportReason ||
        localPost.isLikedByCurrentUser != serverPost.isLikedByCurrentUser;
  }


  void _initializeSocket() {
    socket = IO.io("http://192.168.1.104:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    connect();
  }

  Future<void> _initializeHive() async {
    if (!Hive.isBoxOpen(postsBoxName)) {
      postsBox = await Hive.openBox<Post>(postsBoxName);
    } else {
      postsBox = Hive.box<Post>(postsBoxName);
    }
    _loadLocalPosts();
  }
  

void _loadLocalPosts() {
  if (postsBox != null) {
    var posts = postsBox!.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    setState(() {
      listPost = posts;
    });
    
    print('Loaded ${listPost.length} posts from Hive');
  }
}

  Future<void> _debugPrintHiveContents() async {
    if (postsBox != null) {
      print('Total posts in Hive: ${postsBox!.length}');
      print('Posts in listPost: ${listPost.length}');
      
      final posts = postsBox!.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      for (var post in posts) {
        print('Post ID: ${post.id}, Created: ${post.createdAt}');
      }
    }
  }
  

Future<void> _savePostToHive(Post post) async {
  if (postsBox == null) {
    await _initializeHive();
  }
  await postsBox?.put(post.id, post);
    _loadLocalPosts(); // Add await here
}

  void _navigateToCreatePost() async {
    if (postsBox == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait while the app initializes...')),
      );
      return;
    }

    final PostData? result = await Navigator.push<PostData>(
      context,
      MaterialPageRoute(
        builder: (context) => const CreatePostScreen(),
      ),
    );

    if (result != null) {
      await _processPost(result);
    }
  }

Future<void> _processPost(PostData postData) async {
  if (postsBox == null) {
    throw Exception('Storage not initialized');
  }

  print('Processing post with content: ${postData.content}');
  print('Number of images: ${postData.images.length}');
  
  try {
    String? mediaUrl;
    String? base64Image;

    if (postData.images.isNotEmpty) {
      try {
        File imageFile = postData.images.first;
        if (!await imageFile.exists()) {
          throw Exception('Image file not found');
        }

        int fileSize = await imageFile.length();
        if (fileSize > 10 * 1024 * 1024) {
          throw Exception('Image file too large (max 10MB)');
        }

        // First upload image to Cloudinary
        mediaUrl = await postService.uploadImageToCloudinary(imageFile);
        print('Successfully uploaded to Cloudinary: $mediaUrl');

        if (mediaUrl == null || mediaUrl.isEmpty) {
          throw Exception('Failed to get upload URL');
        }

        // Convert to base64 for socket
        base64Image = await _imageToBase64(imageFile);

        // Send to server to get MongoDB ID
        final Post? savedPost = await postService.sendPost(
          context: context,
          content: postData.content,
          userId: widget.userId,
          mediaUrl: mediaUrl,
        );

        if (savedPost != null) {
            final newPost = Post(
              id: savedPost.id,
              userId: widget.userId,
              content: postData.content,
              mediaUrl: mediaUrl,
              likes: [],
              comments: [],
              user: UserPreview(
                id: widget.userId,
                username: widget.name,
              ),
              commentCount: 0,
              createdAt: DateTime.now(),
              isDeleted: false,
              isReported: false,
              reportReason: null,
              isLikedByCurrentUser: false,
            );

          // Save to Hive with server ID
          await _savePostToHive(newPost);

          // Prepare socket message with server ID
          Map<String, dynamic> messageData = {
            'type': 'post',
            'postId': savedPost.id, // Use server ID
            'msg': postData.content,
            'senderName': widget.name,
            'userId': widget.userId,
            'mediaUrl': mediaUrl,
            'mediaData': base64Image,
            'mediaType': 'image/jpeg',
            'createdAt': savedPost.createdAt.toIso8601String(),
          };

          socket.emit('sendMsg', messageData);
        }
      } catch (e) {
        print('Error processing image: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to upload image: ${e.toString()}'),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } else {
      // Text-only post
      try {
        // Send to server first to get MongoDB ID
        final Post? savedPost = await postService.sendPost(
          context: context,
          content: postData.content,
          userId: widget.userId,
        );

        if (savedPost != null) {
          final newPost = Post(
            id: savedPost.id,
            userId: widget.userId,
            content: postData.content,
            likes: [],
            comments: [],
            user: UserPreview(
              id: widget.userId,
              username: widget.name,
            ),
            commentCount: 0,
            createdAt: DateTime.now(),
            isDeleted: false,
            isReported: false,
            reportReason: null,
            isLikedByCurrentUser: false,
          );

          // Save to Hive with server ID
          await _savePostToHive(newPost);

          // Prepare socket message with server ID
          Map<String, dynamic> messageData = {
            'type': 'post',
            'postId': savedPost.id, // Use server ID
            'msg': postData.content,
            'senderName': widget.name,
            'userId': widget.userId,
            'createdAt': savedPost.createdAt.toIso8601String(),
          };

          socket.emit('sendMsg', messageData);
        }
      } catch (e) {
        print('Error processing text post: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create text post: ${e.toString()}'),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  } catch (e) {
    print('Error in _processPost: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create post: ${e.toString()}'),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}


  Future<String> _imageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  void handlePostLike(String postId) {
    print('Handling like for post: $postId');
    int postIndex = listPost.indexWhere((post) => post.id == postId);
    if (postIndex == -1) {
      print('Post not found: $postId');
      return;
    }

    Post post = listPost[postIndex];
    bool isLiked = post.likes.contains(widget.userId);
    
    // Emit like event
    Map<String, dynamic> likeData = {
      'postId': postId,
      'userId': widget.userId,
      'senderName': widget.name,
      'action': isLiked ? 'unlike' : 'like'
    };
    print('Emitting like data: $likeData');
    socket.emit('likePost', likeData);
  }

 void _handleLikeUpdate(Map<String, dynamic> data) {
  setState(() {
    int postIndex = listPost.indexWhere((post) => post.id == data['postId']);
    if (postIndex != -1) {
      Post currentPost = listPost[postIndex];
      // Create a new List<String> instead of List<dynamic>
      List<String> newLikes = List<String>.from(currentPost.likes);
      
      if (data['action'] == 'like') {
        if (!newLikes.contains(data['userId'])) {
          newLikes.add(data['userId'].toString()); // Ensure userId is stored as String
        }
      } else {
        newLikes.remove(data['userId'].toString()); // Ensure userId is removed as String
      }

      Post updatedPost = Post(
        id: currentPost.id,
        userId: currentPost.userId,
        content: currentPost.content,
        mediaUrl: currentPost.mediaUrl,
        likes: newLikes, // Now properly typed as List<String>
        comments: currentPost.comments,
        user: currentPost.user,
        commentCount: currentPost.commentCount,
        createdAt: currentPost.createdAt,
        isDeleted: currentPost.isDeleted,
        isReported: currentPost.isReported,
        reportReason: currentPost.reportReason,
        isLikedByCurrentUser: data['userId'] == widget.userId ? 
            data['action'] == 'like' : 
            currentPost.isLikedByCurrentUser,
      );

      listPost[postIndex] = updatedPost;
      postsBox?.put(updatedPost.id, updatedPost);
    }
  });
}

 void connect() {
    socket.connect();
    socket.onConnect((_) {
      print('Connected to frontend');
      socket.emit('joinGroup', 'post_group');
      
      socket.on('sendMsgServer', (msg) async {
        print('Received message from server: $msg');
        
        if (postsBox != null) {
          Post? existingPost = postsBox!.get(msg['postId']);
          if (existingPost == null) {
            Post newPost = Post(
              id: msg['postId'] ?? DateTime.now().toString(),
              userId: msg['userId'],
              content: msg['msg'],
              mediaUrl: msg['mediaUrl'],
              likes: List.from(msg['likes'] ?? []),
              comments: [],
              user: UserPreview(
                id: msg['userId'],
                username: msg['senderName'],
                name: msg['userName'],
                profileImage: msg['userProfileImage'],
              ),
              commentCount: msg['commentCount'] ?? 0,
              createdAt: DateTime.parse(msg['createdAt'] ?? DateTime.now().toIso8601String()),
              isDeleted: msg['isDeleted'] ?? false,
              isReported: msg['isReported'] ?? false,
              reportReason: msg['reportReason'],
              isLikedByCurrentUser: msg['likes']?.contains(widget.userId) ?? false,
            );
            
            await _savePostToHive(newPost);

             setState(() {
        listPost.insert(0, newPost); // Add to beginning of list
        listPost.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Re-sort
      });
          }
        }
      });
      

      socket.on('likeUpdateServer', (data) {
        print('Received like update: $data');
        _handleLikeUpdate(data);
      });
    });

    socket.on('connect_error', (error) {
      print('Connection error: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection error: ${error.toString()}')),
        );
      }
    });

    socket.on('connect_timeout', (timeout) {
      print('Connection timeout: $timeout');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection timeout: ${timeout.toString()}')),
        );
      }
    });
  }

  void updateLikeStatus(String postId, String userId, bool isLiking) {
    print('Updating like status for post: $postId, user: $userId, isLiking: $isLiking');
    
    setState(() {
      int postIndex = listPost.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        if (isLiking) {
          if (!listPost[postIndex].likes.contains(userId)) {
            listPost[postIndex].likes.add(userId);
            print('Added like to post $postId');
          }
        } else {
          listPost[postIndex].likes.remove(userId);
          print('Removed like from post $postId');
        }
        print('New like count for post $postId: ${listPost[postIndex].likes.length}');
      } else {
        print('Post not found for updating like status: $postId');
      }
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
  //     body: Column(
  //       children: [
  // Expanded(
  //           child: ListView.builder(
  //             itemCount: listPost.length,
  //             itemBuilder: (context, index) {
  //               final post = listPost[index];
  //               return PostCardWidget(
  //                 post: post,
  //                 currentUser: UserPreview(
  //                   id: widget.userId,
  //                   username: widget.name,
  //                 ),
  //                 onLike: handlePostLike,
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  body: FutureBuilder(
        future: _initializationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: listPost.length,
                  itemBuilder: (context, index) {
                    final post = listPost[index];
                    return PostCardWidget(
                      post: post,
                      currentUser: UserPreview(
                        id: widget.userId,
                        username: widget.name,
                      ),
                      onLike: handlePostLike,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePost,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    socket.dispose();
    postsBox?.close();
    super.dispose();
  }
}