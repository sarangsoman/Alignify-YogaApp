import 'package:alignify/screens/bmi/result_bmi.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BMI extends StatefulWidget {
  const BMI({Key? key}) : super(key: key);

  @override
  State<BMI> createState() => _BMIState();
}

class _BMIState extends State<BMI> {
  bool isMale = true;
  double heightVal = 170;
  int weight = 60;
  int age = 18;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: const Text(
      //     'BMI CALCULATOR',
      //     style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF68B984)),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: const Color(0xFF191720),
      // ),
      extendBody: true,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Container(
        
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [
        //       Color(0xFF191720),
        //       Color.fromARGB(255, 36, 52, 92),
        //       Color(0xFF191720),
        //     ],
        //   ),
        // ),
        decoration: const BoxDecoration(
        color: Color.fromARGB(255, 48, 48, 48),
        image: DecorationImage(
          opacity: 0.2,
          image: AssetImage(
            "assets/images/image4.jpg",
          ),
          fit: BoxFit.cover,
        ),
      ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0,50,0,10),
                child: Text(
                          'BMI CALCULATOR',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF68B984)),
                        ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20,40,20,20),
                child: Row(
                  children: [
                    m1Expanded('male'),
                    const SizedBox(
                      width: 15,
                    ),
                    m1Expanded('female'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white24,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Height',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            heightVal.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const Text(
                            ' cm',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Slider(
                        min: 90,
                        max: 220,
                        value: heightVal,
                        onChanged: (newValue) => setState(() => heightVal = newValue),
                        activeColor: const Color.fromARGB(255, 60, 62, 106),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20,20,20,20),
                child: Row(
                  children: [
                    m2Expanded('weight'),
                    const SizedBox(
                      width: 15,
                    ),
                    m2Expanded('age'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(130, 140, 230, 172),
                        Color.fromARGB(180, 104, 185, 132),
                      ],
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      var result = weight / pow(heightVal / 100, 2);
                      _saveBMIData(result);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ResultBMI(
                            age: age,
                            isMale: isMale,
                            result: result,
                          );
                        }),
                      );
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Calculate',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  void _saveBMIData(double result) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        Timestamp timestamp = Timestamp.now();
        await _firestore.collection('users').doc(userId).collection('bmiData').add({
          'timestamp': timestamp,
          'bmi': result,
          'weight': weight,
          'height': heightVal,
        });
      }
    } catch (e) {
      print('Error saving BMI data: $e');
    }
  }

  Expanded m1Expanded(String gender) {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        setState(() {
          isMale = gender == 'male' ? true : false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: (isMale && gender == 'male') || (!isMale && gender == 'female')
              ? const Color(0xFF68B984)
              : const Color.fromARGB(57, 255, 255, 255),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              gender == 'male' ? Icons.male : Icons.female,
              color: Colors.white,
              size: 90,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              gender == 'male' ? 'Male' : 'Female',
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    ));
  }

  Expanded m2Expanded(String type) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white24,
              Color.fromARGB(30, 131, 131, 131),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              type == 'age' ? 'Age' : 'Weight',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              type == 'age' ? '$age' : '$weight',
              style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: type == 'age' ? 'age--' : 'weight--',
                  onPressed: () => setState(() => type == 'age' ? age-- : weight--),
                  mini: true,
                  backgroundColor: const Color.fromARGB(150, 255, 255, 255),
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton(
                  heroTag: type == 'age' ? 'age++' : 'weight++',
                  onPressed: () => setState(() => type == 'age' ? age++ : weight++),
                  mini: true,
                  backgroundColor: const Color.fromARGB(150, 255, 255, 255),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
