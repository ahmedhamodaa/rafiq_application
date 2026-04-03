import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/screens/interests_page.dart';
import 'package:vector_graphics/vector_graphics.dart';

class LanguageSelection extends StatelessWidget {
  const LanguageSelection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Center(
                child: SvgPicture(AssetBytesLoader('images/intros/4.svg.vec'))),
            const SizedBox(height: 25),
            const Text(
              'Choose Your Language',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            const LanguageSelectionScreen(),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const InterestsPage();
                  },
                ));
              },
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
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
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
    return RadioGroup<String>(
      groupValue: _selectedLanguage,
      onChanged: (String? value) {
        setState(() {
          _selectedLanguage = value;
        });
      },
      child: Column(
        children: languages.map((language) {
          return Row(
            children: [
              Radio<String>(
                value: language,
                activeColor: const Color(0xff071952),
              ),
              Text(
                language,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
