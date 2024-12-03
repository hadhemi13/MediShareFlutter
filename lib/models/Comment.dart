  class Comment {
    final int? id;
    final int postId;
    final String content;

    Comment({this.id, required this.postId, required this.content});

    // From JSON
    factory Comment.fromJson(Map<String, dynamic> json) {
      return Comment(
          id: json['id'], postId: json['postId'],content: json['content']);
    }

    // To JSON
    Map<String, dynamic> toJson() =>
        {'id': id, 'postId': postId, 'content': content};
  }