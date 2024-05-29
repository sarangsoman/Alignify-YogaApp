import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardPage extends StatefulWidget {
  final String userId;
  const LeaderboardPage({Key? key, required this.userId}) : super(key: key);

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late Stream<List<Map<String, dynamic>>> _leaderboardStream;
  num _totalScore = 0;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
    _fetchExerciseData();
  }

  Future<void> _fetchExerciseData() async {
    try {
      final stream = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('exerciseData')
          .snapshots();

      await for (var querySnapshot in stream) {
        num totalScore = 0;

        for (var doc in querySnapshot.docs) {
          if (doc.exists && doc.data().containsKey('score')) {
            totalScore += (doc['score'] ?? 0).toInt();
          }
        }

        setState(() {
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

  Future<List<Map<String, dynamic>>> _getLeaderboardData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<Map<String, dynamic>> leaderboardData = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> userDoc in snapshot.docs) {
      final userData = {
        'name': userDoc['name'],
        'totalScore': userDoc['total_score'],
        'profilePhotoUrl': userDoc['profile_photo_url'],
      };
      leaderboardData.add(userData);
    }

    leaderboardData.sort((a, b) => b['totalScore'].compareTo(a['totalScore']));

    return leaderboardData;
  }

  void _fetchLeaderboard() {
    _leaderboardStream =
        Stream.periodic(const Duration(seconds: 10)).asyncMap((_) async {
      return await _getLeaderboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(66, 127, 0, 246),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF191720), // Brand color
        title: Text('Leaderboard', style: TextStyle(color: Colors.grey[100])),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _leaderboardStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final leaderboardData = snapshot.data!;
          if (leaderboardData.isEmpty) {
            return const Center(
              child: Text('No leaderboard data available.'),
            );
          }

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 10, 20, 39),
                  Color.fromARGB(66, 64, 0, 124),
                  Color.fromARGB(255, 10, 20, 39),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
              child: ListView.builder(
                itemCount: leaderboardData.length,
                itemBuilder: (context, index) {
                  final userData = leaderboardData[index];
                  final userName = userData['name'];
                  final totalScore = userData['totalScore'];
                  final profilePhotoUrl = userData['profilePhotoUrl'];
                  final position = index + 1;
            
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: ListTile(
                      tileColor: index % 2 == 0
                          ? Color.fromARGB(60, 165, 230, 188)
                          : Color.fromARGB(60, 213, 191, 245),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF68B984), // Brand color
                        // child: Text(position.toString()),
                        backgroundImage: NetworkImage(profilePhotoUrl),
                      ),
                      title: Row(
                        children: [
                          Text(
                            '$position. $userName',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            '$totalScore XP',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
