// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:friends/confession/confession_card.dart';
import 'package:friends/confession/create_confession_screen.dart';
import 'package:friends/constants/global_variables.dart';
import 'package:friends/model/confession.dart';
import 'package:friends/model/user_preview.dart';
import 'package:friends/screens/services/confessio_services.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// class ConfessionScreen extends StatefulWidget {
//   final String name;
//   final String userId;
//   final String chatId;

//   const ConfessionScreen({
//     Key? key,
//     required this.name,
//     required this.userId,
//     required this.chatId,
//   }) : super(key: key);

//   @override
//   _ConfessionScreenState createState() => _ConfessionScreenState();
// }

// class _ConfessionScreenState extends State<ConfessionScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   IO.Socket? socket;
//   List<Confession> confessions = [];
//   bool hasReachedQuota = false;
//   DateTime? quotaResetTime;

//   @override
//   void initState() {
//     super.initState();
//     connect();
//     _checkQuota();
//   }

//   void _checkQuota() {
//     // Example quota check - you should implement your own logic
//     final now = DateTime.now();
//     final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
//     setState(() {
//       quotaResetTime = endOfDay;
//       hasReachedQuota = _hasReachedDailyQuota();
//     });
//   }

//   bool _hasReachedDailyQuota() {
//     // Implement your quota logic here
//     final todayConfessions = confessions
//         .where((c) =>
//             c.userId == widget.userId && c.createdAt.day == DateTime.now().day)
//         .length;
//     return todayConfessions >= 3; // Example: 3 confessions per day limit
//   }

//   void connect() {
//     // 1. Proper socket options configuration
//     socket = IO.io('http://192.168.1.104:5000', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false, // Changed to false to handle connection manually
//       'timeout': 5000, // Add timeout
//       'reconnection': true, // Enable reconnection
//       'reconnectionAttempts': 3,
//       'reconnectionDelay': 1000,
//     });

//     // 2. Add error handling and logging
//     socket!.connect(); // Explicitly connect

//     socket!.onConnect((_) {
//       print('✅ Socket connected into frontend successfully');
//       print('Socket ID: ${socket!.id}'); // Add socket ID logging

//       // 3. Emit a join event after connection
//       socket!.emit('joinConfession', {
//         'userId': widget.userId,
//         'name': widget.name,
//       });

//       // 4. Listen for confessions with proper error handling
//       socket!.on('sendConfessionServer', (data) {
//         try {
//           print('Received confession from server: $data');
//           if (data != null && data['userId'] != widget.userId) {
//             final confession = Confession(
//               id: DateTime.now().millisecondsSinceEpoch.toString(),
//               content: data['msg'] ?? '',
//               category: data['category'] ?? 'General',
//               userId: data['userId'] ?? '',
//               createdAt: DateTime.now(),
//               isAnonymous: data['isAnonymous'] ?? true,
//               likesCount: 0,
//               commentsCount: 0,
//               mentions: [],
//               isDeleted: false,
//               isReported: false,
//             );

//             setState(() {
//               confessions.insert(0, confession);
//             });
//           }
//         } catch (e) {
//           print('Error handling confession data: $e');
//         }
//       });

//       socket!.on('confessionLikeToggled', (data) {
//   try {
//     final confessionId = data['confessionId'];
//     final likesCount = data['likesCount'];
//     final isLiked = data['isLiked'];
//     final likerId = data['userId'];
    
//     setState(() {
//       final index = confessions.indexWhere((c) => c.id == confessionId);
//       if (index != -1) {
//         confessions[index] = confessions[index].copyWith(
//           likesCount: likesCount,
//           isLikedByCurrentUser: likerId == widget.userId ? isLiked : confessions[index].isLikedByCurrentUser,
//         );
//       }
//     });
//   } catch (e) {
//     print('Error handling confession like update: $e');
//   }
// });
//     });

//     // 5. Enhanced error handling
//     socket!.onConnectError((err) {
//       print('❌ Connection Error: $err');
//       _handleReconnect();
//     });

//     socket!.onError((err) {
//       print('❌ Socket Error: $err');
//       _handleReconnect();
//     });

//     socket!.onDisconnect((_) {
//       print('❌ Socket disconnected');
//       _handleReconnect();
//     });
//   }

//   void _handleReconnect() {
//     if (socket != null && !socket!.connected) {
//       Future.delayed(const Duration(seconds: 3), () {
//         print('Attempting to reconnect...');
//         socket!.connect();
//       });
//     }
//   }

// void _handleLike(String confessionId) {
//   if (socket == null || !socket!.connected) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Connection error. Please try again.')),
//     );
//     return;
//   }

//   // Find the confession
//   final confessionIndex = confessions.indexWhere((c) => c.id == confessionId);
//   if (confessionIndex == -1) return;

//   final confession = confessions[confessionIndex];
  
//   // Optimistically update the UI
//   setState(() {
//     confessions[confessionIndex] = confession.copyWith(
//       likesCount: confession.isLikedByCurrentUser 
//         ? confession.likesCount - 1 
//         : confession.likesCount + 1,
//       isLikedByCurrentUser: !confession.isLikedByCurrentUser,
//     );
//   });

//   // Emit the like toggle event
//   socket!.emit('toggleLike', {
//     'confessionId': confessionId,
//     'userId': widget.userId,
//   });
// }

