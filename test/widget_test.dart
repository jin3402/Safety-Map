import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sw_flutter/main.dart';
import 'package:sw_flutter/screens/emergency_contact_screen.dart';
import 'package:sw_flutter/screens/favorites_screen.dart';
import 'package:sw_flutter/screens/settings_screen.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import 'helpers/test_app.dart';

class FakeUrlLauncher extends Fake
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  final launched = <String>[];

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launched.add(url);
    return true;
  }
}

/// 루트 화면에서 [screen]을 push해서, 화면 안의 뒤로 가기(pop)도 확인할 수 있게 해요.
Future<void> pumpPushed(WidgetTester tester, Widget screen) async {
  usePhoneViewport(tester);
  await tester.pumpWidget(
    MaterialApp(
      routes: {
        '/': (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => screen),
                ),
                child: const Text('open'),
              ),
            ),
        '/splash': (context) => const Scaffold(body: Text('SPLASH')),
      },
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('앱은 스플래시에서 시작하고, 로그인 버튼으로 로그인 화면에 간다', (tester) async {
    usePhoneViewport(tester);
    await tester.pumpWidget(const SafeWayApp());

    expect(find.text('SAFE'), findsOneWidget);
    expect(find.text('회원 가입'), findsOneWidget);

    await tester.tap(find.text('로그인'));
    await tester.pumpAndSettle();
    expect(find.text('아이디를 입력하세요'), findsOneWidget);
  });

  testWidgets('즐겨찾기: 저장된 주소를 불러오고, 고친 값을 저장한다', (tester) async {
    SharedPreferences.setMockInitialValues({'home_address': '서울 중구 세종대로 110'});
    await pumpPushed(tester, const FavoritesScreen());

    expect(find.text('서울 중구 세종대로 110'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(1), '서울 종로구 율곡로 99');
    await tester.tap(find.text('저장하기'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('home_address'), '서울 중구 세종대로 110');
    expect(prefs.getString('work_address'), '서울 종로구 율곡로 99');
    // 저장 후 이전 화면으로 돌아가요.
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets('긴급 연락처: 카드를 누르면 해당 번호로 전화 앱을 연다', (tester) async {
    final launcher = FakeUrlLauncher();
    UrlLauncherPlatform.instance = launcher;
    await pumpPushed(tester, const EmergencyContactScreen());

    for (final number in ['112', '1366', '119']) {
      expect(find.text(number), findsOneWidget);
    }

    await tester.tap(find.text('112'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('119'));
    await tester.pumpAndSettle();

    expect(launcher.launched, ['tel:112', 'tel:119']);
  });

  testWidgets('설정: 로그아웃을 확인하면 스플래시로 돌아간다', (tester) async {
    await pumpPushed(tester, const SettingsScreen());

    await tester.tap(find.text('로그아웃'));
    await tester.pumpAndSettle();
    expect(find.text('정말로 로그아웃하시겠습니까?'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, '로그아웃'));
    await tester.pumpAndSettle();
    expect(find.text('SPLASH'), findsOneWidget);
  });
}
