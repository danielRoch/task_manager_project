import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final _searchLocationController = TextEditingController();
  List<Prediction> _predictions = [];
  final GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: 'AIzaSyDZww6dbuvGJp_x8pg0FEDGIGoxIGBa45E');

  void _autocompleteSearch(String input) async {
    if (input.isEmpty) {
      setState(() {
        _predictions = [];
      });
      return;
    }

    final response = await _places.autocomplete(input, types: ['geocode']);

    if (response.isOkay) {
      setState(() {
        _predictions = response.predictions;
      });
    } else {
      setState(
        () {
          _predictions = [];
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: const Text(
          'Location Lookup',
        ),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            autofocus: true,
            controller: _searchLocationController,
            onChanged: (value) => _autocompleteSearch(value),

            // Text Field Styling
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.lightBlue),
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: 'Task Location',
              fillColor: Colors.grey[200],
              filled: true,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _predictions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_predictions[index].description!),
                onTap: () {
                  debugPrint(_predictions[index].placeId);
                  Navigator.pop(context, _predictions[index].description!);
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}
