import 'package:flutter/material.dart';
import 'package:friends/model/comment.dart';
import 'package:friends/post/comment_tile_widget.dart';
import 'package:friends/screens/services/comment_services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../model/user_preview.dart';

class CommentBottomSheet extends StatefulWidget {
  final String postId;
  final String postType;
  final UserPreview currentUser;
  
  const CommentBottomSheet({
    Key? key, 
    required this.postId,
    required this.currentUser,
    required this.postType,
  }) : super(key: key);

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  String? replyingToUsername;
  String? replyingToCommentId;
  IO.Socket? socket;
  List<Comment> comments = [];
  final Set<String> expandedComments = {};
  
  final List<String> emojis = ['😊', '❤️', '👍', '🔥', '😂', '🙌', '✨', '💯'];

  @override
  void initState() {
    super.initState();
    connectSocket();
  }

  void connectSocket() {
    socket = IO.io("http://192.168.1.104:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });

    socket!.connect();
    socket!.onConnect((_) {
      print('Connected to socket server');
      
      // Join single comments group
      socket!.emit('joinComments', {
        'userId': widget.currentUser.id,
        'name': widget.currentUser.username
      });
      
      // Listen for all comments
      socket!.on("sendCommentServer", (data) {
        print('Received message: $data');
        // Only handle messages for the current post type
        if (data['type'] == 'otherMsg' && data['postType'] == widget.postType) {
          handleIncomingMessage(data);
        }
      });
    });

    socket!.onDisconnect((_) => print('Disconnected from socket server'));
    socket!.onError((err) => print('Socket error: $err'));
    socket!.onConnectError((err) => print('Connect error: $err'));
  }

  void handleIncomingMessage(Map<String, dynamic> data) {
    final newComment = Comment(
      id: DateTime.now().toString(),
      postId: widget.postId,
      userId: data['senderId'] ?? '',
      postType: data['postType'] ?? '',
      content: data['msg'],
      likes: [],
      createdAt: DateTime.now(),
      user: UserPreview(
        id: data['senderId'] ?? '',
        username: data['senderName'] ?? 'Unknown',
        profileImage: data['profileImage'],
      ),
      parentId: data['parentId'],
      replies: [],
    );

    setState(() {
      if (data['parentId'] != null) {
        final parentIndex = comments.indexWhere((c) => c.id == data['parentId']);
        if (parentIndex != -1) {
          comments[parentIndex].replies.add(newComment);
        }
      } else {
        comments.add(newComment);
      }
    });
  }

  List<Comment> get organizedComments {
    final Map<String, Comment> commentMap = {};
    final List<Comment> topLevelComments = [];

    // First pass: create a map of all comments
    for (var comment in comments) {
      commentMap[comment.id] = comment;
    }

    // Second pass: organize into hierarchy
    for (var comment in comments) {
      if (comment.parentId != null) {
        final parent = commentMap[comment.parentId];
        if (parent != null) {
          parent.replies.add(comment);
        }
      } else {
        topLevelComments.add(comment);
      }
    }

    return topLevelComments;
  }

  void sendComment(String content) {
  if (content.trim().isEmpty) return;

  final messageData = {
    'msg': content,
    'senderId': widget.currentUser.id,
    'senderName': widget.currentUser.username,
    'profileImage': widget.currentUser.profileImage,
    'postId': widget.postId,
    'postType': widget.postType,
    'parentId': replyingToCommentId,
    'userId': widget.currentUser.id,
  };

  final newComment = Comment(
    id: DateTime.now().toString(),
    postId: widget.postId,
    postType: widget.postType,
    userId: widget.currentUser.id,
    content: content,
    likes: [],
    createdAt: DateTime.now(),
    user: widget.currentUser,
    parentId: replyingToCommentId,
    replies: [],
  );

  setState(() {
    if (replyingToCommentId != null) {
      final parentIndex = comments.indexWhere((c) => c.id == replyingToCommentId);
      if (parentIndex != -1) {
        comments[parentIndex].replies.add(newComment);
        expandedComments.add(replyingToCommentId!);
      }
    } else {
      comments.add(newComment);
    }
  });

  // Listen for acknowledgment before sending
  socket!.on('commentStatus', (response) {
    if (response['status'] == 'error') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending comment: ${response['message']}')),
      );
    }
  });

  // Send the message
  socket!.emit('sendComment', messageData);
  
  _commentController.clear();
  _cancelReply();
}

// void sendComment(String content) async {
//   print('send butotn called  in comments');
//   if (content.trim().isEmpty) return;

