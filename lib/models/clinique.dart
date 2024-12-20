

class Clinique {
  String? id;
   String nom; // Name of the clinic
   double latitude;
   double longitude;
  final String createdBy; // User ID
   String? region; // Optional: Returned by backend after creation

  // Constructor: 'region' is not required
  Clinique({
    this.id,
    required this.nom,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    this.region, // Optional field (returned from backend)
  });

  // Convert the Clinique object to a JSON object (for sending to the backend)
  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
    };
  }

  // Convert a JSON object to a Clinique object (for receiving from the backend)
  factory Clinique.fromJson(Map<String, dynamic> json) {
    return Clinique(
      id: json['_id']?.toString(), // Ensure 'id' is parsed as a String
      nom: json['nom'] ?? '',
      latitude: (json['latitude'] is double) ? json['latitude'] : 0.0,
      longitude: (json['longitude'] is double) ? json['longitude'] : 0.0,
      createdBy: json['createdBy'] ?? '',
      region: json['region'], // 'region' is optional (generated by backend)
    );
  }
}