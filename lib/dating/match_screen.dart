// import 'package:flutter/material.dart';
// import 'package:friends/dating/matched_profile_screen.dart';

// class MatchesScreen extends StatelessWidget {
//   const MatchesScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Your Matches',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.snooze),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {},
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: 10, // Replace with your actual data length
//         itemBuilder: (context, index) {
//           return MatchTile(
//             completeName: 'John Doe $index',
//             username: '@johndoe$index',
//             profileImageUrl: 'https://example.com/profile$index.jpg',
//             progress: (index + 1) / 10, // Example progress value
//           );
//         },
//       ),
//     );
//   }
// }

// class MatchTile extends StatelessWidget {
//   final String completeName;
//   final String username;
//   final String profileImageUrl;
//   final double progress;

//   const MatchTile({
//     Key? key,
//     required this.completeName,
//     required this.username,
//     required this.profileImageUrl,
//     required this.progress,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => MatchedProfileScreen(
//               // completeName: completeName,
//               username: username,
//               profileImageUrl: profileImageUrl, fullName: 'Shivprasad Rahulwad',
//             ),
//           ),
//         );
//       },
//       child: Card(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 30,
//                     backgroundImage: NetworkImage(profileImageUrl),
//                     onBackgroundImageError: (exception, stackTrace) {
//                       debugPrint("Failed to load image: $exception");
//                     },
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           completeName,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           username,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: LinearProgressIndicator(
//                   value: progress,
//                   backgroundColor: Colors.grey[200],
//                   valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
//                   minHeight: 6,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:friends/dating/matched_profile_screen.dart';

// Color scheme matching the profile screen
const Color primaryColor = Color(0xFF6C63FF);
const Color secondaryColor = Color(0xFF2A2D3E);
const Color accentColor = Color(0xFFFF6584);
const Color backgroundColor = Color(0xFFF8F9FE);
const Color cardColor = Colors.white;
const Color textPrimaryColor = Color(0xFF2A2D3E);
const Color textSecondaryColor = Color(0xFF6B7280);

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Matches',
              style: TextStyle(
                color: textPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              '12 new connections today',
              style: TextStyle(
                color: textSecondaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.timer_outlined, color: primaryColor),
              onPressed: () {},
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: accentColor),
                  onPressed: () {},
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return MatchTile(
            completeName: 'Sarah Parker ${index + 1}',
            username: '@sarah.parker${index + 1}',
            profileImageUrl: 'https://example.com/profile$index.jpg',
            progress: (index + 1) / 10,
            matchPercentage: 85 + index,
            lastActive: '2h ago',
            distance: 'MITAOE, Pune',
          );
        },
      ),
    );
  }
}

class MatchTile extends StatelessWidget {
  final String completeName;
  final String username;
  final String profileImageUrl;
  final double progress;
  final int matchPercentage;
  final String lastActive;
  final String distance;

  const MatchTile({
    Key? key,
    required this.completeName,
    required this.username,
    required this.profileImageUrl,
    required this.progress,
    required this.matchPercentage,
    required this.lastActive,
    required this.distance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchedProfileScreen(
              username: username,
              profileImageUrl: profileImageUrl,
              fullName: completeName,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryColor.withOpacity(0.2),
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(profileImageUrl),
                          onBackgroundImageError: (exception, stackTrace) {
                            debugPrint("Failed to load image: $exception");
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: accentColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: cardColor, width: 2),
                          ),
                          child: const Icon(
                            Icons.favorite,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              completeName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textPrimaryColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$matchPercentage%',
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 14,
                            color: textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: textSecondaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              lastActive,
                              style: TextStyle(
                                fontSize: 12,
                                color: textSecondaryColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: textSecondaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              distance,
                              style: TextStyle(
                                fontSize: 12,
                                color: textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: primaryColor.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.message_rounded,
                        color: accentColor,
                      ),
                      onPressed: () {
                        // Add message action
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}