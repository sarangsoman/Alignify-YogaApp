import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WeightProgressScreen extends StatefulWidget {
  const WeightProgressScreen({Key? key}) : super(key: key);

  @override
  _WeightProgressScreenState createState() => _WeightProgressScreenState();
}

class _WeightProgressScreenState extends State<WeightProgressScreen> {
  double latestWeight = 0.0; // Variable to store the latest weight
  double desiredWeight = 0.0;
  List<Card> bmiCards = [];

  @override
  void initState() {
    super.initState();
    _fetchDesiredWeight();
    _fetchAllWeights();
  }

  Future<void> _fetchAllWeights() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final weightSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('bmiData')
          .orderBy('timestamp', descending: true)
          .get();

      if (weightSnapshot.docs.isNotEmpty) {
        final latestWeightDoc = weightSnapshot.docs.first;
        final latestWeightValue =
            latestWeightDoc['weight'] as int; 
        print('latest Weight Retrieved: $latestWeightValue');
        setState(() {
          latestWeight = latestWeightValue.toDouble();
        });
        weightSnapshot.docs.forEach((doc) {
          final timestamp = doc['timestamp'] as Timestamp;
          final weightResult = (doc['weight'] as int).toStringAsFixed(2);
          final day =
              '${timestamp.toDate().day}-${timestamp.toDate().month}-${timestamp.toDate().year}';
          final time = '${timestamp.toDate().hour}:${timestamp.toDate().minute}'; // Extracting time
        
          bmiCards.add(
            Card(
              color: Colors.black.withOpacity(0.5),
              child: ListTile(
                title: Row(
                  mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Day: $day', style: const TextStyle(color: Colors.white70)),
                    Text('Time $time', style: const TextStyle(color: Colors.white70),),
                  ],
                ),
                subtitle: Column(
                  children: [
                    const SizedBox(height:20),
                    Text('Weight: $weightResult kg', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF68B984)),),
                    const SizedBox(height:20),
                  ],
                ),
              ),
            ),
          );
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
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer circle
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!),
              ),
            ),
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
                latestWeight.toString(),
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
              'Goal: $desiredWeight',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 20),
            Text(
              'Current: $latestWeight',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'BodyWeight Tracking',
          style: TextStyle(color: Color(0xFF40D876)),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 32, 32, 32),
          image: DecorationImage(
            opacity: 0.0,
            image: AssetImage(
              "assets/images/image4.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Display circular progress indicator
                    _buildWeightProgressIndicator(latestWeight, desiredWeight),
                    const SizedBox(height:20),
                    SizedBox(
                      height: 460,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8,20,8,8),
                          child: Column(
                            children: bmiCards,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
