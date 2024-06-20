import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class WeatherData {
  final String condition;
  final double temperature;

  WeatherData({required this.condition, required this.temperature});
}

class BadWeatherWidget extends StatefulWidget {
  final bool inParcel;

  const BadWeatherWidget({Key? key, this.inParcel = false}) : super(key: key);

  @override
  State<BadWeatherWidget> createState() => _BadWeatherWidgetState();
}

class _BadWeatherWidgetState extends State<BadWeatherWidget> {
  bool _showAlert = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    fetchLocationAndWeather();
  }

  Future<void> fetchLocationAndWeather() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final lat = position.latitude.toString();
      final lon = position.longitude.toString();
      const apiKey = 'f16c2a40cd98d4b5932c673d0854aa35'; // Replace with your OpenWeatherMap API key
      final apiUrl = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final condition = jsonData['weather'][0]['main'];
        final temperature = jsonData['main']['temp'];
        setState(() {
          _showAlert = condition == 'Rain'; // Example condition for bad weather
          _message = 'It\'s raining!';
          print('Weather Condition: $condition');
        });
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return _showAlert && _message != null && _message!.isNotEmpty
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red.withOpacity(0.7),
            ),
            padding: const EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(
              horizontal: widget.inParcel ? 0 : 10,
              vertical: 20,
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _message!,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
