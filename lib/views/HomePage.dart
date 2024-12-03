import 'package:flutter/material.dart';
import 'package:medishareflutter/models/Comment.dart';
import 'package:medishareflutter/models/Post.dart';
import 'package:medishareflutter/viewModels/PostViewModel.dart';
import 'dart:io'; // Import for file handling

class HomePage extends StatefulWidget {
  final PostViewModel postViewModel = PostViewModel();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = widget.postViewModel.fetchPosts(); // Fetch posts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MediShare"),
        centerTitle: true,
        
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts available.'));
          }

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(post: post);
            },
          );
        },
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _showComments = false;
  final PostViewModel postViewModel = PostViewModel();
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5.0,
      shadowColor: Colors.grey.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            child: Image.file(
              File(widget.post.image),
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              widget.post.description,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ),
          Divider(color: Colors.grey[300]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  _showComments ? Icons.comment_bank : Icons.comment,
                  color: Colors.deepPurple,
                ),
                onPressed: () {
                  setState(() {
                    _showComments = !_showComments;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(
                  _showComments ? 'Hide comments' : 'View comments',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 14.0),
                ),
              ),
            ],
          ),
          if (_showComments)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.post.comments.map((comment) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.person, color: Colors.grey, size: 20.0),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            comment.content,
                            style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          if (_showComments)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.deepPurple),
                    onPressed: () async {
                      if (_commentController.text.isNotEmpty) {
                        final Comment newComment = Comment(
                          postId: widget.post.id!,
                          content: _commentController.text,
                        );

                        setState(() {
                          widget.post.comments.add(newComment);
                        });

                        _commentController.clear();

                        try {
                          await postViewModel.saveCommentToDatabase(newComment);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to save comment: $e'),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
