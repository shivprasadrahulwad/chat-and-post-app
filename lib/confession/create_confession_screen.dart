// import 'package:flutter/material.dart';
// import 'package:friends/widgets/custom_toggle_button.dart';

// class CreateConfessionScreen extends StatefulWidget {
//   const CreateConfessionScreen({Key? key}) : super(key: key);

//   @override
//   State<CreateConfessionScreen> createState() => _CreateConfessionScreenState();
// }

// class _CreateConfessionScreenState extends State<CreateConfessionScreen> {
//   final TextEditingController _confessionController = TextEditingController();
//   bool isAnonymous = true;
//   String selectedCategory = '';
//   String selectedVisibility = '24 Hours';
//   bool isNSFW = false;
//   final int maxCharacters = 500;

//   final List<String> categories = [
//     'Academic Life',
//     'Campus Love',
//     'Roommates',
//     'College Life',
//     'Study Tips',
//     'Party Scene',
//     'Mental Health',
//     'Career',
//   ];

//   final List<String> visibilityOptions = [
//     '24 Hours',
//     '48 Hours',
//     '1 Week',
//     'Forever',
//   ];

//   @override
//   void dispose() {
//     _confessionController.dispose();
//     super.dispose();
//   }

//   void _submitConfession() {
//     // Implement confession submission logic
//     if (_confessionController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please write your confession first!')),
//       );
//       return;
//     }

//     if (selectedCategory.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a category')),
//       );
//       return;
//     }

//     // Add your submission logic here
//     print('Confession submitted!');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text(
//           'Create Confession',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         // actions: [
//         //   TextButton(
//         //     onPressed: _submitConfession,
//         //     child: const Text(
//         //       'Post',
//         //       style: TextStyle(
//         //         fontWeight: FontWeight.bold,
//         //         fontSize: 16,
//         //       ),
//         //     ),
//         //   ),
//         // ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Privacy Settings Card
//               Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Privacy Settings',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Anonymous Post',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 'Hide your identity',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           CustomToggleButton(
//                             isToggled: isAnonymous,
//                             onTap: () {
//                               setState(() {
//                                 isAnonymous = !isAnonymous;
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                       const Divider(),
//                       SizedBox(height: 10,),
//                       DropdownButtonFormField<String>(
//                         decoration: const InputDecoration(
//                           labelText: 'Visibility Duration',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                                 Radius.circular(15)), // Added radius here
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                                 Radius.circular(15)), // Added radius here
//                             borderSide:
//                                 BorderSide(color: Colors.blue, width: 2),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                                 Radius.circular(15)), // Added radius here
//                             borderSide:
//                                 BorderSide(color: Colors.grey, width: 1),
//                           ),
//                         ),
//                         value: selectedVisibility,
//                         items: visibilityOptions.map((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                         onChanged: (newValue) {
//                           setState(() {
//                             selectedVisibility = newValue!;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // Confession Input Card
//               Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextField(
//                         controller: _confessionController,
//                         maxLength: maxCharacters,
//                         maxLines: 8,
//                         decoration: const InputDecoration(
//                           hintText: 'Share your confession...',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                                 Radius.circular(15)), // Added radius here
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                                 Radius.circular(15)), // Added radius here
//                             borderSide:
//                                 BorderSide(color: Colors.blue, width: 2),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                                 Radius.circular(15)), // Added radius here
//                             borderSide:
//                                 BorderSide(color: Colors.grey, width: 1),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'Category',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: categories.map((category) {
//                           return ChoiceChip(
//                             label: Text(category),
//                             selected: selectedCategory == category,
//                             selectedColor: Colors.blue.shade100,
//                             backgroundColor: Colors.grey.shade200,
//                             labelStyle: TextStyle(
//                               color: selectedCategory == category
//                                   ? Colors.blue
//                                   : Colors.black,
//                               fontWeight: selectedCategory == category
//                                   ? FontWeight.bold
//                                   : FontWeight.normal,
//                             ),
//                             showCheckmark: false,
//                             onSelected: (selected) {
//                               setState(() {
//                                 selectedCategory = selected ? category : '';
//                               });
//                             },
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // Guidelines Card
//               Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.info_outline, color: Colors.blue),
//                           SizedBox(width: 8),
//                           Text(
//                             'Guidelines',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         '• Keep it respectful and avoid harmful content\n'
//                         '• Do not share personal information\n'
//                         '• No hate speech or harassment\n'
//                         '• No spam or promotional content',
//                         style: TextStyle(fontSize: 14, color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//     onPressed: _submitConfession,
//     backgroundColor: Colors.green,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(15),
//     ),
//     child: const Icon(
//       Icons.send,
//       color: Colors.white,
//     ),
//   ),
//   floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
// );
//   }
// }

import 'package:flutter/material.dart';
import 'package:friends/model/confession.dart';
import 'package:provider/provider.dart';
import 'package:friends/providers/user_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ConfessionData {
  final String content;
  final String category;

  ConfessionData({required this.content, required this.category});
}

class CreateConfessionScreen extends StatefulWidget {
  final Function(Confession) onConfessionCreated;
  final IO.Socket socket;
  final String userId;
  const CreateConfessionScreen({
    Key? key,
    required this.onConfessionCreated,
    required this.userId,
    required this.socket,
  }) : super(key: key);

