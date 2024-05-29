import 'package:flutter/material.dart';
import 'exercises.dart';

class ExerciseRecommenderPage extends StatefulWidget {
  @override
  _ExerciseRecommenderPageState createState() =>
      _ExerciseRecommenderPageState();
}

class _ExerciseRecommenderPageState extends State<ExerciseRecommenderPage> {
  String _selectedExerciseCategory = "Strength Training";
  List<String> _selectedMuscles = [];

  // Function to recommend top three exercises
  List<String> recommendTopThreeExercises(
      String category, List<String> targetMuscles) {
    // Filter exercises based on category
    List<Map<String, dynamic>> filteredExercises = exercises
        .where((exercise) => exercise['category'] == category)
        .toList();

    // Initialize variables to track recommended exercises
    List<String> recommendedExercises = [];
    Map<String, int> exerciseScores = {};

    // Loop through filtered exercises
    for (var exercise in filteredExercises) {
      // Calculate score for each exercise based on matching muscles
      int score = 0;
      List<String> exerciseMuscles = List<String>.from(exercise['muscles']);
      for (var muscle in targetMuscles) {
        if (exerciseMuscles.contains(muscle)) {
          score++;
        }
      }

      // Update exercise scores
      exerciseScores[exercise['name']] = score;
    }

    // Sort exercises by score in descending order
    List<String> sortedExercises = exerciseScores.keys.toList()
      ..sort((a, b) => exerciseScores[b]!.compareTo(exerciseScores[a]!));

    // Recommend top three exercises
    for (int i = 0; i < sortedExercises.length && i < 3; i++) {
      recommendedExercises.add(sortedExercises[i]);
    }

    // Return recommended exercises
    return recommendedExercises;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(219, 26, 25, 25),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text("GET WORKOUT RECOMMENDATION",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              const Text(
                "Select Category:",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              DropdownButton<String>(
                value: _selectedExerciseCategory,
                onChanged: (newValue) {
                  setState(() {
                    _selectedExerciseCategory = newValue!;
                  });
                },
                items: <String>["Strength Training", "Yoga"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                style: const TextStyle(
                    color: Color(0xFF68B984),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      15.0), // Creates a uniform circular radius
                  // Add a background color for better visualization
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      top: 10,
                      right: 90,
                      child: Text(
                        "Select Target Muscles:",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Positioned(
                      top: 327.0,
                      right: 81.0,
                      child: Image.asset(
                        "assets/images/shadow.png", // Replace with your image asset path
                        width: 200.0,
                        height: 200.0,
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        "assets/images/man_fitness_exercise_recommender.png", // Replace with your image asset path
                        width: 300.0,
                        height: 500.0,
                      ),
                    ),
                    Positioned(
                      bottom: 170.0,
                      right: 255.0,
                      child: buildMuscleChip("Quadriceps"),
                    ),
                    Positioned(
                      top: 240.0,
                      left: 255.0,
                      child: buildMuscleChip("Glutes"),
                    ),
                    Positioned(
                      top: 285.0,
                      left: 255.0,
                      child: buildMuscleChip("Hamstring"),
                    ),
                    Positioned(
                      top: 190.0,
                      right: 255.0,
                      child: buildMuscleChip("Lower Back"),
                    ),
                    Positioned(
                      top: 100.0,
                      left: 255.0,
                      child: buildMuscleChip("Chest"),
                    ),
                    Positioned(
                      top: 150.0,
                      left: 255.0,
                      child: buildMuscleChip("Triceps"),
                    ),
                    Positioned(
                      top: 50.0,
                      left: 255.0,
                      child: buildMuscleChip("Shoulders"),
                    ),
                    Positioned(
                      top: 60.0,
                      right: 255.0,
                      child: buildMuscleChip("Upper Back"),
                    ),
                    Positioned(
                      top: 110.0,
                      right: 255.0,
                      child: buildMuscleChip("Biceps"),
                    ),
                    Positioned(
                      top: 195.0,
                      left: 255.0,
                      child: buildMuscleChip("Forearms"),
                    ),
                    Positioned(
                      bottom: 120.0,
                      right: 255.0,
                      child: buildMuscleChip("Calves"),
                    ),
                    Positioned(
                      top: 150.0,
                      right: 255.0,
                      child: buildMuscleChip("Core"),
                    ),
                    Positioned(
                      top: 230.0,
                      right: 255.0,
                      child: buildMuscleChip("Hips"),
                    ),
                    Positioned(
                      bottom: 90.0,
                      left: 255.0,
                      child: buildMuscleChip("Ankles"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF68B984)),
                onPressed: () {
                  List<String> recommendedExercises =
                      recommendTopThreeExercises(
                          _selectedExerciseCategory, _selectedMuscles);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Recommended Exercise"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: recommendedExercises
                              .map((exercise) => Text(exercise))
                              .toList(),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  "Recommend Exercise",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMuscleChip(String muscle) {
    return ChoiceChip(
      label: Text(
        muscle,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
      selectedColor: const Color(0xFF68B984),
      selected: _selectedMuscles.contains(muscle),
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedMuscles.add(muscle);
          } else {
            _selectedMuscles.remove(muscle);
          }
        });
      },
    );
  }
}
