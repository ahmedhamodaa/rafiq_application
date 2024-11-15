import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForthIntro extends StatelessWidget {
  const ForthIntro({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
              child: SvgPicture.asset(
                'images/intros/4.svg',
                height: 343,
                width: 343,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              'Choose Your Language',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 10,
            ),
            LanguageSelectionScreen(),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 44,
                width: 360,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xff071952)),
                child: const Center(
                  child: Text(
                    'select language',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _selectedLanguage;

  final List<String> languages = [
    'Arabic',
    'English',
    'Spanish',
    'French',
    'Italian'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: languages.map((language) {
        return Row(
          children: [
            Radio<String>(
              value: language,
              groupValue: _selectedLanguage,
              onChanged: (String? value) {
                setState(() {
                  _selectedLanguage = value;
                });
              },
              activeColor: Colors.blue,
            ),
            Text(
              language,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        );
      }).toList(),
    );
  }
}
