import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/add_post_screen.dart';
import 'package:instagram/screens/feed_screen_layout.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/screens/search_screen.dart';

// Define the screen size breakpoint for web vs. mobile
const webScreenSize = 600;

// Define the items for the home screen navigation
final homeScreenItems = [
  FeedScreenLayout(), // Feed screen placeholder
  Searchscreen(), // Search screen placeholder
  AddPostScreen(), // Add Post screen
  // Notifications screen placeholder
  Profilescreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ), // Profile screen placeholder
];
