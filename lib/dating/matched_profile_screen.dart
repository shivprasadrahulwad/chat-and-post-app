import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// class MatchedProfileScreen extends StatefulWidget {
//   final String username;
//   final String fullName;
//   final String profileImageUrl;

//   const MatchedProfileScreen({
//     Key? key,
//     required this.username,
//     required this.fullName,
//     required this.profileImageUrl,
//   }) : super(key: key);

//   @override
//   State<MatchedProfileScreen> createState() => _MatchedProfileScreenState();
// }

// class _MatchedProfileScreenState extends State<MatchedProfileScreen> {
//   late String currentTime;
//   late String currentDate;
//   OverlayEntry? _overlayEntry;
//   final LayerLink _layerLink = LayerLink();

//   @override
//   void initState() {
//     super.initState();
//     _updateDateTime();
//   }

//   void _updateDateTime() {
//     final now = DateTime.now();
//     currentTime = DateFormat('h:mm a').format(now);
//     currentDate = DateFormat('dd MMM, yyyy').format(now);
//   }

//   void _showOptionsMenu(BuildContext context) {
//     final RenderBox button = context.findRenderObject() as RenderBox;
//     final RenderBox overlay =
//         Overlay.of(context).context.findRenderObject() as RenderBox;
//     final RelativeRect position = RelativeRect.fromRect(
//       Rect.fromPoints(
//         button.localToGlobal(Offset.zero, ancestor: overlay),
//         button.localToGlobal(button.size.bottomRight(Offset.zero),
//             ancestor: overlay),
//       ),
//       Offset.zero & overlay.size,
//     );

//     _overlayEntry?.remove();
//     _overlayEntry = OverlayEntry(
//       builder: (context) => Stack(
//         children: [
//           GestureDetector(
//             onTap: () {
//               _overlayEntry?.remove();
//               _overlayEntry = null;
//             },
//             child: Container(
//               color: Colors.transparent,
//               width: double.infinity,
//               height: double.infinity,
//             ),
//           ),
//           Positioned(
//             top: position.top + 110,
//             right: 2,
//             child: Material(
//               color: Colors.transparent,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildMenuOption(
//                       icon: Icons.report_problem,
//                       label: 'Report',
//                       onTap: () {
//                         _overlayEntry?.remove();
//                         _overlayEntry = null;
//                         // Add report logic here
//                       },
//                     ),
//                     const Divider(height: 1),
//                     _buildMenuOption(
//                       icon: Icons.block,
//                       label: 'Block',
//                       onTap: () {
//                         _overlayEntry?.remove();
//                         _overlayEntry = null;
//                         // Add block logic here
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );

//     Overlay.of(context).insert(_overlayEntry!);
//   }

