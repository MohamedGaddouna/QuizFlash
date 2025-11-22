class Event {
  final int id;
  final String title;
  final String? description; // Nullable
  final String date;
  final String imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.imageUrl,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: int.parse(json['id'].toString()),
      title: json['title'] ?? "Titre inconnu", // Valeur par défaut si title est null
      description: json['description'], // Nullable
      date: json['DATE'] ?? "Date inconnue", // Valeur par défaut si date est null
      imageUrl: json['image_url'] ?? "", // Valeur par défaut pour imageUrl
    );
  }
}
