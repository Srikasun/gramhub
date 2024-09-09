import 'package:flutter/material.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:intl/intl.dart';

class Commentcard extends StatefulWidget {
  final Map<String, dynamic> snap;
  final Function(String commentId)
      onDeleteComment; // Callback function for comment deletion

  const Commentcard({
    Key? key,
    required this.snap,
    required this.onDeleteComment, // Pass callback from parent
  }) : super(key: key);

  @override
  State<Commentcard> createState() => _CommentcardState();
}

class _CommentcardState extends State<Commentcard> {
  @override
  Widget build(BuildContext context) {
    // Extract data safely from widget.snap
    final String profilePic = widget.snap['profilePic'] ?? '';
    final String name = widget.snap['name'] ?? 'Unknown User';
    final String text = widget.snap['text'] ?? '';
    final DateTime datePublished = widget.snap['datePublished']?.toDate() ??
        DateTime.now(); // Handle null date

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: profilePic.isNotEmpty
                ? NetworkImage(profilePic)
                : AssetImage('assets/default_avatar.png')
                    as ImageProvider, // Fallback for null or empty profilePic
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .white, // Ensure color is provided for TextSpan
                          ),
                        ),
                        TextSpan(
                          text: ' $text',
                          style: const TextStyle(
                              color: Colors.white), // Added text color
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(datePublished),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w100,
                        color: Colors.grey, // Text color for the date
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shrinkWrap: true,
                    children: [
                      InkWell(
                        onTap: () async {
                          await FireStoreMethods().deleteComment(
                            widget.snap['postId'] ?? '',
                            widget.snap['commentId'] ?? '',
                          );
                          widget.onDeleteComment(widget.snap[
                              'commentId']); // Notify parent about the deletion
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          child: const Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }
}
