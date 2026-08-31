import 'package:flutter/material.dart';

/// Icon choices a user can assign to a chat to tell chats apart at a
/// glance in the list. Keyed by a stable string (stored in
/// `Chats.iconKey`) rather than `IconData` directly, so a future Flutter/
/// Material icon font update can't silently change what's stored in the
/// database.
///
/// This map is **append-only**: the original 16 keys keep their exact
/// spelling so existing rows never break, and the redesign (see
/// docs/ui_redesign_plan.md §2.9) adds 50 more, grouped by
/// [chatIconCategories] for the picker.
const chatIconOptions = <String, IconData>{
  // よく使う
  'forum': Icons.forum,
  'chat_bubble': Icons.chat_bubble,
  'favorite': Icons.favorite,
  'star': Icons.star,
  'home': Icons.home,
  'bookmark': Icons.bookmark,
  'label': Icons.label,
  'push_pin': Icons.push_pin,
  // 人・関係
  'person': Icons.person,
  'people': Icons.people_alt,
  'groups': Icons.groups,
  'family': Icons.family_restroom,
  'child_care': Icons.child_care,
  'parent': Icons.escalator_warning,
  'friends': Icons.diversity_3,
  'handshake': Icons.handshake,
  'face': Icons.face,
  'smile': Icons.emoji_emotions,
  'woman': Icons.woman,
  'man': Icons.man,
  // 生活
  'house2': Icons.house,
  'key': Icons.vpn_key,
  'car': Icons.directions_car,
  'bike': Icons.pedal_bike,
  'train': Icons.train,
  'flight': Icons.flight,
  'money': Icons.payments,
  'shopping': Icons.shopping_bag,
  'restaurant': Icons.restaurant,
  'medical': Icons.local_hospital,
  'work': Icons.work,
  'school': Icons.school,
  'calendar': Icons.calendar_month,
  'pets': Icons.pets,
  // 趣味
  'photo_camera': Icons.photo_camera,
  'music_note': Icons.music_note,
  'movie': Icons.movie,
  'game': Icons.sports_esports,
  'book': Icons.menu_book,
  'art': Icons.palette,
  'run': Icons.directions_run,
  'sports_soccer': Icons.sports_soccer,
  'baseball': Icons.sports_baseball,
  'hiking': Icons.hiking,
  'nightlife': Icons.nightlife,
  'fishing': Icons.phishing,
  'sailing': Icons.sailing,
  'gym': Icons.fitness_center,
  // 季節・記念日
  'cake': Icons.cake,
  'flower': Icons.local_florist,
  'sun': Icons.wb_sunny,
  'tree': Icons.park,
  'snow': Icons.ac_unit,
  'gift': Icons.card_giftcard,
  'ring': Icons.diamond,
  'celebration': Icons.celebration,
  'drink': Icons.local_bar,
  'sparkle': Icons.auto_awesome,
  'flag': Icons.flag,
  'medal': Icons.workspace_premium,
  // 記号
  'circle': Icons.circle,
  'square': Icons.square,
  'triangle': Icons.change_history,
  'check': Icons.check_circle,
  'bolt': Icons.bolt,
  'grade': Icons.grade,
};

/// Ordered category -> icon keys, used to lay the picker out in sections.
/// Every key here must exist in [chatIconOptions]; every option key is
/// listed in exactly one category.
const chatIconCategories = <String, List<String>>{
  'よく使う': [
    'forum',
    'chat_bubble',
    'favorite',
    'star',
    'home',
    'bookmark',
    'label',
    'push_pin',
  ],
  '人・関係': [
    'person',
    'people',
    'groups',
    'family',
    'child_care',
    'parent',
    'friends',
    'handshake',
    'face',
    'smile',
    'woman',
    'man',
  ],
  '生活': [
    'house2',
    'key',
    'car',
    'bike',
    'train',
    'flight',
    'money',
    'shopping',
    'restaurant',
    'medical',
    'work',
    'school',
    'calendar',
    'pets',
  ],
  '趣味': [
    'photo_camera',
    'music_note',
    'movie',
    'game',
    'book',
    'art',
    'run',
    'sports_soccer',
    'baseball',
    'hiking',
    'nightlife',
    'fishing',
    'sailing',
    'gym',
  ],
  '季節・記念日': [
    'cake',
    'flower',
    'sun',
    'tree',
    'snow',
    'gift',
    'ring',
    'celebration',
    'drink',
    'sparkle',
    'flag',
    'medal',
  ],
  '記号': ['circle', 'square', 'triangle', 'check', 'bolt', 'grade'],
};

const defaultChatIconKey = 'forum';

IconData chatIconForKey(String? key) {
  return chatIconOptions[key] ?? chatIconOptions[defaultChatIconKey]!;
}