//   try {
//     // First attempt to store the comment in the database
//     final Comment? savedComment = await CommentServices.sendComment(
//       context: context,
//       content: content,
//       // postId: widget.postId,
//       postId: '67b1e08beb1629917392cc47',
//       postType: widget.postType,
//       userId: '677fd21f5a9def773966c904',
//       parentId: replyingToCommentId,
//     );

//     if (savedComment == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to save comment')),
//       );
//       return;
//     }

//     // If comment is saved successfully, emit socket event for real-time updates
//     final messageData = {
//       'msg': content,
//       'senderId': widget.currentUser.id,
//       'senderName': widget.currentUser.username,
//       'profileImage': widget.currentUser.profileImage,
//       'postId': widget.postId,
//       'postType': widget.postType,
//       'parentId': replyingToCommentId,
//       'userId': widget.currentUser.id,
//       'commentId': savedComment.id, // Include the saved comment ID
//     };

//     // Update local state
//     setState(() {
//       if (replyingToCommentId != null) {
//         final parentIndex = comments.indexWhere((c) => c.id == replyingToCommentId);
//         if (parentIndex != -1) {
//           comments[parentIndex].replies.add(savedComment);
//           expandedComments.add(replyingToCommentId!);
//         }
//       } else {
//         comments.add(savedComment);
//       }
//     });

//     // Listen for acknowledgment before sending
//     socket?.on('commentStatus', (response) {
//       if (response['status'] == 'error') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error sending comment: ${response["message"]}')),
//         );
//       }
//     });

//     // Emit socket event for real-time updates
//     socket?.emit('sendComment', messageData);

//     // Clear input and reset reply state
//     _commentController.clear();
//     _cancelReply();