//   Future<void> sendConfession(Confession confession) async {
//   if (socket == null || !socket!.connected) {
//     print('Socket not connected. Cannot send confession.');
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Connection error. Please try again.')),
//     );
//     return;
//   }

//   try {
//     // Create a new confession with all required fields
//     final newConfession = Confession(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       content: confession.content,
//       category: confession.category,
//       userId: widget.userId,
//       createdAt: DateTime.now(),
//       isAnonymous: confession.isAnonymous,
//       mentions: confession.mentions,
//       likesCount: 0,
//       commentsCount: 0,
//       isDeleted: false,
//       isReported: false,
//     );

//     // Add confession to local list first for immediate feedback
//     setState(() {
//       confessions.insert(0, newConfession);
//     });

//     // Save to database
//     final confessionService = ConfessionService();
//     final savedConfession = await confessionService.sendConfession(
//       context: context,
//       content: newConfession.content,
//       category: newConfession.category,
//       userId: widget.userId,
//       isAnonymous: newConfession.isAnonymous,
//       mentions: newConfession.mentions,
//     );

//     if (savedConfession == null) {
//       // Remove from local list if save failed
//       setState(() {
//         confessions.removeWhere((c) => c.id == newConfession.id);
//       });
//       throw Exception('Failed to save confession');
//     }

//     // Update local confession with saved data
//     setState(() {
//       final index = confessions.indexWhere((c) => c.id == newConfession.id);
//       if (index != -1) {
//         confessions[index] = savedConfession;
//       }
//     });

//     // Emit to socket after successful save
//     socket!.emitWithAck('sendMsg', {
//       "type": "confession",
//       "msg": savedConfession.content,
//       "category": savedConfession.category,
//       "senderName": widget.name,
//       "userId": widget.userId,
//       "isAnonymous": savedConfession.isAnonymous,
//       "timestamp": savedConfession.createdAt.toIso8601String(),
//       "confessionId": savedConfession.id,
//     }, ack: (data) {
//       print('Server acknowledged confession: $data');
//     });

//   } catch (e) {
//     print('Error sending confession: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Error sending confession: ${e.toString()}'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Confession')),
//       body: Container(
//         color: GlobalVariables.backgroundColor,
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: confessions.length,
//                 itemBuilder: (context, index) {
//                   final confession = confessions[index];
//                   return ConfessionCardWidget(
//                     confession: confession,
//                     currentUser: UserPreview(
//                       id: widget.userId,
//                       username: widget.name,
//                     ),
//                     onLike: _handleLike,
//                   );
//                 },
//               ),
//             ),
//             ConfessionCardWidget(
//               confession: Confession(
//                 id: '1',
//                 content:
//                     "I've been pretending to understand calculus all semester. My friends think I'm helping them, but I'm actually learning from teaching them 😅",
//                 category: "Academic",
//                 userId: "user123",
//                 createdAt: DateTime.now().subtract(const Duration(hours: 2)),
//                 isAnonymous: true,
//                 likesCount: 234,
//                 commentsCount: 45,
//                 mentions: [],
//                 isDeleted: false,
//                 isReported: false,
//               ),
//               currentUser:
//                   UserPreview(id: 'current123', username: 'currentUser'),
//               onLike: (id) => print('Liked confession $id'),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.all(16.0),
//                 child: const Text.rich(
//                   TextSpan(
//                     text: "Your ",
//                     style: TextStyle(fontSize: 14, color: Colors.black),
//                     children: [
//                       TextSpan(
//                         text: "today's quota",
//                         style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       TextSpan(
//                         text: " has been ended, it will be renewed on ",
//                       ),
//                       TextSpan(
//                         text: "12:00 AM",
//                         style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       TextSpan(
//                         text: " in Midnight",
//                       ),
//                     ],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Padding(
//         padding: EdgeInsets.only(
//           bottom: 50,
//         ),
//         child: FloatingActionButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => CreateConfessionScreen(
//                   userId: widget.userId,
//                   socket: socket!,
//                   onConfessionCreated: sendConfession,
//                 ),
//               ),
//             );
//           },
//           child: const Icon(Icons.add),
//           backgroundColor: GlobalVariables.primaryColor,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     socket?.disconnect();
//     socket?.dispose();
//     super.dispose();
//   }
// }



// class ConfessionScreen extends StatefulWidget {
//   final String name;
//   final String userId;
//   final String chatId;

//   const ConfessionScreen({
//     Key? key,
//     required this.name,
//     required this.userId,
//     required this.chatId,
//   }) : super(key: key);

//   @override
//   _ConfessionScreenState createState() => _ConfessionScreenState();
// }

// class _ConfessionScreenState extends State<ConfessionScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   IO.Socket? socket;
//   List<Confession> confessions = [];
//   bool hasReachedQuota = false;
//   DateTime? quotaResetTime;
//   Box<Confession>? confessionsBox; // Change to nullable
//   bool isLoading = true; // Add loading state
//     bool isLoadingMore = false;

//       static const int batchSize = 20;
//   int currentPage = 0;
//   bool hasMoreData = true;

//   @override
//   void initState() {
//     super.initState();
//         // _initHive();
//         _initializeScreen();
//         _setupScrollListener();
//     connect();
//     _checkQuota();
//   }

