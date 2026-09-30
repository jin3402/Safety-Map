import 'package:flutter/material.dart';

void _ignoreImageError(Object error, StackTrace? stackTrace) {
  // 자리표시 이미지를 못 받아도 빈칸으로 두고, 오류는 앱 전체로 전파하지 않아요.
}

/// 스플래시·로그인 화면의 로고 자리.
/// 아직 정식 로고가 없어 외부 자리표시(placeholder) 이미지를 네트워크로 불러와요.
class LogoPlaceholder extends StatelessWidget {
  const LogoPlaceholder({super.key, required this.size});

  final int size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.toDouble(),
      height: size.toDouble(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://via.placeholder.com/${size}x$size?text=Logo'),
          fit: BoxFit.fill,
          onError: _ignoreImageError,
        ),
      ),
    );
  }
}
