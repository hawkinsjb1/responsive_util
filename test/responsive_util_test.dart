import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../example/lib/main.dart';
import 'package:responsive_util/corner_button.dart';

void main() {
  testWidgets('Label is visible and displays correct size', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TestApp()));
    await tester.pumpAndSettle();

    var deviceSize = find.byType(Scaffold).evaluate().first.size;
    var cornerButton =
        tester.getTopLeft(find.byType(CornerButton)).translate(-20, -20);

    await tester.longPressAt(cornerButton);

    await tester.timedDragFrom(
      cornerButton,
      const Offset(-150, -150),
      const Duration(seconds: 1),
    );

    expect(
      find.text(
          'H: ${(deviceSize!.height - 170).round()}    W: ${(deviceSize.width - 170).round()}'),
      findsOneWidget,
    );
  });
  testWidgets('Content is resized', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TestApp()));
    await tester.pumpAndSettle();

    var itemCount = find.byType(Text).evaluate().length;
    var cornerButton =
        tester.getTopLeft(find.byType(CornerButton)).translate(-20, -20);

    await tester.longPressAt(cornerButton);

    await tester.timedDragFrom(
      cornerButton,
      const Offset(-150, -150),
      const Duration(seconds: 1),
    );

    expect(
      find.byType(Text).evaluate().length == itemCount,
      false,
    );
  });
}
