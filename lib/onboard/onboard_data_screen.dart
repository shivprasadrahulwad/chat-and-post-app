// import 'package:flutter/material.dart';
// import 'package:friends/onboard/gender_selection_widget.dart';
// import 'package:friends/onboard/interested_gender_selection_widget.dart';
// import 'package:friends/onboard/lifestyle_habits_widget.dart';
// import 'package:friends/onboard/looking_for_widget.dart';

// class OnboardDataScreen extends StatefulWidget {
//   const OnboardDataScreen({super.key});

//   @override
//   _OnboardDataScreenState createState() => _OnboardDataScreenState();
// }

// class _OnboardDataScreenState extends State<OnboardDataScreen> {
//   final List<String> sections = [
//     'Personal Information',
//     'Preferences',
//     'Looking For',
//     'Final Review'
//   ];
//   int currentSection = 0;

//   void nextSection() {
//     if (currentSection < sections.length - 1) {
//       setState(() {
//         currentSection++;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Onboarding')),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             LinearProgressIndicator(
//               value: (currentSection + 1) / sections.length,
//               backgroundColor: Colors.grey[300],
//               color: Colors.blue,
//             ),
//             const SizedBox(height: 24),
//             Text(
//               sections[currentSection],
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             if (currentSection == 0) const GenderSelectionWidget(),
//             if (currentSection == 1) const InterestedGenderSelectionWidget(),
//             if (currentSection == 2) const LookingForWidget(),
//             if (currentSection == 3) const LifestyleHabitsWidget(),
//             const Spacer(),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 onPressed: nextSection,
//                 child: Text(
//                   currentSection == sections.length - 1 ? 'Finish' : 'Next',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:friends/onboard/gender_selection_widget.dart';
import 'package:friends/onboard/interested_gender_selection_widget.dart';
import 'package:friends/onboard/lifestyle_habits_widget.dart';
import 'package:friends/onboard/looking_for_widget.dart';

class OnboardDataScreen extends StatefulWidget {
  const OnboardDataScreen({super.key});

  @override
  _OnboardDataScreenState createState() => _OnboardDataScreenState();
}

class _OnboardDataScreenState extends State<OnboardDataScreen> {
  final List<String> sections = [
    'Personal Information',
    'Preferences',
    'Looking For',
    'Final Review'
  ];
  int currentSection = 0;

  void nextSection() {
    if (currentSection < sections.length - 1) {
      setState(() {
        currentSection++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (currentSection + 1) / sections.length,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            // Text(
            //   sections[currentSection],
            //   style: const TextStyle(
            //     fontSize: 22,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 16),
            // Wrap content in Expanded SingleChildScrollView
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (currentSection == 0) const GenderSelectionWidget(),
                    if (currentSection == 1)
                      const InterestedGenderSelectionWidget(),
                    if (currentSection == 2) const LookingForWidget(),
                    if (currentSection == 3) const LifestyleHabitsWidget(),
                  ],
                ),
              ),
            ),
            Divider(),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: nextSection,
                child: Text(
                  currentSection == sections.length - 1 ? 'Finish' : 'Next',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
