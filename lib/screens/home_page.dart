import 'package:flutter/material.dart';
import 'package:rafiq/screens/academic_category.dart';
import 'package:rafiq/screens/course_details.dart';
import 'package:rafiq/screens/notifications_screen.dart';
import 'package:rafiq/screens/messages_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFavorite = false;
  int selectedButton = 1;
  // Function to handle the favorite toggle
  List<bool> isFavoriteList = List.generate(5, (index) => false);

  void _toggleFavorite(int index) {
    setState(() {
      isFavoriteList[index] = !isFavoriteList[index];
    });

    // Add the instructor to the favorites screen if it's marked as favorite
    if (isFavoriteList[index]) {
      // Code to add instructor to favorites (e.g., saving it to a list or database)
      debugPrint("Instructor at index $index added to favorites.");
    } else {
      // Code to remove instructor from favorites if it's unmarked
      debugPrint("Instructor at index $index removed from favorites.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
            kToolbarHeight + 8), // Adjust height for padding
        child: Container(
          color: Colors.white, // AppBar color
          child: AppBar(
            backgroundColor: Colors.white, // Make AppBar itself transparent
            elevation: 0, // Remove shadow
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    'images/courses/profile_picture.jpg',
                    height: screenHeight * 0.055,
                    width: screenHeight * 0.055,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Ahmed,',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'What do you want to learn today ?',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff999999),
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1, // Prevent overflow
                        softWrap: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                color: const Color(0xff088395),
                style: IconButton.styleFrom(backgroundColor: Colors.black12),
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsScreen(),
                      ));
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                color: const Color(0xff088395),
                style: IconButton.styleFrom(backgroundColor: Colors.black12),
                icon: const Icon(Icons.message_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MessagesScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 18)
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                width: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional
                      .center, // Align the button in the center of the picture
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(16), // Rounded corners
                      child: Image.asset(
                        'images/courses/homeframe.png',
                        width: double.infinity, // Replace with your image path
                        fit: BoxFit.fill, // Replace with your image path
                      ),
                    ),
                    Positioned(
                        top: 26,
                        left: 22,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'New Offer',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 28),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'Discount 20% for the first booking',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xff071952),
                                    fixedSize: const Size(144, 18),
                                    shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    )),
                                onPressed: () {},
                                child: const Text(
                                  'Book now',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AcademicCategory(),
                        ));
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff088395)),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
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
                      'Academic',
                      style: TextStyle(fontSize: 18),
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
                    child: const Text(
                      'Non-Academic',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Our Courses',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            if (selectedButton == 1)
              SizedBox(
                height: 188,
                width: 1000,
                child: ListView.builder(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CourseDetails(
                                type: 'Course Details',
                              ),
                            ));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xffD0D0D0))),
                        height: 140,
                        width: 288,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Stack(
                                alignment: AlignmentDirectional
                                    .center, // Align the button in the center of the picture
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        12), // Rounded corners
                                    child: Image.asset(
                                      'images/courses/cyber.png',
                                      width:
                                          270, // Replace with your image path
                                      height: 120,
                                      fit: BoxFit
                                          .fill, // Replace with your image path
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    left:
                                        8, // Position the button at the bottom of the image

                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          color: Colors.white),
                                      height: 24,
                                      width: 44,
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            size: 16,
                                            Icons.star,
                                            color: Color(0xffFFE100),
                                          ),
                                          Text(
                                            '3.8 ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Academic course',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '1500',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff088395)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (selectedButton == 2)
              SizedBox(
                height: 188,
                width: 1000,
                child: ListView.builder(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CourseDetails(
                                type: 'Course Details',
                              ),
                            ));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xffD0D0D0))),
                        height: 140,
                        width: 288,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Stack(
                                alignment: AlignmentDirectional
                                    .center, // Align the button in the center of the picture
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        12), // Rounded corners
                                    child: Image.asset(
                                      'images/courses/uiuxcourse.png',
                                      width:
                                          270, // Replace with your image path
                                      height: 120,
                                      fit: BoxFit
                                          .fill, // Replace with your image path
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    left:
                                        8, // Position the button at the bottom of the image

                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          color: Colors.white),
                                      height: 24,
                                      width: 44,
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            size: 16,
                                            Icons.star,
                                            color: Color(0xffFFE100),
                                          ),
                                          Text(
                                            '3.8 ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'UI UX Diploma',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '4500',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff088395)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(
              height: 16,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Our Instructors',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Column(
                children: List.generate(
              5,
              (index) => Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Center(
                      child: Container(
                        width: double.infinity, // Width of the card
                        height: 248, // Height of the card
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Cover Photo
                            Container(
                              height: 100,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                                image: DecorationImage(
                                  image: AssetImage(
                                      'images/courses/homeframe.png'), // Cover photo
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            // Profile Picture
                            const Positioned(
                              top:
                                  42, // Overlapping the cover photo and details section
                              left:
                                  150, // Center horizontally (adjust based on width)
                              child: CircleAvatar(
                                radius: 50, // Profile picture size
                                backgroundImage: AssetImage(
                                    'images/courses/aref.png'), // Profile picture
                              ),
                            ),

                            // Name and Description Section
                            Positioned(
                              top: 148, // Below the profile picture
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: [
                                    const Text(
                                      'mohamed aref', // Name
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'A passionate UI/UX designer with a knack for creating intuitive and beautiful interfaces.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                                right: 8,
                                top: 8,
                                child: IconButton(
                                    style: IconButton.styleFrom(
                                        backgroundColor: Colors.white70),
                                    onPressed: () => _toggleFavorite(index),
                                    icon: Icon(
                                      isFavoriteList[index]
                                          ? Icons.favorite
                                          : Icons.favorite_outline,
                                      color: isFavoriteList[index]
                                          ? Colors.red.shade400
                                          : Colors.grey,
                                    )))
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
