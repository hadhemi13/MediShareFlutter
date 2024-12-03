import 'package:medishareflutter/models/Comment.dart';

class Post {
  final int? id;
  final String image;
  final String description;
  final List<Comment> comments;  // Liste des commentaires associés

  Post({
    this.id,
    required this.image,
    required this.description,
   this.comments = const [], 
  });

  // From JSON
  factory Post.fromJson(Map<String, dynamic> json, List<Comment> comments) {
    return Post(
      id: json['id'],
      image: json['image'],
      description: json['description'],
      comments: comments,  // Associez les commentaires ici
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'description': description,
    };
  }
}
