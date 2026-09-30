import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sw_flutter/screens/login_screen.dart';
import 'package:sw_flutter/screens/signup_screen.dart';

import 'helpers/test_app.dart';

/// 지도·위치 플러그인이 필요한 실제 홈 화면 대신 표시만 하는 라우트를 써요.
Widget appWith(String initialRoute) {
  return MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, initialRoute),
                child: const Text('open'),
              ),
            ),
          ),
      '/login': (context) => const LoginScreen(),
      '/signup': (context) => const SignupScreen(),
      '/home': (context) => const Scaffold(body: Text('HOME')),
    },
  );
}

Future<void> open(WidgetTester tester, String route) async {
  usePhoneViewport(tester);
  await tester.pumpWidget(appWith(route));
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  group('로그인', () {
    testWidgets('빈 칸이면 안내 문구를 보여주고 이동하지 않는다', (tester) async {
      await open(tester, '/login');

      await tester.tap(find.widgetWithText(ElevatedButton, '로그인'));
      await tester.pump();

      expect(find.text('아이디를 입력해주세요'), findsOneWidget);
      expect(find.text('비밀번호를 입력해주세요'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('HOME'), findsNothing);
    });

    testWidgets('입력하면 1초 뒤 홈으로 이동한다', (tester) async {
      await open(tester, '/login');

      await tester.enterText(find.byType(TextFormField).at(0), 'user');
      await tester.enterText(find.byType(TextFormField).at(1), 'secret');
      await tester.tap(find.widgetWithText(ElevatedButton, '로그인'));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.text('HOME'), findsOneWidget);
    });

    testWidgets('이동을 기다리는 사이 뒤로 가도 예외가 나지 않는다', (tester) async {
      await open(tester, '/login');

      await tester.enterText(find.byType(TextFormField).at(0), 'user');
      await tester.enterText(find.byType(TextFormField).at(1), 'secret');
      await tester.tap(find.widgetWithText(ElevatedButton, '로그인'));
      await tester.pump();

      // 1초가 지나기 전에 로그인 화면을 닫아요.
      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      await tester.pump(const Duration(seconds: 2));

      expect(tester.takeException(), isNull);
      expect(find.text('HOME'), findsNothing);
    });
  });

  group('회원가입', () {
    testWidgets('이름 2자·아이디 4자·비밀번호 6자 미만이면 안내 문구를 보여준다', (tester) async {
      await open(tester, '/signup');

      await tester.enterText(find.byType(TextFormField).at(0), '김');
      await tester.enterText(find.byType(TextFormField).at(1), 'abc');
      await tester.enterText(find.byType(TextFormField).at(2), '12345');
      await tester.ensureVisible(find.text('가입하기'));
      await tester.tap(find.text('가입하기'));
      await tester.pump();

      expect(find.text('이름은 2글자 이상이어야 합니다'), findsOneWidget);
      expect(find.text('아이디는 4글자 이상이어야 합니다'), findsOneWidget);
      expect(find.text('비밀번호는 6글자 이상이어야 합니다'), findsOneWidget);
    });
  });
}
