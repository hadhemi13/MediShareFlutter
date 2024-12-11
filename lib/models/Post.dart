import 'package:medishareflutter/models/Comment.dart';

class Post {
  final int? id;
  final String idImage;
  final String image;
  final String description;
  //final List<Comment> comments;  // Liste des commentaires associés
  final String title;
  Post({
    this.id,
    required this.idImage,
    required this.image,
    required this.description,
    required this.title,
   //this.comments = const [], 
  });

  // From JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      idImage: json['idImage'],
      image: json['image'],
      description: json['description'],
      title: json['title'],
    //  comments: comments,  // Associez les commentaires ici
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idImage': idImage,
      'image': image,
      'description': description,
      'title': title,
    };
  }
}
