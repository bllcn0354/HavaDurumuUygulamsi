import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:havadurumu/models/weather_model.dart';

class WeatherService {
  Future<String> _getLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return Future.error('Konum servisi kapalı');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Konum izni verilmedi');
      }
    }
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final places = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    final p = places.isNotEmpty ? places.first : null;
    final city =
        (p?.administrativeArea?.trim().isNotEmpty == true
            ? p!.administrativeArea
            : p?.locality) ??
        '';
    return city;
  }

  Future<List<WeatherModel>> getWeatherdata() async {
    final city = Uri.encodeQueryComponent((await _getLocation()).trim());
    final url =
        'https://api.collectapi.com/weather/getWeather?lang=tr&city=$city';
    const headers = {
      'authorization': 'apikey 04iszBYMmMl6s80K7CqnWc:0nHxToLj7Ce0QvyIwxScFE',
      'content-type': 'application/json',
    };

    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
        validateStatus: (s) => s != null && s < 500, // 500+ exception
      ),
    );

    try {
      final resp = await dio.get(url, options: Options(headers: headers));
      if (resp.statusCode != 200) {
        return Future.error('HTTP ${resp.statusCode}: ${resp.data}');
      }

      dynamic raw = resp.data;
      if (raw is String) {
        raw = jsonDecode(raw);
      }

      // 1) { result: [...] } 2) [...]  -> ikisini de destekle
      late final List<dynamic> result;
      if (raw is Map<String, dynamic>) {
        final r = raw['result'];
        if (r is List) {
          result = r;
        } else {
          return Future.error('Beklenmeyen JSON: "result" list değil.');
        }
      } else if (raw is List) {
        result = raw;
      } else {
        return Future.error('Beklenmeyen JSON kök tipi: ${raw.runtimeType}');
      }

      return result
          .whereType<Map<String, dynamic>>() // elemanlar Map olmalı
          .map((e) => WeatherModel.fromjson(e))
          .toList();
    } on DioException catch (e) {
      return Future.error('İstek hatası: ${e.message}');
    } catch (e) {
      return Future.error('Beklenmeyen hata: $e');
    }
  }
}
