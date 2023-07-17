import 'package:flutter/material.dart';

class Weather {
  final double degrees;
  final String description;
  final String icon;

  const Weather({
    required this.degrees,
    required this.description,
    required this.icon,
  });
}
