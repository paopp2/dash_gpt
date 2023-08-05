import 'package:ai_chat_repository/ai_chat_repository.dart';
import 'package:clock/clock.dart';
import 'package:test/test.dart';

void main() {
  group('Message', () {
    test('supports equality', () {
      expect(
        Message(
          content: 'content',
          sender: MessageSender.user,
          createdAt: DateTime(2019),
        ),
        Message(
          content: 'content',
          sender: MessageSender.user,
          createdAt: DateTime(2019),
        ),
      );
    });

    test('initializes createdAt with now (in UTC) if not provided', () {
      final mockedNow = DateTime(2019);
      withClock(Clock.fixed(mockedNow), () {
        final message = Message(content: 'c', sender: MessageSender.user);
        expect(message.createdAt, mockedNow.toUtc());
      });
    });
  });
}
