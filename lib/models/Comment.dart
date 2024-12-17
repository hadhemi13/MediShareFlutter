  class Comment {
    final String? id;
    final String userId;
    final String comment;
    final String postId;

    Comment({ this.id, required this.postId, required this.comment, required this.userId});

    // From JSON
    factory Comment.fromJson(Map<String, dynamic> json) {
      return Comment(
          id: json['_id'], postId: json['post'],comment: json['comment'], userId: json['user']);
    }

    // To JSON
    Map<String, dynamic> toJson() =>
        {'post': postId, 'comment': comment, 'user': userId};
  }