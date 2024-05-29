import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'IntroPage.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = '';
  String _email = '';
  int _age = 0;
  String _profilePhotoUrl = '';
  int _height = 0;
  int _weight = 0;
  int _totalWorkouts = 0;
  num _timeSpent = 0;
  num _totalScore = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchLatestBMI();
    _fetchExerciseData();
  }

  Future<void> _fetchUserData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      setState(() {
        _name = snapshot.get('name');
        _email = snapshot.get('email');
        _age = snapshot.get('age');
        _profilePhotoUrl = snapshot.get('profile_photo_url');
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> _fetchLatestBMI() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('bmiData')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var latestDocument = snapshot.docs.first;
        setState(() {
          _height = latestDocument.get('height').toInt();
          _weight = latestDocument.get('weight');
        });
      }
    } catch (error) {
      print('Error fetching height and weight data: $error');
    }
  }

  Future<void> _fetchExerciseData() async {
    try {
      final stream = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('exerciseData')
          .snapshots();

      await for (var querySnapshot in stream) {
        int totalWorkouts = 0;
        num timeSpent = 0;
        num totalScore = 0;

        for (var doc in querySnapshot.docs) {
          if (doc.exists && doc.data().containsKey('score')) {
            totalWorkouts++;
            timeSpent += (doc['duration'] ?? 0).toInt();
            totalScore += (doc['score'] ?? 0).toInt();
          }
        }

        setState(() {
          _totalWorkouts = totalWorkouts;
          _timeSpent = timeSpent;
          _totalScore = totalScore;
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update({'total_score': _totalScore});
      }
    } catch (error) {
      print("Error fetching exercise data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 48, 48, 48),
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.grey[500])),
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        iconTheme: IconThemeData(color: Colors.grey[500]),
        actions: [
          IconButton(
            onPressed: () {
              // Add your action here
            },
            icon: Icon(Icons.edit, color: Colors.grey[500]),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 48, 48, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 150,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/profile_background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: _profilePhotoUrl.isNotEmpty
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(_profilePhotoUrl),
                        )
                      : const CircularProgressIndicator(), // Or any loading indicator
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _email,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
              ),
              // const SizedBox(height: 16),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   child: Text(
              //     'Bio: $_bio',
              //     style: const TextStyle(
              //       fontSize: 16,
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoContainer('Age: $_age'),
                    const SizedBox(width: 10),
                    _buildInfoContainer('Height: $_height'),
                    const SizedBox(width: 10),
                    _buildInfoContainer('Weight: $_weight'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Levels',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Level',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            '${(_totalScore ~/ 100) + 1}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: (_totalScore - ((_totalScore ~/ 100)) * 100) /
                            (100),
                        backgroundColor: Colors.grey[600],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF68B984)),
                        minHeight: 20,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            '$_totalScore/${((_totalScore ~/ 100) + 1) * 100} XP',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${((_totalScore ~/ 100) + 1) * 100 - _totalScore} XP to level up',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Activity',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Exercises Completed',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            '$_totalWorkouts',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Time Spent',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            '$_timeSpent mins',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Score',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            '$_totalScore XP',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!mounted) return;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return IntroPage();
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ElevatedButton(
                  onPressed: () {
                    //Settings
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: ElevatedButton(
                  onPressed: () {
                    //Settings
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "About",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  /*
  Widget _buildSportProgress(String sport, String distance, int percentage) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(
          sport.substring(0, 2),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      title: Text(sport),
      subtitle: Text(distance),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            Expanded(
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            const SizedBox(width: 8),
            Text('$percentage%'),
          ],
        ),
      ),
    );
  }*/
}

Widget _buildInfoContainer(String label) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ),
    ),
  );
}
