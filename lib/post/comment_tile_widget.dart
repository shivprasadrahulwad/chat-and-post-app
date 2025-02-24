import 'package:flutter/material.dart';

// class CommentTileWidget extends StatefulWidget {
//   final String username;
//   final String comment;
//   final String timeAgo;
//   final String profileImageUrl;
//   final Function(String) onReply;
//   final bool isReply;

//   const CommentTileWidget({
//     Key? key,
//     required this.username,
//     required this.comment,
//     required this.timeAgo,
//     required this.profileImageUrl,
//     required this.onReply,
//     this.isReply = false,
//   }) : super(key: key);

//   @override
//   _CommentTileWidgetState createState() => _CommentTileWidgetState();
// }

// class _CommentTileWidgetState extends State<CommentTileWidget> {
//   bool isLiked = false;
//   int likeCount = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CircleAvatar(
//               radius: 20,
//               backgroundImage: NetworkImage(widget.profileImageUrl),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         widget.username,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         widget.timeAgo,
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     widget.comment,
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                   const SizedBox(height: 4),
//                   GestureDetector(
//                     onTap: () => widget.onReply(widget.username),
//                     child: Text(
//                       'Reply',
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     isLiked ? Icons.favorite : Icons.favorite_border,
//                     color: isLiked ? Colors.red : Colors.grey,
//                     size: 16,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       isLiked = !isLiked;
//                       likeCount += isLiked ? 1 : -1;
//                     });
//                   },
//                 ),
//                 Text(
//                   likeCount.toString(),
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }



class CommentTileWidget extends StatefulWidget {
  final String username;
  final String comment;
  final String timeAgo;
  final String profileImageUrl;
  final Function(String) onReply;
  final bool isReply;

  const CommentTileWidget({
    Key? key,
    required this.username,
    required this.comment,
    required this.timeAgo,
    required this.profileImageUrl,
    required this.onReply,
    this.isReply = false,
  }) : super(key: key);

  @override
  _CommentTileWidgetState createState() => _CommentTileWidgetState();
}

class _CommentTileWidgetState extends State<CommentTileWidget> {
  bool isLiked = false;
  int likeCount = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: widget.isReply ? 8 : 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: widget.isReply ? 16 : 20,
            backgroundImage: NetworkImage(widget.profileImageUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget.isReply ? 13 : 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.timeAgo,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: widget.isReply ? 11 : 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.comment,
                  style: TextStyle(
                    fontSize: widget.isReply ? 13 : 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => widget.onReply(widget.username),
                      child: Text(
                        'Reply',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: widget.isReply ? 11 : 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (likeCount > 0) ...[
                      const SizedBox(width: 12),
                      Text(
                        '$likeCount ${likeCount == 1 ? 'like' : 'likes'}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: widget.isReply ? 11 : 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.grey,
                  size: widget.isReply ? 14 : 16,
                ),
                constraints: BoxConstraints(
                  minWidth: widget.isReply ? 30 : 40,
                  minHeight: widget.isReply ? 30 : 40,
                ),
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked;
                    likeCount += isLiked ? 1 : -1;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}