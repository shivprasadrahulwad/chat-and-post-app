import 'package:flutter/material.dart';

class InterestedGenderSelectionWidget extends StatefulWidget {
  const InterestedGenderSelectionWidget({super.key});

  @override
  _InterestedGenderSelectionWidgetState createState() => _InterestedGenderSelectionWidgetState();
}

class _InterestedGenderSelectionWidgetState extends State<InterestedGenderSelectionWidget> {
  String? selectedInterest;

  void selectInterest(String interest) {
    setState(() {
      selectedInterest = interest;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Who are you interested in for matching?",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildOption('Women'),
        const SizedBox(height: 16),
        _buildOption('Men'),
        const SizedBox(height: 16),
        _buildOption('Everyone'),
      ],
    );
  }

  Widget _buildOption(String label) {
    bool isSelected = selectedInterest == label;
    return GestureDetector(
      onTap: () => selectInterest(label),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
