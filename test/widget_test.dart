import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petverse/screens/splash_screen.dart';

void main() {
  testWidgets('Splash Screen UI Test', (WidgetTester tester) async {
    // Build SplashScreen inside MaterialApp
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

    // ✅ Check tagline text
    expect(find.text('Caring for your pet, smarter'), findsOneWidget);

    // ✅ Check images are present
    expect(find.byType(Image), findsNWidgets(2));

    // (Optional) check specifically for assets
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName.contains('app_symbol.png'),
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName.contains('app_logo.png'),
      ),
      findsOneWidget,
    );
  });
}
