import 'package:medishareflutter/models/Comment.dart';
import 'package:medishareflutter/models/PostResponse.dart';

class DisplayingPosts {
    final List<Comment> comments;
    final PostResponse post;

    DisplayingPosts({ required this.post, required this.comments});

  
  }