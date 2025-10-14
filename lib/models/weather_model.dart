import 'dart:convert';

class WeatherModel {
  final String icon;
  final String gun;
  final String tarih;
  final String durum;
  final String derece;
  final String min;
  final String max;
  final String gece;
  final String nem;

  WeatherModel(
    this.icon,
    this.gun,
    this.tarih,
    this.durum,
    this.derece,
    this.min,
    this.max,
    this.gece,
    this.nem,
  );

  WeatherModel.fromjson(Map<String, dynamic> json)
    : icon = json['icon'],
      gun = json['day'],
      tarih = json['date'],
      durum = json['description'],
      derece = json['degree'],
      min = json['min'],
      max = json['max'],
      gece = json['night'],
      nem = json['humidity'];
}
