// controllers/event_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class EventController {
  static Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('http://localhost/time_traveler_app/get_events.php'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Event.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
}
