import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_view_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final List<Map<String, String>> cards = [
    {
      'image': 'assets/images/image7.png',
      'title': 'Track your form',
      'subtitle': 'Monitor your exercise technique'
    },
    {
      'image': 'assets/images/image10.jpeg',
      'title': 'Track your progress',
      'subtitle': 'Keep an eye on your fitness journey'
    },
    {
      'image': 'assets/images/image9.png',
      'title': 'Compete with other users',
      'subtitle': 'Challenge others and stay motivated'
    }
  ];

  WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/image2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: Text(
                    "Alignify",
                    style: GoogleFonts.bebasNeue(
                      fontSize: 56,
                      color: const Color(0xFF68B984),
                      letterSpacing: 1.8,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 40.0,
                right: 25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Exercise, ",
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Made Fun",
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          color: const Color(0xFF68B984),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "We will help you reach your potential.\nFollow the next steps, to complete your information",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 30, top: 30, bottom: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: GestureDetector(
                            onTap: () {
                              _showCardsDialog(context);
                            },
                            child: Container(
                              width: 120,
                              height: 39,
                              decoration: BoxDecoration(
                                color: const Color(0xFF68B984).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                child: Text(
                                  "Learn More",
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeViewScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 39,
                            decoration: BoxDecoration(
                              color: const Color(0xFF68B984).withOpacity(0.7),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Center(
                              child: Text(
                                "Next",
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showCardsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          elevation: 0,
          child: SizedBox(
            height: 450,
            child: PageView.builder(
              itemCount: cards.length,
              itemBuilder: (BuildContext context, int index) {
                final card = cards[index];
                return CustomCard(
                  image: card['image']!,
                  title: card['title']!,
                  subtitle: card['subtitle']!,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class CustomCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const CustomCard({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF68B984).withOpacity(0.4),
      margin: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      height: 200,
                      width: 400,
                    ),
                  ),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.lato(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          subtitle,
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            color: const Color.fromARGB(150, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
