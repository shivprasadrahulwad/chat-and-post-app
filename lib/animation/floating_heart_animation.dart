import 'dart:math' as math;
import 'package:flutter/material.dart';

class RisingCircles extends StatefulWidget {
  const RisingCircles({super.key});

  @override
  State<RisingCircles> createState() => _RisingCirclesState();
}

class _RisingCirclesState extends State<RisingCircles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Adjust speed
    );

    _positionAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from bottom
      end: const Offset(0, -1), // Move to top
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 1.0, // Fully visible
      end: 0.0, // Fully transparent at the top
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward(); // Start animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        5, // Number of circles
        (index) => AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Positioned(
              left: 50 + (index * 60), // Adjust horizontal position
              bottom: MediaQuery.of(context).size.height * _positionAnimation.value.dy,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: _buildCircle(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCircle() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
    );
  }
}