  @override
  State<CreateConfessionScreen> createState() => _CreateConfessionScreenState();
}

class _CreateConfessionScreenState extends State<CreateConfessionScreen> {
  final TextEditingController _postController = TextEditingController();
  final int _maxCharacters = 1000;
  String selectedCategory = '';
  bool _showCategories = false;
  bool isAnonymous = true;
  late String userId;

  final List<Map<String, dynamic>> categories = [
    {'name': 'Love & Relationships', 'icon': Icons.favorite},
    {'name': 'Family', 'icon': Icons.family_restroom},
    {'name': 'Work Life', 'icon': Icons.work},
    {'name': 'Friendship', 'icon': Icons.people},
    {'name': 'Personal Growth', 'icon': Icons.psychology},
    {'name': 'School & Education', 'icon': Icons.school},
    {'name': 'Secret Dreams', 'icon': Icons.nights_stay},
    {'name': 'Regrets', 'icon': Icons.mood_bad},
  ];

  int get _remainingCharacters => _maxCharacters - _postController.text.length;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userId = userProvider.user.id;
    _postController.addListener(() {
      setState(() {});
    });
  }

  void _handleConfession() {
    if (_postController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write your confession')),
      );
      return;
    }

    if (selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    final confession = Confession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _processText(_postController.text),
      category: selectedCategory,
      userId: widget.userId,
      createdAt: DateTime.now(),
      isAnonymous: isAnonymous,
      likesCount: 0,
      commentsCount: 0,
      mentions: [],
      isDeleted: false,
      isReported: false,
    );

    widget.onConfessionCreated(confession);
    Navigator.pop(context);
  }

  String _processText(String text) {
    final RegExp mentionRegex = RegExp(r'@[\w._]+');
    final RegExp emojiRegex = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
    );

    // Remove emojis
    text = text.replaceAll(emojiRegex, '');

    return text;
  }

  Widget _buildRichText(String text) {
    final RegExp mentionRegex = RegExp(r'@[\w._]+');
    final List<TextSpan> spans = [];
    int lastIndex = 0;

    for (Match match in mentionRegex.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: const TextStyle(
            color: Color(0xFF424242),
            fontSize: 16,
            height: 1.5,
          ),
        ));
      }
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: const TextStyle(
          color: Color(0xFF6B7FD7),
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: Color(0xFF6B7FD7),
          fontSize: 16,
          height: 1.5,
        ),
      ));
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: const TextStyle(
          color: Color(0xFF424242),
          fontSize: 16,
          height: 1.5,
        ),
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }


    Widget _buildTextField() {
    return Stack(
      children: [
        // Hidden TextField for actual input
        TextField(
          controller: _postController,
          maxLines: null,
          maxLength: _maxCharacters,
          style: const TextStyle(
            color: Colors.transparent, // Make the actual input transparent
            fontSize: 16,
            height: 1.5,
          ),
          decoration: const InputDecoration(
            hintText: "Write your confession here...",
            hintStyle: TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 16,
              height: 1.5,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            counterText: '',
          ),
          onChanged: (text) {
            setState(() {});
          },
        ),
        // Overlay with styled text
        _buildRichText(_postController.text.isEmpty 
          ? "Write your confession here..." 
          : _postController.text),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Color(0xFF424242)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Create Confession',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        _remainingCharacters < 0 ? null : _handleConfession,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF85A2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Confess',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SwitchListTile(
                title: const Text('Post Anonymously'),
                value: isAnonymous,
                onChanged: (bool value) {
                  setState(() {
                    isAnonymous = value;
                  });
                },
                activeColor: const Color(0xFFFF85A2),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showCategories = !_showCategories;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE5EC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.category_outlined,
                        color: Color(0xFFFF85A2),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        selectedCategory.isEmpty
                            ? 'Choose Category'
                            : selectedCategory,
                        style: const TextStyle(
                          color: Color(0xFFFF85A2),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        _showCategories
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 24,
                        color: const Color(0xFFFF85A2).withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showCategories) ...[
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedCategory = categories[index]['name'];
                            _showCategories = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: index != categories.length - 1
                                ? const Border(
                                    bottom: BorderSide(
                                      color: Color(0xFFEEEEEE),
                                      width: 1,
                                    ),
                                  )
                                : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                categories[index]['icon'],
                                color: const Color(0xFFFF85A2),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                categories[index]['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF424242),
                                ),
                              ),
                              if (selectedCategory ==
                                  categories[index]['name']) ...[
                                const Spacer(),
                                const Icon(
                                  Icons.check,
                                  color: Color(0xFFFF85A2),
                                  size: 20,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 24),
              // ... (previous code remains the same until the Stack widget)

              Expanded(
                child: Container(
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
                  padding: const EdgeInsets.all(20),
                  child: _buildTextField(), // Use the newTextField widget
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '$_remainingCharacters characters remaining',
                style: TextStyle(
                  color: _remainingCharacters < 50
                      ? const Color(0xFFFF85A2)
                      : const Color(0xFFBDBDBD),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }
}
