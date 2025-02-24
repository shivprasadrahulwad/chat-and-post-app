import 'package:flutter/material.dart';

// class HelpScreen extends StatelessWidget {
//   const HelpScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Help'),
//       ),
//       body: ListView(
//         children: [
//           HelpTile(
//             icon: Icons.help_outline,
//             title: 'Help Center',
//             subtitle: 'Get help, contact us',
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
//               );
//             },
//           ),
//           HelpTile(
//             icon: Icons.description_outlined,
//             title: 'Terms and Privacy Policy',
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const TermsPrivacyScreen()),
//               );
//             },
//           ),
//           HelpTile(
//             icon: Icons.info_outline,
//             title: 'App Info',
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const AppInfoScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Reusable Help Tile Widget
// class HelpTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String? subtitle;
//   final VoidCallback onTap;

//   const HelpTile({
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
//       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//       onTap: onTap,
//     );
//   }
// }

// // Individual Screen Classes for Navigation
// class HelpCenterScreen extends StatelessWidget {
//   const HelpCenterScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Help Center'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           const Text(
//             'How can we help you?',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           // Add contact options, FAQs, etc.
//           Card(
//             child: ListTile(
//               leading: const Icon(Icons.email_outlined),
//               title: const Text('Contact Support'),
//               onTap: () {
//                 // Implement email support
//               },
//             ),
//           ),
//           const SizedBox(height: 8),
//           Card(
//             child: ListTile(
//               leading: const Icon(Icons.chat_outlined),
//               title: const Text('Live Chat'),
//               onTap: () {
//                 // Implement live chat
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TermsPrivacyScreen extends StatelessWidget {
//   const TermsPrivacyScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Terms and Privacy Policy'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: const [
//           Text(
//             'Terms of Service',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Please read these terms carefully before using the application...',
//           ),
//           SizedBox(height: 24),
//           Text(
//             'Privacy Policy',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Your privacy is important to us...',
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Help & Support',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
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
                  HelpTile(
                    icon: Icons.help_outline,
                    iconColor: const Color(0xFF6C63FF),
                    title: 'Help Center',
                    subtitle: 'Get help, contact us',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
                    ),
                  ),
                  const Divider(height: 1),
                  HelpTile(
                    icon: Icons.description_outlined,
                    iconColor: const Color(0xFF4ECDC4),
                    title: 'Terms and Privacy Policy',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TermsPrivacyScreen()),
                    ),
                  ),
                  const Divider(height: 1),
                  HelpTile(
                    icon: Icons.info_outline,
                    iconColor: const Color(0xFFFFBE0B),
                    title: 'App Info',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AppInfoScreen()),
                    ),
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

class HelpTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const HelpTile({
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
                child: Icon(icon, color: iconColor, size: 24),
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

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Help Center',
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
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text(
            'How can we help you?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Choose from the options below to get assistance',
            style: TextStyle(
              fontSize: 16,
              color: const Color(0xFF2D3142).withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 32),
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
                _SupportOption(
                  icon: Icons.email_outlined,
                  iconColor: const Color(0xFF6C63FF),
                  title: 'Email Support',
                  subtitle: 'Get help via email',
                  onTap: () {
                    // Implement email support
                  },
                ),
                const Divider(height: 1),
                _SupportOption(
                  icon: Icons.chat_outlined,
                  iconColor: const Color(0xFF4ECDC4),
                  title: 'Live Chat',
                  subtitle: 'Chat with our support team',
                  onTap: () {
                    // Implement live chat
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SupportOption({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
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
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF2D3142).withOpacity(0.6),
                      ),
                    ),
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

class TermsPrivacyScreen extends StatelessWidget {
  const TermsPrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Terms & Privacy',
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
        padding: const EdgeInsets.all(24.0),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Terms of Service',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Please read these terms carefully before using the application...',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: const Color(0xFF2D3142).withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your privacy is important to us...',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: const Color(0xFF2D3142).withOpacity(0.8),
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

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'App Info',
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
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
                  _InfoTile(
                    title: 'Version',
                    value: '1.0.0',
                    showDivider: true,
                  ),
                  _InfoTile(
                    title: 'Build Number',
                    value: '100',
                    showDivider: true,
                  ),
                  _InfoTile(
                    title: 'Check for Updates',
                    trailing: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.system_update,
                        color: Color(0xFF6C63FF),
                        size: 20,
                      ),
                    ),
                    onTap: () {
                      // Implement update check
                    },
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


class _InfoTile extends StatelessWidget {
  final String title;
  final String? value;
  final Widget? trailing;
  final bool showDivider;
  final VoidCallback? onTap;

  const _InfoTile({
    Key? key,
    required this.title,
    this.value,
    this.trailing,
    this.showDivider = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2D3142),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                if (value != null)
                  Text(
                    value!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF9497A1),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: Color(0xFFEEEFF3),
          ),
      ],
    );
  }
}
