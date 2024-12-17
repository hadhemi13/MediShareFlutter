import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medishareflutter/models/Comment.dart';
import 'package:medishareflutter/services/radiologue/commentaire_service.dart';

class CommentViewModel extends ChangeNotifier {
  final CommentaireService _commentService = CommentaireService();
  bool isLoading = false;
  String? errorMessage;

  Future<Comment?> createComment(Comment comment) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Convert the Comment object to JSON
      Map<String, dynamic> commentData = comment.toJson();
      print(commentData);
      // Call the service to create the comment
      final response = await _commentService.createComment(commentData);

      // Parse the response into a Comment object
      Comment newComment = Comment.fromJson(response);
      print(newComment);
      isLoading = false;
      notifyListeners();
      return newComment;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
