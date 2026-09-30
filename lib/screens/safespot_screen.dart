import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 안전시설 탭: 지도와 시설 종류 버튼.
///
/// 주변 시설 검색(파출소·경찰서·해바라기센터)과 비상벨은 아직 구현되지 않았어요.
/// 버튼을 누르면 설정 화면의 다른 미구현 메뉴처럼 "준비 중" 안내를 보여줘요.
class SafeSpotScreen extends StatelessWidget {
  const SafeSpotScreen({super.key});

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.5665, 126.9780),
    zoom: 15.0,
  );

  static const facilities = ['파출소', '경찰서', '해바라기', '비상벨'];

  void _showNotReady(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('준비 중인 기능입니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. 상단 타이틀
          Container(
            height: 60 + MediaQuery.of(context).padding.top, // 상단 패딩 고려
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 16, right: 16),
            color: const Color(0xFF2567E8),
            alignment: Alignment.centerLeft,
            child: const Text(
              '안전 시설',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),

          // 2. 지도와 버튼 영역 (Expanded로 나머지 공간 채움)
          Expanded(
            child: Stack(
              children: [
                const GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _initialCameraPosition,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                  padding: EdgeInsets.only(bottom: 80), // 버튼 가리지 않게 패딩
                ),

                // 버튼 영역
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20, // 하단에서 20만큼 띄움
                  height: 60,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (final label in facilities)
                          _buildLargeFacilityButton(label, () => _showNotReady(context)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeFacilityButton(String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF2567E8),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
