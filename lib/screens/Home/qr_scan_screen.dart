// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:friends/constants/global_variables.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

// class QRScanScreen extends StatefulWidget {
//   static const String routeName = '/scan';

//   @override
//   State<StatefulWidget> createState() => _QRScanScreenState();
// }

// class _QRScanScreenState extends State<QRScanScreen> {
//   late MobileScannerController cameraController;

//   @override
//   void initState() {
//     super.initState();
//     cameraController = MobileScannerController(
//       facing: CameraFacing.back,
//       torchEnabled: false,
//     );
//   }

//   @override
//   void dispose() {
//     cameraController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(
//               Icons.arrow_back,
//               color: GlobalVariables.greenColor,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           title: const Text(
//             'Scan QR',
//             style: TextStyle(
//               fontFamily: 'Regular',
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: GlobalVariables.greenColor,
//             ),
//           ),
//           actions: [
//             IconButton(
//               icon: ValueListenableBuilder(
//                 valueListenable: cameraController.torchState,
//                 builder: (context, state, child) {
//                   return Icon(
//                     state == TorchState.on ? Icons.flash_on : Icons.flash_off,
//                     color: GlobalVariables.greenColor,
//                   );
//                 },
//               ),
//               onPressed: () => cameraController.toggleTorch(),
//             ),
//             IconButton(
//               icon: ValueListenableBuilder(
//                 valueListenable: cameraController.cameraFacingState,
//                 builder: (context, state, child) {
//                   return Icon(
//                     state == CameraFacing.front
//                         ? Icons.camera_front
//                         : Icons.camera_rear,
//                     color: GlobalVariables.greenColor,
//                   );
//                 },
//               ),
//               onPressed: () => cameraController.switchCamera(),
//             ),
//           ],
//         ),
//         body: Stack(
//           children: [
//             MobileScanner(
//               controller: cameraController,
//               onDetect: (capture) {
//                 final List<Barcode> barcodes = capture.barcodes;
//                 for (final barcode in barcodes) {
//                   // Return the first valid barcode
//                   if (barcode.rawValue != null) {
//                     Navigator.pop(context, barcode.rawValue);
//                     return;
//                   }
//                 }
//               },
//               overlay: QRScannerOverlay(
//                 overlayColor: Colors.black.withOpacity(0.5),
//               ),
//             ),
//             const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text(
//                     'Scan Result',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white54,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                 ],
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 50.0),
//                 child: IconButton(
//                   icon: const Icon(
//                     Icons.qr_code_scanner,
//                     color: Colors.black,
//                     size: 25,
//                   ),
//                   onPressed: () {
//                     // Reset scanner if needed
//                     cameraController.start();
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
// }

// // Custom overlay widget for scanner
// class QRScannerOverlay extends StatelessWidget {
//   const QRScannerOverlay({
//     Key? key,
//     required this.overlayColor,
//   }) : super(key: key);

//   final Color overlayColor;

//   @override
//   Widget build(BuildContext context) {
//     // Get the screen size
//     final size = MediaQuery.of(context).size;
//     // Calculate the scan area size
//     final scanAreaSize = size.width * 0.7;

//     return Stack(
//       children: [
//         ColorFiltered(
//           colorFilter: ColorFilter.mode(
//             overlayColor,
//             BlendMode.srcOut,
//           ),
//           child: Stack(
//             children: [
//               Container(
//                 decoration: const BoxDecoration(
//                   color: Colors.transparent,
//                 ),
//                 child: Center(
//                   child: Container(
//                     height: scanAreaSize,
//                     width: scanAreaSize,
//                     decoration: BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Center(
//           child: Container(
//             width: scanAreaSize,
//             height: scanAreaSize,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: GlobalVariables.greenColor,
//                 width: 2,
//               ),
//               borderRadius: BorderRadius.circular(20),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friends/constants/global_variables.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// Modern color scheme
const Color primaryColor = Color(0xFF6C63FF);
const Color secondaryColor = Color(0xFF2A2D3E);
const Color accentColor = Color(0xFFFF6584);
const Color darkOverlay = Color(0xFF1A1A1A);

