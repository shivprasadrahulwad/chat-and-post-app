import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// class VideoViewPage extends StatefulWidget {
//   const VideoViewPage({
//     Key? key,
//     required this.path,
//   }) : super(key: key);
//   final String path;

//   @override
//   _VideoViewPageState createState() => _VideoViewPageState();
// }

// class _VideoViewPageState extends State<VideoViewPage> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.file(File(widget.path))
//       ..initialize().then((_) {
//         setState(() {});
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         actions: [
//           IconButton(
//               icon: const Icon(
//                 Icons.crop_rotate,
//                 size: 27,
//               ),
//               onPressed: () {}),
//           IconButton(
//               icon: const Icon(
//                 Icons.emoji_emotions_outlined,
//                 size: 27,
//               ),
//               onPressed: () {}),
//           IconButton(
//               icon: const Icon(
//                 Icons.title,
//                 size: 27,
//               ),
//               onPressed: () {}),
//           IconButton(
//               icon: const Icon(
//                 Icons.edit,
//                 size: 27,
//               ),
//               onPressed: () {}),
//         ],
//       ),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Stack(
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height - 150,
//               child: _controller.value.isInitialized
//                   ? AspectRatio(
//                       aspectRatio: _controller.value.aspectRatio,
//                       child: VideoPlayer(_controller),
//                     )
//                   : Container(),
//             ),
//             Positioned(
//               bottom: 0,
//               child: Container(
//                 color: Colors.black38,
//                 width: MediaQuery.of(context).size.width,
//                 padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//                 child: TextFormField(
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 17,
//                   ),
//                   maxLines: 6,
//                   minLines: 1,
//                   decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: "Add Caption....",
//                       prefixIcon: const Icon(
//                         Icons.add_photo_alternate,
//                         color: Colors.white,
//                         size: 27,
//                       ),
//                       hintStyle: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 17,
//                       ),
//                       suffixIcon: CircleAvatar(
//                         radius: 27,
//                         backgroundColor: Colors.tealAccent[700],
//                         child: const Icon(
//                           Icons.check,
//                           color: Colors.white,
//                           size: 27,
//                         ),
//                       )),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.center,
//               child: InkWell(
//                 onTap: () {
//                   setState(() {
//                     _controller.value.isPlaying
//                         ? _controller.pause()
//                         : _controller.play();
//                   });
//                 },
//                 child: CircleAvatar(
//                   radius: 33,
//                   backgroundColor: Colors.black38,
//                   child: Icon(
//                     _controller.value.isPlaying
//                         ? Icons.pause
//                         : Icons.play_arrow,
//                     color: Colors.white,
//                     size: 50,
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







class VideoViewPage extends StatefulWidget {
  const VideoViewPage({
    Key? key,
    required this.path,
    required this.onVideoSend,
  }) : super(key: key);
  
  final String path;
  final Function onVideoSend;

  @override
  _VideoViewPageState createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> {
  late VideoPlayerController _controller;
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              icon: const Icon(
                Icons.crop_rotate,
                size: 27,
              ),
              onPressed: () {}),
          IconButton(
              icon: const Icon(
                Icons.emoji_emotions_outlined,
                size: 27,
              ),
              onPressed: () {}),
          IconButton(
              icon: const Icon(
                Icons.title,
                size: 27,
              ),
              onPressed: () {}),
          IconButton(
              icon: const Icon(
                Icons.edit,
                size: 27,
              ),
              onPressed: () {}),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 150,
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black38,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: TextFormField(
                  controller: _captionController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                  maxLines: 6,
                  minLines: 1,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Add Caption....",
                      prefixIcon: const Icon(
                        Icons.add_photo_alternate,
                        color: Colors.white,
                        size: 27,
                      ),
                      hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      suffixIcon: CircleAvatar(
                        radius: 27,
                        backgroundColor: Colors.tealAccent[700],
                        child: IconButton(
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 27,
                          ),
                          onPressed: () {
                            // Return true to indicate the video should be sent
                            Navigator.pop(context, true);
                          },
                        ),
                      )),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: CircleAvatar(
                  radius: 33,
                  backgroundColor: Colors.black38,
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
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