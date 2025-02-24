import 'package:flutter/material.dart';

class JoinScreen extends StatelessWidget {
  const JoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.deepPurple),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Join Your Tribe! 🎓✨\n\n"
              "Where memories are made, friendships are forged, and stories become legends.",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
                height: 1.4,
                fontStyle: FontStyle.italic
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Find your people. Share your vibe. Make college unforgettable! 🚀",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: ListView(
                children: [
                  buildJoinTile(
                    Icons.create_rounded,
                    "Your Stories",
                    "Share your epic moments and thoughts!",
                    "From midnight study sessions to surprise campus flash mobs",
                  ),
                  const SizedBox(height: 16),
                  buildJoinTile(
                    Icons.favorite_rounded,
                    "Secret Crushes",
                    "Express your feelings anonymously! 💝",
                    "Because sometimes the best love stories start with a confession",
                  ),
                  const SizedBox(height: 16),
                  buildJoinTile(
                    Icons.emoji_events_rounded,
                    "Event Squad",
                    "Find your crew for upcoming events! 🎉",
                    "From sports tournaments to cultural fests",
                  ),
                  const SizedBox(height: 16),
                  buildJoinTile(
                    Icons.camera_alt_rounded,
                    "Campus Shots",
                    "Share the perfect Instagram moments! 📸",
                    "Because every corner has a story to tell",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildJoinTile(IconData icon, String title, String subtitle, String description) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, size: 30, color: Colors.deepPurple),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepPurple.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              "Join",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';

// class JoinScreen extends StatelessWidget {
//   const JoinScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.deepPurple),
//           onPressed: () => Navigator.pop(context),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           // Quote Container with Gradient Background
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.deepPurple.shade50,
//                   Colors.white,
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//             child: Column(
//               children: [
//                 const Text(
//                   "Every memory here becomes a story worth telling.",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.deepPurple,
//                     height: 1.4,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "- Campus Life",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.deepPurple.shade300,
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           // Groups List
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 buildGroupTile(
//                   context,
//                   "Campus Stories 📝",
//                   "Share your daily adventures",
//                   () => Navigator.push(context, 
//                     MaterialPageRoute(builder: (context) => const DummyScreen("Campus Stories"))
//                   ),
//                 ),
//                 buildGroupTile(
//                   context,
//                   "Confession Corner 💝",
//                   "Express yourself anonymously",
//                   () => Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => const DummyScreen("Confession Corner"))
//                   ),
//                 ),
//                 buildGroupTile(
//                   context,
//                   "Event Squad 🎉",
//                   "Find your festival crew",
//                   () => Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => const DummyScreen("Event Squad"))
//                   ),
//                 ),
//                 buildGroupTile(
//                   context,
//                   "Campus Shots 📸",
//                   "Share your perfect moments",
//                   () => Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => const DummyScreen("Campus Shots"))
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildGroupTile(BuildContext context, String title, String subtitle, VoidCallback onTap) {
//     return Card(
//       elevation: 0,
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(color: Colors.grey.shade200),
//       ),
//       child: ListTile(
//         onTap: onTap,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.deepPurple,
//           ),
//         ),
//         subtitle: Padding(
//           padding: const EdgeInsets.only(top: 4),
//           child: Text(
//             subtitle,
//             style: TextStyle(
//               color: Colors.grey.shade600,
//               fontSize: 14,
//             ),
//           ),
//         ),
//         trailing: Icon(
//           Icons.arrow_forward_ios,
//           color: Colors.deepPurple.shade300,
//           size: 20,
//         ),
//       ),
//     );
//   }
// }

// // Dummy Screen for Navigation Demo
// class DummyScreen extends StatelessWidget {
//   final String title;
//   const DummyScreen(this.title, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepPurple,
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               child: const Text(
//                 "Join Now",
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }