import 'package:flutter/material.dart';
import 'package:medishareflutter/models/Post.dart';
import 'package:medishareflutter/models/PostResponse.dart';
import 'package:medishareflutter/models/displaying_posts.dart';
import 'package:medishareflutter/utils/constants.dart';
import 'package:medishareflutter/viewModels/post_view_model.dart';
import 'dart:io';

import 'package:medishareflutter/views/full_screen_image.dart'; // Import for file handling

class HomePage extends StatefulWidget {
  final PostViewModel postViewModel = PostViewModel();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Post>> _postsFuture;
  late Future<List<DisplayingPosts>> _postsFuture2;

  @override
  void initState() {
    super.initState();
    _postsFuture = widget.postViewModel.fetchPostss(); // Fetch posts
    _postsFuture2 = widget.postViewModel.fetchPosts(); // Fetch posts
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("MediShare"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:
                  // Row of buttons
                  Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle 'Recent' button logic
                      },
                      child: Text('Recent'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle 'Trending' button logic
                      },
                      child: Text('Trending'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle 'Best' button logic
                      },
                      child: Text('Best'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle 'Risking' button logic
                      },
                      child: Text('Risking'),
                    ),
                  ],
                ),
              ),
              // Expanded ListView
            ),
            Expanded(
              child: FutureBuilder<List<DisplayingPosts>>(
                future: _postsFuture2,
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
                      return PostCard(postres: post.post);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  final PostResponse postres;

  const PostCard({Key? key, required this.postres}) : super(key: key);

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
          // most create row here ...
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Image from assets
                CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/profile_placeholder.png'),
                  radius: 20.0,
                ),
                SizedBox(width: 12.0),
                // Name and hour
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe', // Replace with dynamic name if needed
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        '2 hours ago', // Replace with dynamic time if needed
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Action icons
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              widget.postres.content,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ),

          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FullScreenImage(imagePath: widget.postres.image),
                  ),
                );
              },
              child: Image.network(
                        "${Constants.baseUrl}${widget.postres.image.replaceAll('\\', '/')}",
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
          ),
          Divider(color: Colors.grey[300]),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 0.2),
              Container(
                child: Row(
                  children: [
                    Icon(Icons.arrow_upward, color: Colors.grey[700]),
                    Text("16"),
                  ],
                ),
              ),
              const SizedBox(width: 0.2),
              IconButton(
                icon: Icon(
                  _showComments ? Icons.comment_bank : Icons.comment,
                  color: Color(0xFF113155),
                ),
                onPressed: () {
                  setState(() {
                    _showComments = !_showComments;
                  });
                },
              ),
              const SizedBox(width: 0.2),
              Icon(Icons.ios_share, color: Colors.grey[700]),
              const SizedBox(width: 0.2),
            ],
          ),
          if (_showComments)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [].map((comment) {
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
                            style: TextStyle(
                                fontSize: 14.0, color: Colors.grey[700]),
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
                    icon: Icon(Icons.send, color: Color(0xFF113155)),
                    onPressed: () async {
                      if (_commentController.text.isNotEmpty) {
                        //final Comment newComment = Comment(
                          //postId: widget.postres.id,
                          //content: _commentController.text,
                       // );

                        //setState(() {
                          //widget.postres.comments.add(newComment);
                        //});

                        _commentController.clear();

                        try {
                          //await postViewModel.saveCommentToDatabase(newComment);
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
