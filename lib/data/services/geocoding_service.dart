import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

class GeocodingService {
  static final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// 주소를 좌표로 변환합니다.
  /// 성공 시 LatLng을 반환하고, 실패 시 예외를 던집니다.
  static Future<Map<String, double>> geocodeAddress(String address) async {
    try {
      final callable = _functions.httpsCallable('geocodeAddress');

      final result = await callable.call(<String, dynamic>{'address': address});

      final rawData = result.data;
      // debugPrint('🔍 GeocodingService - rawData 타입: ${rawData.runtimeType}');
      // debugPrint('🔍 GeocodingService - rawData 내용: $rawData');

      if (rawData == null) {
        throw StateError('Firebase Functions에서 null 응답을 받았습니다.');
      }

      final data =
          rawData is Map
              ? Map<String, dynamic>.from(rawData.cast<String, dynamic>())
              : throw StateError(
                  '예상하지 못한 응답 형식: ${rawData.runtimeType} - $rawData',
              );

      // debugPrint('🔍 GeocodingService - 변환된 data: $data');
      // debugPrint('🔍 GeocodingService - data keys: ${data.keys.toList()}');

      if (data.containsKey('latitude') && data.containsKey('longitude')) {
        // debugPrint('✅ GeocodingService - 이미 변환된 데이터 형식입니다.');
        return {
          'latitude': (data['latitude'] as num).toDouble(),
          'longitude': (data['longitude'] as num).toDouble(),
        };
      }

      final status = data['status'];
      if (status == null) {
        // debugPrint('⚠️ GeocodingService - status가 null입니다. 전체 응답: $data');
        if (data.containsKey('error')) {
          throw StateError('Geocoding API 오류: ${data['error']}');
        }
        throw StateError('Geocoding 응답에 status가 없습니다: $data');
      }

      if (status != 'OK') {
        throw StateError(
          'Geocoding 실패: $status - ${data['error_message'] ?? ''}',
        );
      }

      final results = data['results'];
      if (results is! List || results.isEmpty) {
        throw StateError('주소를 찾을 수 없습니다: $address');
      }

      final firstResult = results.first;
      if (firstResult is! Map) {
        throw StateError('예상하지 못한 결과 형식: $firstResult');
      }

      final geometry = firstResult['geometry'];
      if (geometry is! Map) {
        throw StateError('geometry 정보를 찾을 수 없습니다: $firstResult');
      }

      final location = geometry['location'];
      if (location is! Map) {
        throw StateError('좌표 정보를 찾을 수 없습니다: $geometry');
      }

      final locationMap = Map<String, dynamic>.from(
        location.cast<String, dynamic>(),
      );
      final lat = locationMap['lat'];
      final lng = locationMap['lng'];

      if (lat == null || lng == null) {
        throw StateError('좌표 값이 없습니다: $locationMap');
      }

      return {
        'latitude': (lat as num).toDouble(),
        'longitude': (lng as num).toDouble(),
      };
    } on FirebaseFunctionsException catch (e) {
      throw HttpException(
        message: 'Cloud Function 오류: ${e.message}',
        statusCode: 500,
        body: e.details?.toString() ?? '',
      );
    } catch (e) {
      throw HttpException(
        message: 'Geocoding 중 알 수 없는 오류: $e',
        statusCode: 500,
        body: e.toString(),
      );
    }
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
