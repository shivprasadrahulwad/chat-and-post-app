import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:friends/post/post_screen.dart';
import 'package:friends/providers/user_provider.dart';

class PostData {
  final String content;
  final List<File> images;

  PostData({required this.content, required this.images});
}

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _postController = TextEditingController();
  final List<File> _pickedImages = [];
  final int _maxCharacters = 1000;
  final int _maxImages = 4;
  final ImagePicker _picker = ImagePicker();
  late String userId;
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

  Future<void> _pickImage() async {
    if (_pickedImages.length >= _maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 4 images allowed')),
      );
      return;
    }

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImages.add(File(image.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
  }

  void _handlePost() {
  if (_postController.text.isEmpty && _pickedImages.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter some text or add images for your post')),
    );
    return;
  }

  // Create PostData object
  final postData = PostData(
    content: _postController.text,
    images: List<File>.from(_pickedImages),
  );

  // Simply pop and return the data
  Navigator.pop(context, postData);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _remainingCharacters < 0 ? null : _handlePost,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text('Post'),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/40'),
                    onBackgroundImageError: (_, __) {
                      print("Error loading image");
                    },
                    child: const Icon(Icons.person),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _postController,
                      maxLines: null,
                      maxLength: _maxCharacters,
                      decoration: const InputDecoration(
                        hintText: "What's happening?",
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  ),
                ],
              ),
              if (_pickedImages.isNotEmpty) ...[
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: _pickedImages.length == 1 ? 1 : 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: _pickedImages.length == 1 ? 16 / 9 : 1,
                  children: List.generate(_pickedImages.length, (index) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            _pickedImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey, width: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image_outlined),
                      onPressed: _pickImage,
                    ),
                    IconButton(
                      icon: const Icon(Icons.gif_box_outlined),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.poll_outlined),
                      onPressed: () {},
                    ),
                  ],
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
