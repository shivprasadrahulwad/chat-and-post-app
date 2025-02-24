import 'package:flutter/material.dart';

class LookingForWidget extends StatefulWidget {
  const LookingForWidget({super.key});

  @override
  _LookingForWidgetState createState() => _LookingForWidgetState();
}

class _LookingForWidgetState extends State<LookingForWidget> {
  String? selectedOption;

  void selectOption(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(  // Wrap the Column in a SingleChildScrollView
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What are you looking for?",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "All good if it changes. There's something for everyone.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          _buildOptionRow(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOptionRow() {
    return Column(
      children: [
        _buildOptionRowWithThree(
          '💘', 'Long-term partner',
          '😍', 'Long-term, open to short',
          '🥂', 'Short-term, open to long',
        ),
        const SizedBox(height: 16),
        _buildOptionRowWithThree(
          '🎉', 'Short-term fun',
          '👋', 'New friends',
          '🤔', 'Still figuring it out',
        ),
      ],
    );
  }

  Widget _buildOptionRowWithThree(String emoji1, String text1, String emoji2, String text2, String emoji3, String text3) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // Adds equal spacing between containers
      children: [
        Expanded(child: _buildOption(emoji1, text1)),
        Expanded(child: _buildOption(emoji2, text2)),
        Expanded(child: _buildOption(emoji3, text3)),
      ],
    );
  }

  Widget _buildOption(String emoji, String text) {
    bool isSelected = selectedOption == text;
    return GestureDetector(
      onTap: () => selectOption(text),
      child: Container(
        height: 160,
        margin: const EdgeInsets.symmetric(horizontal: 4),  // Adjust margin for spacing between containers
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 