//   Widget _buildMenuOption({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 20, color: Colors.grey[700]),
//             const SizedBox(width: 12),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[800],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Padding(
//           padding: const EdgeInsets.only(right: 10),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.arrow_back_ios),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               CircleAvatar(
//                 radius: 20,
//                 backgroundImage: NetworkImage(widget.profileImageUrl),
//               ),
//               const SizedBox(width: 8),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.username,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     widget.fullName,
//                     style: const TextStyle(
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () => _showOptionsMenu(context),
//           ),
//         ],
//       ),
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           SingleChildScrollView(
//             child: Container(
//               width: double.infinity,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 20),
//                   Text(
//                     '$currentTime, $currentDate',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   CircleAvatar(
//                     radius: 60,
//                     backgroundImage: NetworkImage(widget.profileImageUrl),
//                   ),
//                   const SizedBox(height: 20),
//                   Text.rich(
//                     TextSpan(
//                       text: 'You matched with ',
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.normal),
//                       children: [
//                         TextSpan(
//                           text: widget.username,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.grey,
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('🔍Looking for '),
//                           Text(
//                             '🍻🥂Short - term, open to long',
//                             style: const TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.grey,
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Essentials '),
//                           Row(
//                             children: [
//                               Icon(Icons.school),
//                               SizedBox(width: 8,),
//                               Text(
//                             'MIT Academy Of Engineering',
//                             style: const TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.grey,
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons
//                                   .favorite), // Replace with an appropriate icon
//                               SizedBox(width: 8),
//                               Text(
//                                 'Lifestyle',
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 10),
//                           Text('Drinking'),
//                           Row(
//                             children: [
//                               Icon(Icons.local_bar), // Drink icon
//                               SizedBox(width: 8),
//                               Text('Not for me'),
//                             ],
//                           ),
//                           Divider(),
//                           Text('Smoking'),
//                           Row(
//                             children: [
//                               Icon(Icons.smoke_free), // Smoke icon
//                               SizedBox(width: 8),
//                               Text('Non-smoker'),
//                             ],
//                           ),
//                           Divider(),
//                           Text('Workout'),
//                           Row(
//                             children: [
//                               Icon(Icons.fitness_center), // Workout icon
//                               SizedBox(width: 8),
//                               Text('Everyday'),
//                             ],
//                           ),
//                           Divider(),
//                           Text('Pets'),
//                           Row(
//                             children: [
//                               Icon(Icons.pets), // Pet icon
//                               SizedBox(width: 8),
//                               Text('Bird'),
//                             ],
//                           ),
//                           Divider(),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10,),
//                   Container(
//   width: double.infinity,
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(10),
//     color: Colors.grey,
//   ),
//   child: Padding(
//     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(Icons.star), // Interests icon
//             SizedBox(width: 8),
//             Text(
//               'Interests',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         SizedBox(height: 10),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: [
//             _interestChip('Traveling'),
//             _interestChip('Photography'),
//             _interestChip('Gaming'),
//             _interestChip('Music'),
//             _interestChip('Cooking'),
//           ],
//         ),
//       ],
//     ),
//   ),
// ),
// SizedBox(height: 100,)
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 20,
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 20),
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _buildActionButton(
//                     icon: Icons.chat,
//                     onPressed: () {},
//                     color: Colors.blue,
//                   ),
//                   _buildActionButton(
//                     icon: Icons.access_time,
//                     onPressed: () {},
//                     color: Colors.orange,
//                   ),
//                   _buildActionButton(
//                     icon: Icons.check_circle,
//                     onPressed: () {},
//                     color: Colors.green,
//                   ),
//                   _buildActionButton(
//                     icon: Icons.close,
//                     onPressed: () {},
//                     color: Colors.red,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _interestChip(String text) {
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//     decoration: BoxDecoration(
//       color: Colors.grey.shade700,
//       borderRadius: BorderRadius.circular(15),
//     ),
//     child: Text(
//       text,
//       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//     ),
//   );
// }

//   Widget _buildActionButton({
//     required IconData icon,
//     required VoidCallback onPressed,
//     required Color color,
//   }) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           icon: Icon(
//             icon,
//             color: color,
//             size: 30,
//           ),
//           onPressed: onPressed,
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MatchedProfileScreen extends StatefulWidget {
  final String username;
  final String fullName;
  final String profileImageUrl;

  const MatchedProfileScreen({
    Key? key,
    required this.username,
    required this.fullName,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  State<MatchedProfileScreen> createState() => _MatchedProfileScreenState();
}

class _MatchedProfileScreenState extends State<MatchedProfileScreen> {
  late String currentTime;
  late String currentDate;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  // Modern color scheme
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF2A2D3E);
  static const Color accentColor = Color(0xFFFF6584);
  static const Color backgroundColor = Color(0xFFF8F9FE);
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF2A2D3E);
  static const Color textSecondaryColor = Color(0xFF6B7280);

  @override
  void initState() {
    super.initState();
    _updateDateTime();
  }

  void _updateDateTime() {
    final now = DateTime.now();
    currentTime = DateFormat('h:mm a').format(now);
    currentDate = DateFormat('dd MMM, yyyy').format(now);
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
    IconData? icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: primaryColor, size: 24),
                  const SizedBox(width: 12),
                ],
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildLifestyleItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: textSecondaryColor,
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: textPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _interestChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: textPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.profileImageUrl),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.fullName,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: textPrimaryColor),
            onPressed: () => _showOptionsMenu(context),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 3),
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(widget.profileImageUrl),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  widget.username,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textPrimaryColor,
                  ),
                ),
                Text(
                  widget.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: textSecondaryColor,
                  ),
                ),
                Text(
                  '$currentTime, $currentDate',
                  style: const TextStyle(
                    fontSize: 14,
                    color: textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 30),
                _buildInfoCard(
                  title: 'Looking For',
                  icon: Icons.search,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.wine_bar, color: primaryColor),
                        SizedBox(width: 8),
                        Text(
                          'Short-term, open to long',
                          style: TextStyle(
                            fontSize: 16,
                            color: textPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                _buildInfoCard(
                  title: 'Education',
                  icon: Icons.school,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.business, color: primaryColor),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'MIT Academy Of Engineering',
                            style: TextStyle(
                              fontSize: 16,
                              color: textPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                _buildInfoCard(
                  title: 'Lifestyle',
                  icon: Icons.favorite,
                  children: [
                    _buildLifestyleItem(
                      icon: Icons.local_bar,
                      label: 'Drinking',
                      value: 'Not for me',
                    ),
                    _buildLifestyleItem(
                      icon: Icons.smoke_free,
                      label: 'Smoking',
                      value: 'Non-smoker',
                    ),
                    _buildLifestyleItem(
                      icon: Icons.fitness_center,
                      label: 'Workout',
                      value: 'Everyday',
                    ),
                    _buildLifestyleItem(
                      icon: Icons.pets,
                      label: 'Pets',
                      value: 'Bird',
                    ),
                  ],
                ),
                _buildInfoCard(
                  title: 'Interests',
                  icon: Icons.star,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 12,
                      children: [
                        _interestChip('Traveling'),
                        _interestChip('Photography'),
                        _interestChip('Gaming'),
                        _interestChip('Music'),
                        _interestChip('Cooking'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.close,
                    color: Colors.red,
                    onPressed: () {},
                  ),
                  _buildActionButton(
                    icon: Icons.access_time,
                    color: Colors.orange,
                    onPressed: () {},
                  ),
                  _buildActionButton(
                    icon: Icons.favorite,
                    color: accentColor,
                    onPressed: () {},
                  ),
                  _buildActionButton(
                    icon: Icons.chat_bubble,
                    color: primaryColor,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onPressed,
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.report_problem, color: Colors.orange),
              ),
              title: const Text('Report'),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
                color: Colors.orange,
                size: 30,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.block, color: Colors.red),
              ),
              title: const Text('Block'),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
                color: Colors.red,
                size: 30,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
