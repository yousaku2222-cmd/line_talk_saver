import 'package:flutter_test/flutter_test.dart';
import 'package:line_talk_saver/features/chat_detail/self_sender_prefs.dart';

void main() {
  String ja(String name) => '$name（自分）';

  test('marks only the self sender', () {
    expect(
      markSelfSender({1: '山田花子', 2: '溝上'}, '溝上', ja),
      {1: '山田花子', 2: '溝上（自分）'},
    );
  });

  test('leaves names alone when no self sender is set', () {
    expect(markSelfSender({1: '溝上'}, null, ja), {1: '溝上'});
    expect(markSelfSender({1: '溝上'}, '', ja), {1: '溝上'});
  });

  test('does not mark a sender already named the bare word', () {
    expect(markSelfSender({1: '自分'}, '自分', ja), {1: '自分'});
    expect(
      markSelfSender({1: 'me'}, 'me', (n) => '$n (me)'),
      {1: 'me'},
    );
  });
}
