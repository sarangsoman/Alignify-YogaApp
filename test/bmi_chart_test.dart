// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:alignify/screens/bmi/bmi_chart.dart';
// import 'package:fl_chart/fl_chart.dart';

// void main() {
//   testWidgets('Test BMI Chart Widgets', (WidgetTester tester) async {
//     // Hardcoded data for testing
//     final dataPoints = [
//       DataPoint(DateTime(2022, 4, 25), 22.5),
//       DataPoint(DateTime(2022, 4, 26), 23.0),
//       DataPoint(DateTime(2022, 4, 27), 23.2),
//       DataPoint(DateTime(2022, 4, 28), 22.8),
//       DataPoint(DateTime(2022, 4, 29), 23.5),
//     ];

//     // Build our widget and trigger a frame.
//     await tester.pumpWidget(
//       MaterialApp(
//         home: BMIDataChart(
//           dataPoints: dataPoints,
//         ),
//       ),
//     );
//     // Ensure that the title text is rendered
//   expect(find.text('BMI Chart'), findsOneWidget);
//   // Ensure that the LineChart widget is rendered
//   expect(find.byType(LineChart), findsOneWidget);
//   });
// }
