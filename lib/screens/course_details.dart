import 'package:flutter/material.dart';
import 'package:rafiq/screens/booking_screen.dart';
import 'package:rafiq/screens/video_screen.dart';
import 'package:rafiq/widgets/read_more_description.dart';
import 'package:video_player/video_player.dart';

class CourseDetails extends StatefulWidget {
  const CourseDetails({super.key, required this.type});
  final String type;

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  late VideoPlayerController _videoController;
  int selectedButton = 1;
  @override
  void initState() {
    super.initState();
    // Initialize the video player with a real video URL
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse('www.w3schools.com/html/mov_bbb.mp4'), // Sample video URL
    )
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..initialize();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_videoController.value.isPlaying) {
      _videoController.pause();
    } else {
      _videoController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional
                      .center, // Align the button in the center of the picture
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                      child: Image.asset(
                        'images/courses/uiuxcourse.png',
                        width: double.infinity, // Replace with your image path
                        fit: BoxFit.fill, // Replace with your image path
                      ),
                    ),
                    Positioned(
                      top: screenHeight *
                          0.01, // Position the button at the bottom of the image

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: Colors.white),
                            height: screenHeight * 0.04,
                            width: screenWidth * 0.18,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  size: screenWidth * 0.06,
                                  Icons.star,
                                  color: const Color(0xffFFE100),
                                ),
                                Text(
                                  '3.8 ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: screenWidth * 0.044),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: screenWidth * 1 / 1.8),
                          IconButton(
                            onPressed: () {
                              // Action for the button
                            },
                            icon: const Icon(
                              Icons.favorite_outline, // Example icon
                              color: Colors.black87, // Set icon color
                            ),
                            iconSize: 32, // Adjust the icon size
                            splashRadius: 24, // Set the splash effect radius
                            style: IconButton.styleFrom(
                                backgroundColor: Colors
                                    .white54), // Semi-transparent background
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'UI UX Diploma',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                // widget.type == 'Course Details'
                //     ? const Text(
                //         '4500',
                //         style: TextStyle(
                //             fontSize: 22,
                //             fontWeight: FontWeight.w600,
                //             color: Color(0xff088395)),
                //       )
                //     : const SizedBox()
              ],
            ),
            widget.type == 'Course Details'
                ? Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    width: double.infinity,
                    height: 150,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        FilledButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BookingScreen(),
                                ),
                              );
                            },
                            child: const Text('Book Now')),
                        const SizedBox(height: 8),
                        FilledButton(
                            onPressed: () {},
                            style: FilledButton.styleFrom(
                                backgroundColor: theme.colorScheme.onPrimary,
                                foregroundColor: theme.colorScheme.primary),
                            child: const Text('Add to favorite'))
                      ],
                    ))
                : const SizedBox(),
            const SizedBox(
              height: 12,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Instructor',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              leading: Image.asset('images/courses/aref.png'),
              title: const Text(
                'Mohammed Aref',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Instructor at route academy',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              trailing: SizedBox(
                width: 98,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        style: IconButton.styleFrom(
                            backgroundColor: const Color(0xffEEEEEE)),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.message_outlined,
                          color: Color(
                            0xff088395,
                          ),
                        )),
                    IconButton(
                        style: IconButton.styleFrom(
                            backgroundColor: const Color(0xffEEEEEE)),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.phone_outlined,
                          color: Color(
                            0xff088395,
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: Colors.grey),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time_sharp,
                      color: Colors.grey,
                    ),
                    Text(
                      '120h 45min',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                Row(
                  spacing: 2,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      color: Colors.grey,
                    ),
                    Text(
                      'Certificate',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                Row(
                  spacing: 2,
                  children: [
                    Icon(
                      Icons.person_add_alt_outlined,
                      color: Colors.grey,
                    ),
                    Text(
                      '150+ Students',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ],
            ),
            const Divider(color: Colors.grey),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                )
              ],
            ),
            const SizedBox(height: 8),
            const ReadMoreDescription(
              description:
                  'Unlock the world of user-centric design with our comprehensive UI/UX Design Course! This course is tailored for aspiring designers, developers, and anyone passionate about crafting intuitive and engaging digital experiences. You\'ll learn the fundamentals of user interface (UI) design and user experience (UX) principles, exploring tools like Figma and Adobe XD to create wireframes, prototypes, and mockups. Dive into the psychology of design, usability testing, and responsive design techniques to ensure your creations resonate across all devices. By the end of this course, you\'ll have a polished portfolio of projects, showcasing your ability to design visually appealing and user-friendly websites and mobile applications. Whether you\'re starting from scratch or enhancing your current skills, this course will elevate your design journey.What You’ll Learn: Design principles and color theory Wireframing and prototyping User research and persona creation Usability testing and feedback integration Responsive design for web and mobile Who This Course is For: Beginners, developers, and professionals aiming to transition into the design field or improve their skills in crafting exceptional digital experiences.',
            ),
            const Divider(
              color: Color(0xffEEEEEE),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: selectedButton == 1
                          ? Colors.white
                          : const Color(0xff088395),
                      backgroundColor: selectedButton == 1
                          ? const Color(0xff088395)
                          : Colors.white,
                      minimumSize:
                          const Size(0, 44), // Width set to 0, height is fixed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                          color: Color(0xff088395),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedButton = 1; // Select the first button
                      });
                    },
                    child: const Text(
                      'Roadmap',
                      style: TextStyle(fontSize: 13),
                      maxLines: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Add space between the buttons
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: selectedButton == 2
                          ? Colors.white
                          : const Color(0xff088395),
                      backgroundColor: selectedButton == 2
                          ? const Color(0xff088395)
                          : Colors.white,
                      minimumSize:
                          const Size(0, 44), // Width set to 0, height is fixed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                          color: Color(0xff088395),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedButton = 2; // Select the second button
                      });
                    },
                    child: Text(
                      'Reviews',
                      style: TextStyle(fontSize: screenWidth * 0.038),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Add space between the buttons
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: selectedButton == 3
                          ? Colors.white
                          : const Color(0xff088395),
                      backgroundColor: selectedButton == 3
                          ? const Color(0xff088395)
                          : Colors.white,
                      minimumSize:
                          const Size(0, 44), // Width set to 0, height is fixed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                          color: Color(0xff088395),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedButton = 3; // Select the second button
                      });
                    },
                    child: Text(
                      'Mentor',
                      style: TextStyle(fontSize: screenWidth * 0.038),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (selectedButton == 1)
              widget.type == 'Course Details'
                  ? Column(
                      children: List.generate(
                        10,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: ListTile(
                            leading: const Text(
                              '01',
                              style: TextStyle(
                                fontSize: 42,
                                color: Color(0xff999999),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            title: const Text(
                              'Session 1',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text('Subtitle'),
                            trailing: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xff088395),
                              ),
                              onPressed: () {},
                              icon: const Icon(
                                Icons.lock_outline_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: List.generate(
                        10,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey)),
                          child: ListTile(
                            leading: const Text(
                              '01',
                              style: TextStyle(
                                  fontSize: 42,
                                  color: Color(0xff999999),
                                  fontWeight: FontWeight.bold),
                            ),
                            title: const Text(
                              'Session 1',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text('Subtitle'),
                            trailing: IconButton(
                                style: IconButton.styleFrom(
                                    backgroundColor: const Color(0xff088395)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const VideoScreen(),
                                      ));
                                },
                                icon: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                    ),
            if (selectedButton == 2)
              Column(
                children: List.generate(
                  10,
                  (index) => Column(
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: 120,
                              child: Row(
                                children: List<Icon>.generate(
                                        4,
                                        (_) => const Icon(Icons.star,
                                            color: Color(0xffffe100))) +
                                    [
                                      const Icon(Icons.star, color: Colors.grey)
                                    ],
                              )),
                          const Text('01/07/2024')
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Simple explanation of the information and constant follow-up and training on practical projects',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'By Mohammed Nasser',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