//   void _setupScrollListener() {
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >= 
//           _scrollController.position.maxScrollExtent * 0.8 && // Load more when 80% scrolled
//           !isLoadingMore &&
//           hasMoreData) {
//         _loadMoreConfessions();
//       }
//     });
//   }


//   Future<void> _initializeScreen() async {
//     try {
//       if (!Hive.isBoxOpen('confessions')) {
//         confessionsBox = await Hive.openBox<Confession>('confessions');
//       } else {
//         confessionsBox = Hive.box<Confession>('confessions');
//       }
      
//       await _loadInitialConfessions();
//       connect();
//       _checkQuota();
      
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Error initializing screen: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error initializing app: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   Future<void> _loadInitialConfessions() async {
//     if (confessionsBox == null) return;
    
//     try {
//       final allConfessions = confessionsBox!.values.toList();
//       allConfessions.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort by newest first
      
//       final initialBatch = allConfessions.take(batchSize).toList();
//       hasMoreData = allConfessions.length > batchSize;
      
//       if (mounted) {
//         setState(() {
//           confessions = initialBatch;
//           currentPage = 1;
//         });
//       }
//     } catch (e) {
//       print('Error loading initial confessions: $e');
//     }
//   }

//   Future<void> _loadMoreConfessions() async {
//     if (confessionsBox == null || isLoadingMore || !hasMoreData) return;
    
//     try {
//       setState(() {
//         isLoadingMore = true;
//       });

//       final allConfessions = confessionsBox!.values.toList();
//       allConfessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
//       final startIndex = currentPage * batchSize;
//       final endIndex = startIndex + batchSize;
//       final nextBatch = allConfessions
//           .skip(startIndex)
//           .take(batchSize)
//           .toList();
      
//       hasMoreData = allConfessions.length > endIndex;

//       if (mounted) {
//         setState(() {
//           confessions.addAll(nextBatch);
//           currentPage++;
//           isLoadingMore = false;
//         });
//       }
//     } catch (e) {
//       print('Error loading more confessions: $e');
//       setState(() {
//         isLoadingMore = false;
//       });
//     }
//   }


//   void _checkQuota() {
//     // Example quota check - you should implement your own logic
//     final now = DateTime.now();
//     final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
//     setState(() {
//       quotaResetTime = endOfDay;
//       hasReachedQuota = _hasReachedDailyQuota();
//     });
//   }

// bool _hasReachedDailyQuota() {
//     if (confessionsBox == null) return false;
    
//     final now = DateTime.now();
//     final todayConfessions = confessionsBox!.values
//         .where((c) =>
//             c.userId == widget.userId &&
//             c.createdAt.day == now.day &&
//             c.createdAt.month == now.month &&
//             c.createdAt.year == now.year)
//         .length;
//     return todayConfessions >= 3;
//   }

//   void connect() {
//     // 1. Proper socket options configuration
//     socket = IO.io('http://192.168.1.104:5000', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false, // Changed to false to handle connection manually
//       'timeout': 5000, // Add timeout
//       'reconnection': true, // Enable reconnection
//       'reconnectionAttempts': 3,
//       'reconnectionDelay': 1000,
//     });

//     // 2. Add error handling and logging
//     socket!.connect(); // Explicitly connect

//     socket!.onConnect((_) {
//       print('✅ Socket connected into frontend successfully');
//       print('Socket ID: ${socket!.id}'); // Add socket ID logging

//       // 3. Emit a join event after connection
//       socket!.emit('joinConfession', {
//         'userId': widget.userId,
//         'name': widget.name,
//       });

//       // 4. Listen for confessions with proper error handling
//       socket!.on('sendConfessionServer', (data) async {
//       try {
//         print('Received confession from server: $data');
//         if (data != null && data['userId'] != widget.userId) {
//           final confession = Confession(
//             id: DateTime.now().millisecondsSinceEpoch.toString(),
//             content: data['msg'] ?? '',
//             category: data['category'] ?? 'General',
//             userId: data['userId'] ?? '',
//             createdAt: DateTime.now(),
//             isAnonymous: data['isAnonymous'] ?? true,
//             likesCount: 0,
//             commentsCount: 0,
//             mentions: [],
//             isDeleted: false,
//             isReported: false,
//           );

//           // Store in Hive
//           await confessionsBox?.put(confession.id, confession);

//           if (mounted) {
//             setState(() {
//               confessions.insert(0, confession);
//             });
//           }
//         }
//       } catch (e) {
//         print('Error handling confession data: $e');
//       }
//     });


    
//       socket!.on('confessionLikeToggled', (data) async {
//       try {
//         final confessionId = data['confessionId'];
//         final likesCount = data['likesCount'];
//         final isLiked = data['isLiked'];
//         final likerId = data['userId'];
        
//         // Update in Hive and state
//         final confession = confessionsBox?.get(confessionId);
//         if (confession != null) {
//           final updatedConfession = confession.copyWith(
//             likesCount: likesCount,
//             isLikedByCurrentUser: likerId == widget.userId ? isLiked : confession.isLikedByCurrentUser,
//           );
          
//           await confessionsBox?.put(confessionId, updatedConfession);
          
//           if (mounted) {
//             setState(() {
//               final index = confessions.indexWhere((c) => c.id == confessionId);
//               if (index != -1) {
//                 confessions[index] = updatedConfession;
//               }
//             });
//           }
//         }
//       } catch (e) {
//         print('Error handling confession like update: $e');
//       }
//     });
//     }
//     );
//     }
  
// void _handleLike(String confessionId) {
//   if (socket == null || !socket!.connected) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Connection error. Please try again.')),
//     );
//     return;
//   }

//   // Find the confession
//   final confessionIndex = confessions.indexWhere((c) => c.id == confessionId);
//   if (confessionIndex == -1) return;

//   final confession = confessions[confessionIndex];
  
//   // Optimistically update the UI
//   setState(() {
//     confessions[confessionIndex] = confession.copyWith(
//       likesCount: confession.isLikedByCurrentUser 
//         ? confession.likesCount - 1 
//         : confession.likesCount + 1,
//       isLikedByCurrentUser: !confession.isLikedByCurrentUser,
//     );
//   });

//   // Emit the like toggle event
//   socket!.emit('toggleLike', {
//     'confessionId': confessionId,
//     'userId': widget.userId,
//   });
// }

//   Future<void> sendConfession(Confession confession) async {
//   if (socket == null || !socket!.connected) {
//     print('Socket not connected. Cannot send confession.');
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Connection error. Please try again.')),
//     );
//     return;
//   }

//   try {
//     // Create a new confession with all required fields
//     final newConfession = Confession(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       content: confession.content,
//       category: confession.category,
//       userId: widget.userId,
//       createdAt: DateTime.now(),
//       isAnonymous: confession.isAnonymous,
//       mentions: confession.mentions,
//       likesCount: 0,
//       commentsCount: 0,
//       isDeleted: false,
//       isReported: false,
//     );

//     await confessionsBox!.put(newConfession.id, newConfession);

//     // Add confession to local list first for immediate feedback
//     setState(() {
//       confessions.insert(0, newConfession);
//     });

//     print('object :  ${newConfession.id}');

//     // Save to database
//     final confessionService = ConfessionService();
//     final savedConfession = await confessionService.sendConfession(
//       context: context,
//       content: newConfession.content,
//       category: newConfession.category,
//       userId: widget.userId,
//       isAnonymous: newConfession.isAnonymous,
//       mentions: newConfession.mentions,
//     );

//     if (savedConfession == null) {
//       // Remove from local list if save failed
//       setState(() {
//         confessions.removeWhere((c) => c.id == newConfession.id);
//       });
//       throw Exception('Failed to save confession');
//     }

//     // Update local confession with saved data
//     setState(() {
//       final index = confessions.indexWhere((c) => c.id == newConfession.id);
//       if (index != -1) {
//         confessions[index] = savedConfession;
//       }
//     });

//     // Emit to socket after successful save
//     socket!.emitWithAck('sendMsg', {
//       "type": "confession",
//       "msg": savedConfession.content,
//       "category": savedConfession.category,
//       "senderName": widget.name,
//       "userId": widget.userId,
//       "isAnonymous": savedConfession.isAnonymous,
//       "timestamp": savedConfession.createdAt.toIso8601String(),
//       "confessionId": savedConfession.id,
//     }, ack: (data) {
//       print('Server acknowledged confession: $data');
//     });

//     if (savedConfession != null) {
//         await confessionsBox!.put(savedConfession.id, savedConfession);
//       }

//   } catch (e) {
//     print('Error sending confession: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Error sending confession: ${e.toString()}'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Confession')),
//       body: Container(
//         color: GlobalVariables.backgroundColor,
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: confessions.length,
//                 itemBuilder: (context, index) {
//                   final confession = confessions[index];
//                   return ConfessionCardWidget(
//                     confession: confession,
//                     currentUser: UserPreview(
//                       id: widget.userId,
//                       username: widget.name,
//                     ),
//                     onLike: _handleLike,
//                   );
//                 },
//               ),
//             ),
//             ConfessionCardWidget(
//               confession: Confession(
//                 id: '1',
//                 content:
//                     "I've been pretending to understand calculus all semester. My friends think I'm helping them, but I'm actually learning from teaching them 😅",
//                 category: "Academic",
//                 userId: "user123",
//                 createdAt: DateTime.now().subtract(const Duration(hours: 2)),
//                 isAnonymous: true,
//                 likesCount: 234,
//                 commentsCount: 45,
//                 mentions: [],
//                 isDeleted: false,
//                 isReported: false,
//               ),
//               currentUser:
//                   UserPreview(id: 'current123', username: 'currentUser'),
//               onLike: (id) => print('Liked confession $id'),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.all(16.0),
//                 child: const Text.rich(
//                   TextSpan(
//                     text: "Your ",
//                     style: TextStyle(fontSize: 14, color: Colors.black),
//                     children: [
//                       TextSpan(
//                         text: "today's quota",
//                         style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       TextSpan(
//                         text: " has been ended, it will be renewed on ",
//                       ),
//                       TextSpan(
//                         text: "12:00 AM",
//                         style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       TextSpan(
//                         text: " in Midnight",
//                       ),
//                     ],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Padding(
//         padding: EdgeInsets.only(
//           bottom: 50,
//         ),
//         child: FloatingActionButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => CreateConfessionScreen(
//                   userId: widget.userId,
//                   socket: socket!,
//                   onConfessionCreated: sendConfession,
//                 ),
//               ),
//             );
//           },
//           child: const Icon(Icons.add),
//           backgroundColor: GlobalVariables.primaryColor,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//         confessionsBox?.compact();
//     confessionsBox?.close();
//     socket?.disconnect();
//     socket?.dispose();
//     super.dispose();
//   }
// }












// class ConfessionScreen extends StatefulWidget {
//   final String name;
//   final String userId;
//   final String chatId;

//   const ConfessionScreen({
//     Key? key,
//     required this.name,
//     required this.userId,
//     required this.chatId,
//   }) : super(key: key);

//   @override
//   _ConfessionScreenState createState() => _ConfessionScreenState();
// }

// class _ConfessionScreenState extends State<ConfessionScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   IO.Socket? socket;
//   List<Confession> confessions = [];
//   bool hasReachedQuota = false;
//   DateTime? quotaResetTime;
//   late Box<Confession> confessionBox;

//   @override
//   void initState() {
//     super.initState();
//     _initHive();
//     connect();
//     _checkQuota();
//   }

//   Future<void> _initHive() async {
//     confessionBox = await Hive.openBox<Confession>('confessions');
//     // Load cached confessions
//     setState(() {
//       confessions = confessionBox.values.toList()
//         ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
//     });
//   }

//   void _updateLocalConfession(Confession confession) async {
//     try {
//       // Store using confession ID as key for easier updates
//       await confessionBox.put(confession.id, confession);

//       setState(() {
//         confessions = confessionBox.values.toList()
//           ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
//       });
//     } catch (e) {
//       print('Error updating local confession: $e');
//     }
//   }



//   void _checkQuota() {
//     // Example quota check - you should implement your own logic
//     final now = DateTime.now();
//     final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
//     setState(() {
//       quotaResetTime = endOfDay;
//       hasReachedQuota = _hasReachedDailyQuota();
//     });
//   }

//   bool _hasReachedDailyQuota() {
//     // Implement your quota logic here
//     final todayConfessions = confessions
//         .where((c) =>
//             c.userId == widget.userId && c.createdAt.day == DateTime.now().day)
//         .length;
//     return todayConfessions >= 3; // Example: 3 confessions per day limit
//   }

//   void connect() {
//     socket = IO.io('http://192.168.1.104:5000', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//       'timeout': 5000,
//       'reconnection': true,
//       'reconnectionAttempts': 3,
//       'reconnectionDelay': 1000,
//     });

//     socket!.connect();

//     socket!.onConnect((_) {
//       print('✅ Socket connected into frontend successfully');
//       print('Socket ID: ${socket!.id}');

//       socket!.emit('joinConfession', {
//         'userId': widget.userId,
//         'name': widget.name,
//       });

//       socket!.on('sendConfessionServer', (data) {
//         try {
//           print('Received confession from server: $data');
//           if (data != null && data['userId'] != widget.userId) {
//             final confession = Confession(
//               id: data['confessionId'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
//               content: data['msg'] ?? '',
//               category: data['category'] ?? 'General',
//               userId: data['userId'] ?? '',
//               createdAt: DateTime.parse(data['timestamp'] ?? DateTime.now().toIso8601String()),
//               isAnonymous: data['isAnonymous'] ?? true,
//               likesCount: 0,
//               commentsCount: 0,
//               mentions: [],
//               isDeleted: false,
//               isReported: false,
//             );

//             _updateLocalConfession(confession);
//           }
//         } catch (e) {
//           print('Error handling confession data: $e');
//         }
//       });

//       socket!.on('confessionLikeToggled', (data) {
//         try {
//           final confessionId = data['confessionId'];
//           final likesCount = data['likesCount'];
//           final isLiked = data['isLiked'];
//           final likerId = data['userId'];
          
//           final confession = confessionBox.get(confessionId);
          
//           if (confession != null) {
//             final updatedConfession = confession.copyWith(
//               likesCount: likesCount,
//               isLikedByCurrentUser: likerId == widget.userId ? isLiked : confession.isLikedByCurrentUser,
//             );
//             _updateLocalConfession(updatedConfession);
//           }
//         } catch (e) {
//           print('Error handling confession like update: $e');
//         }
//       });
//     });

//     socket!.onConnectError((err) => _handleReconnect());
//     socket!.onError((err) => _handleReconnect());
//     socket!.onDisconnect((_) => _handleReconnect());
//   }
//   void _handleReconnect() {
//     if (socket != null && !socket!.connected) {
//       Future.delayed(const Duration(seconds: 3), () {
//         print('Attempting to reconnect...');
//         socket!.connect();
//       });
//     }
//   }

// void _handleLike(String confessionId) {
//     if (socket == null || !socket!.connected) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Connection error. Please try again.')),
//       );
//       return;
//     }

//     final confession = confessionBox.get(confessionId);
    
//     if (confession != null) {
//       final updatedConfession = confession.copyWith(
//         likesCount: confession.isLikedByCurrentUser 
//           ? confession.likesCount - 1 
//           : confession.likesCount + 1,
//         isLikedByCurrentUser: !confession.isLikedByCurrentUser,
//       );
      
//       _updateLocalConfession(updatedConfession);

//       socket!.emit('toggleLike', {
//         'confessionId': confessionId,
//         'userId': widget.userId,
//       });
//     }
//   }

//   Future<void> sendConfession(Confession confession) async {
//     if (socket == null || !socket!.connected) {
//       print('Socket not connected. Cannot send confession.');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Connection error. Please try again.')),
//       );
//       return;
//     }

//     try {
//       // Save to server
//       final confessionService = ConfessionService();
//       final savedConfession = await confessionService.sendConfession(
//         context: context,
//         content: confession.content,
//         category: confession.category,
//         userId: widget.userId,
//         isAnonymous: confession.isAnonymous,
//         mentions: confession.mentions,
//       );

//       if (savedConfession == null) {
//         throw Exception('Failed to save confession');
//       }

//       // Store in local cache only after successful server save
//       _updateLocalConfession(savedConfession);

//       socket!.emitWithAck('sendMsg', {
//         "type": "confession",
//         "msg": savedConfession.content,
//         "category": savedConfession.category,
//         "senderName": widget.name,
//         "userId": widget.userId,
//         "isAnonymous": savedConfession.isAnonymous,
//         "timestamp": savedConfession.createdAt.toIso8601String(),
//         "confessionId": savedConfession.id,
//       }, ack: (data) {
//         print('Server acknowledged confession: $data');
//       });

//     } catch (e) {
//       print('Error sending confession: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error sending confession: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
// }

//   @override
//   void dispose() {
//     confessionBox.close();
//     socket?.disconnect();
//     socket?.dispose();
//     super.dispose();
//   }


//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Confession')),
//       body: Container(
//         color: GlobalVariables.backgroundColor,
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: confessions.length,
//                 itemBuilder: (context, index) {
//                   final confession = confessions[index];
//                   return ConfessionCardWidget(
//                     confession: confession,
//                     currentUser: UserPreview(
//                       id: widget.userId,
//                       username: widget.name,
//                     ),
//                     onLike: _handleLike,
//                   );
//                 },
//               ),
//             ),
//             ConfessionCardWidget(
//               confession: Confession(
//                 id: '1',
//                 content:
//                     "I've been pretending to understand calculus all semester. My friends think I'm helping them, but I'm actually learning from teaching them 😅",
//                 category: "Academic",
//                 userId: "user123",
//                 createdAt: DateTime.now().subtract(const Duration(hours: 2)),
//                 isAnonymous: true,
//                 likesCount: 234,
//                 commentsCount: 45,
//                 mentions: [],
//                 isDeleted: false,
//                 isReported: false,
//               ),
//               currentUser:
//                   UserPreview(id: 'current123', username: 'currentUser'),
//               onLike: (id) => print('Liked confession $id'),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.all(16.0),
//                 child: const Text.rich(
//                   TextSpan(
//                     text: "Your ",
//                     style: TextStyle(fontSize: 14, color: Colors.black),
//                     children: [
//                       TextSpan(
//                         text: "today's quota",
//                         style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       TextSpan(
//                         text: " has been ended, it will be renewed on ",
//                       ),
//                       TextSpan(
//                         text: "12:00 AM",
//                         style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       TextSpan(
//                         text: " in Midnight",
//                       ),
//                     ],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Padding(
//         padding: EdgeInsets.only(
//           bottom: 50,
//         ),
//         child: FloatingActionButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => CreateConfessionScreen(
//                   userId: widget.userId,
//                   socket: socket!,
//                   onConfessionCreated: sendConfession,
//                 ),
//               ),
//             );
//           },
//           child: const Icon(Icons.add),
//           backgroundColor: GlobalVariables.primaryColor,
//         ),
//       ),
//     );
//   }

// }











class ConfessionScreen extends StatefulWidget {
  final String name;
  final String userId;
  final String chatId;

  const ConfessionScreen({
    Key? key,
    required this.name,
    required this.userId,
    required this.chatId,
  }) : super(key: key);

  @override
  _ConfessionScreenState createState() => _ConfessionScreenState();
}

class _ConfessionScreenState extends State<ConfessionScreen> {
  final TextEditingController _messageController = TextEditingController();
  IO.Socket? socket;
  List<Confession> confessions = [];
  bool hasReachedQuota = false;
  DateTime? quotaResetTime;
  late Box<Confession> confessionBox;
  Timer? _refreshTimer;
  DateTime? _lastFetchTimestamp;
    static const int DAILY_MESSAGE_LIMIT = 1;
  bool _hasUsedDailyQuota = false;
  late SharedPreferences prefs;
  

  @override
  void initState() {
    super.initState();
        _initPreferences();
    _initHive();
    connect();
    _startQuotaCheck();
     _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) => _fetchNewConfessions());
  }

  Future<void> _initPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _checkAndResetQuota();
  }

  void _checkAndResetQuota() {
    final lastQuotaCheckDate = prefs.getString('lastQuotaCheckDate');
    final currentDate = DateTime.now().toIso8601String().split('T')[0];
    
    if (lastQuotaCheckDate != currentDate) {
      // It's a new day, reset quota
      prefs.setBool('hasUsedDailyQuota', false);
      prefs.setString('lastQuotaCheckDate', currentDate);
      setState(() {
        _hasUsedDailyQuota = false;
      });
    } 
    
    // Check actual confessions count for today regardless of stored state
    final todayConfessionsCount = _getTodayConfessionsCount();
    setState(() {
      _hasUsedDailyQuota = todayConfessionsCount >= DAILY_MESSAGE_LIMIT;
    });
    
    // Update stored state to match actual count
    prefs.setBool('hasUsedDailyQuota', _hasUsedDailyQuota);
  }

  int _getTodayConfessionsCount() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return confessions.where((confession) =>
      confession.userId == widget.userId &&
      confession.createdAt.isAfter(startOfDay) &&
      confession.createdAt.isBefore(endOfDay)
    ).length;
  }

  void _startQuotaCheck() {
    // Check quota state every minute
    Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkAndResetQuota();
    });
  }

  Future<void> _markQuotaAsUsed() async {
    await prefs.setBool('hasUsedDailyQuota', true);
    setState(() {
      _hasUsedDailyQuota = true;
    });
  }


  Future<void> _initHive() async {
    confessionBox = await Hive.openBox<Confession>('confessions');
    // Load cached confessions
    setState(() {
      confessions = confessionBox.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
    
    // Check quota after loading confessions
    _checkAndResetQuota();
    
    // Set initial timestamp for fetching updates
    if (confessions.isNotEmpty) {
      _lastFetchTimestamp = confessions
          .map((c) => c.createdAt)
          .reduce((a, b) => a.isAfter(b) ? a : b);
    } else {
      _lastFetchTimestamp = DateTime.now().subtract(const Duration(days: 7));
    }
    
    // Fetch initial updates
    _fetchNewConfessions();
  }

  Future<void> _fetchNewConfessions() async {
    if (_lastFetchTimestamp == null) return;

    try {
      final confessionService = ConfessionService();
      final newConfessions = await confessionService.fetchConfessionsAfterDate(
        context: context,
        timestamp: _lastFetchTimestamp!,
        limit: 50,
      );

      if (newConfessions.isEmpty) return;

      // Update last fetch timestamp
      _lastFetchTimestamp = newConfessions
          .map((c) => c.createdAt)
          .reduce((a, b) => a.isAfter(b) ? a : b);

      // Update local storage and state
      await _updateConfessionsWithNewData(newConfessions);
    } catch (e) {
      print('Error fetching new confessions: $e');
      // Don't show error to user since this is a background refresh
    }
  }

  Future<void> _updateConfessionsWithNewData(List<Confession> newConfessions) async {
    // Create a map of existing confessions for faster lookup
    final existingConfessions = Map.fromEntries(
      confessionBox.values.map((c) => MapEntry(c.id, c))
    );

    for (final newConfession in newConfessions) {
      final existing = existingConfessions[newConfession.id];
      
      if (existing != null) {
        // Update only if the new confession has different data
        if (_hasConfessionChanged(existing, newConfession)) {
          await confessionBox.put(newConfession.id, newConfession);
        }
      } else {
        // Add new confession
        await confessionBox.put(newConfession.id, newConfession);
      }
    }

    // Update state with sorted confessions
    setState(() {
      confessions = confessionBox.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  bool _hasConfessionChanged(Confession existing, Confession newConfession) {
    return existing.likesCount != newConfession.likesCount ||
           existing.commentsCount != newConfession.commentsCount ||
           existing.isDeleted != newConfession.isDeleted ||
           existing.isReported != newConfession.isReported ||
           existing.content != newConfession.content;
  }

  void _updateLocalConfession(Confession confession) async {
    try {
      await confessionBox.put(confession.id, confession);

      setState(() {
        confessions = confessionBox.values.toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });
      
      // Recheck quota after updating confessions
      _checkAndResetQuota();
    } catch (e) {
      print('Error updating local confession: $e');
    }
  }


  void _checkQuota() {
    // Example quota check - you should implement your own logic
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    setState(() {
      quotaResetTime = endOfDay;
      hasReachedQuota = _hasReachedDailyQuota();
    });
  }

  bool _hasReachedDailyQuota() {
    // Implement your quota logic here
    final todayConfessions = confessions
        .where((c) =>
            c.userId == widget.userId && c.createdAt.day == DateTime.now().day)
        .length;
    return todayConfessions >= 3; // Example: 3 confessions per day limit
  }

  void connect() {
    socket = IO.io('http://192.168.1.104:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'timeout': 5000,
      'reconnection': true,
      'reconnectionAttempts': 3,
      'reconnectionDelay': 1000,
    });

    socket!.connect();

    socket!.onConnect((_) {
      print('✅ Socket connected into frontend successfully');
      print('Socket ID: ${socket!.id}');

      socket!.emit('joinConfession', {
        'userId': widget.userId,
        'name': widget.name,
      });

      socket!.on('sendConfessionServer', (data) {
        try {
          print('Received confession from server: $data');
          if (data != null && data['userId'] != widget.userId) {
            final confession = Confession(
              id: data['confessionId'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
              content: data['msg'] ?? '',
              category: data['category'] ?? 'General',
              userId: data['userId'] ?? '',
              createdAt: DateTime.parse(data['timestamp'] ?? DateTime.now().toIso8601String()),
              isAnonymous: data['isAnonymous'] ?? true,
              likesCount: 0,
              commentsCount: 0,
              mentions: [],
              isDeleted: false,
              isReported: false,
            );

            _updateLocalConfession(confession);
          }
        } catch (e) {
          print('Error handling confession data: $e');
        }
      });

      socket!.on('confessionLikeToggled', (data) {
        try {
          final confessionId = data['confessionId'];
          final likesCount = data['likesCount'];
          final isLiked = data['isLiked'];
          final likerId = data['userId'];
          
          final confession = confessionBox.get(confessionId);
          
          if (confession != null) {
            final updatedConfession = confession.copyWith(
              likesCount: likesCount,
              isLikedByCurrentUser: likerId == widget.userId ? isLiked : confession.isLikedByCurrentUser,
            );
            _updateLocalConfession(updatedConfession);
          }
        } catch (e) {
          print('Error handling confession like update: $e');
        }
      });
    });

    socket!.onConnectError((err) => _handleReconnect());
    socket!.onError((err) => _handleReconnect());
    socket!.onDisconnect((_) => _handleReconnect());
  }
  void _handleReconnect() {
    if (socket != null && !socket!.connected) {
      Future.delayed(const Duration(seconds: 3), () {
        print('Attempting to reconnect...');
        socket!.connect();
      });
    }
  }

void _handleLike(String confessionId) {
    if (socket == null || !socket!.connected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connection error. Please try again.')),
      );
      return;
    }

    final confession = confessionBox.get(confessionId);
    
    if (confession != null) {
      final updatedConfession = confession.copyWith(
        likesCount: confession.isLikedByCurrentUser 
          ? confession.likesCount - 1 
          : confession.likesCount + 1,
        isLikedByCurrentUser: !confession.isLikedByCurrentUser,
      );
      
      _updateLocalConfession(updatedConfession);

      socket!.emit('toggleLike', {
        'confessionId': confessionId,
        'userId': widget.userId,
      });
    }
  }

  Future<void> sendConfession(Confession confession) async {
    if (socket == null || !socket!.connected) {
      print('Socket not connected. Cannot send confession.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connection error. Please try again.')),
      );
      return;
    }

    try {
      // Save to server
      final confessionService = ConfessionService();
      final savedConfession = await confessionService.sendConfession(
        context: context,
        content: confession.content,
        category: confession.category,
        userId: widget.userId,
        isAnonymous: confession.isAnonymous,
        mentions: confession.mentions,
      );

      if (savedConfession == null) {
        throw Exception('Failed to save confession');
      }

      // Store in local cache only after successful server save
      _updateLocalConfession(savedConfession);

      socket!.emitWithAck('sendMsg', {
        "type": "confession",
        "msg": savedConfession.content,
        "category": savedConfession.category,
        "senderName": widget.name,
        "userId": widget.userId,
        "isAnonymous": savedConfession.isAnonymous,
        "timestamp": savedConfession.createdAt.toIso8601String(),
        "confessionId": savedConfession.id,
      }, ack: (data) {
        print('Server acknowledged confession: $data');
      });

    } catch (e) {
      print('Error sending confession: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending confession: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
}

 @override
  void dispose() {
    _refreshTimer?.cancel();
    confessionBox.close();
    socket?.disconnect();
    socket?.dispose();
    super.dispose();
  }
  


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confession')),
      body: Container(
        color: GlobalVariables.backgroundColor,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: confessions.length,
                itemBuilder: (context, index) {
                  final confession = confessions[index];
                  return ConfessionCardWidget(
                    confession: confession,
                    currentUser: UserPreview(
                      id: widget.userId,
                      username: widget.name,
                    ),
                    onLike: _handleLike,
                  );
                },
              ),
            ),
            ConfessionCardWidget(
              confession: Confession(
                id: '1',
                content:
                    "I've been pretending to understand calculus all semester. My friends think I'm helping them, but I'm actually learning from teaching them 😅",
                category: "Academic",
                userId: "user123",
                createdAt: DateTime.now().subtract(const Duration(hours: 2)),
                isAnonymous: true,
                likesCount: 234,
                commentsCount: 45,
                mentions: [],
                isDeleted: false,
                isReported: false,
              ),
              currentUser:
                  UserPreview(id: 'current123', username: 'currentUser'),
              onLike: (id) => print('Liked confession $id'),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: const Text.rich(
                  TextSpan(
                    text: "Your ",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    children: [
                      TextSpan(
                        text: "today's quota",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: " has been ended, it will be renewed on ",
                      ),
                      TextSpan(
                        text: "12:00 AM",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: " in Midnight",
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: !_hasUsedDailyQuota ? Padding(
  padding: EdgeInsets.only(bottom: 50),
  child: FloatingActionButton(
    onPressed: () async {
      if (_getTodayConfessionsCount() >= DAILY_MESSAGE_LIMIT) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Daily confession limit reached')),
        );
        return;
      }
      
      final result = await Navigator.push<Confession>(
        context,
        MaterialPageRoute(
          builder: (context) => CreateConfessionScreen(
            userId: widget.userId,
            socket: socket!,
            onConfessionCreated: (confession) async {
              await sendConfession(confession);
              // Quota will be checked and updated automatically in _updateLocalConfession
            },
          ),
        ),
      );
      
      if (result != null) {
        // Double check quota after confession is sent
        _checkAndResetQuota();
      }
    },
    child: const Icon(Icons.add),
    backgroundColor: GlobalVariables.primaryColor,
  ),
) : null,
    );
  }

}
