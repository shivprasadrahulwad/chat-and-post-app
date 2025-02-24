import 'package:flutter/material.dart';

class LifestyleHabitsWidget extends StatefulWidget {
  const LifestyleHabitsWidget({super.key});

  @override
  _LifestyleHabitsWidgetState createState() => _LifestyleHabitsWidgetState();
}

class _LifestyleHabitsWidgetState extends State<LifestyleHabitsWidget> {
  final Map<String, String> selectedOptions = {};

  void selectOption(String question, String option) {
    setState(() {
      selectedOptions[question] = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Let's Talk Lifestyle Habits, Username",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            "Do their habits match yours? You go first.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          _buildQuestionWithOptions(
            'How often do you drink?',
            [
              'Not for me',
              'Sober',
              'Sober curious',
              'On special occasions',
              'Socially on weekends',
              'Most nights'
            ],
          ),
          _buildQuestionWithOptions(
            'How often do you smoke?',
            [
              'Social smoker',
              'Smoker when drinking',
              'Non-smoker',
              'Smoker',
              'Trying to quit',
            ],
          ),
          _buildQuestionWithOptions(
            'Do you workout?',
            ['Everyday', 'Often', 'Sometimes', 'Never'],
          ),
          _buildQuestionWithOptions(
            'Do you have any pets?',
            [
              'Dog',
              'Cat',
              'Reptile',
              'Amphibian',
              'Bird',
              'Fish',
              'Don\'t have but love',
              'Other',
              'Allergic to pets',
              'Pet-free',
            ],
          ),
          _buildQuestionWithOptions(
            'What is your communication style?',
            [
              'I stay on WhatsApp all day',
              'Big time texter',
              'Phone caller',
              'Video chatter',
              'I am slow to answer on WhatsApp',
              'Bad texter',
              'Better in person',
            ],
          ),
          _buildQuestionWithOptions(
            'How do you receive love?',
            [
              'Thoughtful gestures',
              'Presence',
              'Touch',
              'Compliments',
              'Time together',
            ],
          ),
          _buildQuestionWithOptions(
            'What is your education level?',
            [
              'Bachelors',
              'In college',
              'High School',
              'PhD',
              'In Grad School',
              'Masters',
              'Trade School',
              'Professional Work',
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildQuestionWithOptions(String question, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLifestyleQuestion(question),
        const SizedBox(height: 10),
        _buildOptionRow(question, options),
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildLifestyleQuestion(String question) {
    return Row(
      children: [
        const Icon(Icons.help_outline),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            question,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionRow(String question, List<String> options) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children:
          options.map((option) => _buildOption(question, option)).toList(),
    );
  }

  Widget _buildOption(String question, String option) {
    bool isSelected = selectedOptions[question] == option;
    return GestureDetector(
      onTap: () => selectOption(question, option),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Text(
          option,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
