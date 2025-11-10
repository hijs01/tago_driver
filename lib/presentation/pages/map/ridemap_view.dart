import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tago_driver/data/services/geocoding_service.dart';
import 'package:tago_driver/data/services/directions_service.dart';

class RideMapView extends StatefulWidget {
  final String? fromAddress; // 출발지 주소
  final String? toAddress; // 목적지 주소
  final String? fromName; // 출발지 이름
  final String? toName; // 목적지 이름
  final bool useCurrentLocation; //

  const RideMapView({
    super.key,
    this.fromAddress,
    this.toAddress,
    this.fromName,
    this.toName,
    this.useCurrentLocation = false,
  });

  @override
  State<RideMapView> createState() => _RideMapViewState();
}

class _RideMapViewState extends State<RideMapView> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  bool _isLoadingRoute = false;
  bool _isMapReady = false; // ✅ API 키 설정 확인용

  LatLng? _originLatLng;
  LatLng? _destinationLatLng;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // ✅ iOS에서 API 키가 설정되었는지 확인하고 지도 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _waitForApiKeyAndInitialize();
    });
  }

  // ✅ API 키가 설정될 때까지 대기한 후 지도 초기화
  Future<void> _waitForApiKeyAndInitialize() async {
    // ✅ 최소 1초 대기 (main.dart에서 API 키 설정 완료 대기)
    await Future.delayed(const Duration(milliseconds: 1000));

    // ✅ iOS에서 GMSServices.provideAPIKey()가 완료될 시간을 확보
    // Google Maps SDK 초기화가 완료되도록 추가 시간 대기
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isMapReady = true;
      });
      _initializeMap();
    }
  }

  // ✅ 초기화를 별도 메서드로 분리하여 안전하게 처리
  Future<void> _initializeMap() async {
    try {
      // 현재 위치 가져오기 (실패해도 계속 진행)
      await _getCurrentLocation();

      // 경로 로드 (목적지가 있을 때만)
      if (widget.toAddress != null && mounted) {
        await _loadRoute();
      }
    } catch (e) {
      debugPrint('❌ 지도 초기화 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('지도를 불러오는 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 경로 로드 (수정)
  Future<void> _loadRoute() async {
    if (widget.toAddress == null || !mounted) return;

    setState(() {
      _isLoadingRoute = true;
    });

    try {
      LatLng origin;

      // ✅ useCurrentLocation이 true이고 현재 위치가 있으면 현재 위치 사용
      // 그렇지 않으면 fromAddress 사용
      if (widget.useCurrentLocation && _currentPosition != null) {
        origin = LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        debugPrint(
          '📍 출발지: 현재 위치 사용 (${origin.latitude}, ${origin.longitude})',
        );
      } else if (widget.fromAddress != null && widget.fromAddress!.isNotEmpty) {
        debugPrint('📍 출발지 주소 변환 중: ${widget.fromAddress}');
        final originCoords = await GeocodingService.geocodeAddress(
          widget.fromAddress!,
        );
        final originLat = originCoords['latitude'];
        final originLng = originCoords['longitude'];
        if (originLat == null || originLng == null) {
          throw StateError('출발지 주소를 좌표로 변환할 수 없습니다: ${widget.fromAddress}');
        }
        origin = LatLng(originLat, originLng);
      } else {
        throw StateError('출발지 정보가 없습니다. 위치 권한을 확인해주세요.');
      }

      // 목적지 좌표 변환
      debugPrint('📍 목적지 주소 변환 중: ${widget.toAddress}');
      final destCoords = await GeocodingService.geocodeAddress(
        widget.toAddress!,
      );
      final destLat = destCoords['latitude'];
      final destLng = destCoords['longitude'];
      if (destLat == null || destLng == null) {
        throw StateError('목적지 주소를 좌표로 변환할 수 없습니다: ${widget.toAddress}');
      }
      _destinationLatLng = LatLng(destLat, destLng);
      _originLatLng = origin;

      debugPrint('✅ 출발지: $_originLatLng, 목적지: $_destinationLatLng');

      // 경로 가져오기
      debugPrint('🛣️ 경로 가져오는 중...');
      final routePoints = await DirectionsService.getRoute(
        origin: _originLatLng!,
        destination: _destinationLatLng!,
      );

      debugPrint('✅ 경로 포인트 수: ${routePoints.length}');

      // ✅ mounted 체크 후 setState
      if (!mounted) return;

      // 마커 추가
      setState(() {
        _markers = {
          Marker(
            markerId: const MarkerId('origin'),
            position: _originLatLng!,
            infoWindow: InfoWindow(
              title:
                  widget.useCurrentLocation && _currentPosition != null
                      ? '현재 위치'
                      : (widget.fromName ?? '출발지'),
              snippet:
                  widget.useCurrentLocation && _currentPosition != null
                      ? '내 위치'
                      : widget.fromAddress,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
          Marker(
            markerId: const MarkerId('destination'),
            position: _destinationLatLng!,
            infoWindow: InfoWindow(
              title: widget.toName ?? '목적지',
              snippet: widget.toAddress,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        };

        // Polyline 추가
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            points: routePoints,
            color: Colors.blue,
            width: 5,
          ),
        };

        _isLoadingRoute = false;
      });

      // 지도 카메라를 경로 전체가 보이도록 조정
      if (mounted &&
          _mapController != null &&
          _originLatLng != null &&
          _destinationLatLng != null) {
        await _fitBounds();
      }
    } catch (e) {
      debugPrint('❌ 경로 로드 실패: $e');
      if (mounted) {
        setState(() {
          _isLoadingRoute = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('경로를 불러오는 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 경로 전체가 보이도록 카메라 조정
  Future<void> _fitBounds() async {
    if (_originLatLng == null ||
        _destinationLatLng == null ||
        _mapController == null ||
        !mounted) {
      return;
    }

    try {
      double minLat =
          _originLatLng!.latitude < _destinationLatLng!.latitude
              ? _originLatLng!.latitude
              : _destinationLatLng!.latitude;
      double maxLat =
          _originLatLng!.latitude > _destinationLatLng!.latitude
              ? _originLatLng!.latitude
              : _destinationLatLng!.latitude;
      double minLng =
          _originLatLng!.longitude < _destinationLatLng!.longitude
              ? _originLatLng!.longitude
              : _destinationLatLng!.longitude;
      double maxLng =
          _originLatLng!.longitude > _destinationLatLng!.longitude
              ? _originLatLng!.longitude
              : _destinationLatLng!.longitude;

      if (mounted && _mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(minLat - 0.01, minLng - 0.01),
              northeast: LatLng(maxLat + 0.01, maxLng + 0.01),
            ),
            100.0,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ 카메라 조정 실패: $e');
      // 에러가 발생해도 앱이 크래시되지 않도록 처리
    }
  }

  // 현재 위치 가져오기
  Future<void> _getCurrentLocation() async {
    if (!mounted) return;

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('❌ 위치 서비스가 비활성화되어 있습니다.');
        if (mounted) {
          setState(() {
            _isLoadingLocation = false;
          });
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('❌ 위치 권한이 거부되었습니다.');
          if (mounted) {
            setState(() {
              _isLoadingLocation = false;
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('❌ 위치 권한이 영구적으로 거부되었습니다.');
        if (mounted) {
          setState(() {
            _isLoadingLocation = false;
          });
        }
        return;
      }

      // ✅ iOS에서 안전하게 위치 가져오기
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10), // ✅ 타임아웃 설정
      );

      if (mounted) {
        setState(() {
          _currentPosition = position;
          _isLoadingLocation = false;
        });
        debugPrint('✅ 현재 위치: ${position.latitude}, ${position.longitude}');
      }
    } catch (e) {
      debugPrint('❌ 위치 가져오기 실패: $e');
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 초기 카메라 위치
    LatLng initialLocation =
        _originLatLng ??
        (_currentPosition != null
            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
            : const LatLng(40.7982, -77.8599));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.fromName != null && widget.toName != null
              ? '${widget.fromName} → ${widget.toName}'
              : '지도 테스트',
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          if (_isLoadingLocation || _isLoadingRoute)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: _getCurrentLocation,
              tooltip: '현재 위치 새로고침',
            ),
        ],
      ),
      body: Stack(
        children: [
          // ✅ API 키가 설정될 때까지 로딩 표시
          if (!_isMapReady)
            Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          else
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialLocation,
                zoom: 14.0,
              ),
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                debugPrint('✅ 지도 생성 완료');

                // 경로가 있으면 카메라 조정 (안전하게 처리)
                if (mounted && _originLatLng != null && _destinationLatLng != null) {
                  _fitBounds();
                }
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              mapType: MapType.normal,
            ),
          // 로딩 인디케이터
          if (_isLoadingRoute && _isMapReady)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
