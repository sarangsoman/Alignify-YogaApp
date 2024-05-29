import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'IntroPage.dart';
import 'package:alignify/screens/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String userName = '';

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      setState(() {
        userName = userSnapshot['name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Homepage", style: TextStyle(color: Color.fromARGB(255, 213, 191, 245))),
      //   backgroundColor: Color.fromARGB(255, 52, 52, 52),
      // ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/emely.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color:
                Colors.black.withOpacity(0.8), // Set the color and opacity here
          ),
          Positioned(
            top: 40.0,
            right: 20.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                "Alignify",
                style: GoogleFonts.bebasNeue(
                  fontSize: 24,
                  color: const Color(0xFF68B984),
                  letterSpacing: 1.8,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hello $userName",
                  style: const TextStyle(
                      fontSize: 54, color: Color.fromARGB(255, 213, 191, 245)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                    height: 50), // Add space between text and buttons
                if (FirebaseAuth.instance.currentUser != null)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          const Size(200, 50), // Set the size of the button
                    ),
                    child:
                        const Text("Continue", style: TextStyle(fontSize: 20)),
                  ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!mounted) return;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return IntroPage();
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        const Size(200, 50), // Set the size of the button
                  ),
                  child: const Text("Sign Out", style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
