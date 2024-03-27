import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:twitter_clone/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("log in, check for tweet, logout",
      (widgetTester) async {
    app.main();
    await widgetTester.pumpAndSettle();
    Finder loginText = find.text("Log in to Twitter");
    expect(loginText, findsOneWidget);

    Finder loginEmail =
        find.byKey(const ValueKey("loginEmail"));
    Finder loginPassword =
        find.byKey(const ValueKey("loginPassword"));
    Finder loginButton =
        find.byKey(const ValueKey("loginButton"));
    Finder profilePic =
        find.byKey(const ValueKey("profilePic"));
    Finder signOut = find.byKey(const ValueKey("signOut"));

    await widgetTester.enterText(
        loginEmail, "test1@gmail.com");
    await widgetTester.enterText(loginPassword, "123456!");
    await widgetTester.tap(loginButton);
    await widgetTester.pumpAndSettle();

    Finder tweetName = find.text("Isaac To");
    expect(tweetName, findsAny);

    await widgetTester.tap(profilePic);
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(signOut);
    await widgetTester.pumpAndSettle();

    expect(loginText, findsOneWidget);
  });
}
