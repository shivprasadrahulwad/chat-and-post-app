import 'package:flutter/material.dart';
import 'package:friends/screens/Home/qr_scan_screen.dart';
import 'package:friends/screens/chat/create_new_password.dart';
import 'package:friends/screens/chat/passowrd_reset_screen.dart';
import 'package:friends/screens/qr_code/qr_code_screen.dart';
import 'package:friends/screens/settings/account_screen.dart';
import 'package:friends/screens/settings/help_screen.dart';
import 'package:friends/screens/settings/notifications_setting_screen.dart';
import 'package:friends/screens/settings/privacy_screen.dart';

// class SettingsScreen extends StatefulWidget {
//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Settings'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   const CircleAvatar(
//                     radius: 30,
//                     backgroundImage: NetworkImage(
//                       'https://via.placeholder.com/150',
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   const Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Shivprasad Rahulwad',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         'If you really look clocks',
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     icon: const Icon(Icons.qr_code),
//                     onPressed: () {
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //       builder: (context) => const QRCodeScreen()),
//                       // );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const Divider(),
//             SettingsTile(
//               icon: Icons.person,
//               title: 'Account',
//               subtitle: 'Security notifications, change number',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const AccountScreen()),
//                 );
//               },
//             ),
//             SettingsTile(
//               icon: Icons.lock,
//               title: 'Privacy',
//               subtitle: 'Block contacts, disappearing messages',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const PrivacyScreen()),
//                 );
//               },
//             ),
//             SettingsTile(
//               icon: Icons.message,
//               title: 'Chats',
//               subtitle: 'Themes, wallpapers, chat history',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => NotificationSettingScreen()),
//                 );
//               },
//             ),
//             SettingsTile(
//               icon: Icons.notifications,
//               title: 'Notifications',
//               subtitle: 'Message, group & call tones',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) =>
//                           NotificationSettingScreen()),
//                 );
//               },
//             ),
//             SettingsTile(
//               icon: Icons.storage,
//               title: 'Storage and data',
//               subtitle: 'Network usage, auto-download',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) =>  PasswordResetScreen()),
//                 );
//               },
//             ),
//             SettingsTile(
//               icon: Icons.language,
//               title: 'App language',
//               subtitle: 'English (device language)',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => CreateNewPassword()),
//                 );
//               },
//             ),
//             SettingsTile(
//               icon: Icons.help,
//               title: 'Help',
//               subtitle: 'Help center, contact us, privacy policy',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const HelpScreen()),
//                 );
//               },
//             ),
//             SettingsTile(
//               icon: Icons.group,
//               title: 'Invite friends',
//               subtitle: '',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const HelpScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SettingsTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final VoidCallback onTap;

//   const SettingsTile({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(icon, size: 28),
//       title: Text(
//         title,
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//       subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
//       onTap: onTap,
//     );
//   }
// }








import 'package:flutter/material.dart';

// Modern color scheme
const Color primaryColor = Color(0xFF6366F1);
const Color secondaryColor = Color(0xFF0F172A);
const Color backgroundColor = Color(0xFFF8FAFC);
const Color surfaceColor = Color(0xFFFFFFFF);
const Color textColor = Color(0xFF1E293B);
const Color subtitleColor = Color(0xFF64748B);
const Color dividerColor = Color(0xFFE2E8F0);

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: surfaceColor,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor.withOpacity(0.2),
                        width: 3,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 35,
                      backgroundColor: primaryColor,
                      backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150',
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Shivprasad Rahulwad',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'If you really look clocks',
                          style: TextStyle(
                            color: subtitleColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.qr_code, color: primaryColor),
                      onPressed: () {
                                              Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QRCodeScreen()),
                      );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: surfaceColor,
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
                  ModernSettingsTile(
                    icon: Icons.person,
                    iconBackground: const Color(0xFFECFDF5),
                    iconColor: const Color(0xFF059669),
                    title: 'Account',
                    subtitle: 'Security notifications, change number',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AccountScreen()),
                    ),
                  ),
                  const CustomDivider(),
                  ModernSettingsTile(
                    icon: Icons.lock,
                    iconBackground: const Color(0xFFF0F9FF),
                    iconColor: const Color(0xFF0284C7),
                    title: 'Privacy',
                    subtitle: 'Block contacts, disappearing messages',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacyScreen()),
                    ),
                  ),
                  const CustomDivider(),
                  ModernSettingsTile(
                    icon: Icons.message,
                    iconBackground: const Color(0xFFFDF2F8),
                    iconColor: const Color(0xFFDB2777),
                    title: 'Chats',
                    subtitle: 'Themes, wallpapers, chat history',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationSettingScreen()),
                    ),
                  ),
                  const CustomDivider(),
                  ModernSettingsTile(
                    icon: Icons.notifications,
                    iconBackground: const Color(0xFFFEF3C7),
                    iconColor: const Color(0xFFD97706),
                    title: 'Notifications',
                    subtitle: 'Message, group & call tones',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationSettingScreen()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: surfaceColor,
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
                  ModernSettingsTile(
                    icon: Icons.storage,
                    iconBackground: const Color(0xFFF3E8FF),
                    iconColor: const Color(0xFF9333EA),
                    title: 'Storage and data',
                    subtitle: 'Network usage, auto-download',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PasswordResetScreen()),
                    ),
                  ),
                  const CustomDivider(),
                  ModernSettingsTile(
                    icon: Icons.language,
                    iconBackground: const Color(0xFFFFE4E6),
                    iconColor: const Color(0xFFE11D48),
                    title: 'App language',
                    subtitle: 'English (device language)',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateNewPassword()),
                    ),
                  ),
                  const CustomDivider(),
                  ModernSettingsTile(
                    icon: Icons.help,
                    iconBackground: const Color(0xFFDCFCE7),
                    iconColor: const Color(0xFF22C55E),
                    title: 'Help',
                    subtitle: 'Help center, contact us, privacy policy',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpScreen()),
                    ),
                  ),
                  const CustomDivider(),
                  ModernSettingsTile(
                    icon: Icons.group,
                    iconBackground: const Color(0xFFE0F2FE),
                    iconColor: const Color(0xFF0EA5E9),
                    title: 'Invite friends',
                    subtitle: 'Share the app with friends and family',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpScreen()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class ModernSettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ModernSettingsTile({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBackground,
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
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: subtitleColor,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      color: dividerColor,
    );
  }
}