class QRScanScreen extends StatefulWidget {
  static const String routeName = '/scan';

  @override
  State<StatefulWidget> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> with TickerProviderStateMixin {
  MobileScannerController cameraController = MobileScannerController();
  bool isFlashOn = false;
  
  late AnimationController _scanAnimationController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _scanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_scanAnimationController);
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              await cameraController.toggleTorch();
              setState(() => isFlashOn = !isFlashOn);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Scanner
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  Navigator.pop(context, barcode.rawValue);
                  return;
                }
              }
            },
          ),
          
          // Overlay with scanning animation
          CustomPaint(
            painter: ScannerOverlayPainter(
              scanAnimation: _scanAnimation,
              overlayColor: darkOverlay.withOpacity(0.8),
            ),
          ),

          // Bottom Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.qr_code_scanner,
                          color: primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Scan QR code to connect',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Animation<double> scanAnimation;
  final Color overlayColor;

  ScannerOverlayPainter({
    required this.scanAnimation,
    required this.overlayColor,
  }) : super(repaint: scanAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final scanAreaSize = size.width * 0.7;
    final scanAreaOffset = (size.width - scanAreaSize) / 2;
    final scanAreaRect = Rect.fromLTWH(
      scanAreaOffset,
      (size.height - scanAreaSize) / 2,
      scanAreaSize,
      scanAreaSize,
    );

    // Draw dark overlay
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final scanArea = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          scanAreaRect,
          const Radius.circular(20),
        ),
      );
    final finalPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      scanArea,
    );
    canvas.drawPath(
      finalPath,
      Paint()..color = overlayColor,
    );

    // Draw scan area border
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        scanAreaRect,
        const Radius.circular(20),
      ),
      Paint()
        ..color = primaryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Draw scanning line
    final scanLineY = scanAreaRect.top +
        (scanAreaRect.height * scanAnimation.value);
    canvas.drawLine(
      Offset(scanAreaRect.left + 20, scanLineY),
      Offset(scanAreaRect.right - 20, scanLineY),
      Paint()
        ..color = primaryColor
        ..strokeWidth = 3
        ..shader = LinearGradient(
          colors: [
            primaryColor.withOpacity(0),
            primaryColor,
            primaryColor.withOpacity(0),
          ],
        ).createShader(
          Rect.fromLTWH(
            scanAreaRect.left,
            scanLineY - 1.5,
            scanAreaRect.width,
            3,
          ),
        ),
    );

    // Draw corner indicators
    const cornerSize = 20.0;
    final cornerPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Top left corner
    canvas.drawPath(
      Path()
        ..moveTo(scanAreaRect.left, scanAreaRect.top + cornerSize)
        ..lineTo(scanAreaRect.left, scanAreaRect.top)
        ..lineTo(scanAreaRect.left + cornerSize, scanAreaRect.top),
      cornerPaint,
    );

    // Top right corner
    canvas.drawPath(
      Path()
        ..moveTo(scanAreaRect.right - cornerSize, scanAreaRect.top)
        ..lineTo(scanAreaRect.right, scanAreaRect.top)
        ..lineTo(scanAreaRect.right, scanAreaRect.top + cornerSize),
      cornerPaint,
    );

    // Bottom left corner
    canvas.drawPath(
      Path()
        ..moveTo(scanAreaRect.left, scanAreaRect.bottom - cornerSize)
        ..lineTo(scanAreaRect.left, scanAreaRect.bottom)
        ..lineTo(scanAreaRect.left + cornerSize, scanAreaRect.bottom),
      cornerPaint,
    );

    // Bottom right corner
    canvas.drawPath(
      Path()
        ..moveTo(scanAreaRect.right - cornerSize, scanAreaRect.bottom)
        ..lineTo(scanAreaRect.right, scanAreaRect.bottom)
        ..lineTo(scanAreaRect.right, scanAreaRect.bottom - cornerSize),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}