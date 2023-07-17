import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherApi {
  static const apiKey = 'f101fdd44b16471dabd204705231607';

  static Future<Weather> getWeather(
      {required String location,
      required DateTime date,
      required String apiType}) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    debugPrint('Input');
    debugPrint('location: $location');
    debugPrint('Date ${DateFormat('MM/dd/yyyy').format(date)}');
    debugPrint('apiType: $apiType');

    final String url =
        'http://api.weatherapi.com/v1/$apiType.json?key=$apiKey&q=$location&days=1&dt=$formattedDate';

    debugPrint('URL: ${Uri.parse(url)}');

    final response = await http.get(Uri.parse(url));
    // debugPrint(response.headers.toString());

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Transforming the data
      final forecast = data['forecast']['forecastday'][0];
      final avgTempF = forecast['day']['avgtemp_f'].toDouble();
      final conditionText = forecast['day']['condition']['text'];
      final iconUrl = forecast['day']['condition']['icon'];

      return Weather(
          degrees: avgTempF, description: conditionText, icon: iconUrl);
    }
    // Return a default weather value
    return const Weather(
        degrees: 75.0,
        description: 'Sunny',
        icon: '//cdn.weatherapi.com/weather/64x64/day/113.png');
  }
}
