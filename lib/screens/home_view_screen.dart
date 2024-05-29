import 'package:alignify/screens/exercise_selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'profile_screen.dart';
import 'progress_screen.dart';
import 'leaderboard.dart';
import 'bmi/calculate_bmi.dart';
import 'exercises.dart';
import '../utils/exercise.dart';

enum ExerciseCategory {
  All,
  Yoga,
  StrengthTraining,
}

class HomeViewScreen extends StatefulWidget {
  const HomeViewScreen({super.key});

  @override
  State<HomeViewScreen> createState() => _HomeViewScreenState();
}

class _HomeViewScreenState extends State<HomeViewScreen> {
  int _currentIndex = 0;
  late PageController _pageController;
  late List<Widget> _screens;
  late String _userId = '';

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    _fetchUserId();
    _screens = [
      HomeViewBody(userId: _userId),
      const BMI(),
      const ProgressScreen(),
      LeaderboardPage(userId: _userId),
      //ExerciseRecommenderPage(),
      //const WeightProgressScreen(),
    ];
    _pageController = PageController(initialPage: _currentIndex);
    super.initState();
  }

  void _fetchUserId() {
    User? user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      setState(() {
        _userId = user.uid; // Store the userID
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: const Color(0xFF68B984),
          buttonBackgroundColor: const Color(0xFF68B984),
          color: const Color(0xFF212121),
          onTap: _onItemTapped,
          items: const [
            Icon(
              Icons.home,
              color: Color(0xFFFAFAFA),
            ),
            Icon(
              Icons.calculate,
              color: Color(0xFFFAFAFA),
            ),
            Icon(
              Icons.show_chart_rounded,
              color: Color(0xFFFAFAFA),
            ),
            Icon(
              Icons.leaderboard,
              color: Color(0xFFFAFAFA),
            ),
          ]),
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _screens,
      ),
    );
  }
}

class HomeViewBody extends StatefulWidget {
  final String userId;

