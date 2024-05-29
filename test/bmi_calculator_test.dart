// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:alignify/screens/bmi/calculate_bmi.dart';

// void main() {
//   testWidgets('BMI Widget Test', (WidgetTester tester) async {
//     await tester.pumpWidget(const MaterialApp(
//       home: BMI(),
//     ));

//     // Verify that the title is displayed
//     expect(find.text('BMI CALCULATOR'), findsOneWidget);

//     // Drag the height slider and verify the value change
//     await tester.drag(find.byType(Slider), const Offset(100.0, 0.0));
//     await tester.pump();


//     // Tap on the calculate button and verify navigation
//     await tester.tap(find.text('Calculate'), warnIfMissed: false);
//     await tester.pumpAndSettle();
    
//     // Add a debug print statement to check if the onPressed callback is triggered
//     print('Calculate Button pressed!');
//   });
// }