//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error: ${e.toString()}')),
//     );
//   }
// }


  void _insertEmoji(String emoji) {
    final text = _commentController.text;
    final selection = _commentController.selection;
    final newText = text.replaceRange(selection.start, selection.end, emoji);
    _commentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.baseOffset + emoji.length,
      ),
    );
  }

  void _startReply(String username, String commentId) {
    setState(() {
      replyingToUsername = username;
      replyingToCommentId = commentId;
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  void _cancelReply() {
    setState(() {
      replyingToUsername = null;
      replyingToCommentId = null;
    });
  }

  @override
  void dispose() {
    socket?.disconnect();
    _commentController.dispose();
    super.dispose();
  }



    @override
  Widget build(BuildContext context) {
    final topLevelComments = organizedComments;
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 1.5,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  '${comments.length}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          Expanded(
            child: ListView.builder(
              itemCount: topLevelComments.length,
              itemBuilder: (context, index) {
                return _buildCommentWithReplies(topLevelComments[index]);
              },
            ),
          ),
          
          if (replyingToUsername != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[100],
              child: Row(
                children: [
                  Text(
                    'Replying to @$replyingToUsername',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _cancelReply,
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: emojis.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _insertEmoji(emojis[index]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      emojis[index],
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                );
              },
            ),
          ),
          
          Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 8,
              // bottom: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    widget.currentUser.profileImage ?? ''
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: replyingToUsername != null 
                          ? 'Reply to @$replyingToUsername...'
                          : 'Add a comment...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                  onPressed: () => sendComment(_commentController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentWithReplies(Comment comment) {
    final hasReplies = comment.replies.isNotEmpty;
    final isExpanded = expandedComments.contains(comment.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommentTileWidget(
          username: comment.user?.username ?? 'Unknown',
          comment: comment.content,
          timeAgo: _getTimeAgo(comment.createdAt),
          profileImageUrl: comment.user?.profileImage ?? '',
          onReply: (username) => _startReply(username, comment.id),
        ),
        if (hasReplies) ...[
          GestureDetector(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  expandedComments.remove(comment.id);
                } else {
                  expandedComments.add(comment.id);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 56, top: 4, bottom: 8),
              child: Text(
                isExpanded 
                    ? 'Hide replies'
                    : '${comment.replies.length == 1 ? "View 1 reply" : "View ${comment.replies.length} replies"}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          if (isExpanded)
            Container(
              margin: const EdgeInsets.only(left: 40),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
              ),
              child: Column(
                children: comment.replies.map((reply) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: CommentTileWidget(
                      username: reply.user?.username ?? 'Unknown',
                      comment: reply.content,
                      timeAgo: _getTimeAgo(reply.createdAt),
                      profileImageUrl: reply.user?.profileImage ?? '',
                      onReply: (username) => _startReply(username, comment.id),
                      isReply: true,
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ],
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}







// class CommentBottomSheet extends StatefulWidget {
//   final String postId;
//   final String postType;
//   final UserPreview currentUser;
  
//   const CommentBottomSheet({
//     Key? key, 
//     required this.postId,
//     required this.currentUser,
//     required this.postType,
//   }) : super(key: key);

//   @override
//   State<CommentBottomSheet> createState() => _CommentBottomSheetState();
// }

// class _CommentBottomSheetState extends State<CommentBottomSheet> {
//   final TextEditingController _commentController = TextEditingController();
//   String? replyingToUsername;
//   String? replyingToCommentId;
//   IO.Socket? socket;
//   List<Comment> comments = [];
//   final Set<String> expandedComments = {};
  
//   final List<String> emojis = ['😊', '❤️', '👍', '🔥', '😂', '🙌', '✨', '💯'];

//   @override
//   void initState() {
//     super.initState();
//     connectSocket();
//   }

//   void connectSocket() {
//     socket = IO.io("http://192.168.1.121:5000", <String, dynamic>{
//       "transports": ["websocket"],
//       "autoConnect": false,
//     });

//     socket!.connect();
//     socket!.onConnect((_) {
//       print('Connected to socket server');
      
//       // Listen for incoming messages
//       socket!.on("sendMsgServer", (data) {
//         print('Received message: $data');
//         if (data['type'] == 'otherMsg') {
//           handleIncomingMessage(data);
//         }
//       });
//     });

//     socket!.onDisconnect((_) => print('Disconnected from socket server'));
//     socket!.onError((err) => print('Socket error: $err'));
//     socket!.onConnectError((err) => print('Connect error: $err'));
//   }

//   void handleIncomingMessage(Map<String, dynamic> data) {
//     final newComment = Comment(
//       id: DateTime.now().toString(),
//       postId: widget.postId,
//       userId: data['senderId'] ?? '',
//       postType: data['postType'] ?? '',
//       content: data['msg'],
//       likes: [],
//       createdAt: DateTime.now(),
//       user: UserPreview(
//         id: data['senderId'] ?? '',
//         username: data['senderName'] ?? 'Unknown',
//         profileImage: data['profileImage'],
//       ),
//       parentId: data['parentId'],
//       replies: [],
//     );

//     setState(() {
//       if (data['parentId'] != null) {
//         final parentIndex = comments.indexWhere((c) => c.id == data['parentId']);
//         if (parentIndex != -1) {
//           comments[parentIndex].replies.add(newComment);
//         }
//       } else {
//         comments.add(newComment);
//       }
//     });
//   }

//   List<Comment> get organizedComments {
//     final Map<String, Comment> commentMap = {};
//     final List<Comment> topLevelComments = [];

//     // First pass: create a map of all comments
//     for (var comment in comments) {
//       commentMap[comment.id] = comment;
//     }

//     // Second pass: organize into hierarchy
//     for (var comment in comments) {
//       if (comment.parentId != null) {
//         final parent = commentMap[comment.parentId];
//         if (parent != null) {
//           parent.replies.add(comment);
//         }
//       } else {
//         topLevelComments.add(comment);
//       }
//     }

//     return topLevelComments;
//   }

//   void sendComment(String content) {
//     if (content.trim().isEmpty) return;

//     final messageData = {
//       'msg': content,
//       'senderId': widget.currentUser.id,
//       'senderName': widget.currentUser.username,
//       'profileImage': widget.currentUser.profileImage,
//       'postId': widget.postId,
//       'parentId': replyingToCommentId,
//     };

//     final newComment = Comment(
//       id: DateTime.now().toString(),
//       postId: widget.postId,
//       postType: widget.postType,
//       userId: widget.currentUser.id,
//       content: content,
//       likes: [],
//       createdAt: DateTime.now(),
//       user: widget.currentUser,
//       parentId: replyingToCommentId,
//       replies: [],
//     );

//     setState(() {
//       // If it's a reply, add it to the parent's replies
//       if (replyingToCommentId != null) {
//         final parentIndex = comments.indexWhere((c) => c.id == replyingToCommentId);
//         if (parentIndex != -1) {
//           comments[parentIndex].replies.add(newComment);
//           // Automatically expand the comment when adding a new reply
//           expandedComments.add(replyingToCommentId!);
//         }
//       } else {
//         // If it's a top-level comment, add it to the main list
//         comments.add(newComment);
//       }
//     });

//     // Send message to server
//     socket!.emit('sendMsg', messageData);
    
//     // Clear input and reply state
//     _commentController.clear();
//     _cancelReply();
//   }


//   void _insertEmoji(String emoji) {
//     final text = _commentController.text;
//     final selection = _commentController.selection;
//     final newText = text.replaceRange(selection.start, selection.end, emoji);
//     _commentController.value = TextEditingValue(
//       text: newText,
//       selection: TextSelection.collapsed(
//         offset: selection.baseOffset + emoji.length,
//       ),
//     );
//   }

//   void _startReply(String username, String commentId) {
//     setState(() {
//       replyingToUsername = username;
//       replyingToCommentId = commentId;
//       FocusScope.of(context).requestFocus(FocusNode());
//     });
//   }

//   void _cancelReply() {
//     setState(() {
//       replyingToUsername = null;
//       replyingToCommentId = null;
//     });
//   }

//   @override
//   void dispose() {
//     socket?.disconnect();
//     _commentController.dispose();
//     super.dispose();
//   }



//     @override
//   Widget build(BuildContext context) {
//     final topLevelComments = organizedComments;
    
//     return Container(
//       constraints: BoxConstraints(
//         maxHeight: MediaQuery.of(context).size.height / 1.5,
//       ),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(15),
//           topRight: Radius.circular(15),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 const Expanded(
//                   child: Text(
//                     'Comments',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 Text(
//                   '${comments.length}',
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           const Divider(),
          
//           Expanded(
//             child: ListView.builder(
//               itemCount: topLevelComments.length,
//               itemBuilder: (context, index) {
//                 return _buildCommentWithReplies(topLevelComments[index]);
//               },
//             ),
//           ),
          
//           if (replyingToUsername != null)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               color: Colors.grey[100],
//               child: Row(
//                 children: [
//                   Text(
//                     'Replying to @$replyingToUsername',
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 12,
//                     ),
//                   ),
//                   const Spacer(),
//                   GestureDetector(
//                     onTap: _cancelReply,
//                     child: Icon(
//                       Icons.close,
//                       size: 16,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
            
//           Container(
//             height: 50,
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: emojis.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () => _insertEmoji(emojis[index]),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     child: Text(
//                       emojis[index],
//                       style: const TextStyle(fontSize: 24),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
          
//           Container(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//               left: 16,
//               right: 16,
//               top: 8,
//               // bottom: 8,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border(
//                 top: BorderSide(
//                   color: Colors.grey[200]!,
//                   width: 1,
//                 ),
//               ),
//             ),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 18,
//                   backgroundImage: NetworkImage(
//                     widget.currentUser.profileImage ?? 'https://via.placeholder.com/36'
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: TextField(
//                     controller: _commentController,
//                     decoration: InputDecoration(
//                       hintText: replyingToUsername != null 
//                           ? 'Reply to @$replyingToUsername...'
//                           : 'Add a comment...',
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   color: Colors.blue,
//                   onPressed: () => sendComment(_commentController.text),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCommentWithReplies(Comment comment) {
//     final hasReplies = comment.replies.isNotEmpty;
//     final isExpanded = expandedComments.contains(comment.id);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CommentTileWidget(
//           username: comment.user?.username ?? 'Unknown',
//           comment: comment.content,
//           timeAgo: _getTimeAgo(comment.createdAt),
//           profileImageUrl: comment.user?.profileImage ?? 'https://via.placeholder.com/40',
//           onReply: (username) => _startReply(username, comment.id),
//         ),
//         if (hasReplies) ...[
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 if (isExpanded) {
//                   expandedComments.remove(comment.id);
//                 } else {
//                   expandedComments.add(comment.id);
//                 }
//               });
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(left: 56, top: 4, bottom: 8),
//               child: Text(
//                 isExpanded 
//                     ? 'Hide replies'
//                     : '${comment.replies.length == 1 ? "View 1 reply" : "View ${comment.replies.length} replies"}',
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//           if (isExpanded)
//             Container(
//               margin: const EdgeInsets.only(left: 40),
//               decoration: BoxDecoration(
//                 border: Border(
//                   left: BorderSide(
//                     color: Colors.grey[300]!,
//                     width: 1.5,
//                   ),
//                 ),
//               ),
//               child: Column(
//                 children: comment.replies.map((reply) {
//                   return Padding(
//                     padding: const EdgeInsets.only(left: 16),
//                     child: CommentTileWidget(
//                       username: reply.user?.username ?? 'Unknown',
//                       comment: reply.content,
//                       timeAgo: _getTimeAgo(reply.createdAt),
//                       profileImageUrl: reply.user?.profileImage ?? 'https://via.placeholder.com/40',
//                       onReply: (username) => _startReply(username, comment.id),
//                       isReply: true,
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//         ],
//       ],
//     );
//   }

//   String _getTimeAgo(DateTime dateTime) {
//     final difference = DateTime.now().difference(dateTime);
//     if (difference.inDays > 0) {
//       return '${difference.inDays}d';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours}h';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes}m';
//     } else {
//       return 'now';
//     }
//   }
// }






















// @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     constraints: BoxConstraints(
  //       maxHeight: MediaQuery.of(context).size.height / 1.5,
  //     ),
  //     decoration: const BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(15),
  //         topRight: Radius.circular(15),
  //       ),
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Row(
  //             children: [
  //               const Expanded(
  //                 child: Text(
  //                   'Comments',
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 ),
  //               ),
  //               Text(
  //                 '${comments.length}',
  //                 style: TextStyle(
  //                   color: Colors.grey[600],
  //                   fontSize: 16,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
          
  //         const Divider(),
          
  //         Expanded(
  //           child: ListView.builder(
  //             itemCount: comments.length,
  //             itemBuilder: (context, index) {
  //               final comment = comments[index];
  //               return Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   CommentTileWidget(
  //                     username: comment.user?.username ?? 'Unknown',
  //                     comment: comment.content,
  //                     timeAgo: _getTimeAgo(comment.createdAt),
  //                     profileImageUrl: comment.user?.profileImage ?? 'https://via.placeholder.com/40',
  //                     onReply: (username) => _startReply(username, comment.id),
  //                   ),
  //                   // Indented replies
  //                   if (comment.replies.isNotEmpty)
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 40),
  //                       child: Column(
  //                         children: comment.replies.map((reply) => 
  //                           CommentTileWidget(
  //                             username: reply.user?.username ?? 'Unknown',
  //                             comment: reply.content,
  //                             timeAgo: _getTimeAgo(reply.createdAt),
  //                             profileImageUrl: reply.user?.profileImage ?? 'https://via.placeholder.com/40',
  //                             onReply: (username) => _startReply(username, comment.id),
  //                           ),
  //                         ).toList(),
  //                       ),
  //                     ),
  //                 ],
  //               );
  //             },
  //           ),
  //         ),
          
  //         if (replyingToUsername != null)
  //           Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //             color: Colors.grey[100],
  //             child: Row(
  //               children: [
  //                 Text(
  //                   'Replying to @$replyingToUsername',
  //                   style: TextStyle(
  //                     color: Colors.grey[600],
  //                     fontSize: 12,
  //                   ),
  //                 ),
  //                 const Spacer(),
  //                 GestureDetector(
  //                   onTap: _cancelReply,
  //                   child: Icon(
  //                     Icons.close,
  //                     size: 16,
  //                     color: Colors.grey[600],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
            
  //         Container(
  //           height: 50,
  //           padding: const EdgeInsets.symmetric(horizontal: 8),
  //           child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             itemCount: emojis.length,
  //             itemBuilder: (context, index) {
  //               return GestureDetector(
  //                 onTap: () => _insertEmoji(emojis[index]),
  //                 child: Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 8),
  //                   child: Text(
  //                     emojis[index],
  //                     style: const TextStyle(fontSize: 24),
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
          
  //         Container(
  //           padding: EdgeInsets.only(
  //             bottom: MediaQuery.of(context).viewInsets.bottom,
  //             left: 16,
  //             right: 16,
  //           ),
  //           child: Row(
  //             children: [
  //               CircleAvatar(
  //                 radius: 18,
  //                 backgroundImage: NetworkImage(
  //                   widget.currentUser.profileImage ?? 'https://via.placeholder.com/36'
  //                 ),
  //               ),
  //               const SizedBox(width: 12),
  //               Expanded(
  //                 child: TextField(
  //                   controller: _commentController,
  //                   decoration: InputDecoration(
  //                     hintText: replyingToUsername != null 
  //                         ? 'Reply to @$replyingToUsername...'
  //                         : 'Add a comment...',
  //                     border: InputBorder.none,
  //                   ),
  //                 ),
  //               ),
  //               IconButton(
  //                 icon: const Icon(Icons.send),
  //                 color: Colors.blue,
  //                 onPressed: () => sendComment(_commentController.text),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
