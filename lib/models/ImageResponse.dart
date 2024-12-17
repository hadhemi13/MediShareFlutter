import 'package:medishareflutter/models/Comment.dart';

class ImageResponse {
  final String id;
  final String imageName;
  final String title;

  ImageResponse(
      {required this.id,
      required this.imageName,
      required this.title,
      });

  // From JSON
  factory ImageResponse.fromJson(Map<String, dynamic> json) {
    return ImageResponse(
      id: json['_id'],
      imageName: json['imageName'],
      title: json['title'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageName': imageName,
    };
  }
}
