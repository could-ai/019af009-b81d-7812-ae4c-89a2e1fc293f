class Reminder {
  String id;
  String title;
  bool isActive;
  String? locationName; // For "Buy" reminders
  String? category;     // For "Buy" reminders
  double? distance;     // Mock distance for demo

  Reminder({
    required this.id,
    required this.title,
    this.isActive = true,
    this.locationName,
    this.category,
    this.distance,
  });
}

class Store {
  final String name;
  final double distanceKm;
  final String address;

  Store({required this.name, required this.distanceKm, required this.address});
}
