import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );

      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<bool> likePost(String postId, String uid, List likes) async {
    bool isNewLike = false;
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
        isNewLike = true;
      }
    } catch (e) {
      print(e.toString());
    }
    return isNewLike;
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now()
        });
      } else {
        print('text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      // Fetch current user data
      DocumentSnapshot userSnap =
          await _firestore.collection('users').doc(uid).get();
      List following =
          (userSnap.data() as Map<String, dynamic>)?['following'] ?? [];

      // Fetch follow user data
      DocumentSnapshot followUserSnap =
          await _firestore.collection('users').doc(followId).get();
      List followers =
          (followUserSnap.data() as Map<String, dynamic>)?['followers'] ?? [];

      // Check if already following or not
      if (following.contains(followId)) {
        // Unfollow the user
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        // Follow the user
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> bookmarkPost(String postId, String uid, List bookmarks) async {
    try {
      // Check if the post is already bookmarked
      if (bookmarks.contains(postId)) {
        // If it is already bookmarked, unbookmark it
        await _firestore.collection('users').doc(uid).update({
          'bookmarks': FieldValue.arrayRemove([postId]),
        });
      } else {
        // If not, add it to the bookmarks list
        await _firestore.collection('users').doc(uid).update({
          'bookmarks': FieldValue.arrayUnion([postId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
