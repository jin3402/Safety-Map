import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.739, 127.081),
    zoom: 15.0,
  );

  LatLng? _currentPosition;
  bool _isLocationLoading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    final bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _setLoading(false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _setLoading(false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _setLoading(false);
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      // 마운트 되었는지 확인 후 setState 호출 (안전성 강화)
      if (!mounted) return;

      final current = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentPosition = current;
        _markers
          ..clear()
          ..add(_currentLocationMarker(current));
        _isLocationLoading = false;
      });
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(current, 15.0));
    } catch (e) {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (mounted) setState(() => _isLocationLoading = value);
  }

  Marker _currentLocationMarker(LatLng position) {
    return Marker(
      markerId: const MarkerId('blueDot'),
      position: position,
      infoWindow: const InfoWindow(title: '현재 위치'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 하단 바 코드 삭제됨. 오직 지도와 앱바만 표시
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2567E8),
        elevation: 0,
        title: const Text('SafeMap', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.pushReplacementNamed(context, '/splash'),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              // 지도가 늦게 뜨면 이미 구한 현재 위치로 바로 옮겨요.
              final current = _currentPosition;
              if (current != null) {
                controller.moveCamera(CameraUpdate.newLatLngZoom(current, 15.0));
              }
            },
            markers: _markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
          ),
          if (_isLocationLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}