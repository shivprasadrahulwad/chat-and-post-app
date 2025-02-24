import 'package:flutter/material.dart';
import 'package:friends/model/confession.dart';
import 'package:friends/model/post.dart';
import 'package:friends/screens/services/confessio_services.dart';
import 'package:friends/screens/services/post_services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:friends/model/chatData.dart';
import 'package:friends/model/message.dart';
import 'package:friends/screens/chat/chat_screen.dart';
import 'package:intl/intl.dart';

class ChatDataDisplayWidget extends StatefulWidget {
  @override
  _ChatDataDisplayWidgetState createState() => _ChatDataDisplayWidgetState();
}

class _ChatDataDisplayWidgetState extends State<ChatDataDisplayWidget> {
  List<ChatData> _chatDataList = [];

  @override
  void initState() {
    super.initState();
    _loadChatData();
  }

  Future<void> _loadChatData() async {
    final box = await Hive.openBox<ChatData>('chatData');
    
    setState(() {
      // Convert all values in the box to a list
      _chatDataList = box.values.toList();
    });

    // Optional: Close the box when done
    await box.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stored Chat Data'),
      ),
      body: _chatDataList.isEmpty
          ? Center(child: Text('No chat data found'))
          : ListView.builder(
              itemCount: _chatDataList.length,
              itemBuilder: (context, index) {
                final chatData = _chatDataList[index];
                return ListTile(
                  title: Text('Chat ID: ${chatData.chatId}'),
                  subtitle: Text('Receiver ID: ${chatData.receiverId}'),
                );
              },
            ),
    );
  }
}


class ChatDataScreen extends StatefulWidget {
  final String chatId;

  const ChatDataScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatDataScreenState createState() => _ChatDataScreenState();
}

class _ChatDataScreenState extends State<ChatDataScreen> {
  late Box<Message> messagesBox;

  @override
  void initState() {
    super.initState();
    // Open the Hive box for messages
    messagesBox = Hive.box<Message>('messages');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Messages'),
      ),
      body: ValueListenableBuilder(
        valueListenable: messagesBox.listenable(),
        builder: (context, Box<Message> box, _) {
          // Filter messages for the current chat
          final messages = box.values
              .where((message) => message.chatId == widget.chatId)
              .toList();

          if (messages.isEmpty) {
            return Center(
              child: Text('No messages found.'),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return MessageBubble(message: message);
            },
          );
        },
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: message.senderId == 'currentUserId' ? Colors.blue[100] : Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.senderId,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.0),
          // Display message ID
          Text(
            'Message ID: ${message.messageId}',
            style: TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
          SizedBox(height: 4.0),
          Text(
            'reply To: ${message.replyTo}',
            style: TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
          SizedBox(height: 4.0),
          if (message.type == MessageType.text)
            Text(message.content.text ?? ''),
          if (message.type == MessageType.image)
            Image.network(message.content.mediaUrl ?? ''),
          if (message.type == MessageType.video)
            Text('Video: ${message.content.mediaUrl}'),
          if (message.type == MessageType.audio)
            Text('Audio: ${message.content.duration} seconds'),
          SizedBox(height: 4.0),
          Text(
            '${message.createdAt.toLocal()}',
            style: TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}


class FetchedConfessionScreen extends StatefulWidget {
  @override
  _FetchedConfessionScreenState createState() => _FetchedConfessionScreenState();
}

class _FetchedConfessionScreenState extends State<FetchedConfessionScreen> {
  late Future<List<Confession>> _futureConfessions;

  @override
  void initState() {
    super.initState();
    _fetchConfessions();
  }

  void _fetchConfessions() {
    final timestamp = DateTime.parse('2025-02-21T01:06:11.164+00:00');
    setState(() {
      _futureConfessions = ConfessionService().fetchConfessionsAfterDate(
        context: context,
        timestamp: timestamp,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fetched Confessions"),
      ),
      body: FutureBuilder<List<Confession>>(
        future: _futureConfessions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No confessions found"));
          }

          final confessions = snapshot.data!;
          return ListView.builder(
            itemCount: confessions.length,
            itemBuilder: (context, index) {
              final confession = confessions[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(confession.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Category: ${confession.category}"),
                      Text("Likes: ${confession.likesCount} • Comments: ${confession.commentsCount}"),
                      Text("Posted: ${DateFormat.yMMMd().add_jm().format(confession.createdAt)}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}










class ConfessionsScreen extends StatefulWidget {
  @override
  _ConfessionsScreenState createState() => _ConfessionsScreenState();
}

class _ConfessionsScreenState extends State<ConfessionsScreen> {
  late Box<Confession> confessionBox;

@override
void initState() {
  super.initState();

  // Ensure the box is open
  if (!Hive.isBoxOpen('confessions')) {
    Hive.openBox<Confession>('confessions').then((box) {
      setState(() {
        confessionBox = box;
      });
    });
  } else {
    confessionBox = Hive.box<Confession>('confessions');
  }
}

  void _addConfession() {
    TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("New Confession"),
          content: TextField(
            controller: contentController,
            decoration: InputDecoration(hintText: "Enter your confession"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final newConfession = Confession(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  content: contentController.text,
                  category: "General",
                  userId: "user_123",
                  createdAt: DateTime.now(),
                  isAnonymous: true,
                  mentions: [],
                  likesCount: 0,
                  commentsCount: 0,
                  isDeleted: false,
                  isReported: false,
                );
                confessionBox.add(newConfession);
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Confessions")),
      body: ValueListenableBuilder(
        valueListenable: confessionBox.listenable(),
        builder: (context, Box<Confession> box, _) {
          if (box.isEmpty) {
            return Center(child: Text("No confessions yet."));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final confession = box.getAt(index);

              return ListTile(
                title: Text(confession!.content),
                subtitle: Text("Category: ${confession.id}"),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => box.deleteAt(index),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addConfession,
        child: Icon(Icons.add),
      ),
    );
  }
}



class SamplePostScreen extends StatefulWidget {
  @override
  _SamplePostScreenState createState() => _SamplePostScreenState();
}

class _SamplePostScreenState extends State<SamplePostScreen> {
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = PostService().fetchPostsAfterDate(
      context: context,
      afterDate: DateTime.now().subtract(Duration(days: 7)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts found'));
          }
          
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(post.id[0]), // Display user's first letter
                  ),
                  title: Text(post.id),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.content),
                      Text(post.id),
                      SizedBox(height: 4),
                      Text(
                        'Posted on: ${post.createdAt}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}









class PostDataScreen extends StatefulWidget {
  @override
  _PostDataScreenState createState() => _PostDataScreenState();
}

class _PostDataScreenState extends State<PostDataScreen> {
  late Box<Post> postBox;
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    postBox = await Hive.openBox<Post>('posts');
    setState(() {
      posts = postBox.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.content,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        if (post.mediaUrl != null)
                          Image.network(post.mediaUrl!),
                        SizedBox(height: 8),
                        Text('id: ${post.id}'),
                        SizedBox(height: 8),
                        Text('Likes: ${post.likes.length}'),
                        SizedBox(height: 8),
                        Text('Comments: ${post.commentCount}'),
                        SizedBox(height: 8),
                        Text('Created At: ${post.createdAt}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}