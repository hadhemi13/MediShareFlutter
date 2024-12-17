class PostResponse {
  final String id;
  final String title;
   int upvotes;
  final String subreddit;
  final String timeAgo;
  final String author;
  final String image;
  bool statepost;
  final String profileImage;
  final String content;
  PostResponse({
    required this.id,
    required this.upvotes,
    required this.image,
    required this.author,
    required this.title,
    required this.subreddit,
    required this.timeAgo,
    required this.content,
    required this.profileImage,
    required this.statepost,
  });

  // From JSON
  factory PostResponse.fromJson(
      Map<String, dynamic> json) {
    return PostResponse(
      id: json['id'],
      title: json['title'],
      upvotes: json['upvotes'],
      subreddit: json['subreddit'],
      timeAgo: json['timeAgo'],
      author: json['author'],
      image: json['image'],
      statepost: json['statepost'],
      profileImage: json['profileImage'],
      content:json['Content'],  // Associez les commentaires ici
    );
  }



  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'upvotes': upvotes,
      'subreddit': subreddit,
      'timeAgo': timeAgo,
      'author': author,
      'image': image,
      'statepost': statepost,
      'profileImage': profileImage,
      'Content': content,
    };
  }
}
