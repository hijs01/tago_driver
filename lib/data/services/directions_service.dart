import 'package:cloud_functions/cloud_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';

class DirectionsService {
  static final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// 두 좌표 사이의 경로를 가져옵니다.
  /// 성공 시 Polyline 좌표 리스트를 반환하고, 실패 시 예외를 던집니다.
  static Future<List<LatLng>> getRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final callable = _functions.httpsCallable('getRoute');

      final result = await callable.call(<String, dynamic>{
        'origin': {'lat': origin.latitude, 'lng': origin.longitude},
        'destination': {
          'lat': destination.latitude,
          'lng': destination.longitude,
        },
      });

      final rawData = result.data;
      debugPrint('🔍 DirectionsService - rawData 타입: ${rawData.runtimeType}');
      debugPrint('🔍 DirectionsService - rawData 내용: $rawData');

      if (rawData == null) {
        throw StateError('Firebase Functions에서 null 응답을 받았습니다.');
      }

      final data =
          rawData is Map
              ? Map<String, dynamic>.from(rawData.cast<String, dynamic>())
              : throw StateError(
                '예상하지 못한 응답 형식: ${rawData.runtimeType} - $rawData',
              );

      debugPrint('🔍 DirectionsService - 변환된 data: $data');
      debugPrint('🔍 DirectionsService - data keys: ${data.keys.toList()}');
      debugPrint('🔍 DirectionsService - data[status]: ${data['status']}');

      final status = data['status'];
      if (status == null) {
        debugPrint('⚠️ DirectionsService - status가 null입니다. 전체 응답: $data');
        if (data.containsKey('error')) {
          throw StateError('Directions API 오류: ${data['error']}');
        }
        throw StateError('Directions 응답에 status가 없습니다: $data');
      }

      if (status != 'OK') {
        throw StateError('경로 찾기 실패: $status - ${data['error_message'] ?? ''}');
      }

      final routes = data['routes'];
      if (routes is! List || routes.isEmpty) {
        throw StateError('경로를 찾을 수 없습니다.');
      }

      final route = routes.first;
      if (route is! Map) {
        throw StateError('예상하지 못한 경로 형식: $route');
      }

      final routeMap = Map<String, dynamic>.from(route.cast<String, dynamic>());
      final legs = routeMap['legs'];
      if (legs is! List || legs.isEmpty) {
        throw StateError('경로 정보가 없습니다.');
      }

      // Polyline 디코딩
      final overviewPolyline = routeMap['overview_polyline'];
      if (overviewPolyline is! Map) {
        throw StateError('경로 좌표를 찾을 수 없습니다.');
      }

      final polylineMap = Map<String, dynamic>.from(
        overviewPolyline.cast<String, dynamic>(),
      );
      final encodedPolyline = polylineMap['points'];
      if (encodedPolyline is! String || encodedPolyline.isEmpty) {
        throw StateError('경로 인코딩 데이터가 없습니다.');
      }

      return _decodePolyline(encodedPolyline);
    } on FirebaseFunctionsException catch (e) {
      throw HttpException(
        message: 'Cloud Function 오류: ${e.message}',
        statusCode: 500,
        body: e.details?.toString() ?? '',
      );
    } catch (e) {
      throw HttpException(
        message: '경로 찾기 중 알 수 없는 오류: $e',
        statusCode: 500,
        body: e.toString(),
      );
    }
  }

  /// Polyline 문자열을 LatLng 리스트로 디코딩
  static List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int shift = 0;
      int result = 0;
      int byte;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);

      int deltaLat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += deltaLat;

      shift = 0;
      result = 0;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);

      int deltaLng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += deltaLng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }
}

class HttpException implements Exception {
  final String message;
  final int statusCode;
  final String body;

  const HttpException({
    required this.message,
    required this.statusCode,
    required this.body,
  });

  @override
  String toString() => 'HttpException($statusCode): $message';
}
