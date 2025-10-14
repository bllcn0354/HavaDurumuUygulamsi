import 'package:flutter/material.dart';
import 'package:havadurumu/models/weather_model.dart';
import 'package:havadurumu/services/weather_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<WeatherModel> _weathers = [];

  void _getWeatherData() async {
    final data = await WeatherService().getWeatherdata();
    setState(() {
      _weathers = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: Text("Hava Durumu", style: TextStyle(color: Colors.white70)),
        ),
      ),
      persistentFooterButtons: [],
      floatingActionButton: FloatingActionButton(onPressed: () {}),
      body: Center(child: liste(weathers: _weathers)), //add
    );
  }
}

class liste extends StatelessWidget {
  const liste({super.key, required List<WeatherModel> weathers})
    : _weathers = weathers;

  final List<WeatherModel> _weathers;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _weathers.length,
      itemBuilder: (context, index) {
        final WeatherModel weatherModel = _weathers[index];
        return Opacity(
          opacity: 0.90,
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                Image.network(weatherModel.icon, height: 100, width: 100),
                Gun(weatherModel: weatherModel),
                Durum(weatherModel: weatherModel),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Gun extends StatelessWidget {
  const Gun({super.key, required this.weatherModel});

  final WeatherModel weatherModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        "${weatherModel.gun.toUpperCase()}\n${weatherModel.tarih}",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 19, color: Colors.black),
      ),
    );
  }
}

class Durum extends StatelessWidget {
  const Durum({super.key, required this.weatherModel});

  final WeatherModel weatherModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${weatherModel.durum.toUpperCase()} ${weatherModel.derece}°\n Gece: ${weatherModel.gece.toUpperCase()}°",
                style: const TextStyle(fontSize: 19, color: Colors.black),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Max: ${weatherModel.max.toUpperCase()}°\n Min: ${weatherModel.min}°",
                style: const TextStyle(fontSize: 19, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
