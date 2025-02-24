import 'package:flutter/material.dart';
import 'package:friends/confession/confession_card.dart';
import 'package:friends/confession/confession_screen.dart';
import 'package:friends/dating/match_screen.dart';
import 'package:friends/dating/matched_profile_screen.dart';
import 'package:friends/join/join_home_screen.dart';
import 'package:friends/model/confession.dart';
import 'package:friends/model/user_preview.dart';
import 'package:friends/onboard/onboard_data_screen.dart';
import 'package:friends/onboard/welcome_screen.dart';
import 'package:friends/post/post_screen.dart';
import 'package:friends/screens/data_safety/chat_data_safety_popup.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:friends/confession/create_confession_screen.dart';
import 'package:friends/contact/search_contact_screen.dart';
import 'package:friends/group/group_chat_screen.dart';
import 'package:friends/home/home_screen.dart';
import 'package:friends/model/chat.dart';
import 'package:friends/model/chatData.dart';
import 'package:friends/model/message.dart';
import 'package:friends/poll/poll_screen.dart';
import 'package:friends/providers/user_provider.dart';
import 'package:friends/screens/Home/button_card.dart';
import 'package:friends/screens/Home/qr_scan_screen.dart';
import 'package:friends/screens/chat/chat_screen.dart';
import 'package:friends/screens/chat/sample_screen.dart';
import 'package:friends/screens/groups/group_details_screen.dart';
import 'package:friends/screens/services/chat_services.dart';
import 'package:friends/screens/settings/settings_screen.dart';
import 'package:friends/screens/story/story_widgets.dart';
import 'package:uuid/uuid.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
  late Chat sourcechat;
  var uuid = Uuid();
  List<Chat> chatModells = [];
  bool _isLoading = true;
  String? _error;
  late String userId;

  @override
  void initState() {
    super.initState();
    _fetchChats();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userId = userProvider.user.id;
    final participantId = userId; // Ensure this is a valid MongoDB ObjectId

    // Call the createOrGetChat method
    _createOrGetChat(participantId);
    // _createChat();
  }
  

  Future<void> _createOrGetChat(String participantId) async {
    final chatService = ChatServices();

    try {
      final chat = await chatService.createOrGetChat(
        context: context,
        participantId: participantId,
        hide: false,
      );

      setState(() {
        // _chat = chat;
      });
    } catch (e) {
      // Handle error appropriately, maybe show a message to the user
      print("Error: $e");
    }
  }

  Future<void> _fetchChats() async {
    try {
      final chats = await ChatServices().fetchUserChats(context: context);
      if (chats != null && chats.isNotEmpty) {
        final box =
            Hive.box<ChatData>('chatData'); // Use the already opened box
        await box.clear(); // Clear old data

        for (var chatModel in chats) {
          if (chatModel.hide == true && chatModel.id.isNotEmpty) {
            String receiverId = chatModel.type == "group"
                ? "group"
                : chatModel.participants
                        .where((p) => p.userId != userId)
                        .map((p) => p.userId)
                        .firstOrNull ??
                    'No user available';

            final chatData =
                ChatData(chatId: chatModel.id, receiverId: receiverId);
            await box.put(chatModel.id, chatData);
          }
        }
      }

      setState(() {
        chatModells = chats;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      print('Error in _fetchChats: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _isLoading = false;
        _error = 'Failed to fetch chats: $e';
      });
    }
  }

  void sendReplyMessage(BuildContext context) async {
    final chatService = ChatServices();
    final String newMessageId = Uuid().v4();

    Message? message = await chatService.replyMessages(
        context: context,
        messageId: newMessageId,
        chatId: '6780a6a7e058f492419e0092',
        content: 'Hello, this is a test reply message!',
        senderId: '677fd21f5a9def773966c904',
        messageType: MessageType.text,
        quotedMessageId: 'b255ba64-2cfe-4408-8780-a3211ed887ab');

    if (message != null) {
      print('Message sent successfully: ${message.toJson()}');
    } else {
      print('Failed to send message.');
    }
  }

  Future<void> clearAllHiveData() async {
    try {
      // Open and clear messages box
      final messagesBox = await Hive.openBox<Message>('messages');
      await messagesBox.clear();
      print('Messages box cleared');

      // Open and clear chat data box
      final chatBox = await Hive.openBox<ChatData>('chatData');
      await chatBox.clear();
      print('Chat box cleared');

      // Close the boxes
      await messagesBox.close();
      await chatBox.close();

      print('All Hive data cleared successfully');
    } catch (e) {
      print('Error clearing Hive data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('friendsGo'),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRScanScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: GestureDetector(
              onTap: () => {
                // navigateToSearchScreen()
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Search ',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 17,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              UserStoryWidget(),
              const SizedBox(
                width: 10,
              ),
              const OtherUsersStoryWidget(
                name: 'shrutika_rahulwad',
                imageName: 'assets/images/shrutika.png',
                isSeen: false,
              ),
              const SizedBox(
                width: 10,
              ),
              const OtherUsersStoryWidget(
                name: 'mr.prasad',
                imageName: 'assets/images/shrutika.png',
                isSeen: true,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const GroupDetailsScreen()));
              },
              child: const Text('Groups1')),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatModells.length,
              itemBuilder: (context, index) {
                final chatModel = chatModells[index];

                // If it's a group, use group name
                if (chatModel.type == "group" && !chatModel.hide) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            password: '',
                            reciverId:
                                chatModel.id, 
                            sourchat: user.id,
                            chatId: chatModel.id,
                            hide: chatModel.hide,
                            isUserBlocked: false,
                          ),
                        ),
                      );
                    },
                    child: ButtonCard(
                      name: chatModel.name ?? 'Unnamed Group',
                      imageUrl: chatModel.groupPicture ?? '',
                    ),
                  );
                }


                if (chatModel.type == "post") {
                  return InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostScreen(name: userProvider.user.name, userId: userId)
                        ),
                      );
                    },
                    child: ButtonCard(
                      name: chatModel.name ?? 'Unnamed post',
                      imageUrl: chatModel.groupPicture ?? '',
                    ),
                  );
                }

                if (chatModel.type == "confession") {
                  return InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfessionScreen(name: 'Shivam ', userId: user.id,
                            chatId: chatModel.id,)
                        ),
                      );
                    },
                    child: ButtonCard(
                      name: chatModel.name ?? 'confession',
                      imageUrl: chatModel.groupPicture ?? '',
                    ),
                  );
                }


                // For non-group chats, get unique participant IDs excluding current user
                final uniqueParticipantIds = chatModel.participants
                    .where((participant) => participant.userId != user.id)
                    .map((participant) => participant.userId)
                    .toSet()
                    .toList();

                // Only show if not hidden and has unique participant IDs
                if (!chatModel.hide && uniqueParticipantIds.isNotEmpty) {
                  return InkWell(
                    onTap: () {
                      // Since we're using uniqueParticipantIds.first, we should also get the corresponding participant
                      final participant = chatModel.participants.firstWhere(
                        (p) => p.userId == uniqueParticipantIds.first,
                        orElse: () => Participant(
                          userId: uniqueParticipantIds.first,
                          joinedAt: DateTime.now(),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            reciverId: uniqueParticipantIds.first,
                            sourchat: user.id,
                            chatId: chatModel.id,
                            hide: chatModel.hide,
                            password: participant.password,
                            isUserBlocked: chatModel.settings?.blockedUsers
                                    ?.any((blockedUser) =>
                                        blockedUser.userId.toString() ==
                                        uniqueParticipantIds.first) ??
                                false,
                          ),
                        ),
                      );
                    },
                    child: ButtonCard(
                      name: uniqueParticipantIds.first,
                      imageUrl: '',
                    ),
                  );
                }

                return Container();
              },
            ),
          ),
          // GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) =>  CreateConfessionScreen(onConfessionCreated: (Confession ) {  }, userId: '', socket: ,),
          //         ),
          //       );
          //     },
          //     child: const Text('create confession screen')),
          // const SizedBox(
          //   height: 20,
          // ),

          // GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) =>  ConfessionsScreen(),
          //         ),
          //       );
          //     },
          //     child: const Text('confession hive screen')),
          // const SizedBox(
          //   height: 20,
          // ),

           GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  JoinScreen(),
                  ),
                );
              },
              child: const Text('join home screen')),
          const SizedBox(
            height: 20,
          ),

          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  ConfessionsScreen(),
                  ),
                );
              },
              child: const Text('hive confess screen')),
          const SizedBox(
            height: 20,
          ),
          // GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => ChatDataDisplayWidget(),
          //         ),
          //       );
          //     },
          //     child: const Text('chat data ')),
          // const SizedBox(
          //   height: 20,
          // ),
          ElevatedButton(
            onPressed: () => sendReplyMessage(context),
            child: const Text("Send Dummy Message"),
          ),

          GestureDetector(
  onTap: () {
    showDataSafetyPopup(context);
  },
  child: Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      'data safety Popup',
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  ),
),

GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MatchedProfileScreen(username: 'shivprasad', fullName: 'Shivprasad Rahulwad', profileImageUrl: '',)
                  ),
                );
              },
              child: const Text('match profile screen')),
          const SizedBox(
            height: 20,
          ),

          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MatchesScreen()
                  ),
                );
              },
              child: const Text('match profile screen')),
          const SizedBox(
            height: 20,
          ),

          // GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => ChatDataScreen(
          //             chatId: '6780a6a7e058f492419e0092',
          //           ),
          //         ),
          //       );
          //     },
          //     child: const Text('hive messages')),
          // const SizedBox(
          //   height: 20,
          // ),

          // GestureDetector(
          //     onTap: clearAllHiveData,
          //     child: const Text('clear hive messages')),
          // const SizedBox(
          //   height: 20,
          // ),

          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomesScreen(),
                  ),
                );
              },
              child: const Text('cHome screen')),
          const SizedBox(
            height: 20,
          ),

          // GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => MatchesScreen(),
          //         ),
          //       );
          //     },
          //     child: const Text('matches screen')),
          // const SizedBox(
          //   height: 20,
          // ),

          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelcomeScreen(),
                  ),
                );
              },
              child: const Text('welcone screen')),
          const SizedBox(
            height: 10,
          ),

          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnboardDataScreen(),
                  ),
                );
              },
              child: const Text('onboard data screen')),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfessionScreen(name: 'Shivam ', userId: '123456', chatId: '162172r1',),
                  ),
                );
              },
              child: const Text('Confession screen')),
          const SizedBox(
            height: 10,
          ),

          

          // GestureDetector(
          //     onTap: () => _createOrGetChat('67832e8d7602108a46881602'),
          //     child: const Text('create chat')),
          // const SizedBox(
          //   height: 20,
          // ),

// ConfessionCardWidget(
//       confession: Confession(
//         id: '1',
//         content: "I've been pretending to understand calculus all semester. My friends think I'm helping them, but I'm actually learning from teaching them 😅",
//         category: "Academic",
//         userId: "user123",
//         createdAt: DateTime.now().subtract(const Duration(hours: 2)),
//         isAnonymous: true,
//         likesCount: 234,
//         commentsCount: 45,
//         mentions: [],
//         isDeleted: false,
//         isReported: false,
//       ),
//       currentUser: UserPreview(id: 'current123', username: 'currentUser'),
//       onLike: (id) => print('Liked confession $id'),
//     ),

          GestureDetector(
              onTap: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Confession'),
                        content: TextFormField(
                          controller: nameController,
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GroupChatScreen(
                                              name: nameController.text,
                                              userId: uuid.v1(),
                                              chatId: '',
                                            )));
                              },
                              child: const Text('Enter')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close'))
                        ],
                      )),
              child: const Text('group chat screen')),
          // const SizedBox(
          //   height: 100,
          // ),

          // GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const CreatePollScreen()));
          //     },
          //     child: const Text('poll screen')),
          // const SizedBox(
          //   height: 100,
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SearchContactScreen()));
        },
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
