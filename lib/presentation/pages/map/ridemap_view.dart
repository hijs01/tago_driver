import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tago_driver/data/services/geocoding_service.dart';
import 'package:tago_driver/data/services/directions_service.dart';
import 'package:tago_driver/l10n/app_localizations.dart';
import 'dart:async';

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
  bool _isMapReady = false;

  LatLng? _originLatLng;
  LatLng? _destinationLatLng;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  BitmapDescriptor? _originMarkerIcon;
  BitmapDescriptor? _destinationMarkerIcon;
  Timer? _routeUpdateTimer;

  // ✨ Glassmorphism 마커 생성
  Future<BitmapDescriptor> _createGlassMarkerIcon(
    Color color,
    IconData icon,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = 110.0; // 80.0 → 110.0 (더 크게)

    // 외부 글로우 효과
    final glowPaint =
        Paint()
          ..color = color.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(Offset(size / 2, size / 2), 30, glowPaint); // 22 → 30

    // Glassmorphism 배경
    final gradientPaint =
        Paint()
          ..shader = ui.Gradient.radial(Offset(size / 2, size / 2), 28, [
            // 20 → 28
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.1),
          ]);
    canvas.drawCircle(Offset(size / 2, size / 2), 28, gradientPaint); // 20 → 28

    // 테두리
    final borderPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5; // 2 → 2.5
    canvas.drawCircle(Offset(size / 2, size / 2), 28, borderPaint); // 20 → 28

    // 아이콘 그리기
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: 32, // 24 → 32
        fontFamily: icon.fontFamily,
        color: color,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size - textPainter.width) / 2, (size - textPainter.height) / 2),
    );

    // 하단 포인터
    final pointerPath = Path();
    pointerPath.moveTo(size / 2 - 8, size / 2 + 28); // 크기 조정
    pointerPath.lineTo(size / 2, size / 2 + 40); // 30 → 40
    pointerPath.lineTo(size / 2 + 8, size / 2 + 28);
    pointerPath.close();

    final pointerPaint =
        Paint()
          ..shader = ui.Gradient.linear(
            Offset(size / 2, size / 2 + 28),
            Offset(size / 2, size / 2 + 40),
            [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
          );
    canvas.drawPath(pointerPath, pointerPaint);
    canvas.drawPath(pointerPath, borderPaint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(
      size.toInt(),
      (size + 40).toInt(),
    ); // 30 → 40
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  // ✨ 세련된 다크 테마 지도 스타일
  static const String _mapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#212121"
        }
      ]
    },
    {
      "elementType": "labels.icon",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#212121"
        }
      ]
    },
    {
      "featureType": "administrative",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#757575"
        },
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "administrative.country",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#9e9e9e"
        }
      ]
    },
    {
      "featureType": "administrative.land_parcel",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "administrative.locality",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#bdbdbd"
        }
      ]
    },
    {
      "featureType": "poi",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#181818"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#616161"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#1b1b1b"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#2c2c2c"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.icon",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#8a8a8a"
        }
      ]
    },
    {
      "featureType": "road.arterial",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#373737"
        }
      ]
    },
    {
      "featureType": "road.arterial",
      "elementType": "labels",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#3c3c3c"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "road.highway.controlled_access",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#4e4e4e"
        }
      ]
    },
    {
      "featureType": "road.local",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "road.local",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#616161"
        }
      ]
    },
    {
      "featureType": "transit",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "transit",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#000000"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#3d3d3d"
        }
      ]
    }
  ]
  ''';

  @override
  void initState() {
    super.initState();
    _initializeCustomMarkers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _waitForApiKeyAndInitialize();
    });
  }

  // ✨ 커스텀 마커 아이콘 초기화
  Future<void> _initializeCustomMarkers() async {
    _originMarkerIcon = await _createGlassMarkerIcon(
      const Color(0xFF32CD32), // Green
      Icons.circle,
    );
    _destinationMarkerIcon = await _createGlassMarkerIcon(
      const Color(0xFFFF4444), // Red
      Icons.location_on,
    );
  }

  Future<void> _waitForApiKeyAndInitialize() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isMapReady = true;
      });
      _initializeMap();
    }
  }

  Future<void> _initializeMap() async {
    try {
      await _getCurrentLocation();

      if (widget.toAddress != null && mounted) {
        await _loadRoute(shouldFitBounds: true);

        _startRouteUpdateTimer(10);
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

  Future<void> _loadRoute({bool shouldFitBounds = false}) async {
    if (widget.toAddress == null || !mounted) return;

    setState(() {
      _isLoadingRoute = true;
    });

    try {
      LatLng origin;

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
        origin = LatLng(originCoords['latitude']!, originCoords['longitude']!);
      } else {
        throw StateError('출발지 정보가 없습니다. 위치 권한을 확인해주세요.');
      }

      debugPrint('📍 목적지 주소 변환 중: ${widget.toAddress}');
      final destCoords = await GeocodingService.geocodeAddress(
        widget.toAddress!,
      );
      _destinationLatLng = LatLng(
        destCoords['latitude']!,
        destCoords['longitude']!,
      );
      _originLatLng = origin;

      debugPrint('✅ 출발지: ${_originLatLng}, 목적지: ${_destinationLatLng}');

      debugPrint('🛣️ 경로 가져오는 중...');
      final routePoints = await DirectionsService.getRoute(
        origin: _originLatLng!,
        destination: _destinationLatLng!,
      );

      debugPrint('✅ 경로 포인트 수: ${routePoints.length}');

      if (!mounted) return;

      setState(() {
        // 커스텀 glassmorphism 마커 추가
        // ✅ useCurrentLocation이 true일 때는 초록색 마커(origin)를 표시하지 않음
        final markers = <Marker>[];

        // useCurrentLocation이 false일 때만 출발지 마커 표시
        if (!widget.useCurrentLocation) {
          markers.add(
            Marker(
              markerId: const MarkerId('origin'),
              position: _originLatLng!,
              icon: _originMarkerIcon ?? BitmapDescriptor.defaultMarker,
              anchor: const Offset(0.5, 0.85),
            ),
          );
        }

        // 목적지 마커는 항상 표시
        markers.add(
          Marker(
            markerId: const MarkerId('destination'),
            position: _destinationLatLng!,
            icon: _destinationMarkerIcon ?? BitmapDescriptor.defaultMarker,
            anchor: const Offset(0.5, 0.85),
          ),
        );

        _markers = markers.toSet();

        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            points: routePoints,
            color: const Color(0xFF00B4D8), // Bright cyan for dark theme
            width: 5,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
          ),
        };

        _isLoadingRoute = false;
      });

      if (shouldFitBounds &&
          mounted &&
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

  //경로 재탐색하는 타이머
  //경로 재탐색하는 타이머
  void _startRouteUpdateTimer(int interval) {
    _routeUpdateTimer?.cancel();
    _routeUpdateTimer = Timer.periodic(Duration(seconds: interval), (
      timer,
    ) async {
      if (mounted && widget.toAddress != null) {
        // ✅ useCurrentLocation이 true일 때 현재 위치를 먼저 업데이트
        if (widget.useCurrentLocation) {
          await _getCurrentLocation();
        }
        // 경로 업데이트 (shouldFitBounds는 false로 유지하여 카메라 이동 방지)
        await _loadRoute();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _fitBounds() async {
    if (_originLatLng == null ||
        _destinationLatLng == null ||
        _mapController == null)
      return;

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

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      if (_mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            15.0,
          ),
        );
      }

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

  // ✨ 완전 투명 AppBar (버튼만)
  Widget _buildGlassAppBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: const BoxDecoration(), // 완전 투명
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.white.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      color: Colors.white,
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),

              // Action Button
              if (_isLoadingLocation || _isLoadingRoute)
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: IconButton(
                        icon: const Icon(Icons.my_location, size: 22),
                        color: Colors.white,
                        padding: EdgeInsets.zero,
                        onPressed: _getCurrentLocation,
                        tooltip: l10n.currentLocation,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ✨ Glassmorphism 정보 카드 (초소형)
  Widget _buildInfoCard() {
    if (_originLatLng == null || _destinationLatLng == null)
      return const SizedBox.shrink();

    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return _buildInfoCardContent(l10n);
      },
    );
  }

  Widget _buildInfoCardContent(AppLocalizations l10n) {
    return Positioned(
      bottom: 12,
      left: 12,
      right: 12,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 출발지
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF32CD32),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF32CD32).withOpacity(0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.useCurrentLocation &&
                                      _currentPosition != null
                                  ? l10n.currentLocation
                                  : (widget.fromName ?? l10n.origin),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            if (widget.fromAddress != null &&
                                !(widget.useCurrentLocation &&
                                    _currentPosition != null))
                              Text(
                                widget.fromAddress!,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // 연결선
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 2.5,
                      top: 4,
                      bottom: 4,
                    ),
                    child: Container(
                      width: 1,
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF32CD32).withOpacity(0.4),
                            const Color(0xFFFF4444).withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 목적지
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF4444),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF4444).withOpacity(0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.toName ?? l10n.destination,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            if (widget.toAddress != null)
                              Text(
                                widget.toAddress!,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LatLng initialLocation =
        _originLatLng ??
        (_currentPosition != null
            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
            : const LatLng(40.7982, -77.8599));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(),
      ),
      body: Stack(
        children: [
          // 지도
          if (!_isMapReady)
            Container(
              color: const Color(0xFF1a1a1a),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Builder(
                      builder: (context) {
                        final l10n = AppLocalizations.of(context)!;
                        return Text(
                          l10n.mapLoading,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ],
                ),
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

                // ✨ 커스텀 스타일 적용
                controller.setMapStyle(_mapStyle);

                debugPrint('✅ 지도 생성 완료');

                if (_originLatLng != null && _destinationLatLng != null) {
                  _fitBounds();
                }
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false, // 커스텀 버튼 사용
              zoomControlsEnabled: false, // 커스텀 UI를 위해 기본 컨트롤 숨김
              mapType: MapType.normal,
            ),

          // 로딩 오버레이
          // if (_isLoadingRoute && _isMapReady)
          //   Container(
          //     color: Colors.black.withOpacity(0.5),
          //     child: BackdropFilter(
          //       filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          //       child: Center(
          //         child: Container(
          //           padding: const EdgeInsets.all(32),
          //           decoration: BoxDecoration(
          //             gradient: LinearGradient(
          //               begin: Alignment.topLeft,
          //               end: Alignment.bottomRight,
          //               colors: [
          //                 Colors.white.withOpacity(0.15),
          //                 Colors.white.withOpacity(0.08),
          //               ],
          //             ),
          //             borderRadius: BorderRadius.circular(20),
          //             border: Border.all(
          //               color: Colors.white.withOpacity(0.2),
          //               width: 1,
          //             ),
          //           ),
          //           child: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               const CircularProgressIndicator(
          //                 valueColor: AlwaysStoppedAnimation<Color>(
          //                   Colors.white,
          //                 ),
          //               ),
          //               const SizedBox(height: 20),
          //               Text(
          //                 '경로 검색 중...',
          //                 style: TextStyle(
          //                   color: Colors.white.withOpacity(0.9),
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.w500,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),

          // Glassmorphism AppBar (positioned at top)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildGlassAppBar(context),
          ),

          // 정보 카드
          _buildInfoCard(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _routeUpdateTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }
}
