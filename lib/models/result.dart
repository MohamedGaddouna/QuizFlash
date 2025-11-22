// models/result.dart
class Result {
  final int id;
  final int eventId;
  final int score;

  Result({required this.id, required this.eventId, required this.score});

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'score': score,
    };
  }
}
