import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExerciseListView extends StatefulWidget {
  const ExerciseListView({Key? key}) : super(key: key);

  @override
  _ExerciseListViewState createState() => _ExerciseListViewState();
}

class _ExerciseListViewState extends State<ExerciseListView> {
  List<Map<String, dynamic>> exerciseData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExerciseData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Exercise List',
            style: TextStyle(color: Color(0xFF40D876))),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      ),
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: Container(
        height: 500,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : exerciseData.isEmpty
                ? const Center(
                    child: Text(
                      'No exercises found.',
                      style: TextStyle(color: Color.fromARGB(255, 197, 17, 17)),
                    ),
                  )
                : ListView.builder(
                    itemCount: exerciseData.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ExerciseCard(exerciseData: exerciseData[index]),
                          const SizedBox(height: 16), // Add extra space below each card
                        ],
                      );
                    },
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
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              formattedDate,
              style: const TextStyle(color: Colors.green),
            ),
          ],
        ),
      ),
      Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                exerciseData['exercise_name'] ?? 'Exercise Name',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time), // Clock icon
                  const SizedBox(width: 4),
                  Text(
                    '$durationInMin min',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: targetedMuscles
                      .map((muscle) => Text(
                            muscle,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 48, 50, 83)),
                          ))
                      .toList(),
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     const Icon(Icons.calendar_today),
                //     Text(formattedDate),
                //   ],
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Sets: $setCount'),
                    Text('Reps: $repCount'),
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
