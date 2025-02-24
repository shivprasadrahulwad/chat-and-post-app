import 'package:flutter/material.dart';
import 'package:friends/screens/settings/app_lock_screen.dart';
import 'package:friends/screens/settings/blocked_contacts_screen.dart';
import 'package:friends/screens/settings/biometric_chat_lock_screen.dart';
import 'package:friends/screens/settings/message_timer_screen.dart';
import 'package:friends/screens/settings/privacy_checkup_screen.dart';

// Privacy Screen Main Page
// class PrivacyScreen extends StatelessWidget {
//   const PrivacyScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Privacy'),
//       ),
//       body: ListView(
//         children: [
//           PrivacyTile(
//             icon: Icons.block,
//             title: 'Blocked contacts',
//             subtitle: '33',
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const BlockedContactsScreen()),
//               );
//             },
//           ),
//           PrivacyTile(
//             icon: Icons.lock,
//             title: 'App lock',
//             subtitle: 'Disabled',
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const AppLockScreen()),
//               );
//             },
//           ),
//           PrivacyTile(
//             icon: Icons.lock_outline,
//             title: 'Chat lock',
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ChatLockScreen()),
//               );
//             },
//           ),
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               'Disappearing messages',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           PrivacyTile(
//             icon: Icons.timer,
//             title: 'Default message timer',
//             subtitle: 'Start new chats with disappearing messages set to your timer',
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const MessageTimerScreen()),
//               );
//             },
//           ),
//           PrivacyTile(
//             icon: Icons.security,
//             title: 'Privacy checkup',
//             subtitle: 'Control your privacy and choose the right settings for you',
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const PrivacyCheckupScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Reusable Privacy Tile Widget
// class PrivacyTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String? subtitle;
//   final VoidCallback onTap;

//   const PrivacyTile({
//     Key? key,
//     required this.icon,
//     required this.title,
//     this.subtitle,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(icon),
//       title: Text(title),
//       subtitle: subtitle != null ? Text(subtitle!) : null,
//       onTap: onTap,
//     );
//   }
// }


import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Privacy',
          style: TextStyle(
            color: Color(0xFF2D3142),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3142)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                PrivacyTile(
                  icon: Icons.block,
                  iconColor: const Color(0xFFFF6B6B),
                  title: 'Blocked contacts',
                  subtitle: '33',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BlockedContactsScreen()),
                  ),
                ),
                const Divider(height: 1),
                PrivacyTile(
                  icon: Icons.lock,
                  iconColor: const Color(0xFF4ECDC4),
                  title: 'App lock',
                  subtitle: 'Disabled',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AppLockScreen()),
                  ),
                ),
                const Divider(height: 1),
                PrivacyTile(
                  icon: Icons.lock_outline,
                  iconColor: const Color(0xFF45B7D1),
                  title: 'Chat lock',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatLockScreen()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 16),
            child: Text(
              'Disappearing messages',
              style: TextStyle(
                color: const Color(0xFF2D3142).withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                PrivacyTile(
                  icon: Icons.timer,
                  iconColor: const Color(0xFFFFBE0B),
                  title: 'Default message timer',
                  subtitle: 'Start new chats with disappearing messages set to your timer',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MessageTimerScreen()),
                  ),
                ),
                const Divider(height: 1),
                PrivacyTile(
                  icon: Icons.security,
                  iconColor: const Color(0xFF6C63FF),
                  title: 'Privacy checkup',
                  subtitle: 'Control your privacy and choose the right settings for you',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PrivacyCheckupScreen()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PrivacyTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const PrivacyTile({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF2D3142).withOpacity(0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF2D3142),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}