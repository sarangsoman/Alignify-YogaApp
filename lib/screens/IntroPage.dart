import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CarouselSlider(
            items: [
              _buildCarouselItem(
                'assets/images/vajrasana.jpg',
                'Get fit and healthy',
                'Track your workouts and stay motivated to reach your fitness goals.',
              ),
            ],
            carouselController: _controller,
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {},
            ),
          ),
          Positioned(
            top: 40.0,
            right: 20.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                "Alignify",
                style: GoogleFonts.bebasNeue(
                  fontSize: 34,
                  color: const Color(0xFF68B984),
                  letterSpacing: 1.8,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Color.fromARGB(255, 213, 191, 245)),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors
                        .black
                        .withOpacity(0.2)), // set the background color
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(10)), // set the padding
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontSize: 23)), // set the text style
                    fixedSize: MaterialStateProperty.all<Size>(Size(25, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10))), // set the shape
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen()));
                  },
                  child: Text('Sign up',
                      style:
                          TextStyle(color: Color.fromARGB(255, 213, 191, 245))),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.black.withOpacity(0.3)),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(10)), // set the padding
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontSize: 23)), // set the text style
                    fixedSize: MaterialStateProperty.all<Size>(Size(20, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10))), // set the shape
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(String imagePath, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 48, 48, 48),
        image: DecorationImage(
          opacity: 0.2,
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF68B984),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
