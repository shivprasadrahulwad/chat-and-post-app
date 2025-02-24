import 'package:flutter/material.dart';
import 'package:friends/screens/services/confessio_services.dart';
import 'package:friends/screens/services/post_services.dart';

// class PostActionSheet extends StatelessWidget {
//   final String postId;
//   final String userId;
//   final String postType;

//   const PostActionSheet({
//     super.key,
//     required this.postId,
//     required this.userId,
//     required this.postType,
//   });

//   void _showReportReasonSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => ReportReasonSheet(postId: postId, userId: userId),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
//       ),
//       child: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height: 8),
//             Container(
//               height: 4,
//               width: 40,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ListTile(
//               contentPadding: const EdgeInsets.symmetric(horizontal: 24),
//               leading: Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.red[50],
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.flag_outlined,
//                     color: Colors.red, size: 22),
//               ),
//               title: const Text(
//                 'Report',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//               ),
//               subtitle: const Text(
//                 'Let us know if something concerns you',
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Colors.grey,
//                 ),
//               ),
//               trailing: const Icon(Icons.chevron_right, color: Colors.grey),
//               onTap: () {
//                 Navigator.pop(context);
//                 _showReportReasonSheet(context);
//               },
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ReportReasonSheet extends StatelessWidget {
//   final String postId;
//   final String userId;

//   ReportReasonSheet({
//     super.key,
//     required this.postId,
//     required this.userId,
//   });

//   final Map<String, List<String>> reportReasons = {
//     "False information": [
//       "Health",
//       "Politics",
//       "Social issues",
//       "Digitally created or altered"
//     ],
//     "Bullying or harassment": [
//       "Threatening behavior",
//       "Hate speech",
//       "Harassment",
//       "Spam"
//     ],
//     "Harmful content": [
//       "Self-harm",
//       "Eating disorders",
//       "Violence",
//       "Exploitation",
//       "Animal abuse"
//     ],
//     "Inappropriate content": [
//       "Adult content",
//       "Sensitive material",
//       "Graphic content"
//     ],
//     "Scam or fraud": ["Suspicious activity", "Fraud", "Scam", "Spam"],
//     "Other": ["Other concerns"]
//   };

//   void _showDetailedReportSheet(
//       BuildContext context, String reason, List<String> subCategories) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => DetailedReportSheet(
//         reason: reason,
//         subCategories: subCategories,
//         postId: postId,
//         userId: userId,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.8,
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
//       ),
//       child: Padding(
//         padding: EdgeInsets.only(left: 10,right: 10),
//         child: Column(
//           children: [
//             const SizedBox(height: 40),
//             // Title
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Icon(Icons.arrow_back),
//                 ),
//                 Expanded(
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Text(
//                       'Report',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
        
//             const SizedBox(height: 12),
//             const Divider(height: 1),
//             const SizedBox(height: 16),
//             // Question
//             const Text(
//               'Why are you reporting this post?',
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),
//             // Options
//             Expanded(
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 itemCount: reportReasons.length,
//                 itemBuilder: (context, index) {
//                   String reason = reportReasons.keys.elementAt(index);
//                   return Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                           _showDetailedReportSheet(
//                               context, reason, reportReasons[reason]!);
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 10),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 reason,
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                               // const Icon(Icons.chevron_right,
//                               //     color: Colors.grey, size: 20),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DetailedReportSheet extends StatelessWidget {
//   final String reason;
//   final List<String> subCategories;
//   final String postId;
//   final String userId;
//   final PostService _postServices = PostService();

//   DetailedReportSheet({
//     super.key,
//     required this.reason,
//     required this.subCategories,
//     required this.postId,
//     required this.userId,
//   });

//   Future<void> _handleReport(BuildContext context, String reportReason) async {
//     try {
//       await _postServices.sendReport(
//         context: context,
//         postId: postId,
//         userId: userId,
//         reportReason: reportReason,
//       );

