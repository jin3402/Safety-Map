import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

/// 흔한 휴대폰 화면 크기(393×852)로 맞춰요.
void usePhoneViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(393 * 3, 852 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}
