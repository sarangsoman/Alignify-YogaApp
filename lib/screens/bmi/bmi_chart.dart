import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BMIDataChart extends StatefulWidget {
  const BMIDataChart({Key? key}) : super(key: key);

  @override
  _BMIDataChartState createState() => _BMIDataChartState();
}

class _BMIDataChartState extends State<BMIDataChart> {
  late List<DataPoint<DateTime>> dataPoints;
  int? previousDay;
  int selectedDays = 10;

  @override
  void initState() {
    super.initState();
    dataPoints = [];
    _fetchBMIData();
  }

  Future<void> _fetchBMIData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final now = DateTime.now();
      final weekAgo = now.subtract(Duration(days: selectedDays)); // 7 days ago

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('bmiData')
          .where('timestamp', isGreaterThanOrEqualTo: weekAgo)
          .orderBy('timestamp', descending: true)
          .get();

      final Map<DateTime, double> latestBMIs = {};

      querySnapshot.docs.forEach((doc) {
        final bmi = doc['bmi'] as double;
        final timestamp = (doc['timestamp'] as Timestamp).toDate();
        final date = DateTime(timestamp.year, timestamp.month, timestamp.day);
        // Check if a BMI value for this date already exists
        if (latestBMIs.containsKey(date)) {
          // If a value exists, compare timestamps and update if the new one is more recent
          if (timestamp.isAfter(doc['timestamp'].toDate())) {
            latestBMIs[date] = bmi;
          }
        } else {
          latestBMIs[date] = bmi;
        }
      });

      // print('Available Days:');
      // latestBMIs.keys.forEach((date) {
      //   print('${date.day}');
      // });

      // print('BMI Data:');
      // latestBMIs.forEach((date, bmi) {
      //   print('$date: $bmi');
      // });

      final List<DataPoint<DateTime>> newDataPoints =
          latestBMIs.entries.map((entry) {
        return DataPoint(entry.key, entry.value);
      }).toList();

      newDataPoints.sort((a, b) => a.x.compareTo(b.x));

      setState(() {
        dataPoints = newDataPoints;
      });
    } catch (e) {
      print('Error fetching BMI data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Min X: ${dataPoints.isNotEmpty ? dataPoints.first.x : 'N/A'}');
    print('Max X: ${dataPoints.isNotEmpty ? dataPoints.last.x : 'N/A'}');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            const Text('BMI Chart', style: TextStyle(color: Color(0xFF40D876))),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
        actions: [
          DropdownButton<int>(
            value: selectedDays,
            onChanged: (value) {
              setState(() {
                selectedDays = value!;
                _fetchBMIData(); // Refetch data when the selection changes
              });
            },
            items: const [
              DropdownMenuItem<int>(
                value: 7,
                child: Text('7 Days'),
              ),
              DropdownMenuItem<int>(
                value: 10,
                child: Text('10 Days'),
              ),
              DropdownMenuItem<int>(
                value: 20,
                child: Text('20 Days'),
              ),
              DropdownMenuItem<int>(
                value: 30,
                child: Text('30 Days'),
              ),
            ],
            style: const TextStyle(
                color: Colors.white), // Change text color to white
            dropdownColor: Colors.grey[800],
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: LineChart(
            LineChartData(
              minX: dataPoints.isNotEmpty
                  ? dataPoints.first.x.millisecondsSinceEpoch.toDouble()
                  : 0,
              maxX: dataPoints.isNotEmpty
                  ? dataPoints.last.x.millisecondsSinceEpoch.toDouble() +
                      86400000.0
                  : 1,
              minY: dataPoints.isNotEmpty ? _calculateMinBMI() - 1.0 : 0,
              maxY: dataPoints.isNotEmpty ? _calculateMaxBMI() + 1.0 : 1,
              titlesData: FlTitlesData(
                bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 20,
                  getTextStyles: (_, __) => const TextStyle(
                    color: Color(0xff68737d),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  margin: 10,
                  getTitles: (value) {
                    // Extracting the day component from the timestamp
                    final date =
                        DateTime.fromMillisecondsSinceEpoch(value.toInt());

                    // Check if the current day is different from the previously displayed day
                    // If so, return the day as the title, otherwise return an empty string
                    if (previousDay != date.day) {
                      previousDay = date.day;
                      return '${date.day}';
                    } else {
                      return '';
                    }
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 20,
                  getTextStyles: (_, __) => const TextStyle(
                    color: Color(0xff67727d),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  getTitles: (value) {
                    return value.toStringAsFixed(0);
                  },
                ),
              ),
              axisTitleData: FlAxisTitleData(
                leftTitle: AxisTitle(
                  showTitle: true,
                  titleText: 'BMI',
                  margin: 2,
                  textStyle: const TextStyle(
                    color: Color(0xff67727d),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                bottomTitle: AxisTitle(
                  showTitle: true,
                  titleText: 'Day',
                  margin: 2,
                  textStyle: const TextStyle(
                    color: Color(0xff68737d),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border.symmetric(
                  horizontal: BorderSide(
                      color: Color(
                          0xff68737d)), // Set color to match x-axis text color
                  vertical: BorderSide(
                      color: Color(
                          0xff68737d)), // Set color to match y-axis text color
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: dataPoints.map((dataPoint) {
                    return FlSpot(dataPoint.x.millisecondsSinceEpoch.toDouble(),
                        dataPoint.y);
                  }).toList(),
                  isCurved: true,
                  colors: [Colors.blue],
                  barWidth: 2,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(show: false),
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _calculateMinBMI() {
    return dataPoints
        .map((e) => e.y)
        .reduce((value, element) => value < element ? value : element);
  }

  double _calculateMaxBMI() {
    return dataPoints
        .map((e) => e.y)
        .reduce((value, element) => value > element ? value : element);
  }
}

class DataPoint<T extends Comparable> {
  final T x;
  final double y;

  DataPoint(this.x, this.y);
}
