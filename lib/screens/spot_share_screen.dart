// screens/spot_share_screen.dart (수정본)
import 'package:flutter/material.dart';

class SpotShareScreen extends StatelessWidget {
  const SpotShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Scaffold 없이 Container만 리턴하거나, Scaffold를 쓰되 BottomBar는 없음
    return Scaffold(
      body: Stack(
        children: [

          // 하단 파란색 배경
          Positioned(
            left: 0,
            top: screenHeight * 0.35,
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.65,
              decoration: const BoxDecoration(color: Color(0xFF2567E8)),
            ),
          ),

        
          // 위치 공유 중지 버튼 
          Positioned(
            left: 0,
            bottom: 20, // MainScreen의 BottomBar 높이를 고려하지 않아도 됨 (Scaffold body 안이므로)
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('위치 공유가 중지되었습니다.')),
                  );
                },
                child: const Text('위치 공유 중지', style: TextStyle(color: Color(0xFF2567E8), fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}