  const HomeViewBody({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _HomeViewBodyState createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
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

  ExerciseCategory _selectedCategory = ExerciseCategory.All;

  @override
  void initState() {
    // You can access userId using widget.userId
    super.initState();
  }

  List<Exercise> _getFilteredExercises() {
    if (_selectedCategory == ExerciseCategory.Yoga) {
      return availableExercises
          .where((exercise) => exercise.name.toLowerCase().contains('asana'))
          .toList();
    } else if (_selectedCategory == ExerciseCategory.StrengthTraining) {
      return availableExercises
          .where((exercise) => !exercise.name.toLowerCase().contains('asana'))
          .toList();
    } else {
      return availableExercises;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Exercise> filteredExercises = _getFilteredExercises();

    return Container(
      width: double.infinity,
      height: double.infinity,
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
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Welcome to ",
                          style: GoogleFonts.bebasNeue(
                            fontSize: 22,
                            color: Colors.white,
                            letterSpacing: 1.8,
                          ),
                        ),
                        Text(
                          "Alignify",
                          style: GoogleFonts.bebasNeue(
                            fontSize: 22,
                            color: const Color(0xFF68B984),
                            letterSpacing: 1.8,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(userId: widget.userId)),
                        );
                      },
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          border: Border.all(
                            width: 3,
                            color: const Color(0xFF40D876),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.account_circle,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(height: 10),
              ),
              const Text("SELECT YOUR WORKOUT",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Category Selector
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCategoryButton(ExerciseCategory.All, "All"),
                    const SizedBox(width: 20),
                    _buildCategoryButton(ExerciseCategory.Yoga, "Yoga"),
                    const SizedBox(width: 20),
                    _buildCategoryButton(
                        ExerciseCategory.StrengthTraining, "Strength Training"),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 460,
                      width: double.infinity,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredExercises.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, index) {
                          return InkWell(
                            onTap: () {},
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ExerciseSelectionScreen(
                                      exercise: filteredExercises[index],
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: const Color.fromARGB(115, 124, 124, 124),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 8, top: 8, bottom: 8),
                                  child: CustomListTile(
                                    exercise: filteredExercises[index],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text("GET WORKOUT RECOMMENDATION",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    const Text(
                      "Select Category:",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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
                        color: const Color.fromARGB(115, 124, 124,
                            124), // Add a background color for better visualization
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
                                  color: Colors.white),
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
                          CustomPaint(
                            painter: MuscleLinesPainter(_selectedMuscles),
                            child:
                                Container(), // Use an empty container as child
                          ),
                          Positioned(
                            bottom: 170.0,
                            right: 265.0,
                            child: buildMuscleChip("Quadriceps"),
                          ),
                          Positioned(
                            top: 240.0,
                            left: 265.0,
                            child: buildMuscleChip("Glutes"),
                          ),
                          Positioned(
                            top: 285.0,
                            left: 265.0,
                            child: buildMuscleChip("Hamstring"),
                          ),
                          Positioned(
                            top: 190.0,
                            right: 265.0,
                            child: buildMuscleChip("Lower Back"),
                          ),
                          Positioned(
                            top: 100.0,
                            left: 265.0,
                            child: buildMuscleChip("Chest"),
                          ),
                          Positioned(
                            top: 150.0,
                            left: 265.0,
                            child: buildMuscleChip("Triceps"),
                          ),
                          Positioned(
                            top: 50.0,
                            left: 265.0,
                            child: buildMuscleChip("Shoulders"),
                          ),
                          Positioned(
                            top: 60.0,
                            right: 265.0,
                            child: buildMuscleChip("Upper Back"),
                          ),
                          Positioned(
                            top: 110.0,
                            right: 265.0,
                            child: buildMuscleChip("Biceps"),
                          ),
                          Positioned(
                            top: 195.0,
                            left: 265.0,
                            child: buildMuscleChip("Forearms"),
                          ),
                          Positioned(
                            bottom: 120.0,
                            right: 265.0,
                            child: buildMuscleChip("Calves"),
                          ),
                          Positioned(
                            top: 150.0,
                            right: 265.0,
                            child: buildMuscleChip("Core"),
                          ),
                          Positioned(
                            top: 230.0,
                            right: 265.0,
                            child: buildMuscleChip("Hips"),
                          ),
                          Positioned(
                            bottom: 90.0,
                            left: 265.0,
                            child: buildMuscleChip("Ankles"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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

  Widget _buildCategoryButton(ExerciseCategory category, String label) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedCategory == category
            ? const Color(0xFF68B984)
            : Colors.grey,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class MuscleLinesPainter extends CustomPainter {
  final List<String> targetMuscles;

  MuscleLinesPainter(this.targetMuscles);

  @override
  void paint(Canvas canvas, Size size) {
    // Define the coordinates for the different body parts
    Map<String, Offset> bodyParts = {
      "Quadriceps": const Offset(150, 290),
      "Glutes": const Offset(220, 260),
      "Hamstring": const Offset(222, 289),
      "Lower Back": const Offset(150, 200),
      "Chest": const Offset(180, 160),
      "Triceps": const Offset(235, 170),
      "Shoulders": const Offset(220, 140),
      "Upper Back": const Offset(155, 130),
      "Biceps": const Offset(90, 130),
      "Forearms": const Offset(240, 220),
      "Calves": const Offset(140, 360),
      "Core": const Offset(180, 200),
      "Hips": const Offset(145, 245),
      "Ankles": const Offset(228, 405),
    };

    // Define the coordinates for the target muscles
    Map<String, Offset> musclesCoordinates = {
      "Quadriceps": const Offset(85, 300),
      "Glutes": const Offset(270, 260),
      "Hamstring": const Offset(265, 310),
      "Lower Back": const Offset(90, 210),
      "Chest": const Offset(275, 125),
      "Triceps": const Offset(265, 175),
      "Shoulders": const Offset(265, 70),
      "Upper Back": const Offset(90, 90),
      "Biceps": const Offset(140, 170),
      "Forearms": const Offset(265, 220),
      "Calves": const Offset(80, 370),
      "Core": const Offset(80, 170),
      "Hips": const Offset(80, 260),
      "Ankles": const Offset(285, 390),
      // Add more muscles and their coordinates as needed
    };

    // Draw lines from muscles to body parts
    targetMuscles.forEach((muscle) {
      if (bodyParts.containsKey(muscle)) {
        canvas.drawLine(
          musclesCoordinates[muscle]!,
          bodyParts[muscle]!,
          Paint()
            ..color = Colors.white
            ..strokeWidth = 2,
        );
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CustomListTile extends StatelessWidget {
  final Exercise exercise;

  const CustomListTile({
    required this.exercise,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      // padding: const EdgeInsets.all(4),
      child: Row(children: [
        Expanded(
          flex: 9,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(exercise.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                exercise.name,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: exercise.targetedMuscles.length,
                itemBuilder: (BuildContext context, int i) {
                  return Text(
                    "- ${exercise.targetedMuscles[i]}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
