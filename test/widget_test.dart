import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/providers/user_provider.dart';
import 'package:movie_app/main.dart';

void main() {
  testWidgets('App should build without crashing', (WidgetTester tester) async {
    final userProvider = UserProvider();
    await userProvider.initialize();

    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp(userProvider: userProvider));

    // Verify that the app builds successfully
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
