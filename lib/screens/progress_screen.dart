import 'package:flutter/material.dart';
import 'bmi/bmi_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'weight_progress.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  double latestWeight = 0.0; // Variable to store the latest weight
  double desiredWeight = 0.0;
  double avgFormCorrectness = 0.0;
  int totalScore = 0;
  List<Map<String, dynamic>> exerciseData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLatestWeight(); // Fetch the latest weight when the widget initializes
    _fetchDesiredWeight();
    _fetchAvgForm();
    _fetchTotalScore();
    fetchExerciseData();
  }

  Future<void> _fetchLatestWeight() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final weightSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('bmiData')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (weightSnapshot.docs.isNotEmpty) {
        final latestWeightDoc = weightSnapshot.docs.first;
        final latestWeightValue =
            latestWeightDoc['weight'] as int; // Change to double
        print('latest Weight Retrieved: $latestWeightValue');
        setState(() {
          latestWeight = latestWeightValue.toDouble();
        });
      }
    } catch (e) {
      print('Error fetching latest weight: $e');
    }
  }

  Future<void> _fetchDesiredWeight() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final desiredWeightValue =
            userData['desired_weight'] as int; // Change to double
        print('Desired Weight Retrieved: $desiredWeightValue');
        setState(() {
          desiredWeight = desiredWeightValue.toDouble();
        });
      }
    } catch (e) {
      print('Error fetching desired weight: $e');
    }
  }

  Widget _buildWeightProgressIndicator(
      double latestWeight, double desiredWeight) {
    // Ensure desiredWeight is not zero to prevent division by zero
    if (desiredWeight == 0) {
      return const Text(
        'Desired weight is not set',
        style: TextStyle(color: Colors.white),
      );
    }
    // Calculate progress percentage
    double progress = latestWeight / desiredWeight;
    // Calculate the color based on conditions
    Color color;
    if (latestWeight == desiredWeight) {
      color = Colors.green;
    } else if ((latestWeight - desiredWeight).abs() <= 2) {
      color = Colors.yellow;
    } else {
      color = Colors.red;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Inner filled circle based on progress
            SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                value: progress.isFinite
                    ? progress
                    : 0, // Check if progress is finite
                strokeWidth: 10,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            // Text indicating weight value
            Positioned(
              child: Text(
                '$latestWeight kg',
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current: $latestWeight kg',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Goal: $desiredWeight kg',
              style: TextStyle(
                  color: Colors.grey[300], fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> fetchExerciseData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('exerciseData')
          .orderBy('end_time',
              descending: true) // Order by timestamp descending
          .get();

      final List<Map<String, dynamic>> data = [];
      querySnapshot.docs.forEach((doc) {
        final exercise = doc.data();
        if (exercise != null) {
          data.add(exercise as Map<String, dynamic>);
        }
      });

      if (mounted) {
        setState(() {
          exerciseData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching exercise data: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchAvgForm() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final exerciseSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('exerciseData')
          .get();

      if (exerciseSnapshot.docs.isNotEmpty) {
        double sum = 0.0;
        int count = 0;
        for (final doc in exerciseSnapshot.docs) {
          if (doc.exists &&
              doc.data().containsKey('average_form_correctness')) {
            final avgForm = doc['average_form_correctness'] as double?;
            if (avgForm != null) {
              sum += avgForm;
              count++;
            }
          }
        }
        if (count > 0) {
          final avgForm = sum / count;
          setState(() {
            avgFormCorrectness = avgForm;
          });
          print('Average Form Correctness Retrieved: $avgForm');
        } else {
          print('No valid data found in average_form_correctness field');
        }
      } else {
        print('No documents found in exerciseData subcollection');
      }
    } catch (e) {
      print('Error fetching latest weight: $e');
    }
  }

  Future<void> _fetchTotalScore() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final exerciseSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('exerciseData')
          .get();

      if (exerciseSnapshot.docs.isNotEmpty) {
        int sum = 0;
        for (final doc in exerciseSnapshot.docs) {
          if (doc.exists && doc.data().containsKey('score')) {
            final scoreValue = doc['score'] as int?;
            if (scoreValue != null) {
              sum += scoreValue;
            }
          }
        }
        setState(() {
          totalScore = sum;
        });
        print('Sum calculated Retrieved: $sum');
      } else {
        print('No documents found in exerciseData subcollection');
      }
    } catch (e) {
      print('Error fetching latest weight: $e');
    }
  }

  Widget _buildAvgFormCorrectnessIndicator() {
    if (avgFormCorrectness == 0) {
      return const Text('No form correctness data available',
          style: TextStyle(color: Colors.white));
    }
    double progress = avgFormCorrectness * 100;
    String progressFormatted = progress.toStringAsFixed(2);

    Color color;
    if (progress >= 85) {
      color = Colors.green;
    } else if (progress >= 50 && progress < 85) {
      color = Colors.yellow;
    } else {
      color = Colors.red;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                value: avgFormCorrectness.isFinite
                    ? avgFormCorrectness
                    : 0, // Check if progress is finite
                strokeWidth: 5,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Positioned(
              child: Text(
                '$progressFormatted %',
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Form Accuracy',
              style: TextStyle(
                  color: Colors.grey[300], fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalScoreIndicator() {
    double progress = (totalScore - ((totalScore ~/ 100)) * 100);
    Color color;
    if (progress >= 90) {
      color = Colors.green;
    } else if (progress >= 50 && progress < 90) {
      color = Colors.yellow;
    } else {
      color = Colors.red;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                value: (totalScore - ((totalScore ~/ 100)) * 100) /
                    (100), // Check if progress is finite
                strokeWidth: 5,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Positioned(
              child: Text(
                '$totalScore XP',
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Score',
              style: TextStyle(
                  color: Colors.grey[300], fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 133, 130, 130),
      appBar: AppBar(
        title:
            Text('Progress Screen', style: TextStyle(color: Colors.grey[500])),
        iconTheme: IconThemeData(color: Colors.grey[500]),
        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      ),
      body: Container(
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
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          color: Colors.white,
                          height: 500,
                          child: const BMIDataChart(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Navigate to the first screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WeightProgressScreen()),
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 270,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                child: _buildWeightProgressIndicator(
                                    latestWeight, desiredWeight),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    height: 130,
                                    width: 110,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                    child: _buildAvgFormCorrectnessIndicator()),
                                const SizedBox(height: 10),
                                Container(
                                    height: 130,
                                    width: 110,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                    child: _buildTotalScoreIndicator()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    height: 540,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : exerciseData.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No exercises found.',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 197, 17, 17)),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 15, 8, 0),
                                      child: Text(
                                        'WORKOUTS COMPLETED',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: exerciseData.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              ExerciseCard(
                                                  exerciseData:
                                                      exerciseData[index]),
                                              const SizedBox(
                                                  height:
                                                      0), // Add extra space below each card
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                    ),
                    
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final Map<String, dynamic> exerciseData;

  const ExerciseCard({required this.exerciseData});

  @override
  Widget build(BuildContext context) {
    final List<String> targetedMuscles =
        List<String>.from(exerciseData['targeted_muscles'] ?? []);
    final int durationInMin = exerciseData['duration'];
    final int setCount = exerciseData['set_count'];
    final int repCount = exerciseData['rep_count'];
    final DateTime startTime =
        (exerciseData['start_time'] as Timestamp).toDate();
    final String formattedDate =
        '${startTime.day}-${startTime.month}-${startTime.year}';

    return Column(children: [
      Card(
        color: Colors.black.withOpacity(0.4),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                exerciseData['exercise_name'] ?? 'Exercise Name',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.grey[300]),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const Icon(Icons.access_time), // Clock icon
                  // const SizedBox(width: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                  ),
                ],
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: targetedMuscles
                          .map((muscle) => Text(
                                muscle,
                                style: TextStyle(color: Colors.grey[500]),
                              ))
                          .toList(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Sets: $setCount',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        Text(
                          'Reps: $repCount',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${((exerciseData['average_form_correctness'] ?? 0) * 100.0).toStringAsFixed(2)} %",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.grey[300]),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.grey[300],
                        ), // Clock icon
                        const SizedBox(width: 4),
                        Text(
                          '$durationInMin min',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[300]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${exerciseData['score']} XP",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.grey[300]),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
