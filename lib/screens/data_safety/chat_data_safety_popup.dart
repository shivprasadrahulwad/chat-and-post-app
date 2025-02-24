import 'package:flutter/material.dart';

void showDataSafetyPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return DataSafetyPopup();
    },
  );
}

class DataSafetyPopup extends StatefulWidget {
  @override
  _DataSafetyPopupState createState() => _DataSafetyPopupState();
}

class _DataSafetyPopupState extends State<DataSafetyPopup> {
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Be respectful',
      'image': 'assets/images/image.png',
      'description': "Don't bully, harass, or threaten others. We don't support discrimination of any kind. SocialGo is no place for hate.",
      'subtitle': 'Respect boundaries',
      'subDescription': "Always get consent before talking about personal matters.",
    },
    {
      'title': 'Is it a scam?',
      'image': 'assets/images/image.png',
      'description': 'Be mindful of someone playing on your emotions or claiming they desperately need money. It’s okay to say "no".',
      'subtitle': 'Spot a get-rich-quick scheme',
      'subDescription': 'If someone promises a big cash-out that sounds too good to be true – it probably is. Trust your gut.',
    },
    {
      'title': 'Take your time, if you want',
      'image': 'assets/images/image.png',
      'description': "You can always ask someone for photo verification or a video call before sharing too much info or meeting up.",
      'subtitle': 'Unmatch, block, or report',
      'subDescription': "If someone crosses a line, tell us. Reports are treated confidentially. You can also block or unmatch them.",
    }
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      setState(() => _currentPage++);
    } else {
      Navigator.pop(context); // Close dialog on last page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adjusts height dynamically
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.security, size: 20,),
                SizedBox(width: 5,),
                Text(
                "Data Safety",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ],
            ),
            SizedBox(height: 20),

            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                _pages[_currentPage]['image']!,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),

            // **Bold Text Below Image**
            Text(
              _pages[_currentPage]['title']!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),

            // Description
            Text(
              _pages[_currentPage]['description']!,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),

            // **Bold Subtitle**
            Text(
              _pages[_currentPage]['subtitle']!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 5),

            // Sub-description
            Text(
              _pages[_currentPage]['subDescription']!,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),

            // Page Indicator (Dots)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Next Button
            GestureDetector(
              onTap: _nextPage,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text(
                  _currentPage < _pages.length - 1 ? 'Next' : 'Close',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}