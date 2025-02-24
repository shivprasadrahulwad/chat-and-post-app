// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';

// class VideoCallScreen extends StatefulWidget {
//   final String channelName;
//   final String callerName;
//   final String callerAvatar;

//   const VideoCallScreen({
//     Key? key,
//     required this.channelName,
//     required this.callerName,
//     required this.callerAvatar,
//   }) : super(key: key);

//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }

// class _VideoCallScreenState extends State<VideoCallScreen> {
//   AgoraClient? client;
//   bool isMicMuted = false;
//   bool isVideoMuted = false;
//   bool isFrontCamera = true;
//   bool _isRemoteUserConnected = false;
//    bool _isCallEnded = false;
   

//   int _remoteDurationSeconds = 0;
//   DateTime? _remoteUserJoinTime;

//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }

//     void initAgora() async {
//     client = AgoraClient(
//       agoraConnectionData: AgoraConnectionData(
//         appId: '20810c5544884126b8ffbbe4e0453736',
//         channelName: widget.channelName,
//         username: widget.callerName,
//       ),
//     );
//     await client!.initialize();

//     client!.engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           if (mounted && !_isCallEnded) {
//             setState(() {
//               _isRemoteUserConnected = true;
//               _startRemoteUserTimer();
//             });
//           }
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
//           if (mounted && !_isCallEnded) {
//             setState(() {
//               _isRemoteUserConnected = false;
//             });
//           }
//         },
//       ),
//     );

//     setState(() {});
//   }

//   void _startRemoteUserTimer() {
//     Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_isRemoteUserConnected && !_isCallEnded) {
//         setState(() {
//           _remoteDurationSeconds++;
//         });
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   void _toggleMicrophone() {
//     setState(() {
//       isMicMuted = !isMicMuted;
//       client?.engine.muteLocalAudioStream(isMicMuted);
//     });
//   }

//   void _toggleVideo() {
//     setState(() {
//       isVideoMuted = !isVideoMuted;
//       client?.engine.muteLocalVideoStream(isVideoMuted);
//     });
//   }

//   void _switchCamera() {
//     setState(() {
//       isFrontCamera = !isFrontCamera;
//       client?.engine.switchCamera();
//     });
//   }

// void _endCall() async {
//   print('Call ending process started');
  
//   try {
//     await client?.engine.leaveChannel();
//     await client?.release();
//   } catch (e) {
//     print('Error ending call: $e');
//   }

//   if (mounted) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Pass int duration instead of string
//       Navigator.of(context, rootNavigator: true).pop(_remoteDurationSeconds);
//     });
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     String _duration = _isRemoteUserConnected 
//         ? _formatDuration(_remoteDurationSeconds)
//         : 'Connecting..';

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: client == null
//           ? const Center(child: CircularProgressIndicator(color: Colors.white))
//           : SafeArea(
//               child: Stack(
//                 children: [
//                   AgoraVideoViewer(
//                     client: client!,
//                     layoutType: Layout.oneToOne,
//                     enableHostControls: true,
//                     showNumberOfUsers: false,
//                   ),

//                   Positioned(
//                     top: 20,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               CircleAvatar(
//                                 radius: 16,
//                                 backgroundImage: AssetImage(widget.callerAvatar),
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 widget.callerName,
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.4),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               _duration,
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   Positioned(
//                     bottom: 40,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 20),
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.5),
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           _buildControlButton(
//                             icon: isMicMuted 
//                               ? Icons.mic_off 
//                               : Icons.mic,
//                             backgroundColor: isMicMuted 
//                               ? Colors.red 
//                               : Colors.white30,
//                             onPressed: _toggleMicrophone,
//                           ),
//                           _buildControlButton(
//                             icon: isVideoMuted 
//                               ? Icons.videocam_off 
//                               : Icons.videocam,
//                             backgroundColor: isVideoMuted 
//                               ? Colors.red 
//                               : Colors.white30,
//                             onPressed: _toggleVideo,
//                           ),
//                           _buildControlButton(
//                             icon: Icons.cameraswitch,
//                             onPressed: _switchCamera,
//                           ),
//                           _buildControlButton(
//                             icon: Icons.call_end,
//                             backgroundColor: Colors.red,
//                             onPressed: _endCall,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildControlButton({
//     required IconData icon,
//     required VoidCallback onPressed,
//     Color backgroundColor = Colors.white30,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: backgroundColor,
//       ),
//       child: IconButton(
//         icon: Icon(icon),
//         color: Colors.white,
//         iconSize: 24,
//         padding: const EdgeInsets.all(12),
//         onPressed: onPressed,
//       ),
//     );
//   }

//   String _formatDuration(int seconds) {
//     int hours = seconds ~/ 3600;
//     int minutes = (seconds % 3600) ~/ 60;
//     int remainingSeconds = seconds % 60;
//     return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
//   }

// @override
// void dispose() {
//   try {
//     client?.release();
//   } catch (e) {
//     print('Error in dispose: $e');
//   }
//   super.dispose();
// }
// }