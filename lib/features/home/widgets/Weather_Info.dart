import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherInfo extends StatefulWidget {
  const WeatherInfo({super.key});

  @override
  State<WeatherInfo> createState() => _WeatherInfoState();
}

class _WeatherInfoState extends State<WeatherInfo> {
  String? _message;
  bool _showAlert = false;
  String? _weatherCondition;

  Future<void> fetchLocationAndWeather() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final lat = position.latitude.toString();
      final lon = position.longitude.toString();
      const apiKey =
          'f16c2a40cd98d4b5932c673d0854aa35'; // Replace with your OpenWeatherMap API key
      final apiUrl =
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final condition = jsonData['weather'][0]['main'];
        setState(() {
          _weatherCondition = condition;
          _showAlert = condition == 'Rain'; // Example condition for bad weather
          _message = 'It\'s raining!';
          Get.snackbar('Weahter', _message!);
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
    String svgPath = 'assets/svg/Clear.svg';
    if (_weatherCondition != null) {
      // Update icon based on weather condition
      switch (_weatherCondition) {
        case 'Rain':
          svgPath = 'assets/svg/Rain.svg';
          break;
        case 'Clouds':
          svgPath = 'assets/svg/Clouds.svg';
          break;
        // Add more cases for other weather conditions if needed
        default:
          svgPath = 'assets/svg/Clear.svg'; // Default icon
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SvgPicture.asset(
        svgPath,
        width: 60,
        height: 60,
      ),
    );
  }
}
