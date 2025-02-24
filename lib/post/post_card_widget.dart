import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:friends/model/post.dart';
import 'package:friends/model/user_preview.dart';
import 'package:friends/post/commets_bottom_sheet.dart';
import 'package:friends/post/post_action_bottom_sheet.dart';



class PostCardWidget extends StatelessWidget {
  final Post post;
  final UserPreview currentUser;
  final Function(String) onLike;

  static const String serverBaseUrl = "http://192.168.1.104:5000";

  const PostCardWidget({
    super.key,
    required this.post,
    required this.currentUser,
    required this.onLike,
  });

  bool get isLiked => post.likes.contains(currentUser.id);

  String? _getFullImageUrl(String? mediaUrl) {
    if (mediaUrl == null) return null;
    if (mediaUrl.startsWith('http')) return mediaUrl;
    return '$serverBaseUrl$mediaUrl';
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  void showCommentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentBottomSheet(
        postId: post.id,
        currentUser: currentUser,
        postType: 'post',
      ),
    );
  }

    void _showPostActionSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => PostActionSheet(
      postId: post.id,
      userId: post.user?.id ?? '',
      postType: 'post',
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with user info
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Hero(
                      tag: 'profile-${post.user?.id}',
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF6C63FF), Color(0xFF4834DF)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C63FF).withOpacity(0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(2),
                        child: CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.white,
                          backgroundImage: post.user?.profileImage != null
                              ? NetworkImage(_getFullImageUrl(post.user!.profileImage!)!)
                              : null,
                          child: post.user?.profileImage == null
                              ? Text(
                                  post.user?.username.substring(0, 1).toUpperCase() ?? '',
                                  style: const TextStyle(
                                    color: Color(0xFF6C63FF),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.user?.username ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1F36),
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _getTimeAgo(post.createdAt),
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF1A1F36).withOpacity(0.6),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz_rounded),
                      color: const Color(0xFF1A1F36).withOpacity(0.6),
                      onPressed: () => _showPostActionSheet(context),
                    ),
                  ],
                ),
              ),

              // Caption with gradient background
              if (post.content != null && post.content!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.95),
                      ],
                    ),
                  ),
                  child: Text(
                    post.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Color(0xFF1A1F36),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),

              // Media Content
              if (post.mediaUrl != null)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  child: Stack(
                    children: [
                      Hero(
                        tag: 'post-image-${post.id}',
                        child: Image.network(
                          _getFullImageUrl(post.mediaUrl!)!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 300,
                              color: const Color(0xFFF4F5F7),
                              child: Center(
                                child: LoadingIndicator(
                                  progress: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 300,
                              color: const Color(0xFFF4F5F7),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.image_not_supported_rounded,
                                    size: 48,
                                    color: Color(0xFF6C63FF),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Image unavailable',
                                    style: TextStyle(
                                      color: const Color(0xFF1A1F36).withOpacity(0.8),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // Interaction overlay with glassmorphism
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.black.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Row(
                                children: [
                                  _AnimatedActionButton(
                                    icon: isLiked
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_outline_rounded,
                                    label: post.likes.length.toString(),
                                    isActive: isLiked,
                                    onTap: () => onLike(post.id),
                                  ),
                                  const SizedBox(width: 24),
                                  _AnimatedActionButton(
                                    icon: Icons.chat_bubble_outline_rounded,
                                    label: (post.commentCount ?? 0).toString(),
                                    onTap: () => showCommentSheet(context),
                                  ),
                                  const Spacer(),
                                  _AnimatedActionButton(
                                    icon: Icons.share_outlined,
                                    onTap: () {
                                      // Add share functionality
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                // Actions without image
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _AnimatedActionButton(
                        icon: isLiked
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline_rounded,
                        label: post.likes.length.toString(),
                        isActive: isLiked,
                        onTap: () => onLike(post.id),
                        darkMode: false,
                      ),
                      const SizedBox(width: 24),
                      _AnimatedActionButton(
                        icon: Icons.chat_bubble_outline_rounded,
                        label: (post.commentCount ?? 0).toString(),
                        onTap: () => showCommentSheet(context),
                        darkMode: false,
                      ),
                      const Spacer(),
                      _AnimatedActionButton(
                        icon: Icons.share_outlined,
                        onTap: () {
                          // Add share functionality
                        },
                        darkMode: false,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedActionButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final bool isActive;
  final VoidCallback onTap;
  final bool darkMode;

  const _AnimatedActionButton({
    required this.icon,
    this.label,
    this.isActive = false,
    required this.onTap,
    this.darkMode = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = darkMode
        ? Colors.white
        : (isActive ? const Color(0xFF6C63FF) : const Color(0xFF1A1F36));

    final Color textColor = darkMode ? Colors.white : const Color(0xFF1A1F36);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? (darkMode ? Colors.white.withOpacity(0.2) : const Color(0xFF6C63FF).withOpacity(0.1))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: isActive ? 1.1 : 1.0,
                child: Icon(
                  icon,
                  size: 24,
                  color: iconColor,
                ),
              ),
              if (label != null) ...[
                const SizedBox(width: 8),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                  child: Text(label!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  final double? progress;

  const LoadingIndicator({super.key, this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      padding: const EdgeInsets.all(4),
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: 3,
        backgroundColor: const Color(0xFF6C63FF).withOpacity(0.2),
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
      ),
    );
  }
}
