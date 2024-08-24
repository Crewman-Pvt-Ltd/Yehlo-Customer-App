import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherInfo extends StatefulWidget {
  const WeatherInfo({super.key});

  @override
  State<WeatherInfo> createState() => _WeatherInfoState();
}

class _WeatherInfoState extends State<WeatherInfo> {
  String? _message;
  String? _weatherCondition;

  Future<void> requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

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
          _message = getAlertMessage(condition);
         // _showAlertIfNeeded();
        });
      } else {
        setState(() {
          _message = 'Failed to load weather data';
        });
        Get.snackbar('Error', _message!);
      }
    } catch (e) {
      setState(() {
        _message = 'Error: $e';
      });
      Get.snackbar('Error', _message!);
    }
  }

  // Future<void> _showAlertIfNeeded() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool hasShownAlert = prefs.getBool('hasShownAlert') ?? false;
  //   if (!hasShownAlert) {
  //     Get.snackbar('Weather', _message!);
  //     prefs.setBool('hasShownAlert', true);
  //   }
  // }

  String getAlertMessage(String condition) {
    switch (condition) {
      case 'Rain':
        return 'It\'s raining!';
      case 'Clouds':
        return 'It\'s cloudy!';
      case 'Clear':
        return 'It\'s clear!';
      default:
        return 'Weather condition: $condition';
    }
  }

  @override
  void initState() {
    super.initState();
    requestLocationPermission().then((_) {
      fetchLocationAndWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    String lottiePath = 'assets/Lottie/Clear.json';
    if (_weatherCondition != null) {
      // Update icon based on weather condition
      switch (_weatherCondition) {
        case 'Rain':
          lottiePath = 'assets/Lottie/Rainy.json';
          break;
        case 'Clouds':
          lottiePath = 'assets/Lottie/CLD.json';
          break;
        case 'Clear':
          lottiePath = 'assets/Lottie/Clear.json';
          break;
        // Add more cases for other weather conditions if needed
        default:
          lottiePath = 'assets/Lottie/Clear.json'; // Default icon
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Lottie.asset(
        lottiePath,
        width: 40,
        height: 40,
      ),
    );
  }
}
