
  class ImageDao {
    final int? id;
    final String path;
    final String title;
    final String description;
    final DateTime date;

    ImageDao({
      this.id,
      required this.path,
      required this.description,
      required this.title,
      required this.date
    });

    // From JSON
    factory ImageDao.fromJson(Map<String, dynamic> json) {
      return ImageDao(
        id: json['id'],
        path: json['path'],
        title: json['title'],
        description: json['description'],
        date: DateTime.parse(json['date']),  // Associez les commentaires ici
      );
    }

    // To JSON
    Map<String, dynamic> toJson() {
      return {
        'id': id,
        'path': path,
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
      };
    }
  }
