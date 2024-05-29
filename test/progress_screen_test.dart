// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:alignify/screens/progress_screen.dart';

// void main() {
//   testWidgets('Test Progress Screen Widgets', (WidgetTester tester) async {
//     // Define hard-coded values for testing
//     const double latestWeight = 70.0;
//     const double desiredWeight = 65.0;
//     const double avgFormCorrectness = 0.85;
//     const int totalScore = 500;

//     // Build our widget and trigger a frame.
//     await tester.pumpWidget(
//       const MaterialApp(
//         home: ProgressScreen(),
//       ),
//     );
//     await tester.pumpWidget(
//       const MaterialApp(
//         home: ProgressScreen(
//           latestWeight: latestWeight,
//           desiredWeight: desiredWeight,
//           avgFormCorrectness: avgFormCorrectness,
//           totalScore: totalScore,
//         ),
//       ),
//     );

//     // Ensure that Weight Progress Indicator is rendered
//     expect(find.byKey(const ValueKey('weight_progress_indicator')), findsOneWidget);

//     // Ensure that Average Form Correctness Indicator is rendered
//     expect(find.byKey(const ValueKey('avg_form_correctness_indicator')), findsOneWidget);

//     // Ensure that Total Score Indicator is rendered
//     expect(find.byKey(const ValueKey('total_score_indicator')), findsOneWidget);
//   });
// }
