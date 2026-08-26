import 'package:flutter/material.dart';

/// Icon choices a user can assign to a chat to tell chats apart at a
/// glance in the list. Keyed by a stable string (stored in
/// `Chats.iconKey`) rather than `IconData` directly, so a future Flutter/
/// Material icon font update can't silently change what's stored in the
/// database.
const chatIconOptions = <String, IconData>{
  'forum': Icons.forum,
  'chat_bubble': Icons.chat_bubble,
  'people': Icons.people_alt,
  'person': Icons.person,
  'favorite': Icons.favorite,
  'star': Icons.star,
  'home': Icons.home,
  'work': Icons.work,
  'school': Icons.school,
  'cake': Icons.cake,
  'pets': Icons.pets,
  'flight': Icons.flight,
  'restaurant': Icons.restaurant,
  'sports_soccer': Icons.sports_soccer,
  'music_note': Icons.music_note,
  'photo_camera': Icons.photo_camera,
};

const defaultChatIconKey = 'forum';

IconData chatIconForKey(String? key) {
  return chatIconOptions[key] ?? chatIconOptions[defaultChatIconKey]!;
}
