import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart'; // 추가

class SafeSpotScreen extends StatefulWidget {
  const SafeSpotScreen({Key? key}) : super(key: key);

  @override
  State<SafeSpotScreen> createState() => _SafeSpotScreenState();
}

class _SafeSpotScreenState extends State<SafeSpotScreen> {
  // 기존 변수 및 로직은 동일, 하단 바 관련 변수만 삭제
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  bool _isSearching = false;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.5665, 126.9780),
    zoom: 15.0,
  );

  LatLng? _currentPosition;
  bool _isLocationLoading = true;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  

  Future<void> _requestLocationPermission() async {
  
    _determinePosition();
  }
  Future<void> _determinePosition() async {
    
  }
  void _addCurrentMarker() {
    
  }
  Future<void> _searchNearbyFacility(String facilityType) async {
    // (기존 코드 유지 - dotenv 키 사용 부분 포함)
  }
  double _getMarkerColor(String facilityType) {
    
    return BitmapDescriptor.hueRed; // 예시
  }
  String _getApiKey() {
    
    return dotenv.env['GOOGLE_MAPS_API_KEY'] ?? "";
  }
  void _showEmergencyOptions() {
    
  }
  void _copyToClipboard(String text) {
    
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    
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
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _initialCameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    if (!_controller.isCompleted) {
                      _controller.complete(controller);
                    }
                    _mapController = controller;
                  },
                  markers: _markers,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                  padding: const EdgeInsets.only(bottom: 80), // 버튼 가리지 않게 패딩
                ),
                if (_isLocationLoading || _isSearching)
                  const Center(child: CircularProgressIndicator()),

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
                        _buildLargeFacilityButton('파출소', () => _searchNearbyFacility('파출소')),
                        _buildLargeFacilityButton('경찰서', () => _searchNearbyFacility('경찰서')),
                        _buildLargeFacilityButton('해바라기', () => _searchNearbyFacility('해바라기센터')),
                        _buildLargeFacilityButton('비상벨', _showEmergencyOptions),
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
              BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6, offset: const Offset(0, 2)),
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