//       if (context.mounted) {
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Container(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               child: const Row(
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.white, size: 20),
//                   SizedBox(width: 12),
//                   Text(
//                     'Thanks for letting us know',
//                     style: TextStyle(fontSize: 15),
//                   ),
//                 ],
//               ),
//             ),
//             backgroundColor: Colors.green[600],
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Container(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               child: Row(
//                 children: [
//                   const Icon(Icons.error_outline,
//                       color: Colors.white, size: 20),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       'Error: ${e.toString()}',
//                       style: const TextStyle(fontSize: 15),
//                       maxLines: 2,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             backgroundColor: Colors.red[600],
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.7,
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
//       ),
//       child: Padding(
//         padding: EdgeInsets.only(left: 10,right: 10),
//         child: Column(
//           children: [
//             const SizedBox(height: 40),
//             // Title
//              Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Icon(Icons.arrow_back),
//                   ),
//                   Expanded(
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Report',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
          
//             const SizedBox(height: 12),
//             const Divider(height: 1),
//             const SizedBox(height: 16),
//             // Question
//             Text(
//               'What kind of $reason is this?',
//               style: const TextStyle(
//                 fontSize: 20,
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),
//             // Options
//             Expanded(
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 itemCount: subCategories.length,
//                 itemBuilder: (context, index) {
//                   return Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () => _handleReport(context, subCategories[index]),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 10),
//                           child: Row(
//                             children: [
//                               Text(
//                                 subCategories[index],
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';

class PostActionSheet extends StatelessWidget {
  final String postId;
  final String userId;
  final String postType;

  const PostActionSheet({
    super.key,
    required this.postId,
    required this.userId,
    required this.postType,
  });

  void _showReportReasonSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReportReasonSheet(
        itemId: postId, 
        userId: userId,
        postType: postType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.flag_outlined, color: Colors.red, size: 22),
              ),
              title: const Text(
                'Report',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: const Text(
                'Let us know if something concerns you',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                Navigator.pop(context);
                _showReportReasonSheet(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class ReportReasonSheet extends StatelessWidget {
  final String itemId;
  final String userId;
  final String postType;

  ReportReasonSheet({
    super.key,
    required this.itemId,
    required this.userId,
    required this.postType,
  });

  final Map<String, List<String>> reportReasons = {
    "False information": [
      "Health",
      "Politics",
      "Social issues",
      "Digitally created or altered"
    ],
    "Bullying or harassment": [
      "Threatening behavior",
      "Hate speech",
      "Harassment",
      "Spam"
    ],
    "Harmful content": [
      "Self-harm",
      "Eating disorders",
      "Violence",
      "Exploitation",
      "Animal abuse"
    ],
    "Inappropriate content": [
      "Adult content",
      "Sensitive material",
      "Graphic content"
    ],
    "Scam or fraud": ["Suspicious activity", "Fraud", "Scam", "Spam"],
    "Other": ["Other concerns"]
  };

  void _showDetailedReportSheet(
      BuildContext context, String reason, List<String> subCategories) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DetailedReportSheet(
        reason: reason,
        subCategories: subCategories,
        itemId: itemId,
        userId: userId,
        postType: postType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String contentType = postType == 'post' ? 'post' : 'confession';
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: const Text(
                      'Report',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Text(
              'Why are you reporting this $contentType?',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: reportReasons.length,
                itemBuilder: (context, index) {
                  String reason = reportReasons.keys.elementAt(index);
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _showDetailedReportSheet(
                            context, 
                            reason, 
                            reportReasons[reason]!
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20, 
                            vertical: 10
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                reason,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailedReportSheet extends StatelessWidget {
  final String reason;
  final List<String> subCategories;
  final String itemId;
  final String userId;
  final String postType;
  final PostService _postServices = PostService();
  final ConfessionService _confessionServices = ConfessionService();

  DetailedReportSheet({
    super.key,
    required this.reason,
    required this.subCategories,
    required this.itemId,
    required this.userId,
    required this.postType,
  });

  Future<void> _handleReport(BuildContext context, String reportReason) async {
    try {
      if (postType == 'post') {
        await _postServices.sendReport(
          context: context,
          postId: itemId,
          userId: userId,
          reportReason: reportReason,
        );
      } else {
        await _confessionServices.sendConfessionReport(
          context: context,
          confessionId: itemId,
          userId: userId,
          reportReason: reportReason,
        );
      }

      if (context.mounted) {
        Navigator.pop(context);
        _showSuccessSnackBar(context);
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, e.toString());
      }
    }
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text(
                'Thanks for letting us know',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Error: $errorMessage',
                  style: const TextStyle(fontSize: 15),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String contentType = postType == 'post' ? 'post' : 'confession';
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Report $contentType',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Text(
              'What kind of $reason is this?',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: subCategories.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => _handleReport(context, subCategories[index]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20, 
                            vertical: 10
                          ),
                          child: Row(
                            children: [
                              Text(
                                subCategories[index],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}