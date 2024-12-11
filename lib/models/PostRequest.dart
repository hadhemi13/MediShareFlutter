class PostRequest {
  final String title;
  final String imageId;
  final String content;
  final String userid;
  final String subreddit;
  // Liste des commentaires associés

  PostRequest(
      {required this.title,
      required this.imageId,
      required this.content,
      required this.userid,
      required this.subreddit});
}
