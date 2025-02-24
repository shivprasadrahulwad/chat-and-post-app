import 'package:flutter/material.dart';
import 'package:friends/model/confession.dart';
import 'package:friends/model/user_preview.dart';
import 'package:friends/post/commets_bottom_sheet.dart';
import 'package:friends/post/post_action_bottom_sheet.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfessionCardWidget extends StatelessWidget {
  final Confession confession;
  final UserPreview currentUser;
  final Function(String) onLike;


  // Custom colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFFFF6584);
  static const Color backgroundColor = Color(0xFFF8F9FF);
  static const Color textPrimaryColor = Color(0xFF2D3436);
  static const Color textSecondaryColor = Color(0xFF636E72);

  const ConfessionCardWidget({
    super.key,
    required this.confession,
    required this.currentUser,
    required this.onLike,
  });

  bool get isLiked => confession.isLikedByCurrentUser;

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
        postId: confession.id,
        postType: 'confession',
        currentUser: currentUser,
      ),
    );
  }

  Color _getCategoryColor() {
    // Add different colors for different categories
    switch (confession.category.toLowerCase()) {
      case 'love':
        return const Color(0xFFFF6B6B);
      case 'life':
        return const Color(0xFF4ECDC4);
      case 'family':
        return const Color(0xFFFFBE0B);
      case 'work':
        return const Color(0xFF45B7D1);
      case 'school':
        return const Color(0xFFA78BFA);
      default:
        return primaryColor;
    }
  }

   void _showPostActionSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => PostActionSheet(
      postId: confession.id,
      userId:  confession.userId,
      postType: 'confession',
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Category indicator line
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 4,
                height: 100,
                color: _getCategoryColor(),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: confession.isAnonymous 
                                ? [const Color(0xFFE0E0E0), const Color(0xFFF5F5F5)]
                                : [primaryColor, primaryColor.withOpacity(0.7)],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Icon(
                            confession.isAnonymous ? Icons.block : Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // User Info & Category
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              confession.isAnonymous ? 'Anonymous Soul' : 'User',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getCategoryColor().withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    confession.category,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: _getCategoryColor(),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _getTimeAgo(confession.createdAt),
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: textSecondaryColor,
                                  ),
                                ),
                              ],
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

                  // Confession Content
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      confession.content,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        height: 1.5,
                        color: textPrimaryColor,
                      ),
                    ),
                  ),

                  // Action Buttons
                  Row(
                    children: [
                      _ActionButton(
        icon: isLiked ? Icons.favorite : Icons.favorite_outline,
        label: confession.likesCount.toString(),
        color: isLiked ? secondaryColor : textSecondaryColor,
        onTap: () => onLike(confession.id),
      ),
                      const SizedBox(width: 24),
                      _ActionButton(
                        icon: Icons.chat_bubble_outline_rounded,
                        label: confession.commentsCount.toString(),
                        color: textSecondaryColor,
                        onTap: () => showCommentSheet(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}